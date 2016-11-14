<!---
<h2>Browse / edit cards</h2>
<br>
--->
<cfform name="fcards">

<div id="form-area">
	Deck 
	<cfselect query="decks" name="idDeck_browse" value="idDeck" display="deckName" selected="#request.idDeck#" queryposition="below" onchange="setDashboardDeck($('##idDeck_browse option:selected').val());">
		<option value="">View All Cards</option>
		<option value="0">Unassigned (not in any deck)</option>
	</cfselect>
	
	<cfinput type="button" name="fsubmit" value="add card" class="submit-button" onclick="javascript:addCard($('##idDeck_browse option:selected').val());">
	<cfinput type="button" name="fsubmit" value="study deck" class="submit-button" onclick="javascript:reviewDeck($('##idDeck_browse option:selected').val());">
	
</div>

<cfajaxproxy bind="javascript:editCard({cardGrid.idCard})" />
<cfgrid name="cardGrid" 
				format="html" 
				pagesize="5"
				preservePageOnSort="true"
				bind="cfc:gateways.cards.getCardGrid({cfgridpage},{cfgridpagesize},{cfgridsortcolumn},{cfgridsortdirection},{idDeck_browse})" 
				sort="true"
				stripeRows="true" 
				fontSize="14"
				width="'800'" 
				autowidth="true"
				selectOnLoad="false">
	<cfgridcolumn name="idCard" display="false">
	<cfgridcolumn name="front" header="Front">
	<cfgridcolumn name="back" header="Back">
</cfgrid>

</cfform>
<!---
<cfset ajaxonload("init")>
--->