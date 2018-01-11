class FolderController < ApplicationController
  before_action :authenticate_user!
  def index
  end

  def create
  end

  def destroy
    byebug
  end

  def show
    @root_folder=Folder.find(params[:id])
    @folders=Folder.where(parent_id: @root_folder.id)
    @documents=UserDocument.where(folder_id: @root_folder.id).page(params[:user_documents]).per(12)
  end

  def edit
  end
end
