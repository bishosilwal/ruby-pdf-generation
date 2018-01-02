class PdfGenerator < Prawn::Document

	def initialize(data)
		super(top_margin: 50,left_margin: 100)
		@data=data
		text "#{Time.zone.now}"
		document_details
	end

	def document_details
		move_down 40
		@data.each do |key,value|
			font_size 16
			text (key.to_s+". "+value[0])
			font_size 10
			text ("="+value[1])	
		end
	end

end