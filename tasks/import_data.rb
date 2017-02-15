require_relative '../environment.rb'

Dir.glob("./test/fixtures/*.eml") do |email_file|

  parsed_email = MailParser.parse(email_file)

  Order.find_or_create_by(
    date: parsed_email[:date],
    time_window: parsed_email[:time_window],
    customer_name: parsed_email[:customer],
    street: parsed_email[:street],
    zip: parsed_email[:zip],
    total: parsed_email[:total],
  )
end
