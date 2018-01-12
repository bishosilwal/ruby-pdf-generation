class FolderController < ApplicationController
  before_action :authenticate_user!
  def index
  end

  def create
   new_folder=Folder.new(name: folder_params[:folder_name],parent_id: folder_params[:parent_folder],user_id: current_user.id)
   if new_folder.save
    flash[:notice]="New Folder create successfully"
   else
    flash[:alert]="New Folder create failed"
   end 
   redirect_to folder_path(folder_params[:parent_folder])
  end

  def destroy
    @folder=Folder.find(params[:id])
    parent_id=@folder.parent_id
    if @folder.destroy
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

  def edit
  end

  def folder_params
    params.permit(:folder_name,:parent_folder,:utf8, :authenticity_token, :commit, :method)
  end
end
