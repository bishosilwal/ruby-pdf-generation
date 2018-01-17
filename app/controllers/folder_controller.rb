class FolderController < ApplicationController
  before_action :authenticate_user!
  def index
  end

  def create
   new_folder=Folder.new(name: folder_params[:folder_name],parent_id: folder_params[:parent_folder],user_id: current_user.id)
   prev_folder=Folder.where("parent_id=? AND name=? ",folder_params[:parent_folder],folder_params[:folder_name])
  
   if prev_folder.any?
    flash[:alert]="#{folder_params[:folder_name]} is already exist!! Please choose different name."
    redirect_to folder_path(folder_params[:parent_folder])
    return
   end
   if new_folder.save
    flash[:notice]="New Folder create successfully"
   else
    flash[:alert]="New Folder create failed"
   end 
   redirect_to folder_path(folder_params[:parent_folder])
  end

  def destroy
    @folder=Folder.find(params[:id])
    @foldershare=FolderShare.where(folder_id: @folder.id)
    parent_id=@folder.parent_id
    if @folder.destroy && @foldershare.destroy_all
      flash[:notice]="folder deleted successfully"
    else
      flash[:alert]="folder is not deleted!!"
    end

    redirect_to folder_path(parent_id)
  end

  def show
    @root_folder=Folder.find(params[:id])
    @folders=Folder.where(parent_id: @root_folder.id)
    @documents=UserDocument.where(folder_id: @root_folder.id).page(params[:user_documents]).per(12)
  end

  
  def update
    folder=Folder.find(params[:id])
    prev_folder=Folder.find_by(name: params[:name])
    unless prev_folder.nil?
      if prev_folder.parent_id==folder.parent_id

        flash[:alert]="#{params[:name]} folder already exist,Please choose different folder name.."
        redirect_to folder_path(folder.parent_id)
        return
      end
    end
    folder.name=params[:name]
    if folder.save
      flash[:notice]="Folder name changed successfully"
    else
      flash[:alert]="Folder name is not changed successfully"
    end
    redirect_to folder_path(folder.parent_id)
  end

  def appendfolder
    parent_folder=Folder.find(params[:parentFolderId])
    child_folder=Folder.find(params[:childFolderId])
    child_folder.parent_id=parent_folder.id
    if child_folder.save
      flash[:notice]="Folder moved successfully"
    else
      flash[:alert]="Folder is not moved successfully"
    end
    redirect_to folder_path(parent_folder.parent_id)
  end

  def appendfile
    parent_folder=Folder.find(params[:parentFolderId])
    doc=UserDocument.find(params[:fileId])
    doc.folder_id=parent_folder.id
    if doc.save
      flash[:notice]="File moved successfully"
    else
      flash[:alert]="File is not moved successfully"
    end
    redirect_to folder_path(parent_folder.parent_id)
  end

  def folder_params
    params.permit(:folder_name,:parent_folder,:utf8, :authenticity_token, :commit, :method)
  end


end
