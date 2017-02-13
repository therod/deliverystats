require 'mail'

class MailParser
  def self.parse(email)
    text = Mail.read(email).parts.first.body.raw_source
    data = MailData.new(text)
    data.to_h
  end
end

class MailData
  attr_accessor :data
  attr_reader :date, :time_window, :customer, :street, :zip, :total

  def initialize(text)
    @data        = clean(text)
    @date        = data[customer_index - 1].split(' ')[1]
    @time_window = data[customer_index - 1].split(' ')[2]
    @customer    = data[customer_index + 1]
    @street      = data[customer_index + 3]
    @zip         = data[customer_index + 4]
    @total       = data[total_index + 1]
  end

  def to_h
    { date: date, time_window: time_window, customer: customer,
      street: street, zip: zip, total: total }
  end

  private

  def customer_index
    data.index { |s| s.include?('Kundeninformation') }
  end

  def total_index
    data.index { |s| s.include?('Total in CHF') }
  end

  def clean(text)
    replacements = { '> ' => '', "\r" => '', '=' => '%' }

    text.split("\n").map do |string|
      CGI.unescape(string.gsub(Regexp.union(replacements.keys), replacements)).strip
    end
  end
end
