<cfcomponent>
<!---
	<cffunction name="process" access="public" output="false" hint="Manages session data">
		<!--- this cfc manages data object access and persistence --->
		<cfargument name="dataObjectName" required="true">
		inside data master<br>
		
		<!--- make sure controller exists --->
		<cfif ((NOT structKeyExists(session.data,arguments.dataObjectName) OR (isDefined("url.refreshData"))))>
			<!--- create controller --->
			<cfoutput>creating data #arguments.dataObjectName#<br></cfoutput>
			<cfset "session.data.#arguments.dataObjectName#" = createObject("data.#arguments.dataObjectName#").init()>
		<cfelse>
			data exists<br>
		</cfif>
		
		<!--- controller process --->
		
		<cfreturn evaluate("session.data.#arguments.dataObjectName#.process(argumentcollection=arguments)")>
		
		
		<!---
		dumping args and app<br>
		<cfdump var="#arguments#">
		<cfdump var="#application#">
		--->
		
	</cffunction>
	--->
	<cffunction name="getGateway" access="public" output="false" hint="Returns an application gateway object" returntype="Any">
		<!--- this cfc manages data gateway persistence --->
		<cfargument name="dataObjectName" required="true">
		inside getGateway<br>
		
		<!--- make sure gateway exists --->
		<cfif ((NOT structKeyExists(application.gateways,arguments.dataObjectName) OR (isDefined("url.refreshData"))))>
			<!--- create controller --->
			<cfoutput>creating data #arguments.dataObjectName#<br></cfoutput>
			<cfset "application.gateways.#arguments.dataObjectName#" = createObject("gateways.#arguments.dataObjectName#").init()>
		<cfelse>
			gateway exists<br>
		</cfif>
		
		<!--- return data object --->
		<cfreturn evaluate("application.gateways.#arguments.dataObjectName#")>
		
	</cffunction>
	
</cfcomponent>