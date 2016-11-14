<cfset idDeck = url.idDeck>

<cfset userDO = getDO("users")>
<cfset userRecord = userDO.getRecord()>
<cfset userDecks = getDO("decks")>
<cfset decks = userDecks.getRecord()>
<cfset decksGateway = getGateway("decks")>
<cfset cardsGateway = getGateway("cards")>

<cfset getReviewStats = decksGateway.getReviewStats(userRecord.idUser,idDeck)>
<cfset getDueCards30 = cardsGateway.getDueCards30(userRecord.idUser,idDeck)>

<!--- calculate cards due --->
<cfset cardsDue = arrayNew(1)>
<cfloop from="0" to="30" index="indexDay">
	<cfset dateOffset = indexDay>
	<cfset tpos = indexDay + 1>
	<cfset tdate = dateAdd("d",dateOffset,now())>
	<cfset dateFormatted = dateFormat(tdate,"yyyy-mm-dd")>
	<cfset arrayAppend(cardsDue,structNew())>
	<cfset cardsDue[tpos].date = tdate>
	<!--- calculate due --->
	<cfquery dbtype="query" name="todayDue">
	select count(*) as tval from getDueCards30 
	<cfif indexDay GT 0>
		where (([dateDue] > '#dateFormatted# 00:00:00') AND ([dateDue] < '#dateFormatted# 23:59:59'))
	<cfelse>
		<cfset dateFormatted = dateFormat(now(),"yyyy-mm-dd")>
		where [dateDue] <= '#dateFormatted# 23:59:59'
	</cfif>
	</cfquery>
	<cfset cardsDue[tpos].due = val(todayDue.tval)>
</cfloop>

<cfquery dbtype="query" name="todayDue">
select count(*) as tval from getDueCards30 
where [dateDue] <= '#dateFormat(now(),"yyyy-mm-dd")# #timeFormat(now(),"HH:mm:ss")#'
</cfquery>
<cfquery dbtype="query" name="dueNext" maxrows="100">
select * from getDueCards30 
where [dateDue] >= '#dateFormat(now(),"yyyy-mm-dd")# #timeFormat(now(),"HH:mm:ss")#' order by dateDue asc
</cfquery>
<cfset dueNow = val(todayDue.tval)>
<cfset dueLaterToday = cardsDue[1].due - dueNow>
<cfset dueNextTime = abs(dateDiff("n",dueNext.dateDue,now()))>
<cfif dueLaterToday EQ 0>
	<cfset dueNextLabel = "on #dateFormat(dueNext.dateDue,"mm-dd-yyyy")#">
<cfelseif dueNextTime GT 60>
	<cfset dueNextTime = abs(dateDiff("h",dueNext.dateDue,now()))>
	<cfif dueNextTime GT 1>
		<cfset dueNextLabel = "in #dueNextTime# hours">
	<cfelse>
		<cfset dueNextLabel = "in #dueNextTime# hour">
	</cfif>
<cfelse>
	<cfif dueNextTime GT 1>
		<cfset dueNextLabel = "in #dueNextTime# minutes">
	<cfelse>
		<cfset dueNextLabel = "in #dueNextTime# minute">
	</cfif>
</cfif>

<!--- calculate weekly performance --->
<cfset weeklyPerformance = arrayNew(1)>
<cfloop from="0" to="6" index="indexDay">
	<cfset dateOffset = indexDay * - 1>
	<cfset tpos = indexDay + 1>
	<cfset tdate = dateAdd("d",dateOffset,now())>
	<cfset dateFormatted = dateFormat(tdate,"yyyy-mm-dd")>
	<cfset arrayAppend(weeklyPerformance,structNew())>
	<cfset weeklyPerformance[tpos].date = tdate>
	<!--- calculate performance --->
	<cfquery dbtype="query" name="todayStats">
	select * from getReviewStats 
	where [date] = '#dateFormatted#'
	</cfquery>
	<cfif todayStats.recordCount EQ 0>
		<cfset weeklyPerformance[tpos].totalReviews = 0>
		<cfset weeklyPerformance[tpos].passes = 0>
		<cfset weeklyPerformance[tpos].fails = 0>
		<cfset weeklyPerformance[tpos].totalCorrect = 0>
		<cfset weeklyPerformance[tpos].totalIncorrect = 0>
		<cfset weeklyPerformance[tpos].totalNew = 0>
	<cfelse>
		<cfset weeklyPerformance[tpos].totalReviews = todayStats.passes + todayStats.fails>
		<cfset weeklyPerformance[tpos].passes = todayStats.passes>
		<cfset weeklyPerformance[tpos].fails = todayStats.fails>
		<cfset weeklyPerformance[tpos].totalReviews = todayStats.passes + todayStats.fails>
		<cfset weeklyPerformance[tpos].totalCorrect = todayStats.passes / weeklyPerformance[tpos].totalReviews * 100>
		<cfset weeklyPerformance[tpos].totalIncorrect = todayStats.fails / weeklyPerformance[tpos].totalReviews * 100>
		<cfset weeklyPerformance[tpos].totalNew = todayStats.newCards>
	</cfif>
</cfloop>

<cfquery dbtype="query" name="thisDeck">
select * from decks where idDeck = #idDeck#
</cfquery>

<cfoutput>
<h2>Deck Statistics: #thisDeck.deckName#</h2>
<!---
<cfdump var="#thisDeck#">
<cfdump var="#getReviewStats#">
--->
<ul>

<li>#dueNow# cards due now</li>
<li>#dueLaterToday# card<cfif dueToday NEQ 1>s</cfif> due later today</li>
<li>Next card in the future is due #dueNextLabel#</li>

<br>
<div id="form-area">
<input type="button" name="fsubmit" value="review deck" class="submit-button" onclick="javascript:viewDeck(#idDeck#);">
</div>

</ul>

</cfoutput>

<!-- display performance for today -->
<h3>Daily Performance</h2>

<cfset todayStats = weeklyPerformance[1]>
<cfif todayStats.totalReviews EQ 0>
	You haven't reviewed this deck yet today
<cfelse>
	<cfoutput>
	<table border="1" cellpadding="0" cellspacing="0">
	<tr><td>Total Reviews</td><td>#todayStats.totalReviews#</td></tr>
	<tr><td>New Cards</td><td>#todayStats.totalNew#</td></tr>
	<tr><td>Correct</td><td>#todayStats.passes# (#round(todayStats.totalCorrect)#%)</td></tr>
	<tr><td>Incorrect</td><td>#todayStats.fails# (#round(todayStats.totalIncorrect)#%)</td></tr>
	</table>
	</cfoutput>
</cfif>

<br><br>

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
<h3>Cards Due</h3>

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