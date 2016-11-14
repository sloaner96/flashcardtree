<cfcomponent extends="baseController">

	<cffunction name="init" returntype="any" output="true">
		<cfset this.name = "user">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="logout" returntype="void">
		<!--- get data objects --->
		<cfset userDO = getDO("users")>
		<cfset userDO.logout()>
		<cfset userDO.setRedirect(nav("dashboard.home"))>
		<!--- call redirect --->
		<cfset callEvent("index.home")>
	</cffunction>
	
	<cffunction name="login" returntype="void">
		<cfargument name="email" type="string" required="false" default="">
		<cfargument name="password" type="string" required="false" default="">
		<!--- get data objects --->
		<cfset userDO = getDO("users")>
		<cfset userDecksDO = getDO("decks")>
		<cfset tagNamesDO = getDO("tagNames")>
		<!---
		<cfdump var="#nav('user.login')#">
		<cfdump var="#cgi#">
		--->
		<!--- set redirect --->
		<cfif NOT cgi.http_referer CONTAINS 'user.'>
			<!---setting redirect--->
			<cfset userDO.setRedirect(cgi.http_referer)>
		</cfif>
		
		<cfset request.globalMessage = "">
		
		<cfif userDO.isAuthenticated()>
			<cfset callEvent(userDO.getRedirect())>
		<cfelseif arguments.password NEQ "">
			<cfset getUser = getGateway("users").getUserRecord(arguments.email,arguments.password)>
			<cfif getUser.recordCount EQ 1>
				<!--- success --->
				<!--- set user record --->
				<cfset userDO.setRecord(getUser)>
				<!--- load user decks --->
				<cfset tdecks = getGateway("decks").getDecks(getUser.idUser)>
				<cfset userDecksDO.setRecord(tdecks)>
				<!--- load tag names --->
				<cfset tagNamesDO.setRecord(getGateway("tags").getTagNames(getUser.idUser))>
				<!--- call redirect --->
				<!---<cfset redirect(userDO.getRedirect())>--->
				<cflocation url="#userDO.getRedirect()#" addtoken="false">
			<cfelse>
				<!--- failed login attempt --->
				<cfset request.globalMessage = "We weren't able to match the combination entered.  Please try again.">
				<cfset basicLayout("login")>
			</cfif>
		<cfelse>
			<!--- show login screen --->
			<cfset basicLayout("login")>
		</cfif>
	</cffunction>
	
</cfcomponent>