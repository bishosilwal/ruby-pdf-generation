class FolderShare < ApplicationRecord
	validates_presence_of :owner_id,:receipt_id,:folder_id

	scope :shared_folders,->(user_id){where(owner_id: user_id)}

	scope :access_folders,->(user_id){where(receipt_id: user_id)}
end
