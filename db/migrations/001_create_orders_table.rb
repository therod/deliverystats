require_relative '../../environment'

class CreateOrdersTable < ActiveRecord::Migration
  def up
    create_table :orders do |t|
      t.string :customer_name
      t.string :street
      t.string :zip

      t.string :total
      t.string :time_window
      t.date :date

      # TODO Split up these fields
      # t.float :total
      # t.time :time_start
      # t.time :time_end
    end
  end

  def down
    drop_table :orders
  end
end
