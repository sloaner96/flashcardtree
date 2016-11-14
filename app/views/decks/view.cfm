<!---
<h2>Flashcard Decks</h2>
--->
<!---
<cfset tdecks = getGateway("decks").getDecks(userRecord.getRecord().idUser)>
<cfdump var="#tdecks#">
--->

<cfif decks.recordCount EQ 0>
	<cfoutput>
	<p>You haven't created any decks yet.  <a href="#nav('decks.add')#">add a new deck</a></p>
	</cfoutput>
</cfif>
<!---
<cfform name="fdecks">

<cfgrid name="cardGrid" 
				format="html" 
				preservePageOnSort="true"
				query="decks" 
				sort="true"
				stripeRows="true" 
				fontSize="14"
				width="'800'" 
				autowidth="true"
				selectOnLoad="false">
	<cfgridcolumn name="idDeck" display="false">
	<cfgridcolumn name="deckName" header="Name">
	<cfgridcolumn name="dateCreated" header="Date Created">
</cfgrid>

</cfform>
--->
<cfform name="fdecks">
<!---
<cfajaxproxy bind="javascript:viewDeck({deckGrid.idDeck})" />--->

<cfajaxproxy bind="javascript:viewDeck({deckGrid.idDeck})" />
<cfgrid name="deckGrid" 
				format="html" 
				preservePageOnSort="true"
				query="request.decks" 
				sort="true"
				stripeRows="true" 
				fontSize="14"
				width="'800'" 
				autowidth="true"
				selectOnLoad="false">
	<cfgridcolumn name="idDeck" display="false">
	<cfgridcolumn name="deckName" header="Deck Name">
	<cfgridcolumn name="totalCards" header="Total Cards">
	<cfgridcolumn name="newCards" header="New Cards">
	<cfgridcolumn name="passedCards" header="Passed Cards">
	<cfgridcolumn name="failedCards" header="Failed Cards">
	<cfgridcolumn name="dateCreated" header="Date Created">
</cfgrid>

<div id="form-area">
	<br>
	<cfinput type="button" name="fsubmit" value="new deck" class="submit-button" onclick="javascript:addDeck(0);">
</div>

</cfform>

<!---<cfoutput>
<h2>
	#request.currentDeck.deckName#
</h2>
<h3>
	<a href="#nav('dashboard.home')#">Return to all Flashcard Decks</a>
</h3> 
</cfoutput>

<cfset layoutStyle = "background-color:##ebebeb;padding:10px;">
<cflayout type="tab">

	<cflayoutarea title="My Flashcard Decks" style="#layoutStyle#" selected="true">
		My Flashcard Decks
	</cflayoutarea>

	<cflayoutarea title="Review" style="#layoutStyle#" selected="true">

<cfif request.getCards.recordCount EQ 0>
	<cfoutput>
	<p>You haven't added any cards yet.  <a href="javascript:addCard(#request.idDeck#);">Add a new card</a></p>
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
	
	<label for="fsubmit"></label>  <input type="submit" name="fsubmit" value="review" class="submit-button">
</div>

</form>


</cfif>

<!---
decks.view

<cfdump var="#request.getCards#">
<cfdump var="#request.currentDeck#">
--->
	
	</cflayoutarea>
	
	<cflayoutarea title="Browse Cards" style="#layoutStyle#">
	 <cfinclude template="../cards/browse.cfm">
	</cflayoutarea>
	
	<cflayoutarea title="Deck Settings" style="#layoutStyle#">
	This is the second tab.
	</cflayoutarea>
	
</cflayout>--->