cfwindow test

<!---<p>create a new card</p>

<cfform method="post" action="#nav('cards.add')#" name="fadd">
	front<br><cftextarea name="front" rows="4" cols="80" />
	<br>
	back<br><cftextarea name="back" rows="4" cols="80" />
	<br>
	tags
	<!--- list available tags used previously --->
<div id="cblist">
<cfoutput query="tagNamesRecord">
	<input type="checkbox" value="#tagNamesRecord.tagName#" id="cb#tagNamesRecord.currentRow#" class="mycheckbox" /> <label for="cb#tagNamesRecord.currentRow#">#tagNamesRecord.tagName#</label> <br>
</cfoutput>
</div>

<input type="text" id="txtName" />
<input type="button" value="ok" id="btnSave" />

<script type="text/javascript">
$(document).ready(function() {
    $('#btnSave').click(function() {
        addCheckbox($('#txtName').val());
    });
});

function addCheckbox(name) {
	
	
	tid = 'cb1';
	tval = $("label[for='" + tid + "']");
	//alert(tval.text());
	name = jQuery.trim(name);
	//alert(name);
	//return;
	tagExists = 0;
	$('#cblist input[type=checkbox]').each(function () {
		//alert(this.next());
		//tval = $("label[for='" + this.id + "']");
		//alert($(this).attr('checked'));
		//alert($(this).val().trim());
		//alert('name=' + name);
		if ($(this).val() == name) {
			tagExists = 1;
			if ($(this).attr('checked') == false) $(this).attr('checked',true);
		}
	});
	
	if (tagExists == 1) return;
	
	//tval = $("#cb1").next();
	//alert(tval.text());

	//alert('ok');
	//return;
	
   var container = $('#cblist');
   var inputs = container.find('input');
   var id = inputs.length+1;
   var html = '<input type="checkbox" id="cb'+id+'" value="'+name+'" /> <label for="cb'+id+'">'+name+'</label><br>';
   container.append($(html));
}
</script>
	
	<br>
	<cfinput type="submit" name="fsubmit" value="save">
	
</cfform>


<form>



</form>--->