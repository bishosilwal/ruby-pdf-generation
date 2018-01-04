class ShareController < ApplicationController
	include ShareHelper
	before_action :authenticate_user!
  def create

  	@emails=share_params[:users_email]
    @emails=@emails.split(',')
    @users_id=[]
    @emails.each do |email|
      id = user_id(email)
      @users_id<< id unless id.nil? 
    end

    @users_id.each do |id|
      DocumentShare.create!(
          owner_id: current_user.id,
          receipt_id: id,
          doc_id: share_params[:doc_id]
          )
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
  		redirect_to root_path
  end

  def share_params
    params.permit(:users_email,:doc_id)
  end

end
