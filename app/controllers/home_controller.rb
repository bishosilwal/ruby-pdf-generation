class HomeController < ApplicationController
  include HomeHelper
  before_action :authenticate_user!
  def index
    @all_folder=Folder.where(user_id: current_user.id)
    @root_folder=@all_folder.where(parent_id: 0).first
    if @root_folder.nil?
      @root_folder=Folder.create(user_id: current_user.id,parent_id: 0)
    end
    @folders=@all_folder.where(parent_id: @root_folder.id)
    @documents=all_documents(@root_folder.id).page(params[:user_documents]).per(12)
   
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
    @document_model =create_document
    if @document_model.nil?
      redirect_to folder_path(@parent_folder.id)
      return
    end
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
