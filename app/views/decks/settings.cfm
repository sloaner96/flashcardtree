<h2>Deck Settings</h2>

<cfform name="fsettings">

<div id="form-area">
	<label>Deck</label>
	<cfselect query="request.decks" name="idDeck" value="idDeck" display="deckName" id="idDeck_settingsBrowse" selected="#request.idDeck#" queryposition="below" onchange="setDashboardDeck($('##idDeck_settingsBrowse option:selected').val());refreshTab('decksSettings');">
		<option value="null">Select a deck</option>
	</cfselect>
</div>

</cfform>

<cfif val(request.idDeck) EQ 0>
	<!---no deck selected--->
<cfelse>
	
<br>
<cfform method="post">

<div id="form-area">
	<!---
	<cfinput type="hidden" name="commit" value="1">
	<label for="fsubmit"></label>  <cfinput type="submit" name="fsubmit" value="save" class="submit-button">
	<cfinput type="button" name="fsubmit" value="cancel" class="submit-button" onclick="javascript:refreshTab('decksSettings');">
	<br><br>
	--->
	<cfinclude template="includes/deckFormEdit.cfm">
	
	<br>
	<cfinput type="hidden" name="commit" value="1">
	<label for="fsubmit"></label>  <cfinput type="submit" name="fsubmit" value="save" class="submit-button">
	<cfinput type="button" name="fsubmit" value="cancel" class="submit-button" onclick="javascript:refreshTab('decksSettings');">
</div>
</cfform>
	<!---
	<cfdump var="#request.currentDeck#">
	--->
</cfif>