require_relative './environment.rb'
require 'pry'

task :console do
  binding.pry
end

namespace :db do
  task :migrate do
    CreateOrdersTable.migrate(:up)
  end

  task :rollback do
    CreateOrdersTable.migrate(:down)
  end

  task :reset do
    CreateOrdersTable.migrate(:down)
    CreateOrdersTable.migrate(:up)
  end

  task :seed do
    Dir.glob("./test/fixtures/*.eml") do |email_file|

      parsed_email = MailParser.parse(email_file)

      Order.find_or_create_by(
        date: parsed_email[:date],
        time_start: parsed_email[:time_start],
        time_end: parsed_email[:time_end],
        customer_name: parsed_email[:customer],
        street: parsed_email[:street],
        zip: parsed_email[:zip],
        total: parsed_email[:total],
      )
    end
  end
end
