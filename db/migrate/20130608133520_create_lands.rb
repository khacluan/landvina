class CreateLands < ActiveRecord::Migration
  def change
    create_table :lands do |t|
      t.string :title
      t.string :land_position_text
      t.string :land_status
      t.float :price

      t.timestamps
    end
  end
end
