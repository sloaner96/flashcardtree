﻿	<label for="idDeck">Deck</label>
	<cfselect query="decks" name="idDeck" value="idDeck" display="deckName" selected="#request.idDeck#" queryposition="below">
		<option value="">Don't assign a deck right now</option>
	</cfselect>
	<br>
	
	<!--- layout options --->
	<label for="back">Layout</label>
	<input type="checkbox" name="defaultLayout" value="1" id="cb_defaultLayout" class="mycheckbox" checked /> <label for="cb_defaultLayout" class="tags">Use Default Layout <cftooltip tooltip="You can edit the default layout under 'Deck Settings'.  The default layout will override any font options in the 'Front' and 'Back' fields below."><img src="/public/img/box-question.gif"></cftooltip> </label> <br>

	<!---
	<label for="front">Front</label>
	<cftextarea name="front" rows="4" cols="40" value="#request.front#" />
	--->
	<cfset tval = '<span style="font-size: 24px; ">&nbsp;</span>'>
	
	<label for="front">Front</label>
	<cftextarea name="front" 
	            richtext="true"
							skin="default"
							toolbar="Flashcard_Basic" 
							value="#tval#" height="200" width="700" html="true" />
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
							value="#tval#" height="200" width="700" html="true" />
	<br>

	<label for="back">Tags</label>
	<!--- list available tags used previously --->
<div id="cblist_add" style="float:left;">
<cfoutput query="tagNamesRecord">
	<input type="checkbox" name="tags" value="#tagNamesRecord.idTagName#" id="cb_add#tagNamesRecord.currentRow#" class="mycheckbox"<cfif structKeyExists(rc,"idTag#tagNamesRecord.idTagName#isChecked")> checked</cfif> /> <label for="cb_add#tagNamesRecord.currentRow#" class="tags">#urlDecode(tagNamesRecord.tagName)#</label> <br>
</cfoutput>
</div>

<div style="clear:both;"></div>

<label for="txtName">New Tag</label>
<input type="text" id="addCheckboxName_add" />
<input type="button" value="add" id="btnSave" onclick="addCheckbox_add()" />