module HomeHelper
	def user_document
		user_signed_in? && current_user.user_documents.any?
	end
	def all_documents
		current_user.user_documents.all
	end

	def new_file_path
		"#{Rails.root}/public/attachments/new-file#{(UserDocument.ids.last.to_i+1)}.pdf"
	end
	def home_params
    row=1
    home_data= Hash.new{|h,k| h[k]=[]}
    while row<=params[:rowcount].to_i do
      home_data[row]<< params["title#{row}"]
      home_data[row]<< params["content#{row}"]
      row+=1
    end
    return home_data
  end
  def file_path
  	"#{Rails.root}/public/attachments/"
  end
end
