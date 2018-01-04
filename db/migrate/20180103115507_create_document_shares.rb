class CreateDocumentShares < ActiveRecord::Migration[5.1]
  def change
    create_table :document_shares do |t|
      t.bigint :owner_id
      t.bigint :receipt_id
      t.bigint :doc_id

      t.timestamps
    end
  end
end
