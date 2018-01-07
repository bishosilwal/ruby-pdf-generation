class HomeController < ApplicationController
  include HomeHelper
  before_action :authenticate_user!,except: [:index]
  def index
    if user_document
        @user_documents=all_documents
        @shared_documents=DocumentShare.shared_documents(current_user.id)
    end
    if user_signed_in?
      @access_documents=DocumentShare.access_documents(current_user.id)
    end
    
  end

  def show
    pdf=pdf_file(params[:id])
    send_file(pdf, :filename => "your_document.pdf", :disposition => 'inline', :type => "application/pdf")
    
  end

  def new
  end

  def create
    user_data=home_params
    pdf=PdfGenerator.new(user_data)
    file_path = new_file_path
    pdf.render_file file_path
    @document_file=File.open(file_path)
    @document_model=UserDocument.new
    @document_model.document=@document_file
    @document_model.user_id=current_user.id
    if @document_model.save
      flash[:notice]="Document's pdf successfully created"
    else
      flash[:alert]="pdf is not created"
    end
    respond_to do |format|
      format.html {redirect_to home_index_path}
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
    redirect_to home_index_path ,notice: "Document successfully deleted.."
  end

  # def share
  #   @emails=share_params[:users_email]
  #   @emails=@emails.split(',')
  #   @users_id=[]
  #   @emails.each do |email|
  #     id = user_id(email)
  #     @users_id<< id unless id.nil? 
  #   end

  #   @users_id.each do |id|
  #     DocumentShare.create!(
  #         owner_id: current_user.id,
  #         receipt_id: id,
  #         doc_id: share_params[:doc_id]
  #         )
  #   end
  #   redirect_to home_index_path,notice: "Document share successfully"
  # end


  
end
