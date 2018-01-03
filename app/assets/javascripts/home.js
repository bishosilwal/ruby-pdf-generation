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