class NotificationMailer < ApplicationMailer

	def notify_user(userOwner,userReceipt)
		@userOwner=userOwner
		@userReceipt=userReceipt
		mail(to: @userReceipt.email ,
				subject: "#{@userOwner.email} share document with you ",
				template_path: "notification_mailer",
				template_name: "notify_user")

	end
end
