<!--- get card info --->
<cfset card = getGateway("cards").getCard(arguments.idCard)>

<cfset easyFactorIncrement = 1>
<cfset easyFactorDecrement = 2>
<cfset nextEasyFactorMax = 10>
<cfset nextEasyFactorMin = 0>
<cfset rightNow = now()>

<!--- get next interval --->
<cfif card.currentInterval EQ 0>
	<!--- new card --->
	<cfif rating EQ 0>
		<!---
		fail card with interval of #card.currentInterval#<br>
		set dateDue to +10 minutes and status to fail (2)<br>
		decrement easyFactor by 2<br>
		--->
		<!--- default fail --->
		<cfinclude template="_defaultFail.cfm">
	<cfelse>
		<!---
		pass card with interval of #card.currentInterval#<br>
		set interval to 1, status to pass (1), and dateDue to +10 minutes<br>
		increment easyFactor by 1<br>
		--->
		<cfinclude template="_defaultPass.cfm">
		<cfset dateDue = dateAdd('n',10,rightNow)>
	</cfif>
<cfelseif card.currentInterval EQ 1>
	<!--- second interval --->
	<cfif rating EQ 0>
		<!---
		fail card with interval of #card.currentInterval#<br>
		set dateDue to +10 minutes and status to fail (2)<br>
		decrement easyFactor by 2<br>
		--->
		<!--- default fail --->
		<cfinclude template="_defaultFail.cfm">
	<cfelse>
		<!---
		pass card with interval of #card.currentInterval#<br>
		set interval to 3, status to pass (1), and dateDue to +24 hours<br>
		increment easyFactor by 1<br>
		--->
		<cfinclude template="_defaultPass.cfm">
		<cfset dateDue = dateAdd('d',1,rightNow)>
	</cfif>
<cfelse>
	<!--- interval 3 or higher --->
	<cfif rating EQ 0>
		<!---
		fail card with interval of #card.currentInterval#<br>
		set dateDue to +10 minutes and status to fail (2)<br>
		decrement easyFactor by 2<br>
		if fail and EF == 1 reset interval to 1<br>
		--->
		<!--- default fail --->
		<cfinclude template="_defaultFail.cfm">
		<cfif nextEasyFactor LTE 1>
			<!--- reschedule as a new card --->
			reschedule<br>
			<cfset nextInterval = 0>
			<cfset easyFactor = 1>
		</cfif>
	<cfelse>
		<!---
		pass card with interval of #card.currentInterval#<br>
		increment easyFactor by 1<br>
		increment interval by 1, status to pass (1), and dateDue to +((interval - 1) * easyFactor) days<br>
		--->
		<!--- if last interval was a fail always set the next review date to 24 hours later (unless interval is less than 4) --->
		<!--- don't increment EF or interval this time --->
		<cfif card.status EQ 2>
			<!--- last rating was a fail --->
			<cfset nextEasyFactor = card.easyFactor>
			<cfset nextInterval = card.currentInterval>
			<cfset nextDateIncrement = ((card.currentInterval - 1) * nextEasyFactor)>
			<cfset dateDue = dateAdd('d',1,rightNow)>
		<cfelse>
			<!--- last rating was a pass --->
			<cfinclude template="_defaultPass.cfm">
			<cfset nextDateIncrement = ((card.currentInterval - 1) * nextEasyFactor)>
			<cfset dateDue = dateAdd('d',nextDateIncrement,rightNow)>
		</cfif>
	</cfif>
</cfif>

<!--- update card --->
<!--- 
status
passes
fails
dateDue
dateFirstReview
dateLastReview
interval
easyFactor
lastRating
--->
<cfset updatedCard = structNew()>
<cfset updatedCard.idCard = card.idCard>

<!--- status --->
<cfset updatedCard.status = 1>
<cfif rating EQ 0>
	<cfset updatedCard.status = 2>
</cfif>

<!--- passes and fails --->
<cfif rating EQ 0>
	<cfset updatedCard.passes = card.passes>
	<cfset updatedCard.fails = card.fails + 1>
<cfelse>
	<cfset updatedCard.passes = card.passes + 1>
	<cfset updatedCard.fails = card.fails>
</cfif>

<!--- dates --->
<cfset updatedCard.dateDue = dateDue>
<cfif card.dateFirstReview EQ "">
	<cfset updatedCard.dateFirstReview = rightNow>
<cfelse>
	<cfset updatedCard.dateFirstReview = card.dateFirstReview>
</cfif>
<cfset updatedCard.dateLastReview = rightNow>

<!--- interval, easyFactor, lastRating --->
<cfset updatedCard.currentInterval = nextInterval>
<cfset updatedCard.easyFactor = nextEasyFactor>
<cfif card.status EQ 1>
	<!--- pass --->
	<cfset updatedCard.lastRating = 1>
<cfelse>
	<!--- fail --->
	<cfset updatedCard.lastRating = 0>
</cfif>

<cfset updatedCard.idUser = userDO.getRecord().idUser>
<cfset updatedCard.rating = rating>
<cfset updatedCard.previousStatus = card.status>

<!--- update table --->
<cfset cardsGateway.updateRatings(updatedCard)>
<cfset cardsGateway.updateStats(updatedCard)>