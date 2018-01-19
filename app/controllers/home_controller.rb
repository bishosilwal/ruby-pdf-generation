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
    ext=File.extname(pdf)
    if ext==".doc"
      send_file(pdf, :filename => File.basename(pdf), :disposition => 'inline',:type=> "application/msword")  
    elsif ext==".pdf"
      send_file(pdf, :filename => File.basename(pdf), :disposition => 'inline',:type => "application/pdf")  
    end

  end

  def new
    @all_folder=Folder.where(user_id: current_user.id)
    @root_folder=@all_folder.where(parent_id: 0).first
  end

  def create
     @document_models =create_document
    if @document_models.nil?
      #flash[:alert]="Document creation failed!!"
      redirect_to folder_path(params[:parent_folder_id])
      return
    end
    flash[:notice]=""
    flash[:alert]=""
    @document_models.each do |document_model|
      if document_model.save
        flash[:notice]+="#{document_model.document_file_name} created,"
      else
        flash[:alert]+="#{document_model.document_file_name} not created,"
      end
    end

    respond_to do |format|
      format.html {redirect_to folder_path(@parent_folder.id)}
      format.pdf do 
        
        send_data(pdf, filename: 'new-document.pdf', type: 'application/pdf')
      end 
    end
  end

  def createdocumentwithfolder
    #params[:document_file].first.headers.split('\;')[2].split("\"")[1].split("\/")
    root_folder=Folder.find_or_create_by(user_id: current_user.id,parent_id: 0,name: nil)
    parent_folder=Folder.find(params[:parent_folder_id])
    documents=params[:document_file]
    uploaded_root_folder_name=documents.first.headers.split(';')[2].split("\"")[1].split("\/").first
    
    prev_folder=Folder.where(parent_id: parent_folder.id,name: uploaded_root_folder_name)
    unless prev_folder.empty?
      flash[:alert]="#{headers.first} folder already exist ,please change folder name."
      redirect_to folder_path(parent_folder.id)
      return
    end 
    new_folder=Folder.create(user_id: current_user.id,parent_id: parent_folder.id,name: uploaded_root_folder_name )
    
    documents.each do |document|
      temp_prev_id=new_folder.id
      headers=document.headers.split(';')[2].split("\"")[1].split("\/")

      headers.each do |header|
        ext=File.extname(header)

        if ext.empty?
            unless header== new_folder.name
              folder=Folder.create(user_id: current_user.id,name: header,parent_id:temp_prev_id)
              temp_prev_id=folder.id
            end
        else
          doc=UserDocument.create(user_id: current_user.id,folder_id: temp_prev_id,document: document)
        end 
      end

    end
    flash[:notice]="folder uploaded successfully"
    redirect_to folder_path(parent_folder.id)

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

  def update
    document=UserDocument.find(params[:id])
    prev_doc=UserDocument.find_by(document_file_name: params[:name])
    unless prev_doc.nil?
      if prev_doc.folder_id==document.folder_id
        flash[:alert]="#{params[:name]} already exist.please choose different file name.."
        redirect_to folder_path(document.folder_id)
        return
      end
    end
    filename=document.document_file_name
    document.document_file_name=params[:name]
    if document.save
      File.rename("public/system/documents/"+document.id.to_s+"/original/"+filename,"public/system/documents/"+document.id.to_s+"/original/"+document.document_file_name)
      flash[:notice]="File name changed"
    else
      flash[:alert]="File name is not changed"
    end
    redirect_to folder_path(document.folder_id)
  end
  
end
