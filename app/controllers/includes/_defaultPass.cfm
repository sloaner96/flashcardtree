<!--- increment EF after second interval --->
<cfif ((card.status NEQ 2) AND (card.lastRating EQ 1))>
	<cfset nextEasyFactor = card.easyFactor + easyFactorIncrement>
	<cfif nextEasyFactor GT nextEasyFactorMax><cfset nextEasyFactor = nextEasyFactorMax></cfif>
<cfelse>
  <cfset nextEasyFactor = card.easyFactor>
</cfif>
<cfset nextInterval = card.currentInterval + 1>