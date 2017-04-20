class CreatePositions < ActiveRecord::Migration[5.0]
  def change
    create_table :positions do |t|
      t.date :opened_at
      t.references :port, foreign_key: true
      t.references :shippable, polymorphic: true

      t.timestamps
    end
  end
end
