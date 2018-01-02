class CreateUserDocuments < ActiveRecord::Migration[5.1]
  def change
    create_table :user_documents do |t|
      t.attachment :document
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
