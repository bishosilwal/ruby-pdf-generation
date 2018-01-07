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
      NotificationMailer.notify_user(current_user,id,share_params[:doc_id]).deliver_now
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

  def show
    @document=DocumentShare.find_by(doc_id: params[:id])
    if current_user.id == @document.receipt_id
        pdf=pdf_file(@document.doc_id)

        send_file(pdf,:filename=> "new-document.pdf",:disposition=>"inline",:type=> "application/pdf")
    else
      redirect_to home_index_path
    end
  end

  def share_params
    params.permit(:utf8, :method, :authenticity_token, :commit,{:users_id=> []},:doc_id)
  end

end

