<cfset nextEasyFactor = card.easyFactor - easyFactorDecrement>
<cfif nextEasyFactor LT nextEasyFactorMin><cfset nextEasyFactor = nextEasyFactorMin></cfif>
<cfset nextInterval = card.currentInterval>
<cfset dateDue = dateAdd('n',10,rightNow)>