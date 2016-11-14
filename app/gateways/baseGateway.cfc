<cfcomponent>
	<!--- shared methods for base gateway --->
	<cffunction name="getDO" returntype="any">
		<cfargument name="dataObjectName" required="true">
		<cfreturn session.data.master.getDO(arguments.dataObjectName)>
	</cffunction>
	<cffunction name="getGateway" returntype="any">
		<cfargument name="gatewayName" required="true">
		<cfreturn application.gateways.master.getGateway(arguments.gatewayName)>
	</cffunction>
</cfcomponent>