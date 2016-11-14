<cfcomponent extends="forceLogin">

	<cffunction name="init" returntype="any" output="true">
		<cfset this.name = "dashboard">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="home" returntype="void">
		<!---dashboard.home controller<br>--->
		<cfargument name="idDeck" required="false" default="">
		<cfargument name="tab" required="false" default="">
		<!--- get data objects --->
		<cfset request.globalMessage = "">
		
		<cfset request.userRecord = getDO("users")>
		<cfset request.userDecks = getDO("decks")>
		<cfset request.decks = request.userDecks.getRecord()>
		<cfset request.idDeck = arguments.idDeck>
		<cfset request.tab = arguments.tab>
		
		<cfif val(request.idDeck) GT 0>
			<!--- view --->
			<cfset getDecks =  request.userDecks.getRecord()>
			<cfset request.getCards = getGateway("cards").getCards(arguments.idDeck)>
			<cfset request.idDeck = arguments.idDeck>
			<cfquery dbtype="query" name="request.currentDeck">
			select * from getDecks where idDeck = <cfqueryparam value="#request.idDeck#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>
		<!--- view --->
		<cfset basicLayout("home")>
	</cffunction>
	
</cfcomponent>