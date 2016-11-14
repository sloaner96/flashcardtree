<h2>Study Options</h2>

<cfform name="fstats">

<div id="form-area-wide">
	<label>Deck</label>
	<cfselect query="request.decks" name="idDeck" value="idDeck" display="deckName" id="idDeck_studyBrowse" selected="#request.idDeck#" queryposition="below" onchange="setDashboardDeck($('##idDeck_studyBrowse option:selected').val());refreshTab('decksStudy');">
		<option value="null">Select a deck</option>
	</cfselect>
</div>

</cfform>

<cfif val(request.idDeck) EQ 0>
	<!---no deck selected--->
<cfelse>


<cfif request.getCards.recordCount EQ 0>
	<cfoutput>
	<p>You haven't added any cards yet.
	<!---  <a href="javascript:addCard(#request.idDeck#);">Add a new card</a></p>--->
	<div id="form-area-wide">
		<input type="button" name="fsubmit" value="add card" class="submit-button" onclick="javascript:addCard($('##idDeck_studyBrowse option:selected').val());">
	</div>
	</cfoutput>
<cfelse>

<!---
		<!--- new cards --->
		<cfargument name="newCardOrder" required="false" default="0"><!--- order added, reverse order added, random --->
		<cfargument name="newCardTiming" required="false" default="0"><!--- throughout, first, at the end --->
		
		<!--- review cards --->
		<cfargument name="reviewOrder" required="false" default="0"><!--- newer, older, order due, random --->
		<cfargument name="reviewFailed" required="false" default="0"><!--- in 10 minutes, soon, at the end --->
--->
<cfoutput>
<form method="post" action="#nav('decks.study')#" name="fstudy" target="_parent">
</cfoutput>

<div id="form-area-wide">
	<label for="newCardOrder">New Card Display Order</label>
	<select name="newCardOrder">
		<option value="0">Display in the order that they were added</option>
		<option value="1">Display in the reverse order that they were added</option>
		<option value="2">Randomize</option>
	</select>
	<br>
	
	<label for="newCardTiming">New Card Timing</label>
	<select name="newCardTiming">
		<option value="0">Alternate with review cards</option>
		<option value="1">Introduce new cards first</option>
		<option value="2">Introduce new cards last</option>
	</select>
	<br>
	
	<label for="reviewOrder">Deck Review Order</label>
	<select name="reviewOrder">
		<option value="0">Review newer cards first</option>
		<option value="1">Review older cards first</option>
		<option value="2" selected>Order due</option>
		<option value="3">Randomze</option>
	</select>
	<br>
	
	<label for="reviewFailed">Failed Cards</label>
	<select name="reviewFailed">
		<option value="0">Show again in 10 minutes</option>
		<!---<option value="1">Show again soon</option>--->
		<option value="2">Show after everything else</option>
	</select>
	<br>
	
	<label for="newCardMax">Maximum New Cards Per Day</label>
	<input type="text" name="newCardMax" value="50">
	<br>
	
	<cfoutput>
	<input type="hidden" name="idDeck" value="#request.idDeck#">
	</cfoutput>
	
	<label for="fsubmit"></label>  <input type="submit" name="fsubmit" value="study" class="submit-button">
</div>

</form>


</cfif>

<!---
decks.view

<cfdump var="#request.getCards#">
<cfdump var="#request.currentDeck#">
--->

</cfif>