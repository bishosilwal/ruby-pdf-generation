class AddNameToFolder < ActiveRecord::Migration[5.1]
  def change
    add_column :folders, :name, :string
  end
end
