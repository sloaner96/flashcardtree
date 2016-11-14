<cfcomponent output="true" extends="baseGateway">
	<cffunction name="init" returntype="any">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getReviewStats" returntype="query">
		<cfargument name="idUser" required="true">
		<cfargument name="idDeck" required="true">
		<cfquery datasource="#application.dsn#" name="qReviewStats">
		select * from reviewStats 
		<!---
		select  idDeck, idUser, deckName, layoutFront, layoutBack, dateCreated
		from decks
		--->
		where idUser = <cfqueryparam value="#arguments.idUser#"> and idDeck = <cfqueryparam value="#arguments.idDeck#"> and date > <cfqueryparam value="#dateFormat(dateAdd("m",-1,now()),"yyyy-mm-dd")#">
		</cfquery>
		<cfreturn qReviewStats>
	</cffunction>
	
	<cffunction name="getDecks" returntype="query">
		<cfargument name="idUser" required="true">
		<cfquery datasource="#application.dsn#" name="qDecks">
		select * from decksStats 
		<!---
		select  idDeck, idUser, deckName, layoutFront, layoutBack, dateCreated
		from decks
		--->
		where idUser = <cfqueryparam value="#arguments.idUser#">
		order by idDeck desc
		</cfquery>
		<cfreturn qDecks>
	</cffunction>

	<cffunction name="getDeckGrid" access="remote">		
		<cfargument name="cfgridpage" required="true">
		<cfargument name="cfgridpagesize" required="true">
		<cfargument name="cfgridsortcolumn" required="true">
		<cfargument name="cfgridsortdirection" required="true">
		
		<!--- get data objects --->
		<cfset var userDO = getDO("users")>
		<cfif userDO.isAuthenticated() EQ 0>
			<cfabort>
		</cfif>
		<cfset var userRecord = userDO.getRecord()>
		
		<cfquery datasource="#application.dsn#" name="qDecks">
		select * from decksStats 
		where idUser = <cfqueryparam value="#userRecord.idUser#">
		<cfif structKeyExists(arguments,"cfgridsortcolumn")>
			<cfif len(arguments.cfgridsortcolumn) and len(arguments.cfgridsortdirection)>  
			ORDER BY #arguments.cfgridsortcolumn# #arguments.cfgridsortdirection#  
			<cfelse>  
			ORDER BY deckName ASC
			</cfif>
		</cfif>
		</cfquery>
		
		<cfreturn queryConvertForGrid(qDecks,cfgridpage,cfgridpagesize)>
	</cffunction>
	
	<cffunction name="deleteDeck" returntype="query">
		<cfargument name="idUser" required="true">
		<cfargument name="idDeck" required="true">
		<cfquery datasource="#application.dsn#">
		delete from decks 
		where idUser = <cfqueryparam value="#arguments.idUser#"> and idDeck = <cfqueryparam value="#arguments.idDeck#">
		</cfquery>
		<cfreturn getDecks(arguments.idUser)>
	</cffunction>
	
	<cffunction name="addDeck" returntype="query">
		<cfargument name="newDeck" required="true">
		<cfquery datasource="#application.dsn#">
		insert into decks (idUser,idLang,enableSharing,deckName,dateCreated)
		           values (<cfqueryparam value="#arguments.newDeck.idUser#">,<cfqueryparam value="#arguments.newDeck.idLang#">,<cfqueryparam value="#arguments.newDeck.enableSharing#">,<cfqueryparam value="#arguments.newDeck.deckName#">,<cfqueryparam value="#arguments.newDeck.dateCreated#">)
		</cfquery>
		<cfreturn getDecks(arguments.newDeck.idUser)>
	</cffunction>
	
	<cffunction name="updateDeck" returntype="query">
		<cfargument name="updatedDeck" required="true">
		<cfquery datasource="#application.dsn#">
		update decks set deckName = <cfqueryparam value="#arguments.updatedDeck.deckName#">,
		                 idLang = <cfqueryparam value="#arguments.updatedDeck.idLang#">,
										 enableSharing = <cfqueryparam value="#arguments.updatedDeck.enableSharing#">,
										 layoutFront = <cfqueryparam value="#arguments.updatedDeck.layoutFront#">,
										 layoutBack = <cfqueryparam value="#arguments.updatedDeck.layoutBack#">
		where idUser = <cfqueryparam value="#updatedDeck.idUser#"> and idDeck = <cfqueryparam value="#updatedDeck.idDeck#">
		</cfquery>
		<cfreturn getDecks(arguments.updatedDeck.idUser)>
	</cffunction>
	
</cfcomponent>