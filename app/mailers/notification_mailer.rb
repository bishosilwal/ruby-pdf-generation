class NotificationMailer < ApplicationMailer

	def notify_user(userOwner,userReceiptId)
		@userOwner=userOwner
		@userReceipt=User.find(userReceiptId)
		mail(to: @userReceipt.email ,
				subject: "#{@userOwner.email} share document with you ",
				template_path: "notification_mailer",
				template_name: "notify_user")

	end
end
