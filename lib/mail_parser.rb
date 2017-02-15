require 'mail'

class MailParser
  def self.parse(email)
    text = Mail.read(email).parts.first.raw_source
    MailData.new(text).to_h
  end
end

class MailData
  attr_reader :date, :total, :customer, :street, :zip, :time_start, :time_end


  def initialize(body)
    data = clean(body).split("\n").map(&:strip)

    time_index     = data.index('Kundeninformation') || data.index('Customer information')
    customer_index = data.index('Bemerkungen') || data.index('Notes')
    price_index    = data.index('Total in CHF')

    @customer              = data.at(customer_index - 4)
    @street                = data.at(customer_index - 2)
    @zip                   = data.at(customer_index - 1)
    @total                 = data.at(price_index + 1)
    _, @date, time_window  = data.at(time_index - 1).split(' ')
    @time_start, @time_end = time_window.split('-')
  end

  def to_h
    { date: date, time_start: time_start, time_end: time_end, customer: customer,
      street: street, zip: zip, total: total }
  end

  private

  def clean(string)
    replacements = { '> ' => '', "\r" => '', '=' => '%' }
    CGI.unescape(string.gsub(Regexp.union(replacements.keys), replacements))
  end
end
