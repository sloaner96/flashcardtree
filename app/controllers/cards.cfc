<cfcomponent extends="forceLogin">

	<cffunction name="init" returntype="any" output="true">
		<cfset this.name = "cards">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="home" returntype="void">
		<!---dashboard.home controller<br>--->
		<!--- get data objects --->
		<cfset userRecord = getDO("users")>
		<cfset userDecks = getDO("decks")>
		<cfset decks = userDecks.getRecord()>
		<!--- view --->
		<cfset basicLayout("home")>
	</cffunction>
	
	<cffunction name="edit" returntype="void">
		<cfargument name="idCard" required="true" default="">
		<cfargument name="defaultLayout" required="false" default="0">
		<cfargument name="commit" required="false" default="0">
		
		<cfset request.globalMessage = "">
		
		<!--- get data objects --->
		<cfset userDO = getDO("users")>
		<cfset userRecord = userDO.getRecord()>
		<cfset tagNamesDO = getDO("tagNames")>
		<cfset tagNamesRecord = tagNamesDO.getRecord()>
		<cfset cardsGateway = getGateway("cards")>
		<cfset tagsGateway = getGateway("tags")>
		<cfset userDecks = getDO("decks")>
		<cfset decks = userDecks.getRecord()>

		<cfset cardRecord = cardsGateway.getCard(arguments.idCard)>
		<cfset tagsRecord = tagsGateway.getCardTags(arguments.idCard)>
		<cfset request.idCard = arguments.idCard>
		<cfset request.idDeck = cardRecord.idDeck>
		<cfset request.defaultLayout = arguments.defaultLayout>
		<cfset request.front = cardRecord.front>
		<cfset request.back = cardRecord.back>
		
		<cfif ((arguments.commit) AND (front NEQ ""))>
			<!--- update card --->
			<cfset newCard = structNew()>
			<cfset newCard.idDeck = idDeck>
			<cfset newCard.idUser = userRecord.idUser>
			<cfset newCard.idCard = arguments.idCard>
			<cfset newCard.defaultLayout = arguments.defaultLayout>
			<cfset newCard.front = front>
			<cfset newCard.back = back>
			<cfset newCard.tags = "">
			<!--- add new tags --->
			<cfparam name="tags" default="">
			<cfloop list="#tags#" index="tid">
				<cfif isNumeric(tid)>
					<!--- tag already exists --->
					<cfset newCard.tags = listAppend(newCard.tags,tid)>
				<cfelse>
					<!--- create new tag --->
					<cftry>
						<cfset newIdTag = tagsGateway.addTagName(userRecord.idUser,tid)>
						<cfset newCard.tags = listAppend(newCard.tags,newIdTag)>
					<cfcatch type="any"></cfcatch>
					</cftry>
				</cfif>
			</cfloop>
			<!--- update tag record --->
			<cfset tagNamesRecord = tagsGateway.getTagNames(userRecord.idUser)>
			<cfset tagNamesDO.setRecord(tagNamesRecord)>
			<!--- update card --->
			<cfset newCard.dateModified = dateFormat(now(),'yyyy-mm-dd') & ' ' & timeFormat(now(),'hh:mm:ss')>
			<cfset cardsGateway.updateCard(newCard)>
			<cfset request.globalMessage = "Card updated">
		</cfif>
		
		<cfset cardRecord = cardsGateway.getCard(arguments.idCard)>
		<cfset tagsRecord = tagsGateway.getCardTags(arguments.idCard)>
		<cfset request.idCard = arguments.idCard>
		<cfset request.idDeck = cardRecord.idDeck>
		<cfset request.defaultLayout = cardRecord.defaultLayout>
		<cfset request.front = cardRecord.front>
		<cfset request.back = cardRecord.back>
		
		<!--- set some vars to tell the form which tags are selected --->
		<cfloop query="tagsRecord">
			<cfset "request.idTag#tagsRecord.idTagName#isChecked" = 1>
		</cfloop>
		
		<!--- view --->
		<cfset cfwindowLayout("edit")>
	</cffunction>
	
	<cffunction name="browse" returntype="void">
		<cfargument name="idDeck" required="false" default="">
		<cfargument name="commit" required="false" default="0">
		<cfargument name="embedded" required="false" default="0">
		
		<cfset request.globalMessage = "">
		<cfset request.idDeck = arguments.idDeck>
		
		<!--- get data objects --->
		<cfset userDO = getDO("users")>
		<cfset userRecord = userDO.getRecord()>
		<cfset tagNamesDO = getDO("tagNames")>
		<cfset tagNamesRecord = tagNamesDO.getRecord()>
		<cfset cardsGateway = getGateway("cards")>
		<cfset tagsGateway = getGateway("tags")>
		<cfset userDecks = getDO("decks")>
		<cfset decks = userDecks.getRecord()>
		<!--- view --->
		<cfif embedded>
			<cfset cfwindowLayout("browse")>
		<cfelse>
			<cfset basicLayout("browse")>
		</cfif>
	</cffunction>
	
	<cffunction name="add" returntype="void">
		<cfargument name="idDeck" required="false" default="">
		<cfargument name="commit" required="false" default="0">
		<cfargument name="defaultLayout" required="false" default="0">
		<cfargument name="front" required="false" default="">
		<cfargument name="back" required="false" default="">
		
		<cfset request.globalMessage = "">
		<cfset request.idDeck = arguments.idDeck>
		<cfset request.defaultLayout = arguments.defaultLayout>
		<cfset request.front = arguments.front>
		<cfset request.back = arguments.back>

		<!--- get data objects --->
		<cfset userDO = getDO("users")>
		<cfset userDecksDO = getDO("decks")>
		<cfset userRecord = userDO.getRecord()>
		<cfset tagNamesDO = getDO("tagNames")>
		<cfset tagNamesRecord = tagNamesDO.getRecord()>
		<cfset cardsGateway = getGateway("cards")>
		<cfset tagsGateway = getGateway("tags")>
		
		<cfset userDecks = getDO("decks")>
		<cfset decks = userDecks.getRecord()>
		<!---
		<cfdump var="#form#">
		--->
		<cfif ((commit) AND ((front NEQ "") OR (back NEQ "")))>
			<!--- create new card --->
			<cfset newCard = structNew()>
			<cfset newCard.idDeck = arguments.idDeck>
			<cfset newCard.idUser = userRecord.idUser>
			<cfset newCard.defaultLayout = arguments.defaultLayout>
			<cfset newCard.front = front>
			<cfset newCard.back = back>
			<cfset newCard.tags = "">
			<!--- add new tags --->
			<cfparam name="tags" default="">
			<cfloop list="#tags#" index="tid">
				<cfif isNumeric(tid)>
					<!--- tag already exists --->
					<cfset newCard.tags = listAppend(newCard.tags,tid)>
				<cfelse>
					<!--- create new tag --->
					<cftry>
						<cfset newIdTag = tagsGateway.addTagName(userRecord.idUser,tid)>
						<cfset newCard.tags = listAppend(newCard.tags,newIdTag)>
						<!--- set some vars to tell the form which tags are selected --->
						<cfset "request.idTag#newIdTag#isChecked" = 1>
					<cfcatch type="any"></cfcatch>
					</cftry>
				</cfif>
			</cfloop>
			<!--- update tag record --->
			<cfset tagNamesRecord = tagsGateway.getTagNames(userRecord.idUser)>
			<cfset tagNamesDO.setRecord(tagNamesRecord)>
			<!--- add card --->
			<cfset newCard.dateCreated = dateFormat(now(),'yyyy-mm-dd') & ' ' & timeFormat(now(),'hh:mm:ss')>
			<cfset cardsGateway.addCard(newCard)>
			<!--- update decks --->
			<!--- load user decks --->
			<cfset tdecks = getGateway("decks").getDecks(userRecord.idUser)>
			<cfset userDecksDO.setRecord(tdecks)>
			<!--- view --->
			<cfset request.globalMessage = "Card created">
			<cfset cfwindowLayout("add")>
		<cfelse>
			<!--- view --->
			<cfset cfwindowLayout("add")>
		</cfif>
		
	</cffunction>
	
	<cffunction name="rateCard" returntype="void">
		<cfargument name="idUser" required="true">
		<cfargument name="idCard" required="true">
		<cfargument name="rating" required="true">
		<!--- get data objects --->
		<cfset userDO = getDO("users")>
		<cfset userDecksDO = getDO("decks")>
		<cfset cardsGateway = getGateway("cards")>
		<cfinclude template="includes/rateCard.cfm">
		<!--- update decks --->
		<!--- load user decks --->
		<cfset tdecks = getGateway("decks").getDecks(idUser)>
		<cfset userDecksDO.setRecord(tdecks)>
	</cffunction>
	
</cfcomponent>