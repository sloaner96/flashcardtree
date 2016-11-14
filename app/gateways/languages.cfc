<cfcomponent output="true">
	<cffunction name="init" returntype="any">
		<cfreturn this>
	</cffunction>

	<cffunction name="getLanguageCodes" returntype="query">
		<cfquery datasource="#application.dsn#" name="qLangCodes">
		select * from languageCodes order by langName_en
		</cfquery>
		<cfreturn qLangCodes>
	</cffunction>
	
</cfcomponent>