<cfcomponent>
	<cffunction name="init" returntype="any" output="true">
		<cfset this.name = "">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="basicLayout">
		<cfargument name="panel1" required="false" default="index">
		<cfset panel1 = this.name & '/' & arguments.panel1>
		<cfparam name="variables.rc.globalMessage" default="">
		<cfinclude template="../layouts/basic.cfm">
	</cffunction>
	
	<cffunction name="cfwindowLayout">
		<cfargument name="panel1" required="false" default="index">
		<cfset panel1 = this.name & '/' & arguments.panel1>
		<cfparam name="variables.rc.globalMessage" default="">
		<cfinclude template="../layouts/cfwindow.cfm">
	</cffunction>
	
	<cffunction name="methodExists" output="true">
		<cfargument name="tobj" type="any" required="true">
		<cfargument name="tmethod" type="string" required="false">
		<cfset amethods = getMetaData(arguments.tobj).functions>
		<cfset lmethods = "">
		<cfloop from="1" to="#arrayLen(amethods)#" index="i">
			<cfif amethods[i].name EQ tmethod>
				<cfreturn true>
			</cfif>
		</cfloop>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="process" returntype="void" output="true">
		<!---
		<cfset var rc = arguments>
		<cfset var event = listLast(rc.event,'.')>
		<p>baseController->process</p>
		<cfdump var="#rc#">
		--->
		<cfset var event = listLast(arguments.event,'.')>
		<cfif methodExists(this,event)>
			<!--- call local method --->
			<cfset evaluate("#event#(argumentCollection=arguments)")>
		<cfelse>
			<!--- no method exists, call layout for default display --->
			<!---<cfset session.data.setRedirect(event)>--->
			<cfset basicLayout(event)>
		</cfif>
	</cffunction>
	
	<cffunction name="nav" access="public" returntype="string" output="true" hint="Writes navigation links">
		<cfargument name="p1" type="string" required="true">
		<cfargument name="p2" type="any" required="false">
		<!--- p1 is the name of the navigation function --->
		<!--- p2 is simply a second parameter of any type --->
		<cfif NOT methodExists(this,"nav#arguments.p1#")>
			<cfreturn "#application.baseURL#?event=#arguments.p1#">
		<cfelseif isDefined("arguments.p2")>
			<cfreturn evaluate("nav#arguments.p1#(arguments.p2)")>
		<cfelse>
			<cfreturn evaluate("nav#arguments.p1#()")>
		</cfif>
	</cffunction>
	
	<cffunction name="navDeckStats" access="public" returntype="string" output="true" hint="Writes navigation links">
		<cfargument name="p1" type="string" required="true">
		<cfargument name="p2" type="any" required="true">
		<cfreturn "#application.baseURL#?event=#arguments.p1#&idDeck=#arguments.p2#&tab=stats">
	</cffunction>
	
	<cffunction name="navDeckReview" access="public" returntype="string" output="true" hint="Writes navigation links">
		<cfargument name="p1" type="string" required="true">
		<cfargument name="p2" type="any" required="true">
		<cfreturn "#application.baseURL#?event=#arguments.p1#&idDeck=#arguments.p2#&tab=study">
	</cffunction>
	
	<cffunction name="navDeck" access="public" returntype="string" output="true" hint="Writes navigation links">
		<cfargument name="p1" type="string" required="true">
		<cfargument name="p2" type="any" required="true">
		<cfreturn "#application.baseURL#?event=#arguments.p1#&idDeck=#arguments.p2#&tab=stats">
	</cffunction>
	<!---
	<cffunction name="nav" returntype="string" output="false">
		<cfargument name="p1" required="false" default="">
		<cfargument name="p2" required="false" default="">
		<cfargument name="event" required="false" default="nav">
		<cfreturn application.controllers.master.process(argumentCollection=arguments)>
	</cffunction>
	--->
	<cffunction name="redirect" returntype="any">
		<cfargument name="redirectUrl" required="true">
		<cflocation url="#redirectUrl#" addtoken="false">
	</cffunction>
	
	<cffunction name="getDO" returntype="any">
		<cfargument name="dataObjectName" required="true">
		<cfreturn session.data.master.getDO(arguments.dataObjectName)>
	</cffunction>
	<cffunction name="getGateway" returntype="any">
		<cfargument name="gatewayName" required="true">
		<cfreturn application.gateways.master.getGateway(arguments.gatewayName)>
	</cffunction>
	<cffunction name="getCO" returntype="any">
		<cfargument name="controllerObjectName" required="true">
		<cfreturn application.controllers.master.getCO(arguments.controllerObjectName)>
	</cffunction>
	<cffunction name="callEvent" returntype="any">
		<cfargument name="redirectEvent" required="true">
		<cfset application.controllers.master.process(event=arguments.redirectEvent)>
	</cffunction>
</cfcomponent>