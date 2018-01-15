class UserDocument < ApplicationRecord
	has_attached_file :document,:path => ":rails_root/public/system/:attachment/:id/:style/:basename.:extension"
	validates_attachment :document,presence: true,content_type: {content_type: "application/pdf"}
  belongs_to :user
  belongs_to :folder
end
