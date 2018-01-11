class CreateFolders < ActiveRecord::Migration[5.1]
  def change
    create_table :folders do |t|
      t.references :user, foreign_key: true
      t.bigint :parent_id

      t.timestamps
    end
  end
end
