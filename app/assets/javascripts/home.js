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

function saveDocument(){
	var docName=$('#document_name').val().trim();
	if (docName.length==0){
		$('#name_error').html("Please enter file name ");
		return;
	}

	source = $('#userEditor').froalaEditor('html.get',true); 
	var doc = new jsPDF();
	doc.fromHTML(
  	source,
  	15,
  	15,
  	{
    'width': 180
  	});
	var userPdf=doc.output();
	var formData=new FormData();
	formData.append("userpdf",userPdf);

	formData.append("parent_folder_id",$('#parent_folder_id').val());
	formData.append("doc_name",docName);
	$.ajax({
    url: '/home/',
    data: formData,
    type: 'POST',
    contentType: false, // NEEDED, DON'T OMIT THIS (requires jQuery 1.6+)
    processData: false, // NEEDED, DON'T OMIT THIS
    // ... Other options like success and etc
	});

}

function changeName(id){
	var name = $('#fileName'+id+'').val();
	var formData=new FormData();
	formData.append("name",name);
	$.ajax({
		url: '/home/'+id,
		data:formData,
		type: 'PATCH',
		contentType: false,
		processData: false,
	});
}
function changeFolder(id){
	var name = $('#folderName'+id+'').val();
	var formData=new FormData();
	formData.append("name",name);
	$.ajax({
		url: '/folder/'+id,
		data:formData,
		type: 'PATCH',
		contentType: false,
		processData: false,
	});
}
$(document).ready(function() {

	$(document).on('show.bs.modal', '#viewPdf', function(event) {
	// $('#viewPdf').on('show.bs.modal', function (event) {
	  var button = $(event.relatedTarget) // Button that triggered the modal
	  var docId = button.data('id') // Extract info from data-* attributes

	  // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
	  // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead. 
	  $(this).find('.modal-body,.user-form, #pdfObject').attr("data","/home/"+docId+".pdf")


	});	
			
	
		// $('.js-example-basic-multiple').select2({
		// 	placeholder: 'Select an email'

		// });
	
	$(document).on('show.bs.modal','#sharePdf',function(event){
		$('.js-example-basic-multiple').select2({
			placeholder: 'Select an email'

		});
		var button =$(event.relatedTarget)
		var docId=button.data('id')
		$(this).find('.modal-body,.user-share-form,#hiddenDocId').val(docId)


	});

	// $('#sharePdf').on('show.bs.modal',function(event){
	// 	$('.js-example-basic-multiple').select2({
	// 		placeholder: 'Select an email'

	// 	});
	// 	var button =$(event.relatedTarget)
	// 	var docId=button.data('id')
	// 	$(this).find('.modal-body,.user-share-form,#hiddenDocId').val(docId)

	// });

	$(document).on('focus','#userEditor',function(event){

		$('#userEditor').froalaEditor({
	 	toolbarInline: false,
	 	height: 300
	 });
	});
	$(document).on('show.bs.modal','#shareFolder',function(event){
		$('.js-example-basic-multiple').select2({
			placeholder: 'Select an email'

		});
		var button =$(event.relatedTarget)
		var folderId=button.data('id')
		$(this).find('.modal-body,.folder-share-form,#hiddenFolderId').val(folderId)

	});
	
	// $('#shareFolder').on('show.bs.modal',function(event){
	// 	var button =$(event.relatedTarget)
	// 	var folderId=button.data('id')
	// 	$(this).find('.modal-body,.folder-share-form,#hiddenFolderId').val(folderId)

	// });
	

});


