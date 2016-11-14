<cfcomponent output="true" extends="baseGateway">
	<cffunction name="init" returntype="any">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getNextCard" returntype="any">
		<cfargument name="idUser" required="true" default="0">
		<cfargument name="idDeck" required="true" default="0">
		
		<!--- new cards --->
		<cfargument name="newCardOrder" required="false" default="0"><!--- order added, reverse order added, random --->
		<cfargument name="newCardTiming" required="false" default="2"><!--- throughout, first, at the end --->
		
		<!--- review cards --->
		<cfargument name="reviewOrder" required="false" default="2"><!--- newer, older, order due, random --->
		<cfargument name="reviewFailed" required="false" default="2"><!--- in 10 minutes, soon, at the end --->
		
		<cfargument name="newCardMax" required="false" default="50"><!--- maximum new cards per day --->
		
		<!--- get the last card reviewed --->
		<!--- we need this to determine if the next card should be new or review --->
		<cfquery datasource="#application.dsn#" name="qLastCard">
		select * from cards where idDeck = <cfqueryparam value="#arguments.idDeck#"> and idUser = <cfqueryparam value="#arguments.idUser#"> 
		order by dateLastReview desc limit 1
		</cfquery>
		<cfif qLastCard.recordCount EQ 0>
			<cfreturn queryNew("idCard")>
		</cfif>
		
		<!--- get a count of new and review cards --->
		<cfquery datasource="#application.dsn#" name="newCardCount">
		select count(status) as tval from cards 
		where (status = 0) and (idDeck = <cfqueryparam value="#arguments.idDeck#">)
		</cfquery>
		<cfquery datasource="#application.dsn#" name="reviewCardCount">
		select count(status) as tval from cards 
		where (status = 1) and (dateDue < <cfqueryparam value="#dateFormat(now(),"yyyy-mm-dd")# #timeFormat(now(),"HH:mm:ss")#">) and (idDeck = <cfqueryparam value="#arguments.idDeck#">)
		</cfquery>
		<!--- get a count of total new cards reviewed today --->
		<cfquery datasource="#application.dsn#" name="newCardTodayCount">
		select count(status) as tval from cards 
		where (dateFirstReview = dateLastReview) and (dateFirstReview like <cfqueryparam value="#dateFormat(now(),"yyyy-mm-dd")# %">) and (idDeck = <cfqueryparam value="#arguments.idDeck#">)
		</cfquery>

		<cfif newCardTiming EQ 0>
			<!--- alternate new cards with reviews --->
			<cfif qLastCard.dateLastReview EQ qLastCard.dateFirstReview>
				<!--- the last card reviewed was new so we should display a review card next --->
				<cfset nextCardType = "review">
			<cfelse>
				<!--- last card was a review, show a new card --->
				<cfset nextCardType = "new">
			</cfif>
		<cfelseif newCardTiming EQ 1>
			<!--- show new cards first --->
			<cfset nextCardType = "new">
		<cfelseif newCardTiming EQ 2>
			<!--- show new cards at the end --->
			<cfset nextCardType = "review">
			<cfset showNewLast = 1>
		</cfif>
		
		<cfif newCardCount.tval EQ 0><cfset nextCardType = "review"></cfif>
		<cfif reviewCardCount.tval EQ 0><cfset nextCardType = "new"></cfif>
		<cfif newCardTodayCount.tval GTE newCardMax><cfset nextCardType = "review"></cfif>
		
		<!--- get the next card --->
		<!--- return up to 100 rows for development but this should only return 1 row in production --->
		<cfquery datasource="#application.dsn#" name="qNextCard" maxrows="1"><cfinclude template="_nextcard_query.cfm"></cfquery>
		<cfreturn qNextCard>
		
	</cffunction>

	<cffunction name="getCards" returntype="query">
		<cfargument name="idDeck" required="true">
		<cfquery datasource="#application.dsn#" name="qCards">
		select * from cards where idDeck = <cfqueryparam value="#arguments.idDeck#">
		</cfquery>
		<cfreturn qCards>
	</cffunction>
	
	<cffunction name="getDueCards30" returntype="query">
		<cfargument name="idUser" required="true">
		<cfargument name="idDeck" required="true">
		<cfquery datasource="#application.dsn#" name="qDueCards30">
		select idCard, dateDue from cards 
		where idDeck = <cfqueryparam value="#arguments.idDeck#"> and dateDue < <cfqueryparam value="#dateFormat(dateAdd("m",1,now()),"yyyy-mm-dd")#">
		</cfquery>
		<cfreturn qDueCards30>
	</cffunction>
	
	<cffunction name="getCard" returntype="query">
		<cfargument name="idCard" required="true">
		<cfquery datasource="#application.dsn#" name="qCards">
		select * from cards where idCard = <cfqueryparam value="#arguments.idCard#">
		</cfquery>
		<cfreturn qCards>
	</cffunction>
	
	<cffunction name="addCard" returntype="void">
		<cfargument name="newCard" required="true">
		<cftransaction>
			<!--- insert card --->
			<cfquery datasource="#application.dsn#">
			insert into cards (idUser,idDeck,defaultLayout,front,back,dateCreated)
			           values (<cfqueryparam value="#arguments.newCard.idUser#">,
								         <cfqueryparam value="#arguments.newCard.idDeck#" null="#iif(isNumeric(arguments.newCard.idDeck),de("no"),de("yes"))#">,
												 <cfqueryparam value="#arguments.newCard.defaultLayout#">,
												 <cfqueryparam value="#arguments.newCard.front#">,
												 <cfqueryparam value="#arguments.newCard.back#">,
												 <cfqueryparam value="#arguments.newCard.dateCreated#">)
			</cfquery>
			<!--- get card --->
			<cfquery datasource="#application.dsn#" name="getNewCard">
			select idCard from cards 
			where idUser = <cfqueryparam value="#arguments.newCard.idUser#"> and  
						dateCreated = <cfqueryparam value="#arguments.newCard.dateCreated#">
			order by idCard desc
			limit 1
			</cfquery>
			<!--- insert tags --->
			<cfloop list="#arguments.newCard.tags#" index="tIdTagName">
				<cfquery datasource="#application.dsn#">
				insert into tags (idTagName,idCard) values (<cfqueryparam value="#tIdTagName#">,<cfqueryparam value="#getNewCard.idCard#">)
				</cfquery>
			</cfloop>
		</cftransaction>
	</cffunction>
	
	<cffunction name="updateCard" returntype="void">
		<cfargument name="newCard" required="true">
		<cftransaction>
			<!--- update card --->
			<cfquery datasource="#application.dsn#">
			update cards set idDeck = <cfqueryparam value="#arguments.newCard.idDeck#" null="#iif(isNumeric(arguments.newCard.idDeck),de("no"),de("yes"))#">,
											 defaultLayout = <cfqueryparam value="#arguments.newCard.defaultLayout#">,
											 front = <cfqueryparam value="#arguments.newCard.front#">,
											 back = <cfqueryparam value="#arguments.newCard.back#">,
											 dateModified = <cfqueryparam value="#arguments.newCard.dateModified#">
			where idUser = <cfqueryparam value="#newCard.idUser#"> and idCard = <cfqueryparam value="#newCard.idCard#">
			</cfquery>
			<!--- insert tags --->
			<cfquery datasource="#application.dsn#">
			delete from tags where idCard = <cfqueryparam value="#newCard.idCard#">
			</cfquery>
			<cfloop list="#arguments.newCard.tags#" index="tIdTagName">
				<cfquery datasource="#application.dsn#">
				insert into tags (idTagName,idCard) values (<cfqueryparam value="#tIdTagName#">,<cfqueryparam value="#newCard.idCard#">)
				</cfquery>
			</cfloop>
		</cftransaction>
	</cffunction>
	
	<cffunction name="updateRatings" returntype="void">
		<cfargument name="updatedCard" required="true">
		<cftransaction>
			<!--- update card --->
			<cfquery datasource="#application.dsn#">
			update cards set status = <cfqueryparam value="#arguments.updatedCard.status#">,
											 passes = <cfqueryparam value="#arguments.updatedCard.passes#">,
											 fails = <cfqueryparam value="#arguments.updatedCard.fails#">,
											 dateDue = <cfqueryparam value="#dateFormat(arguments.updatedCard.dateDue,"yyyy-mm-dd")# #timeFormat(arguments.updatedCard.dateDue,"HH:mm:ss")#">,
											 dateFirstReview = <cfqueryparam value="#dateFormat(arguments.updatedCard.dateFirstReview,"yyyy-mm-dd")# #timeFormat(arguments.updatedCard.dateFirstReview,"HH:mm:ss")#">,
											 dateLastReview = <cfqueryparam value="#dateFormat(arguments.updatedCard.dateLastReview,"yyyy-mm-dd")# #timeFormat(arguments.updatedCard.dateLastReview,"HH:mm:ss")#">,
											 currentInterval = <cfqueryparam value="#arguments.updatedCard.currentInterval#">,
											 easyFactor = <cfqueryparam value="#arguments.updatedCard.easyFactor#">,
											 lastRating = <cfqueryparam value="#arguments.updatedCard.lastRating#">
			where idUser = <cfqueryparam value="#arguments.updatedCard.idUser#"> and idCard = <cfqueryparam value="#arguments.updatedCard.idCard#">
			</cfquery>
		</cftransaction>
	</cffunction>
	
	<cffunction name="updateStats" returntype="void">
		<cfargument name="updatedCard" required="true">
		<cftransaction>
			<!--- check for existing stat record --->
			<cfquery datasource="#application.dsn#" name="getCard">
			select idDeck from cards where idCard = <cfqueryparam value="#arguments.updatedCard.idCard#">
			</cfquery>
			<cfset idDeck = getCard.idDeck>
			<cfset today = dateFormat(now(),"yyyy-mm-dd")> 
			<cfquery datasource="#application.dsn#" name="checkRecord">
			select * from reviewStats 
			where idDeck = <cfqueryparam value="#idDeck#"> and idUser = <cfqueryparam value="#arguments.updatedCard.idUser#"> and date = <cfqueryparam value="#today#">
			</cfquery>
			<cfif checkRecord.recordCount EQ 0>
				<!--- insert record --->
				<cfset passes = 0>
				<cfset fails = 0>
				<cfif updatedCard.rating EQ 0>
					<cfset fails = 1>
				<cfelse>
					<cfset passes = 1>
				</cfif>
				<cfset newCards = 0>
				<cfif updatedCard.previousStatus EQ 0>
					<cfset newCards = 1>
				</cfif>
				<cfquery datasource="#application.dsn#">
				insert into reviewStats (idUser,idDeck,passes,fails,newCards,date)
				                 values (<cfqueryparam value="#arguments.updatedCard.idUser#">,<cfqueryparam value="#idDeck#">,<cfqueryparam value="#passes#">,<cfqueryparam value="#fails#">,<cfqueryparam value="#newCards#">,<cfqueryparam value="#today#">)
				</cfquery>
			<cfelse>
				<!--- update record --->
				<cfquery datasource="#application.dsn#">
				update reviewStats
				<cfif updatedCard.rating EQ 0>
					set fails = fails + 1
				<cfelse>
					set passes = passes + 1
				</cfif>
				<cfif updatedCard.previousStatus EQ 0>
					, newCards = newCards + 1
				</cfif>
				where idDeck = <cfqueryparam value="#idDeck#"> and idUser = <cfqueryparam value="#arguments.updatedCard.idUser#"> and date = <cfqueryparam value="#today#">
				</cfquery>
			</cfif>
		</cftransaction>
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
</cfcomponent>