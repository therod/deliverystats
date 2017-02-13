require 'mail'
require 'cgi'

class MailParser
  def self.parse(email)
    data = MailData.new(email)
    {
      date:        data.date,
      time_window: data.time_window,
      customer:    data.customer,
      street:      data.street,
      zip:         data.zip,
      total:       data.total
    }
  end
end

class MailData
  attr_accessor :attributes, :clean_array

  def initialize(email)
    @clean_array = clean(email)
  end

  def date
    clean_array[customer_index - 1].split(' ')[1]
  end

  def time_window
    clean_array[customer_index - 1].split(' ')[2]
  end

  def customer
    clean_array[customer_index + 1]
  end

  def street
    clean_array[customer_index + 3]
  end

  def zip
    clean_array[customer_index + 4]
  end

  def total
    clean_array[total_index + 1]
  end

  private

  def customer_index
    clean_array.index { |s| s.include?('Kundeninformation') }
  end

  def total_index
    clean_array.index { |s| s.include?('Total in CHF') }
  end

  def clean(email)
    replacements = { '> ' => '', "\r" => '', '=' => '%' }

    mail_text = Mail.read(email).parts.first.body.raw_source
    mail_text.split("\n").map do |s|
      CGI.unescape(s.gsub(Regexp.union(replacements.keys), replacements)).strip
    end
  end
end
