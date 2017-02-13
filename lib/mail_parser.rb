require 'mail'

class MailParser
  def self.parse(email)
    text = Mail.read(email).parts.first.raw_source
    data = MailData.new(text)
    data.to_h
  end
end

class MailData
  attr_accessor :data
  attr_reader :date, :time_window, :customer, :street, :zip, :total

  def initialize(text)

    customer_info = 'Kundeninformation'
    total_info    = 'Total in CHF'

    @data        = clean(text)

    @date        = data[index(customer_info) - 1].split(' ')[1]
    @time_window = data[index(customer_info) - 1].split(' ')[2]
    @customer    = data[index(customer_info) + 1]
    @street      = data[index(customer_info) + 3]
    @zip         = data[index(customer_info) + 4]
    @total       = data[index(total_info) + 1]
  end

  def to_h
    { date: date, time_window: time_window, customer: customer,
      street: street, zip: zip, total: total }
  end

  private

  def index(string)
    data.index { |line| line.include?(string) }
  end

  def clean(text)
    replacements = { '> ' => '', "\r" => '', '=' => '%' }

    text.split("\n").map do |string|
      CGI.unescape(string.gsub(Regexp.union(replacements.keys), replacements)).strip
    end
  end
end
