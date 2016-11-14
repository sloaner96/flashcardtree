<!---
<h2>Flashcard Decks</h2>
--->
<h2>Flashcard Decks</h2>

<cfif request.decks.recordCount EQ 0>
	<h2>You haven't created any decks yet</h2>
</cfif>

<cfform name="fdecks">
<!---
<cfajaxproxy bind="javascript:viewDeck({deckGrid.idDeck})" />--->

<cfajaxproxy bind="javascript:viewDeck({deckGrid.idDeck})" />
<cfgrid name="deckGrid" 
				format="html" 
				preservePageOnSort="true"
				bind="cfc:gateways.decks.getDeckGrid({cfgridpage},{cfgridpagesize},{cfgridsortcolumn},{cfgridsortdirection})" 
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

<!---
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
--->
<div id="form-area">
	<br>
	<cfinput type="button" name="fsubmit" value="new deck" class="submit-button" onclick="javascript:addDeck(0);">
</div>

</cfform>