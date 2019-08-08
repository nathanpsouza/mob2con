class CreateConvertions < ActiveRecord::Migration[5.2]
  def change
    create_table :convertions do |t|
      t.string :currency_from
      t.string :currency_to
      t.decimal :rate, scale: 3, precision: 8
      t.string :convertion_type

      t.timestamps
    end
  end
end
