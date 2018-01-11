class Folder < ApplicationRecord
  belongs_to :user
  has_many :user_documents, dependent: :destroy

end
