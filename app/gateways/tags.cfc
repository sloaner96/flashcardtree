<cfcomponent output="true">
	<cffunction name="init" returntype="any">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getTagNames" returntype="query">
		<cfargument name="idUser" required="true">
		<cfquery datasource="#application.dsn#" name="qTagNames">
		select idTagName, tagName
		from tagNames
		where idUser = <cfqueryparam value="#arguments.idUser#">
		order by tagName asc
		</cfquery>
		<cfreturn qTagNames>
	</cffunction>
	
	<cffunction name="getCardTags" returntype="query">
		<cfargument name="idCard" required="true">
		<cfquery datasource="#application.dsn#" name="qTags">
		select idTag, idTagName
		from tags
		where idCard = <cfqueryparam value="#arguments.idCard#">
		</cfquery>
		<cfreturn qTags>
	</cffunction>
	
	<cffunction name="addTagName" returntype="any">
		<cfargument name="idUser" required="true">
		<cfargument name="tagName" required="true">
		<cftransaction>
			<cfquery datasource="#application.dsn#">
			insert into tagNames (idUser,tagName)
			              values (<cfqueryparam value="#arguments.idUser#">,<cfqueryparam value="#arguments.tagName#">)
			</cfquery>
			<cfquery datasource="#application.dsn#" name="getNewTag">
			select idTagName from tagNames 
			where idUser = <cfqueryparam value="#arguments.idUser#"> and tagName = <cfqueryparam value="#arguments.tagName#">
			</cfquery>
		</cftransaction>
		<cfreturn getNewTag.idTagName>
	</cffunction>
	
</cfcomponent>