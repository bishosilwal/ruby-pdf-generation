//Drag and Drop folder and file handling

function dragFolder(ev,folderId){
 ev.dataTransfer.setData("childFolderId",folderId);
}

function dropFolder(ev,parentFolderId){
  ev.preventDefault();
	childFolderId=ev.dataTransfer.getData("childFolderId");
	fileId=ev.dataTransfer.getData("fileId");
	var formData=new FormData();
	var destUrl;
	if(childFolderId){
		formData.append("childFolderId",childFolderId);
		destUrl='/appendfolder/';
	}else if(fileId){
		formData.append("fileId",fileId);
		destUrl='/appendfile/';
	}
	
	formData.append("parentFolderId",parentFolderId);

	$.ajax({
		url:destUrl,
		data:formData,
		type: 'POST',
		contentType: false,
		processData: false,
	});
}

function allowFolderDrop(ev){
	ev.preventDefault();
}

function dragFile(ev,fileId){
	ev.dataTransfer.setData("fileId",fileId);
}

//drag and drop file and folder end



function saveDocument(){
	var docName=$('#document_name').val().trim();
	if (docName.length==0){
		$('#name_error').html("Please enter file name ");
		return;
	}

	source = $('#userEditor').froalaEditor('html.get',true); 
	if(source.length==0){
		$('#name_error').html("Please enter some content in editor");
		return
	}
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
	formData.append("document_name",docName);
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


function checkPassword(isNil,id){
	var password='';
	if(isNil=="false"){
		password=prompt("Enter folder password:");
		if(password==""){
			return;
		}
		$('#hiddenPassword'+id).val(password);
	}
	
	$('#passwordForm'+id).trigger("submit");
	
}
var selectedFolder=[];
function folderClick(element,folderId){
	if(selectedFolder.includes(folderId)){
		var index=selectedFolder.indexOf(folderId);
		if (index > -1) {
    selectedFolder.splice(index, 1);
		}
		element.style.backgroundColor= null;
	}else{
		selectedFolder.push(folderId);
		element.style.backgroundColor= "#708aef";
	}
}
function handleRightClick(element,event){
	event.preventDefault();
	console.log(event.pageX + "," + event.pageY);
  $("#rightclick").css("left",event.pageX);
  $("#rightclick").css("top",event.pageY);
  $("#rightclick").fadeIn(200,startFocusOut()); 
}

function startFocusOut(){
  $(document).on("click",function(){
  $("#rightclick").hide();        
  $(document).off("click");
  });
}
function download(){
	window.location="http://localhost:3000/folderdownload.zip?folders="+selectedFolder
	
}

$(document).ready(function() {

	$(document).on('show.bs.modal', '#viewPdf', function(event) {
	// $('#viewPdf').on('show.bs.modal', function (event) {
	  var button = $(event.relatedTarget) // Button that triggered the modal
	  var docId = button.data('id') // Extract info from data-* attributes

	  // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
	  // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead. 
	  $(this).find('.modal-body,.user-form, #pdfObject').attr("data","/home/"+docId)
	  
	});	
	
	
	$(document).on('show.bs.modal','#sharePdf',function(event){
		$('.js-example-basic-multiple').select2({
			placeholder: 'Select an email'

		});
		var button =$(event.relatedTarget)
		var docId=button.data('id')
		$(this).find('.modal-body,.user-share-form,#hiddenDocId').val(docId)


	});


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

	$(document).on('show.bs.modal','#passwordFolder',function(event){
		var button =$(event.relatedTarget)
		var folderId=button.data('id')
		$(this).find('.modal-body,.folder-password-form,#hiddenFolderId').val(folderId)

	});


});


