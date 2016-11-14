<cfcomponent>
	<cffunction name="process" access="public" output="true" hint="Calls application controller methods">
		<!--- this cfc allows controllers to call other controllers --->
		<cfargument name="event" required="true">
		<!---
		inside master controller<br>
		--->
		<cfset controllername = listFirst(arguments.event,'.')>
		<!---
		<cfset var arguments.event = listFirst(url.event,'.')>
		--->
		<!--- make sure controller exists --->
		<cfif ((NOT structKeyExists(application.controllers,controllername) OR (isDefined("url.refreshControllers"))))>
			<!--- create controller --->
			<!---<cfoutput>creating controller #controllername#<br></cfoutput>--->
			<cfset "application.controllers.#controllername#" = createObject("controllers.#controllername#").init()>
		<cfelse>
			<!---controller exists<br>--->
			<cfset "application.controllers.#controllername#" = createObject("controllers.#controllername#").init()>
		</cfif>
		
		<!--- controller process --->
		<cfreturn evaluate("application.controllers.#controllername#.process(argumentcollection=arguments)")>
		<!---
		dumping args and app<br>
		<cfdump var="#arguments#">
		<cfdump var="#application#">
		--->
	</cffunction>
	
	<cffunction name="getCO" access="public" output="true" hint="Returns a conroller object">
		<!--- this cfc allows controllers to call other controllers --->
		<cfargument name="controllerObjectName" required="true">
		inside master getCO<br>
		<cfset controllername = arguments.controllerObjectName>
		<!--- make sure controller exists --->
		<cfif ((NOT structKeyExists(application.controllers,controllername) OR (isDefined("url.refreshControllers"))))>
			<!--- create controller --->
			<cfoutput>creating controller #controllername#<br></cfoutput>
			<cfset "application.controllers.#controllername#" = createObject("controllers.#controllername#").init()>
		<cfelse>
			controller exists<br>
		</cfif>
		
		<!--- controller process --->
		<cfreturn evaluate("application.controllers.#controllername#")>
		<!---
		dumping args and app<br>
		<cfdump var="#arguments#">
		<cfdump var="#application#">
		--->
	</cffunction>
</cfcomponent>