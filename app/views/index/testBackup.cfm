<cfdump var="#form#">

<!--- get card info --->
<cfset card = getGateway("cards").getCard(form.idCard)>
<cfdump var="#card#">

<cfset rating = 1>
<cfset easyFactorIncrement = 1>
<cfset easyFactorDecrement = 2>
<cfset nextEasyFactorMax = 10>
<cfset nextEasyFactorMin = 0>
<!---<cfset tenMinutes = 10 / (24 * 60)>--->
<cfset rightNow = now()>

<cfoutput>

<!--- get next interval --->
<cfif card.currentInterval EQ 0>
	<!--- new card --->
	<cfif rating EQ 0>
		fail card with interval of #card.currentInterval#<br>
		set dateDue to +10 minutes and status to fail (2)<br>
		decrement easyFactor by 2<br>
		<!---
		<cfset nextEasyFactor = card.easyFactor - easyFactorDecrement>
		<cfif nextEasyFactor LT nextEasyFactorMin><cfset nextEasyFactor = nextEasyFactorMin></cfif>
		<cfset nextDateIncrement = tenMinutes>
		<cfset nextInterval = card.currentInterval>
		--->
		<!--- default fail --->
		<cfinclude template="_defaultFail.cfm">
	<cfelse>
		pass card with interval of #card.currentInterval#<br>
		set interval to 1, status to pass (1), and dateDue to +10 minutes<br>
		increment easyFactor by 1<br>
		<cfinclude template="_defaultPass.cfm">
		<cfset dateDue = dateAdd('n',10,rightNow)>
	</cfif>
<cfelseif card.currentInterval EQ 1>
	<!--- first interval --->
	<cfif rating EQ 0>
		fail card with interval of #card.currentInterval#<br>
		set dateDue to +10 minutes and status to fail (2)<br>
		decrement easyFactor by 2<br>
<!---		
		<cfset nextEasyFactor = card.easyFactor - easyFactorDecrement>
		<cfif nextEasyFactor LT nextEasyFactorMin><cfset nextEasyFactor = nextEasyFactorMin></cfif>
		<cfset nextDateIncrement = tenMinutes>
		<cfset nextInterval = card.currentInterval>
		--->
		<!--- default fail --->
		<cfinclude template="_defaultFail.cfm">
	<cfelse>
		pass card with interval of #card.currentInterval#<br>
		set interval to 2, status to pass (1), and dateDue to +8 hours<br>
		increment easyFactor by 1<br>
		<cfinclude template="_defaultPass.cfm">
		<cfset dateDue = dateAdd('h',8,rightNow)>
	</cfif>
<cfelseif card.currentInterval EQ 2>
	<!--- second interval --->
	<cfif rating EQ 0>
		fail card with interval of #card.currentInterval#<br>
		set dateDue to +10 minutes and status to fail (2)<br>
		decrement easyFactor by 2<br>
		<!--- default fail --->
		<cfinclude template="_defaultFail.cfm">
	<cfelse>
		pass card with interval of #card.currentInterval#<br>
		set interval to 3, status to pass (1), and dateDue to +24 hours<br>
		increment easyFactor by 1<br>
		<cfinclude template="_defaultPass.cfm">
		<cfset dateDue = dateAdd('d',1,rightNow)>
	</cfif>
<cfelse>
	<!--- interval 3 or higher --->
	<cfif rating EQ 0>
		fail card with interval of #card.currentInterval#<br>
		set dateDue to +10 minutes and status to fail (2)<br>
		decrement easyFactor by 2<br>
		if fail and EF == 1 reset interval to 1<br>
		
		<cfset nextEasyFactor = card.easyFactor - easyFactorDecrement>
		<cfif nextEasyFactor LT nextEasyFactorMin><cfset nextEasyFactor = nextEasyFactorMin></cfif>
		<cfset nextDateIncrement = tenMinutes>
		<cfset nextInterval = card.currentInterval>
		
		<!--- default fail --->
		<cfinclude template="_defaultFail.cfm">
		<cfif card.easyFactor LTE 1>
			<!--- reschedule as a new card --->
			reschedule<br>
			<cfset nextInterval = 0>
		</cfif>
		
		nextEasyFactor=#nextEasyFactor#, nextDateIncrement=#nextDateIncrement# minutes<br>
		
	<cfelse>
		pass card with interval of #card.currentInterval#<br>
		increment easyFactor by 1<br>
		increment interval by 1, status to pass (1), and dateDue to +((interval - 1) * easyFactor) days<br>
		<!---
		<cfset nextEasyFactor = card.easyFactor + easyFactorIncrement>
		<cfif nextEasyFactor GT nextEasyFactorMax><cfset nextEasyFactor = nextEasyFactorMax></cfif>
		<cfset nextInterval = card.currentInterval + 1>
		nextEasyFactor=#nextEasyFactor#, nextDateIncrement=#nextDateIncrement# days<br>
		--->

		
		<!--- if last interval was a fail always set the next review date to 24 hours later (unless interval is less than 4) --->
		<!--- don't increment EF or interval this time --->
		<cfif card.status EQ 2>
		
			last rating was a fail<br>
		
			<cfset nextEasyFactor = card.easyFactor>
			<cfset nextInterval = card.currentInterval>
			<cfset nextDateIncrement = ((card.currentInterval - 1) * nextEasyFactor)>
			<cfset dateDue = dateAdd('d',1,rightNow)>
		<cfelse>
		
			last rating was cool<br>
		
			<cfinclude template="_defaultPass.cfm">
			<cfset nextDateIncrement = ((card.currentInterval - 1) * nextEasyFactor)>
			<cfset dateDue = dateAdd('d',nextDateIncrement,rightNow)>
		</cfif>
		
	</cfif>
</cfif>

<hr>
nextEasyFactor=#nextEasyFactor#, nextDateIncrement=#nextDateIncrement# days<br>
nextInterval=#nextInterval#<br>

</cfoutput>

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

<cfdump var="#updatedCard#">

<!--- update table --->
<cfquery datasource="#application.dsn#">
update cards set status = <cfqueryparam value="#updatedCard.status#">,
								 passes = <cfqueryparam value="#updatedCard.passes#">,
								 fails = <cfqueryparam value="#updatedCard.fails#">,
								 dateDue = <cfqueryparam value="#dateFormat(updatedCard.dateDue,"yyyy-mm-dd")# #timeFormat(updatedCard.dateDue,"HH:mm:ss")#">,
								 dateFirstReview = <cfqueryparam value="#dateFormat(updatedCard.dateFirstReview,"yyyy-mm-dd")# #timeFormat(updatedCard.dateFirstReview,"HH:mm:ss")#">,
								 dateLastReview = <cfqueryparam value="#dateFormat(updatedCard.dateLastReview,"yyyy-mm-dd")# #timeFormat(updatedCard.dateLastReview,"HH:mm:ss")#">,
								 currentInterval = <cfqueryparam value="#updatedCard.currentInterval#">,
								 easyFactor = <cfqueryparam value="#updatedCard.easyFactor#">,
								 lastRating = <cfqueryparam value="#updatedCard.lastRating#">
where idCard = <cfqueryparam value="#form.idCard#">
</cfquery>