module HomeHelper
	def user_document
		user_signed_in? && current_user.user_documents.any?
	end
	def all_documents(folder_id)
		current_user.user_documents.where(folder_id: folder_id)
	end

	# def new_file_path
	# 	"#{Rails.root}/public/attachments/new-file#{(UserDocument.ids.last.to_i+1)}.pdf"
	# end
	# def home_params
 #    row=1
 #    home_data= Hash.new{|h,k| h[k]=[]}
 #    while row<=params[:rowcount].to_i do
 #      home_data[row]<< params["title#{row}"]
 #      home_data[row]<< params["content#{row}"]
 #      row+=1
 #    end
 #    return home_data
 #  end
  def file_path
  	"#{Rails.root}/public/system/documents/"
  end

  def pdf_file(id)
    document=UserDocument.find(id)
    pdf_file_path=file_path+document.id.to_s+"/original/"+document.document_file_name 
  end
  def create_document
    #generate the pdf document with the user given data content
    #pdf=PdfGenerator.new(home_params)
    pdf = StringIO.new(params[:userpdf]) #mimic a real upload file
    pdf.class.class_eval { attr_accessor :original_filename, :content_type } #add attr's that paperclip needs
    pdf.original_filename = "your_document.pdf"
    pdf.content_type = "application/pdf"
    
    # file_path = new_file_path
    # pdf.render_file file_path
    # @document_file=File.open(file_path)

    #find if root folder exist ,if not then create one else get existed one
    
    @root_folder=Folder.find_or_create_by(user_id: current_user.id,parent_id: 0,name: nil)
    #find parent folder if document is created inside folder
    @parent_folder=Folder.find(params[:parent_folder_id])
    @document_model=UserDocument.new
    #@document_model.document=@document_file
    @document_model.document=pdf 
    @document_model.user_id=current_user.id

    #put newly created document to the root folder
    @document_model.folder_id=@parent_folder.id
    return @document_model
  end

 
end
