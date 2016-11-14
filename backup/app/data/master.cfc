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
	<cffunction name="getDO" access="public" output="false" hint="Returns a session data object" returntype="Any">
		<!--- this cfc manages data object access and persistence --->
		<cfargument name="dataObjectName" required="true">
		inside getDO<br>
		
		<!--- make sure controller exists --->
		<cfif ((NOT structKeyExists(session.data,arguments.dataObjectName) OR (isDefined("url.refreshData"))))>
			<!--- create controller --->
			<cfoutput>creating data #arguments.dataObjectName#<br></cfoutput>
			<cfset "session.data.#arguments.dataObjectName#" = createObject("data.#arguments.dataObjectName#").init()>
		<cfelse>
			data exists<br>
		</cfif>
		
		<!--- return data object --->
		<cfreturn evaluate("session.data.#arguments.dataObjectName#")>
		
	</cffunction>
	
</cfcomponent>