require 'mail'

class MailParser
  def self.parse(email)
    text = Mail.read(email).parts.first.raw_source
    MailData.new(text).to_h
  end
end

class MailData
  attr_reader :date, :time_window, :total, :customer, :street, :zip

  def initialize(body)
    data = clean(body).split("\n").map(&:strip)
    time_index = data.index('Kundeninformation') || data.index('Customer information')
    customer_index = data.index { |i| i.match(/^[8]\d{3}{1,4}$/) }
    price_index = data.index('Total in CHF')

    @customer              = data.at(customer_index - 3)
    @street                = data.at(customer_index - 1)
    @zip                   = data.at(customer_index)
    @total                 = data.at(price_index + 1)
    _, @date, @time_window = data.at(time_index - 1).split(' ')
  end

  def to_h
    { date: date, time_window: time_window, customer: customer,
      street: street, zip: zip, total: total }
  end

  private

  def clean(string)
    replacements = { '> ' => '', "\r" => '', '=' => '%' }
    CGI.unescape(string.gsub(Regexp.union(replacements.keys), replacements))
  end
end
