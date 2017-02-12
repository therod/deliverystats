require 'mail'
require 'cgi'

class MailParser
  class << self
    def parse_email(email_path)
      dirty = Mail.read(email_path).parts.first.body.raw_source

      replacements = { '> ' => '', "\r" => '', '=' => '%' }
      clean_array = dirty.split("\n").map do |s|
        CGI.unescape(
          s.gsub(Regexp.union(replacements.keys), replacements)
        ).strip
      end

      info_index = clean_array.index { |s| s.include?('Kundeninformation') }
      total_index = clean_array.index { |s| s.include?('Total in CHF') }

      {
        date: clean_array[info_index - 1].split(' ')[1],
        time_window: clean_array[info_index - 1].split(' ')[2],
        customer: clean_array[info_index + 1],
        street: clean_array[info_index + 3],
        zip: clean_array[info_index + 4],
        total: clean_array[total_index + 1]
      }
    end
  end
end
