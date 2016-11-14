<cfcomponent>

	<cffunction name="process" access="public" output="true" hint="Calls application controllers">
		<cfargument name="event" required="true">
		<cfset controllername = listFirst(arguments.event,'.')>
		<!--- check if controller exists --->
		<cfif ((NOT structKeyExists(application.controllers,controllername) OR (isDefined("url.refresh"))))>
			<!--- create controller --->
			<cfset "application.controllers.#controllername#" = createObject("controllers.#controllername#").init()>
		</cfif>
		<!--- controller process --->
		<cfreturn evaluate("application.controllers.#controllername#.process(argumentcollection=arguments)")>
	</cffunction>
	
	<cffunction name="getCO" access="public" output="true" hint="Returns a conroller object">
		<cfargument name="controllerObjectName" required="true">
		<cfset controllername = arguments.controllerObjectName>
		<!--- make sure controller exists --->
		<cfif ((NOT structKeyExists(application.controllers,controllername) OR (isDefined("url.refresh"))))>
			<!--- create controller --->
			<cfset "application.controllers.#controllername#" = createObject("controllers.#controllername#").init()>
		</cfif>
		<!--- return controller object --->
		<cfreturn evaluate("application.controllers.#controllername#")>
	</cffunction>
	
</cfcomponent>