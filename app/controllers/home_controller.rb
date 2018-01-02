class HomeController < ApplicationController
  include HomeHelper
  before_action :authenticate_user!,except: [:index]
  def index
    if user_document
        @user_documents=all_documents
    end
  end

  def show
    @document=UserDocument.find(params[:id])
    pdf_filename=file_path+@document.document_file_name 
    send_file(pdf_filename, :filename => "your_document.pdf", :disposition => 'inline', :type => "application/pdf")
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
    send_data  pdf.render,filename: "user-document",
                          type: "application/pdf",
                          disposition: "inline"
    
  end

  def destroy
    @document=UserDocument.find(params[:id])
    file=file_path+@document.document_file_name
    File.delete(file) if File.exist?(file)
    @document.destroy
    redirect_to home_index_path ,notice: "Document successfully deleted.."
  end
end