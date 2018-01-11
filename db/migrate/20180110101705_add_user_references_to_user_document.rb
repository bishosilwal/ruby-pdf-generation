class AddUserReferencesToUserDocument < ActiveRecord::Migration[5.1]
  def change
    add_reference :user_documents, :folder, foreign_key: true
  end
end
