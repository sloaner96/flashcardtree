<!---<cfoutput>
<cfif request.idDeck NEQ "">
<h2>
	My Dashboard
</h2>
<cfelse>
	<h2>My Dashboard</h2>
</cfif>

</cfoutput>
--->
<script>
function refreshTab(tabName) {
	if (tabName == 'decksBrowse') {
		ColdFusion.Layout.selectTab('mainTab','cardsBrowse');
		ColdFusion.Layout.selectTab('mainTab',tabName);
	}
	else {
		ColdFusion.Layout.selectTab('mainTab','decksBrowse');
		ColdFusion.Layout.selectTab('mainTab',tabName);
	}
}
function selectTab(tabName) {
	ColdFusion.Layout.selectTab('mainTab',tabName);
}
</script>

<h2>My Dashboard</h2>
<!---
<a href="javascript:ColdFusion.Grid.refresh('deckGrid',true);">stuff</a>

<a href="javascript:refreshTab('decksStats');">refresh stats</a>

--->
<cfform name="fdashboard">
	<!---<cfinput type="text" name="idDeck" id="dashboard_idDeck" value="#request.idDeck#">--->
	<cfinput type="hidden" name="idDeck" id="dashboard_idDeck" value="#request.idDeck#">
</cfform>
<cfset layoutStyle = "background-color:##ebebeb;padding:10px;">
<cflayout type="tab" name="mainTab" style="font-color:black;color:black;">

	<!--- disable certain tabs if there is no deck selected --->
	<cfset tdisabled = "false">
	<cfif request.idDeck EQ ""><cfset tdisabled = "true"></cfif>

	<!--- tab selector ---><cfif request.tab EQ "decks"><cfset tselected = "true"><cfelse><cfset tselected = "false"></cfif>
	<cflayoutarea title="Flashcard Decks" name="decksBrowse" style="#layoutStyle#" selected="#tselected#" source="#nav('decks.browse')#&idDeck={dashboard_idDeck}&embedded=1" refreshonactivate="true">
	</cflayoutarea>

	<!--- tab selector ---><cfif request.tab EQ "cards"><cfset tselected = "true"><cfelse><cfset tselected = "false"></cfif>
	<cflayoutarea title="Browse Cards" name="cardsBrowse" style="#layoutStyle#" selected="#tselected#" source="#nav('cards.browse')#&idDeck={dashboard_idDeck}&embedded=1" refreshonactivate="true">
	</cflayoutarea>

	<!--- tab selector ---><cfif request.tab EQ "settings"><cfset tselected = "true"><cfelse><cfset tselected = "false"></cfif>
	<cflayoutarea title="Deck Settings" name="decksSettings" style="#layoutStyle#" selected="#tselected#" source="#nav('decks.settings')#&idDeck={dashboard_idDeck}&embedded=1" refreshonactivate="true">
	</cflayoutarea>

	<!--- tab selector ---><cfif request.tab EQ "study"><cfset tselected = "true"><cfelse><cfset tselected = "false"></cfif>
	<cflayoutarea title="Study" name="decksStudy" style="#layoutStyle#" selected="#tselected#" source="#nav('decks.studySettings')#&idDeck={dashboard_idDeck}&embedded=1" refreshonactivate="true">
	</cflayoutarea>

	<!--- tab selector ---><cfif request.tab EQ "stats"><cfset tselected = "true"><cfelse><cfset tselected = "false"></cfif>
	<cflayoutarea title="Study Statistics" name="decksStats" style="#layoutStyle#" selected="#tselected#" source="#nav('decks.statistics')#&idDeck={dashboard_idDeck}&embedded=1" refreshonactivate="true">
	</cflayoutarea>

	<!--- tab selector ---><cfif request.tab EQ "jpdict"><cfset tselected = "true"><cfelse><cfset tselected = "false"></cfif>
	<cflayoutarea title="Japanese-English Dictionary" name="jpdict" style="#layoutStyle#" selected="#tselected#" source="#nav('jpDictionary.search')#&embedded=1" refreshonactivate="true">
	</cflayoutarea>
	
</cflayout>

<!---<h2>Flashcard Decks</h2>
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
<cfform name="fcards">
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
	<cfgridcolumn name="deckName" header="Name">
	<cfgridcolumn name="totalCards" header="Total Cards">
	<cfgridcolumn name="newCards" header="New Cards">
	<cfgridcolumn name="passedCards" header="Passed Cards">
	<cfgridcolumn name="failedCards" header="Failed Cards">
	<cfgridcolumn name="dateCreated" header="Date Created">
</cfgrid>

<div id="form-area">
	<br>
	<cfinput type="button" name="fsubmit" value="new deck" class="submit-button" onclick="javascript:addDeck($('##idDeck_browse option:selected').val());">
</div>

</cfform>


<!---
<div id="searchResults">

<table cellpadding="0" cellspacing="0">
<tr>
	<td>Name</td>
	<td>Date Created</td>
	<td>Actions</td>
</tr>
<cfoutput query="decks">
<tr>
	<td><a href="#nav('decks.view&idDeck=#decks.idDeck#')#">#deckName#</a></td>
	<td>#dateCreated#</td>
	<td>
		<a href="javascript:addCard();">add a new card</a> | 
		<a href="#nav('decks.delete&idDeck=#decks.idDeck#')#">delete deck</a>
	</td>
</tr>
</cfoutput>
</table>

</div>

<cfoutput>
<a href="#nav('decks.add')#">Add a new deck</a>
</cfoutput>
<cfdump var="#decks#">
--->--->