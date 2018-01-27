class NotificationMailer < ApplicationMailer

	def notify_user_with_document(userOwner,userReceiptId,docId)
		@userOwner=userOwner
		@userReceipt=User.find(userReceiptId)
		@docId=docId
		mail(to: @userReceipt.email ,
				subject: "#{@userOwner.email} share document with you ",
				template_path: "notification_mailer",
				template_name: "notify_user_with_document")

	end

	def notify_user_with_folder(owner,receiptId,folderId,password="")
		@owner=owner
		@receipt=User.find(receiptId)
		@folderId=folderId
		@password=password
		mail(to: @receipt.email ,
				subject: "#{@owner.email} share folder with you ",
				template_path: "notification_mailer",
				template_name: "notify_user_with_folder")
	end
end
