<cfcomponent extends="baseController">

	<cffunction name="init" returntype="any" output="true">
		<cfset this.name = "jpDictionary">
		<cfreturn this>
	</cffunction>

	<cffunction name="search" returntype="any" output="true">
		
		<cfargument name="jp" required="false" default="">
		<cfargument name="en" required="false" default="">
		<cfargument name="embedded" required="false" default="0">
		
		<cfset request.globalMessage = "">
		<!--- get data objects --->
		<cfset request.userRecord = getDO("users")>
		
		<cfset request.frmJp = arguments.jp>
		<cfset request.frmEn = arguments.en>
		<cfset request.searchResults = searchEdict(arguments.jp,arguments.en)>
		<cfset request.embedded = arguments.embedded>
		
		<!--- view --->
		<cfif embedded>
			<cfset cfwindowLayout("search")>
		<cfelse>
			<cfset basicLayout("search")>
		</cfif>
		<cfreturn this>
	</cffunction>
<!---
	<cffunction name="search_embedded" returntype="any" output="true">
		
		<cfargument name="jp" required="false" default="">
		<cfargument name="en" required="false" default="">
		
		<cfset request.globalMessage = "">
		<!--- get data objects --->
		<cfset request.userRecord = getDO("users")>
		
		<cfset request.frmJp = arguments.jp>
		<cfset request.frmEn = arguments.en>
		<cfset request.searchResults = searchEdict(arguments.jp,arguments.en)>
		
		<cfset cfwindowLayout("search")>
		<cfreturn this>
	</cffunction>
--->
	<cffunction name="searchEdict" returntype="any" output="true">
		<cfargument name="jp" required="true">
		<cfargument name="en" required="true">
		<cfset resultsSet = arrayNew(1)>
		<cfif ((arguments.jp NEQ "") AND (arguments.en NEQ ""))>
			<!--- search for japanese and english --->
			<cfquery datasource="#application.dsn#" name="searchEdict1">
			select * from edict where ((kanji like <cfqueryparam value="#arguments.jp#%">) and 
			                           (searchdef like <cfqueryparam value="#arguments.en#%">))
			limit 50
			</cfquery>
			<cfif searchEdict1.recordCount GT 0>
				<cfset arrayAppend(resultsSet,searchEdict1)>
			</cfif>
			
			<cfquery datasource="#application.dsn#" name="searchEdict2">
			select * from edict where ((kanji like <cfqueryparam value="%#arguments.jp#%">) and 
			                           (searchdef like <cfqueryparam value="%#arguments.en#%">))
			limit 50
			</cfquery>
			<cfif searchEdict2.recordCount GT 0>
				<cfset arrayAppend(resultsSet,searchEdict2)>
			</cfif>
			
			<cfif ((searchEdict1.recordCount EQ 0) AND (searchEdict2.recordCount EQ 0))>
				<!--- search by kana --->
				<cfquery datasource="#application.dsn#" name="searchEdict1">
				select * from edict where ((kana like <cfqueryparam value="#arguments.jp#%">) and 
				                           (searchdef like <cfqueryparam value="#arguments.en#%">))
				limit 50
				</cfquery>
				<cfif searchEdict1.recordCount GT 0>
					<cfset arrayAppend(resultsSet,searchEdict1)>
				</cfif>
				
				<cfquery datasource="#application.dsn#" name="searchEdict2">
				select * from edict where ((kana like <cfqueryparam value="%#arguments.jp#%">) and 
				                           (searchdef like <cfqueryparam value="%#arguments.en#%">))
				limit 50
				</cfquery>
				<cfif searchEdict2.recordCount GT 0>
					<cfset arrayAppend(resultsSet,searchEdict2)>
				</cfif>
			</cfif>
			
		<cfelseif arguments.jp NEQ "">
			<!--- search for japanese only --->
			<cfquery datasource="#application.dsn#" name="searchEdict3">
			select * from edict where ((kanji = <cfqueryparam value="#arguments.jp#">))
			limit 50
			</cfquery>
			<cfif searchEdict3.recordCount GT 0>
				<cfset arrayAppend(resultsSet,searchEdict3)>
			</cfif>
			
			<cfquery datasource="#application.dsn#" name="searchEdict4">
			select * from edict where ((kanji like <cfqueryparam value="%#arguments.jp#%">))
			limit 50
			</cfquery>
			<cfif searchEdict4.recordCount GT 0>
				<cfset arrayAppend(resultsSet,searchEdict4)>
			</cfif>
			
			<cfif ((searchEdict3.recordCount EQ 0) AND (searchEdict4.recordCount EQ 0))>
				<!--- search by kana --->
				<cfquery datasource="#application.dsn#" name="searchEdict3">
				select * from edict where ((kana = <cfqueryparam value="#arguments.jp#">))
				limit 50
				</cfquery>
				<cfif searchEdict3.recordCount GT 0>
					<cfset arrayAppend(resultsSet,searchEdict3)>
				</cfif>
				
				<cfquery datasource="#application.dsn#" name="searchEdict4">
				select * from edict where ((kana like <cfqueryparam value="%#arguments.jp#%">))
				limit 50
				</cfquery>
				<cfif searchEdict4.recordCount GT 0>
					<cfset arrayAppend(resultsSet,searchEdict4)>
				</cfif>
			</cfif>	
			
			<cfif ((searchEdict3.recordCount EQ 0) AND (searchEdict4.recordCount EQ 0))>
				<!--- search by kanjialt --->
				<cfquery datasource="#application.dsn#" name="searchEdict3">
				select * from edict where ((kanjialt = <cfqueryparam value="#arguments.jp#">))
				limit 50
				</cfquery>
				<cfif searchEdict3.recordCount GT 0>
					<cfset arrayAppend(resultsSet,searchEdict3)>
				</cfif>
				
				<cfquery datasource="#application.dsn#" name="searchEdict4">
				select * from edict where ((kanjialt like <cfqueryparam value="%#arguments.jp#%">))
				limit 50
				</cfquery>
				<cfif searchEdict4.recordCount GT 0>
					<cfset arrayAppend(resultsSet,searchEdict4)>
				</cfif>
			</cfif>	
			
		<cfelseif arguments.en NEQ "">
			<!--- search for english only --->
			<cfquery datasource="#application.dsn#" name="searchEdict5">
			select * from edict where ((searchdef = <cfqueryparam value="#arguments.en#">))
			limit 50
			</cfquery>
			<cfif searchEdict5.recordCount GT 0>
				<!--- return directly --->
				<cfset arrayAppend(resultsSet,searchEdict5)>
			</cfif>
			
			<cfquery datasource="#application.dsn#" name="searchEdict6">
			select * from edict where ((searchdef like <cfqueryparam value="#arguments.en#,%">))
			limit 50
			</cfquery>
			<cfif searchEdict6.recordCount GT 0>
				<cfset arrayAppend(resultsSet,searchEdict6)>
			</cfif>
			
			<cfquery datasource="#application.dsn#" name="searchEdict7">
			select * from edict where ((searchdef like <cfqueryparam value="%#arguments.en#,%">))
			limit 50
			</cfquery>
			<cfif searchEdict7.recordCount GT 0>
				<cfset arrayAppend(resultsSet,searchEdict7)>
			</cfif>
			
			<cfquery datasource="#application.dsn#" name="searchEdict8">
			select * from edict where ((searchdef like <cfqueryparam value="%#arguments.en#%">))
			limit 50
			</cfquery>
			<cfif searchEdict8.recordCount GT 0>
				<cfset arrayAppend(resultsSet,searchEdict8)>
			</cfif>
		</cfif>
		
		<cfreturn resultsSet>
		
	</cffunction>
	
</cfcomponent>

<!---
japanese unicode
decimal range 12353 (small a) to 12438 (ke)

voicing marks etc
decimal range 12441 (ba voice mark) to 12447 (HIRAGANA DIGRAPH YORI ゟ) 

katakana hex 30A0 to 30FF
12448 to 12543
--->