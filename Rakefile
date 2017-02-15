require_relative './environment.rb'

namespace :db do
  task :migrate do
    CreateOrdersTable.migrate(:up)
  end

  task :rollback do
    CreateOrdersTable.migrate(:down)
  end
end
