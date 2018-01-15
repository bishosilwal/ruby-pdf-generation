class CreateFolderShares < ActiveRecord::Migration[5.1]
  def change
    create_table :folder_shares do |t|
      t.bigint :owner_id
      t.bigint :receipt_id
      t.bigint :folder_id

      t.timestamps
    end
  end
end
