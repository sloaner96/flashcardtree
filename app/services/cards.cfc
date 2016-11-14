<cfcomponent>
	<cffunction name="rateCard" access="remote" output="true" returnformat="JSON">
		<!--- rate card --->
		<cfargument name="idCard" required="true">
		<cfargument name="rating" required="true">
		<cfset userDO = getDO("users")>
		<cfif userDO.isAuthenticated() EQ 0>
			<cfreturn>
		</cfif>
		<cfset idUser = userDO.getRecord().idUser>
		<!--- call controller function --->
		<cfset getCO("cards").rateCard(idUser,idCard,rating)>
		<cfreturn SerializeJSON(1)>
	</cffunction>
	
	<cffunction name="test" access="remote" output="true" returnformat="JSON">
		<cfset retVal = arrayNew(1)>
		<cfreturn SerializeJSON(retVal)>
	</cffunction>
	
	<cffunction name="getNextCard" access="remote" returnformat="JSON">
		<cfargument name="idDeck" required="true" default="0">
		
		<!--- new cards --->
		<cfargument name="newCardOrder" required="false" default="0"><!--- order added, reverse order added, random --->
		<cfargument name="newCardTiming" required="false" default="2"><!--- throughout, first, at the end --->
		
		<!--- review cards --->
		<cfargument name="reviewOrder" required="false" default="2"><!--- newer, older, order due, random --->
		<cfargument name="reviewFailed" required="false" default="2"><!--- in 10 minutes, soon, at the end --->
		
		<cfargument name="newCardMax" required="false" default="50"><!--- maximum new cards per day --->
		
		<!--- get objects --->
		<cfset userDO = getDO("users")>
		<cfif userDO.isAuthenticated() EQ 0>
			<cfreturn>
		</cfif>
		<cfset idUser = userDO.getRecord().idUser>
		<cfset getDecks = getDO("decks").getRecord()>
		
		<cfset nextCard = getGateway("cards").getNextCard(idUser,idDeck,newCardOrder,newCardTiming,reviewOrder,reviewFailed,newCardMax)>
		<cfset retVal = arrayNew(1)>
		
		<!--- format card --->
		<cfif nextCard.recordCount EQ 0>
			<cfset formattedCard = structNew()>
			<cfset arrayAppend(retVal,'')>
			<cfset arrayAppend(retVal,'')>
			<cfset arrayAppend(retVal,'')>
		<cfelse>
			<cfset formattedCard = getCO("decks").formatCard(nextCard)>
			<cfset arrayAppend(retVal,formattedCard.idCard)>
			<cfset arrayAppend(retVal,formattedCard.front)>
			<cfset arrayAppend(retVal,formattedCard.back)>
		</cfif>
		
		<!--- get deck layout and format cards --->
		<!---
		<cfquery dbtype="query" name="currentDeck">
		select * from getDecks where idDeck = <cfqueryparam value="#arguments.idDeck#" cfsqltype="cf_sql_integer">
		</cfquery>
		
		<cfset tfront = replace(currentDeck.layoutFront,"{front}",nextCard.front)>
		<cfset tfront = replace(tfront,"{back}",nextCard.back)>
		
		<cfset tback = replace(currentDeck.layoutBack,"{front}",nextCard.front)>
		<cfset tback = replace(tback,"{back}",nextCard.back)>
		--->
		
		<cfreturn SerializeJSON(retVal)>
	</cffunction>
	
	<!--- grid methods --->
	<cffunction name="getCardGrid" access="remote">		
		<cfargument name="cfgridpage" required="true">
		<cfargument name="cfgridpagesize" required="true">
		<cfargument name="cfgridsortcolumn" required="true">
		<cfargument name="cfgridsortdirection" required="true">
		
		<cfargument name="idDeck" required="true">
		
		<!--- get data objects --->
		<cfset userDO = getDO("users")>
		<cfif userDO.isAuthenticated() EQ 0>
			<cfabort>
		</cfif>
		<cfset userRecord = userDO.getRecord()>
		<cfquery datasource="#application.dsn#" name="qGetCards">
		select idCard, idDeck, front, back from cards 
		where idUser = <cfqueryparam value="#userRecord.idUser#">
		
		<!--- deck filter --->
		<cfif arguments.idDeck EQ "">
			<!--- all cards --->
		<cfelseif arguments.idDeck EQ 0>
			<!--- Unassigned --->
			and idDeck is null
		<cfelseif arguments.idDeck GT 0>
			<!--- particular deck --->
			and idDeck = <cfqueryparam value="#arguments.idDeck#">
		</cfif>		
		
		<cfif structKeyExists(arguments,"cfgridsortcolumn")>
			<cfif len(arguments.cfgridsortcolumn) and len(arguments.cfgridsortdirection)>  
			ORDER BY #arguments.cfgridsortcolumn# #arguments.cfgridsortdirection#  
			<cfelse>  
			ORDER BY idCard ASC
			</cfif>
		</cfif>		
		</cfquery>
		<cfreturn queryConvertForGrid(qGetCards,cfgridpage,cfgridpagesize)>
	</cffunction>
	
	<!--- shared methods for base controller --->
	<cffunction name="getDO" returntype="any">
		<cfargument name="dataObjectName" required="true">
		<cfreturn session.data.master.getDO(arguments.dataObjectName)>
	</cffunction>
	<cffunction name="getGateway" returntype="any">
		<cfargument name="gatewayName" required="true">
		<cfreturn application.gateways.master.getGateway(arguments.gatewayName)>
	</cffunction>
	<cffunction name="getCO" returntype="any">
		<cfargument name="controllerName" required="true">
		<cfreturn application.controllers.master.getCO(arguments.controllerName)>
	</cffunction>
</cfcomponent>