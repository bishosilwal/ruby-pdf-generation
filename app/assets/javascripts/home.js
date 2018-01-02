function insRow(){
	var tableRow=  $("#user-document-table tbody");
	var rowCount=tableRow.children().length;
	var newFieldColumn= "<td><input type='text' name='title"+(rowCount+1)+"' class='form-control' placeholder='Enter title of content'/></td>";
	var newAreaColumn= "<td><textarea cols='5' rows='3' name='content"+(rowCount+1)+"' class='form-control' placeholder='Enter content'/></td>";
	var newRow= "<tr class='form-group'>"+newFieldColumn+newAreaColumn+"</tr>";
	tableRow.prepend(newRow);
	var totalRow= parseInt($("#rowcount").val());
	$("#rowcount").val(totalRow+1);
	//$("#user-document-table tbody:last").append("<tr class='form-group'><td><input type='text' name='title3' id="" class='form-control'/></td><td><textarea rows='3' cols='10' name='content3' class='form-control'/></td></tr>")

}