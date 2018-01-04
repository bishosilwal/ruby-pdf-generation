class NotificationMailerPreview < ActionMailer::Preview

	def notify_user_preview
		NotificationMailer.notify_user(userOwner: User.first,userRecipt: User.first)
	end


end