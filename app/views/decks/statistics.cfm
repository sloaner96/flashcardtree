<h2>Study Statistics</h2>

<!---
<cfdump var="#request#">
<cfform name="fstats" method="post" action="#nav('decks.statistics')#&embedded=#request.embedded#">
--->
<cfform name="fstats">

<div id="form-area">
	Deck
	<cfselect query="request.decks" name="idDeck" value="idDeck" display="deckName" id="idDeck_statisticsBrowse" selected="#request.idDeck#" queryposition="below" onchange="setDashboardDeck($('##idDeck_statisticsBrowse option:selected').val());refreshTab('decksStats');">
		<option value="">Select a deck</option>
	</cfselect>
	</h2> 
	<!---
	<cfinput type="button" name="fsubmit" value="add card" class="submit-button" onclick="javascript:addCard($('##idDeck_browse option:selected').val());">
	<cfinput type="button" name="fsubmit" value="study deck" class="submit-button" onclick="javascript:reviewDeck($('##idDeck_browse option:selected').val());">
	--->
</div>

</cfform>

<cfif val(request.idDeck) EQ 0>
	<!---no deck selected--->
<cfelse>

<cfoutput>
<!---
<h2>Deck Statistics: #request.currentDeck.deckName#</h2>
<cfdump var="#currentDeck#">
<cfdump var="#getReviewStats#">
--->
<cfset weeklyPerformance = request.weeklyPerformance>
<cfset cardsDue = request.cardsDue>

<ul>

<li>#request.dueNow# card<cfif request.dueNow NEQ 1>s</cfif> due now</li>
<li>#request.newCards# new card<cfif request.newCards NEQ 1>s</cfif></li>
<li>#request.dueLaterToday# card<cfif request.dueToday NEQ 1>s</cfif> due later today</li>
<li>Next card due #request.dueNextLabel#</li>

<br>
<div id="form-area">
<input type="button" name="fsubmit" value="study deck" class="submit-button" onclick="javascript:reviewDeck(#request.idDeck#);">
</div>

</ul>

</cfoutput>

<!-- display performance for today -->
<h3>Daily Performance</h2>

<cfset todayStats = weeklyPerformance[1]>
<cfif todayStats.totalReviews EQ 0>
	You haven't reviewed this deck yet today
	<br>&nbsp;
<cfelse>
	<cfoutput>

	<ul>
		<li>#todayStats.totalReviews# Total Reviews</li>
		<li>#todayStats.totalNew# New Cards</li>
		<li>#round(todayStats.totalCorrect)#% (#todayStats.passes#) Correct</li>
		<li>#round(todayStats.totalIncorrect)#% (#todayStats.fails#) Incorrect</li>
	</ul>
	<!---
	<table border="1" cellpadding="0" cellspacing="0">
	<tr><td>Total Reviews</td><td>#todayStats.totalReviews#</td></tr>
	<tr><td>New Cards</td><td>#todayStats.totalNew#</td></tr>
	<tr><td>Correct</td><td>#todayStats.passes# (#round(todayStats.totalCorrect)#%)</td></tr>
	<tr><td>Incorrect</td><td>#todayStats.fails# (#round(todayStats.totalIncorrect)#%)</td></tr>
	</table>
	--->
	</cfoutput>
</cfif>

<!-- weekly performance -->
<h3>Weekly Performance</h3>

<cfchart format="png" chartwidth="800" chartheight="300" showlegend="true">
	<cfchartseries type="bar" serieslabel="Total Reviews" seriescolor="0080ff">
		<cfloop from="6" to="0" index="indexDay" step="-1">
			<cfset tpos = indexDay + 1>
			<cfchartdata item="#dateFormat(weeklyPerformance[tpos].date,"m-dd")#" value="#weeklyPerformance[tpos].totalReviews#">
		</cfloop>
	</cfchartseries>
	<cfchartseries type="bar" serieslabel="New Cards" seriescolor="ff8000">
		<cfloop from="6" to="0" index="indexDay" step="-1">
			<cfset tpos = indexDay + 1>
			<cfchartdata item="#dateFormat(weeklyPerformance[tpos].date,"m-dd")#" value="#weeklyPerformance[tpos].totalNew#">
		</cfloop>
	</cfchartseries>
	<cfchartseries type="bar" serieslabel="Passes" seriescolor="008000">
		<cfloop from="6" to="0" index="indexDay" step="-1">
			<cfset tpos = indexDay + 1>
			<cfchartdata item="#dateFormat(weeklyPerformance[tpos].date,"m-dd")#" value="#weeklyPerformance[tpos].passes#">
		</cfloop>
	</cfchartseries>
	<cfchartseries type="bar" serieslabel="Fails" seriescolor="800000">
		<cfloop from="6" to="0" index="indexDay" step="-1">
			<cfset tpos = indexDay + 1>
			<cfchartdata item="#dateFormat(weeklyPerformance[tpos].date,"m-dd")#" value="#weeklyPerformance[tpos].fails#">
		</cfloop>
	</cfchartseries>
</cfchart>

<br><br>

<!--- display cards due in the next 30 days --->
<h3>Cards Due (next 30 days)</h3>

<cfchart format="png" chartwidth="800" chartheight="300">
	<cfchartseries type="bar" seriescolor="0080ff">
		<cfloop from="0" to="30" index="indexDay">
			<cfset dateOffset = indexDay>
			<cfset tpos = indexDay + 1>
			<cfchartdata item="#dateFormat(cardsDue[tpos].date,"m-dd")#" value="#cardsDue[tpos].due#">
		</cfloop>
	</cfchartseries>
</cfchart>

<!---
<cfdump var="#weeklyPerformance#">
<cfoutput>
<table border="1" cellpadding="0" cellspacing="0">
<tr>
	<td>&nbsp;</td>
	<cfloop from="6" to="0" index="indexDay" step="-1">
		<cfset tpos = indexDay + 1>
		<td>#dateFormat(weeklyPerformance[tpos].date,"mm-dd-yyyy")#</td>
	</cfloop>
</tr>
<tr>
	<td>Total Reviews</td>
	<cfloop from="6" to="0" index="indexDay" step="-1">
		<cfset tpos = indexDay + 1>
		<td>#weeklyPerformance[tpos].totalReviews#</td>
	</cfloop>
</tr>
<tr>
	<td>New Cards</td>
	<cfloop from="6" to="0" index="indexDay" step="-1">
		<cfset tpos = indexDay + 1>
		<td>#weeklyPerformance[tpos].totalNew#</td>
	</cfloop>
</tr>
<tr>
	<td>Correct</td>
	<cfloop from="6" to="0" index="indexDay" step="-1">
		<cfset tpos = indexDay + 1>
		<td>#weeklyPerformance[tpos].passes# (#round(weeklyPerformance[tpos].totalCorrect)#%)</td>
	</cfloop>
</tr>
<tr>
	<td>Incorrect</td>
	<cfloop from="6" to="0" index="indexDay" step="-1">
		<cfset tpos = indexDay + 1>
		<td>#weeklyPerformance[tpos].fails# (#round(weeklyPerformance[tpos].totalIncorrect)#%)</td>
	</cfloop>
</tr>
</table>
</cfoutput>
--->

<!---
all
<cfdump var="#cardsDue#">
<cfdump var="#getDueCards30#">
--->


</cfif>