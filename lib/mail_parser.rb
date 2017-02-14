require 'mail'

class MailParser
  def self.parse(email)
    text = Mail.read(email).parts.first.raw_source
    MailData.new(text).to_h
  end
end

class MailData
  attr_reader :date, :time_window, :customer, :street, :zip, :total

  def initialize(body)
    data = clean(body).split("\n").map(&:strip)
    element = DataElement.new(data)

    @date                  = element.date
    @time_window           = element.time_window
    @customer              = element.customer
    @street                = element.street
    @zip                   = element.zip
    @total                 = element.total
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

class DataElement
  attr_reader :data, :customer_index, :price_index, :time_index

  def initialize(array)
    @data = array
    @time_index = array.index('Kundeninformation') || array.index('Customer information')
    @customer_index = array.index { |i| i.match(/^[8]\d{3}{1,4}$/) }
    @price_index = array.index('Total in CHF')
  end

  def date
    data.at(time_index - 1).split(' ')[1]
  end

  def time_window
    data.at(time_index - 1).split(' ')[2]
  end

  def total
    data.at(price_index + 1)
  end

  def customer
    data.at(customer_index - 3)
  end

  def street
    data.at(customer_index - 1)
  end

  def zip
    data.at(customer_index)
  end
end
