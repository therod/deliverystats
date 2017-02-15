require_relative '../../environment'

class CreateOrdersTable < ActiveRecord::Migration[5.0]
  def up
    create_table :orders do |t|
      t.string :customer_name
      t.string :street
      t.string :zip
      t.date :date
      t.float :total
      t.time :time_start
      t.time :time_end
    end
  end

  def down
    drop_table :orders
  end
end
