class HomeController < ApplicationController
  include HomeHelper
  before_action :authenticate_user!,except: [:index]
  def index
    if user_document
        @all_folder=Folder.where(user_id: current_user.id)
        @root_folder=@all_folder.where(parent_id: 0).first
        @folders=@all_folder.where(parent_id: @root_folder.id)
        @documents=all_documents(@root_folder.id).page(params[:user_documents]).per(12)
    end
  end
  def show
    pdf=pdf_file(params[:id])
    send_file(pdf, :filename => "your_document.pdf", :disposition => 'inline', :type => "application/pdf")    
  end

  def new
    @all_folder=Folder.where(user_id: current_user.id)
    @root_folder=@all_folder.where(parent_id: 0).first
  end

  def create

    user_data=home_params
    #generate the pdf document with the user given data content
    pdf=PdfGenerator.new(user_data)
    file_path = new_file_path
    pdf.render_file file_path
    @document_file=File.open(file_path)

    #find if root folder exist ,if not then create one else get existed one
    
    @root_folder=Folder.find_or_create_by(user_id: current_user.id,parent_id: 0,name: nil)
    @parent_folder=Folder.find(params[:parent_folder_id])
    @document_model=UserDocument.new
    @document_model.document=@document_file
    @document_model.user_id=current_user.id

    #put newly created document to the root folder
    @document_model.folder_id=@parent_folder.id
    if @document_model.save
      flash[:notice]="Document's pdf successfully created"
    else
      flash[:alert]="pdf is not created"
    end
    respond_to do |format|
      format.html {redirect_to folder_path(@parent_folder.id)}
      format.pdf do 
        
        send_data(pdf, filename: 'new-document.pdf', type: 'application/pdf')
      end 
    end
  end

  def destroy
    @document=UserDocument.find(params[:id])
    file=file_path+@document.document_file_name
    File.delete(file) if File.exist?(file)
    @document.destroy
    @document_share=DocumentShare.find_by(doc_id: params[:id])
    if @document_share
      @document_share.destroy
    end
    redirect_to home_index_path ,notice: "Document successfully deleted.."
  end
  
end
