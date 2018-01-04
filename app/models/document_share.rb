class DocumentShare < ApplicationRecord
	validates_presence_of :owner_id,:receipt_id,:doc_id

	scope :shared_documents,->(user_id){where(owner_id: user_id)}

	scope :access_documents,->(user_id){where(receipt_id: user_id)}
end
