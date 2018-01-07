class NotificationMailer < ApplicationMailer

	def notify_user(userOwner,userReceiptId,docId)
		@userOwner=userOwner
		@userReceipt=User.find(userReceiptId)
		@docId=docId
		mail(to: @userReceipt.email ,
				subject: "#{@userOwner.email} share document with you ",
				template_path: "notification_mailer",
				template_name: "notify_user")

	end
end
