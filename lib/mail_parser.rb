require 'mail'

class MailParser
  def self.parse(email)
    text = Mail.read(email).parts.first.raw_source
    MailData.new(text).to_h
  end
end

class MailData
  attr_reader :data, :date, :time_window, :customer, :street, :zip, :total

  def initialize(body)
    @data = clean(body).split("\n").map(&:strip)
    set_attributes
  end

  def to_h
    { date: date, time_window: time_window, customer: customer,
      street: street, zip: zip, total: total }
  end

  private

  def set_attributes
    customer_index = data.index('Kundeninformation')
    total_index = data.index('Total in CHF')

    _, @date, @time_window = data.at(customer_index - 1).split(' ')
    @customer              = data.at(customer_index + 1)
    @street                = data.at(customer_index + 3)
    @zip                   = data.at(customer_index + 4)
    @total                 = data.at(total_index + 1)
  end

  def clean(string)
    replacements = { '> ' => '', "\r" => '', '=' => '%' }
    CGI.unescape(string.gsub(Regexp.union(replacements.keys), replacements))
  end
end
