class CreateShipsAndShipments < ActiveRecord::Migration[5.0]
  def change
    create_table :ships do |t|
      t.string :title
      t.integer :hold_capacity

      t.timestamps
    end

    create_table :shipments do |t|
      t.string :title
      t.integer :hold_capacity

      t.timestamps
    end
  end
end
