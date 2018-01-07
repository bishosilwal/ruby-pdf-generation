function insRow(){
	var tableRow=  $("#user-document-table tbody");
	var rowCount=tableRow.children().length;
	var newFieldColumn= "<td><input type='text' name='title"+(rowCount+1)+"' class='form-control' placeholder='Enter title of content'/></td>";
	var newAreaColumn= "<td><textarea cols='5' rows='3' name='content"+(rowCount+1)+"' class='form-control' placeholder='Enter content'/></td>";
	var newRow= "<tr class='form-group'>"+newFieldColumn+newAreaColumn+"</tr>";
	tableRow.append(newRow);
	var totalRow= parseInt($("#rowcount").val());
	$("#rowcount").val(totalRow+1);
	
}


$(document).ready(function($) {
	$('#viewPdf').on('show.bs.modal', function (event) {
	  var button = $(event.relatedTarget) // Button that triggered the modal
	  var docId = button.data('id') // Extract info from data-* attributes

	  // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
	  // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead. 
	  $(this).find('.modal-body,.user-form, #pdfObject').attr("data","/home/"+docId+".pdf")


	});	
	
	$('#sharePdf').on('show.bs.modal',function(event){
		var button =$(event.relatedTarget)
		var docId=button.data('id')
		$(this).find('.modal-body,.user-share-form,#hiddenDocId').val(docId)

	});
	$('.js-example-basic-multiple').select2({
		placeholder: 'Select an email'

	});
});


