module ShareHelper
  def user_document
		user_signed_in? && current_user.user_documents.any?
	end
	def share_document
		user_signed_in? && current_user.folders.any?
	end
end
