<cfcomponent extends="forceLogin">

	<cffunction name="init" returntype="any" output="true">
		<cfset this.name = "decks">
		<cfreturn this>
	</cffunction>

	<cffunction name="statistics" returntype="any" output="true">
		<cfargument name="idDeck" required="false" default="">
		<cfargument name="embedded" required="false" default="0">
		<!--- get data objects --->
		<cfset request.globalMessage = "">
		<cfset request.idUser = getDO("users").getIdUser()>
		<cfset request.idDeck = idDeck>
		<cfset request.embedded = embedded>
		<cfset request.userDecks = getDO("decks")>
		<cfset request.decks = request.userDecks.getRecord()>
		<!--- set rc variables --->
		<cfif val(arguments.idDeck) GT 0>
			<cfset calculateStatistics(request.idUser,request.idDeck)>
		</cfif>
		<!--- view --->
		<cfif embedded>
			<cfset cfwindowLayout("statistics")>
		<cfelse>
			<cfset basicLayout("statistics")>
		</cfif>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="browse" returntype="void" output="true">
		<cfargument name="embedded" required="false" default="0">
		<!--- get data objects --->
		<cfset request.globalMessage = "">
		<cfset request.userRecord = getDO("users")>
		<cfset request.userDecks = getDO("decks")>
		<cfset request.decks = request.userDecks.getRecord()>
		<!---<cfset request.tab = arguments.tab>--->
		<!--- view --->
		<cfif embedded>
			<cfset cfwindowLayout("browse")>
		<cfelse>
			<cfset basicLayout("browse")>
		</cfif>
	</cffunction>

	<cffunction name="studySettings" returntype="any" output="true">
		<cfargument name="idDeck" required="false" default="">
		<cfargument name="embedded" required="false" default="0">
		<cfargument name="tab" required="false" default="">
		<!--- get data objects --->
		<cfset request.globalMessage = "">
		<cfset request.userRecord = getDO("users")>
		<cfset request.userDecks = getDO("decks")>
		<cfset request.decks = request.userDecks.getRecord()>
		<cfset request.idDeck = arguments.idDeck>
		<cfset request.tab = arguments.tab>
		<cfif val(arguments.idDeck) GT 0>
			<!--- view --->
			<cfset getDecks =  request.userDecks.getRecord()>
			<cfset request.getCards = getGateway("cards").getCards(arguments.idDeck)>
			<cfset request.idDeck = arguments.idDeck>
			<cfquery dbtype="query" name="request.currentDeck">
			select * from getDecks where idDeck = <cfqueryparam value="#request.idDeck#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>
		<!--- view --->
		<cfif embedded>
			<cfset cfwindowLayout("studySettings")>
		<cfelse>
			<cfset basicLayout("studySettings")>
		</cfif>
		<cfreturn this>
	</cffunction>

	<cffunction name="settings" returntype="any" output="true">
		<cfargument name="idDeck" required="false" default="0">
		<cfargument name="embedded" required="false" default="0">
		<cfargument name="enableSharing" required="false" default="0">
		<cfargument name="commit" required="false" default="0">
		<!--- get data objects --->
		<cfset var userDO = getDO("users")>
		<cfset var userRecord = userDO.getRecord()>
		<cfset var decksDO = getDO("decks")>
		<cfset var decksGateway = getGateway("decks")>
		<cfset var decks = decksDO.getRecord()>
		<cfset var langGateway = getGateway("languages")>
		<!--- set request variables --->
		<cfset request.globalMessage = "">
		<cfset request.decks = decksDO.getRecord()>
		<cfset request.idDeck = arguments.idDeck>
		<cfset request.languageCodes = langGateway.getLanguageCodes()>
		<!---
		<cfset request.decks = request.userDecks.getRecord()>
		<cfset request.idDeck = arguments.idDeck>
		<cfset request.tab = arguments.tab>
		--->
		
		<cfif arguments.commit>
			<!--- create updated deck --->
			<cfset var updatedDeck = structNew()>
			<cfset updatedDeck.idUser = userRecord.idUser>
			<cfset updatedDeck.idDeck = arguments.idDeck>
			<cfset updatedDeck.idLang = arguments.idLang>
			<cfset updatedDeck.deckName = arguments.deckName>
			<cfset updatedDeck.enableSharing = arguments.enableSharing>
			<cfset updatedDeck.layoutFront = arguments.layoutFront>
			<cfset updatedDeck.layoutBack = arguments.layoutBack>
			<!---<cfdump var="#updatedDeck#">--->
			<!--- update deck --->
			<cfset request.decks = decksGateway.updateDeck(updatedDeck)>
			<!--- update session data --->
			<cfset decksDO.setRecord(request.decks)>
		</cfif>
		
		<cfif val(arguments.idDeck) GT 0>
			<!--- view --->
			<cfquery dbtype="query" name="request.currentDeck">
			select * from request.decks where idDeck = <cfqueryparam value="#request.idDeck#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>
		
		<!--- view --->
		<cfif embedded>
			<cfset cfwindowLayout("settings")>
		<cfelse>
			<cfset basicLayout("settings")>
		</cfif>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="calculateStatistics" returntype="any" output="true">
		<cfargument name="idUser" required="true">
		<cfargument name="idDeck" required="true">
		<!--- get data objects --->
		<!---
		<cfset userDO = getDO("users")>
		<cfset userRecord = userDO.getRecord()>
		--->
		<cfset userDecks = getDO("decks")>
		<cfset decks = userDecks.getRecord()>
		<cfset decksGateway = getGateway("decks")>
		<cfset cardsGateway = getGateway("cards")>
		
		<cfset getReviewStats = decksGateway.getReviewStats(idUser,idDeck)>
		<cfset getDueCards30 = cardsGateway.getDueCards30(idUser,idDeck)>
		
		<cfset request.globalMessage = "">
		
		<cfquery dbtype="query" name="request.currentDeck">
		select * from decks where idDeck = <cfqueryparam value="#idDeck#" cfsqltype="cf_sql_integer">
		</cfquery>

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
		<cfset dueToday = cardsDue[1].due>
		<cfset dueLaterToday = cardsDue[1].due - dueNow>
		<cfif dueNext.recordCount EQ 0>
			<cfset dueNextTime = "">
		<cfelse>
			<cfset dueNextTime = abs(dateDiff("n",dueNext.dateDue,now()))>
		</cfif>
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
			<cfelseif dueNextTime EQ 1>
				<cfset dueNextLabel = "in #dueNextTime# minute">
			<cfelse>
				<!--- seconds --->
				<cfset dueNextTime = abs(dateDiff("s",dueNext.dateDue,now()))>
				<cfset dueNextLabel = "in #dueNextTime# seconds">
				<cfif dueNextTime GT 1>
					<cfset dueNextLabel = "in #dueNextTime# seconds">
				<cfelseif dueNextTime EQ 1>
					<cfset dueNextLabel = "in #dueNextTime# second">
				<cfelseif dueNextTime EQ 0>
					<cfset dueNextLabel = "now">
				</cfif>
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
		<!---
		<cfquery dbtype="query" name="thisDeck">
		select * from decks where idDeck = #idDeck#
		</cfquery>
		--->
		<!--- set rc variables --->
		<cfset request.decks = decks>
		<cfset request.idDeck = idDeck>
		<!---
		<cfset request.thisDeck = thisDeck>
		--->
		<cfset request.newCards = val(request.currentDeck.newCards)>
		<cfset request.dueNow = dueNow>
		<cfset request.dueToday = dueToday>
		<cfset request.dueLaterToday = dueLaterToday>
		<cfset request.dueNextLabel = dueNextLabel>
		<cfset request.weeklyPerformance = weeklyPerformance>
		<cfset request.cardsDue = cardsDue>
		
		<cfreturn>
	</cffunction>
	
	<cffunction name="formatCard" returntype="struct" output="true">
		<cfargument name="card" required="true">
		<!--- get data objects --->
		<cfset getDecks = getDO("decks").getRecord()>
		
		<cfset var formattedCard = structNew()>
		
		<cfquery dbtype="query" name="currentDeck">
		select * from getDecks where idDeck = <cfqueryparam value="#card.idDeck#" cfsqltype="cf_sql_integer">
		</cfquery>
		<!--- format card --->
		<cfset var tfront = arguments.card.front>
		<cfset var tback = arguments.card.back>
		
		<cfset var tlayoutFront = currentDeck.layoutFront>
		<cfset var tlayoutBack = currentDeck.layoutBack>
		
		<cfif card.defaultLayout>
			<!--- use the default deck layout --->
			<!--- strip p and span tags from front/back fields --->
			<cfset tfront = REReplaceNoCase(tfront, "<(((span|p))|(\/+(span|p)))[^>]*>", "", "ALL" )>
			<cfset tback = REReplaceNoCase(tback, "<(((span|p))|(\/+(span|p)))[^>]*>", "", "ALL" )>
		<cfelse>
			<!--- strip p and span and div tags from layout fields --->
			<cfset tlayoutFront = REReplaceNoCase(tlayoutFront, "<(((span|p|div))|(\/+(span|p|div)))[^>]*>", "", "ALL" )>
			<cfset tlayoutBack = REReplaceNoCase(tlayoutBack, "<(((span|p|div))|(\/+(span|p|div)))[^>]*>", "", "ALL" )>
		</cfif>
		
		<cfset frontFormatted = replace(tlayoutFront,"{front}",tfront)>
		<cfset frontFormatted = replace(frontFormatted,"{back}",tback)>
		
		<cfset backFormatted = replace(tlayoutBack,"{front}",tfront)>
		<cfset backFormatted = replace(backFormatted,"{back}",tback)>
		
		<cfset formattedCard.front = frontFormatted>
		<cfset formattedCard.back = backFormatted>
		
		<cfset formattedCard.idCard = card.idCard>
		
		<cfreturn formattedCard>
		
	</cffunction>
	
	<cffunction name="study" returntype="void" output="true">
		<cfargument name="idDeck" required="false" default="0">
		
		<!--- new cards --->
		<cfargument name="newCardOrder" required="false" default="0"><!--- order added, reverse order added, random --->
		<cfargument name="newCardTiming" required="false" default="0"><!--- throughout, first, at the end --->
		
		<!--- review cards --->
		<cfargument name="reviewOrder" required="false" default="0"><!--- newer, older, order due, random --->
		<cfargument name="reviewFailed" required="false" default="0"><!--- in 10 minutes, soon, at the end --->
		
		<cfargument name="newCardMax" required="false" default="50"><!--- maximum new cards per day --->
		
		<!--- get data objects --->
		<cfset userRecord = getDO("users")>
		<cfset request.globalMessage = "">
		
		<cfif idDeck EQ 0>
			<!--- redirect to dashboard home --->
			<cfset redirect(nav('dashboard.home'))>
		<cfelse>
			<!--- view --->
			<cfset getDecks = getDO("decks").getRecord()>
			<!--- get the next card --->
			<cfset request.card = getGateway("cards").getNextCard(userRecord.getRecord().idUser,
																														 arguments.idDeck,
	                                                           arguments.newCardOrder,
																														 arguments.newCardTiming,
																														 arguments.reviewOrder,
																														 arguments.reviewFailed,
																														 arguments.newCardMax)>
			<!---
			<cfset request.getCards = getGateway("cards").getCards(arguments.idDeck)>
			--->			
			<cfset request.idDeck = arguments.idDeck>
			<cfset request.newCardOrder = arguments.newCardOrder>
			<cfset request.newCardTiming = arguments.newCardTiming>
			<cfset request.reviewOrder = arguments.reviewOrder>
			<cfset request.reviewFailed = arguments.reviewFailed>
			<cfset request.newCardMax = arguments.newCardMax>
			
			<cfif request.card.recordCount EQ 0>
				<!--- redirect to results page --->
				<cflocation url="#navDeckStats('dashboard.home',request.idDeck)#" addtoken="false">
			<cfelse>
				<!--- format card --->
				<cfset formattedCard = formatCard(request.card)>
				<cfset request.frontFormatted = formattedCard.front>
				<cfset request.backFormatted = formattedCard.back>
			</cfif>
			
			<cfset basicLayout("study")>
		</cfif>
	</cffunction>
	
	<cffunction name="view" returntype="void" output="true">
		<cfargument name="idDeck" required="false" default="0">
		<cfset request.globalMessage = "">
		<cfif idDeck EQ 0>
			<!--- redirect to dashboard home --->
			<cfset redirect(navDeck('dashboard.home'))>
		<cfelse>
			<!--- view --->
			<cfset getDecks = getDO("decks").getRecord()>
			<cfset request.getCards = getGateway("cards").getCards(arguments.idDeck)>
			<cfset request.idDeck = arguments.idDeck>
			<cfquery dbtype="query" name="request.currentDeck">
			select * from getDecks where idDeck = <cfqueryparam value="#request.idDeck#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfset basicLayout("view")>
		</cfif>
	</cffunction>
			
	<cffunction name="delete" returntype="void" output="true">
		<cfargument name="idDeck" required="true" default="">
		<!--- get data objects --->
		<cfset userRecord = getDO("users")>
		<!--- delete deck --->
		<cfset decks = getGateway("decks").deleteDeck(userRecord.getRecord().idUser,arguments.idDeck)>
		<!--- update session data --->
		<cfset getDO("decks").setRecord(decks)>
		<!--- redirect to dashboard home --->
		<cfset redirect(navDeck('dashboard.home',decks.idDeck))>
	</cffunction>
	
	<cffunction name="add" returntype="void">
		<cfargument name="deckName" required="false" default="">
		<cfargument name="idLang" required="false" default="0">
		<cfargument name="enableSharing" required="false" default="0">
		<!--- get data objects --->
		<cfset userRecord = getDO("users")>
		<cfset langGateway = getGateway("languages")>
		<!---
		<cfset userDecks = getDO("decks")>
		<cfset decks = userDecks.getRecord()>
		<cfdump var="#arguments#">
		--->
		<cfset request.globalMessage = "">
		<cfset request.languageCodes = langGateway.getLanguageCodes()>
		<cfif arguments.deckName NEQ "">
			<!--- create new deck --->
			<cfset newDeck = structNew()>
			<cfset newDeck.idUser = userRecord.getRecord().idUser>
			<cfset newDeck.deckName = arguments.deckName>
			<cfset newDeck.idLang = arguments.idLang>
			<cfset newDeck.enableSharing = arguments.enableSharing>
			<cfset newDeck.dateCreated = dateFormat(now(),'yyyy-mm-dd') & ' ' & timeFormat(now(),'hh:mm:ss')>
			<cfset decks = getGateway("decks").addDeck(newDeck)>
			<!--- update session data --->
			<cfset getDO("decks").setRecord(decks)>
			<!--- redirect to deck view --->
			<!---<cfset redirect(navDeck('decks.view',decks.idDeck))>--->
			<!--- view --->
			<cfset request.globalMessage = "Deck created">
			<cfset cfwindowLayout("add")>
		<cfelse>
			<!--- view --->
			<cfset cfwindowLayout("add")>
		</cfif>
	</cffunction>
	
</cfcomponent>