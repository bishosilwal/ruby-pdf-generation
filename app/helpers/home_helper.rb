module HomeHelper
	def user_document
		user_signed_in? && current_user.user_documents.any?
	end
	def all_documents(folder_id)
		current_user.user_documents.where(folder_id: folder_id)
	end

  def file_path
  	"#{Rails.root}/public/system/documents/"
  end

  def pdf_file(id)
    document=UserDocument.find(id)
    @doc_name=document.document_file_name
    pdf_file_path=file_path+document.id.to_s+"/original/"+document.document_file_name 

  end
  def create_document
    #pdf uploaded

    if params[:document_file]
      pdf=params[:document_file]
    elsif params[:userpdf] #pdf created using text editor and jspdf
      pdf = StringIO.new(params[:userpdf]) #mimic a real upload file
      pdf.class.class_eval { attr_accessor :original_filename, :content_type } #add attr's that paperclip needs 
      pdf.content_type = "application/pdf"
      pdf.original_filename = params[:document_name]+".pdf"
    else
      flash[:alert]="file must be given!!"
      return
    end 
   
    
    
    #find if root folder exist ,if not then create one else get existed one
    
    @root_folder=Folder.find_or_create_by(user_id: current_user.id,parent_id: 0,name: nil)
    #find parent folder if document is created inside folder
    @parent_folder=Folder.find(params[:parent_folder_id])
    prev_doc=@parent_folder.user_documents.where(document_file_name: pdf.original_filename)
    if prev_doc.any?
      flash[:alert]="#{pdf.original_filename} is already exist .Please choose different file name.."
      return
    end
    @document_model=UserDocument.new
    #@document_model.document=@document_file
    @document_model.document=pdf 
    @document_model.user_id=current_user.id

    #put newly created document to the root folder
    @document_model.folder_id=@parent_folder.id
    return @document_model
  end

 
end
