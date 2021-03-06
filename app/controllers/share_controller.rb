class ShareController < ApplicationController
	include ShareHelper
	before_action :authenticate_user!
  def create

  	@ids=share_params[:users_id]
    @ids.each do |id|
      DocumentShare.create!(
          owner_id: current_user.id,
          receipt_id: id,
          doc_id: share_params[:doc_id]
          )
      NotificationMailer.notify_user_with_document(current_user,id,share_params[:doc_id]).deliver_now
    end
    redirect_to home_index_path,notice: "Document share successfully"
  end

  def destroy
  	@doc=DocumentShare.find(params[:id])
  	if @doc.destroy
  		flash[:notice]="Document Unshared successfully"
  	else
  		flash[:alert]="Document is not unshared successfully"

  	end
  		redirect_to sharedbyme_path
  end

  def sharefolder
    @ids=share_params[:users_id]
    @ids.each do |id|
      FolderShare.create!(
          owner_id: current_user.id,
          receipt_id: id,
          folder_id: share_params[:folder_id]
          )
      password=Folder.find(share_params[:folder_id]).password
       @form_auth_token = form_authenticity_token
       NotificationMailer.notify_user_with_folder(current_user,id,share_params[:folder_id],password).deliver_now
    end
    redirect_to home_index_path,notice: "Folder share successfully"
  end

  def unsharefolder
    @folder=FolderShare.find(params[:folder_id])
    if @folder.destroy
      flash[:notice]= "Folder unshared successfully"
    else
      flash[:alert]= "Folder is not unshared!!!"
    end
    redirect_to sharedbyme_path

  end

  def show
    @document=DocumentShare.find_by(doc_id: params[:id])
    if current_user.id == @document.receipt_id
        pdf=pdf_file(@document.doc_id)

        send_file(pdf,:filename=> "new-document.pdf",:disposition=>"inline",:type=> "application/pdf")
    else
      redirect_to home_index_path
    end
  end

   def sharedbyme
    @shared_documents=DocumentShare.shared_documents(current_user.id).page(params[:share_documents]).per(12)
  
    if share_document
     @shared_folders=FolderShare.shared_folders(current_user.id).page(params[:share_documents]).per(12)
    end
  end

  def sharedwithme
    if user_signed_in?
      @access_documents=DocumentShare.access_documents(current_user.id).page(params[:access_documents]).per(12)
      @access_folders=FolderShare.access_folders(current_user.id).page(params[:access_documents]).per(12) 
    end
  end

  def share_params
    params.permit(:utf8, :method, :authenticity_token, :commit,{:users_id=> []},:doc_id,:folder_id)
  end

end

