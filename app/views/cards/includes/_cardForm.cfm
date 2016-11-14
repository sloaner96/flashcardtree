	<label for="idDeck">Deck</label>
	<cfselect query="decks" name="idDeck" value="idDeck" display="deckName" selected="#request.idDeck#" queryposition="below">
		<option value="">Don't assign a deck right now</option>
	</cfselect>
	<br>

	<!---
	<label for="front">Front</label>
	<cftextarea name="front" rows="4" cols="40" value="#request.front#" />
	--->
	<label for="front">Front</label>
	<cftextarea name="front" 
	            richtext="true"
							skin="default"
							toolbar="Flashcard_Basic" 
							value="#request.front#" height="200" width="700" />
	<br>

	<!---
	<label for="back">Back</label>
	<cftextarea name="back" rows="4" cols="40" value="#request.back#" />
	--->
	<label for="back">Back</label>
	<cftextarea name="back" 
	            richtext="true"
							skin="default"
							toolbar="Flashcard_Basic" 
							value="#request.back#" height="200" width="700" />
	<br>
	
	<label for="back">Tags</label>
	<!--- list available tags used previously --->
<div id="cblist" style="float:left;">
<cfoutput query="tagNamesRecord">
	<input type="checkbox" name="tags" value="#tagNamesRecord.idTagName#" id="cb#tagNamesRecord.currentRow#" class="mycheckbox"<cfif structKeyExists(rc,"idTag#tagNamesRecord.idTagName#isChecked")> checked</cfif> /> <label for="cb#tagNamesRecord.currentRow#" class="tags">#urlDecode(tagNamesRecord.tagName)#</label> <br>
</cfoutput>
</div>

<div style="clear:both;"></div>


	<label for="txtName">New Tag</label>
<input type="text" id="txtName" />
<input type="button" value="add" id="btnSave" onclick="addCheckbox()" />

<script type="text/javascript">
$(document).ready(function() {
	//alert('k');
    //$('#btnSave').click(function() {
        //addCheckbox($('#txtName').val());
    //});
});

function addCheckbox(name) {
	alert('k');
	
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
		//alert($(this).next().text());
		
		if ($(this).next().text() == name) {
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
   var html = '<input type="checkbox" name="tags" id="cb'+id+'" value="'+encodeURIComponent(name)+'" checked /> <label for="cb'+id+'" class="tags">'+name+'</label><br>';
   container.append($(html));
}
</script>