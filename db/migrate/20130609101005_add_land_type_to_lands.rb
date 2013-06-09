class AddLandTypeToLands < ActiveRecord::Migration
  def change
    add_column :lands, :land_type, :string
  end
end
