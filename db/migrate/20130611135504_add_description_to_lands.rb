class AddDescriptionToLands < ActiveRecord::Migration
  def change
    add_column :lands, :description, :text
  end
end
