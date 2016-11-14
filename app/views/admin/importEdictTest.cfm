<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=shift_jis">
</head>
<body>

<cffile action="read" file="#application.baseDir#private\data\edict_test.txt" variable="tfile">
<cfset txml = xmlParse(tfile,"No","http://www.csse.monash.edu.au/~jwb/jmdict_dtd_h.html")>

<cfoutput>processing #arrayLen(txml.jmdict.xmlChildren)# entries<br></cfoutput>

<cfloop from="1" to="#arrayLen(txml.jmdict.xmlChildren)#" index="entryIndex">
	<cfinclude template="_processEntry.cfm">
	<!---
	<cfdump var="#word#">
	--->
	<cfoutput>entryIndex: #entryIndex#</cfoutput>
	
	<cfwddx action="cfml2wddx" input="#word.definition#" output="fulldef">
	<cfset searchdef = "">
	<cfloop from="1" to="#arrayLen(word.definition)#" index="defindex">
		<cfset searchdef = listAppend(searchdef,word.definition[defindex].def)>
	</cfloop>
	
	<cfdump var="#word#">
	<cfdump var="#entry#">
<!---	
	<cfdump var="#fulldef#">
	<cfdump var="#searchdef#">
	<br>
	--->
	
	<!---
	<cftry>
		<cfquery datasource="#application.dsn#">
		insert into edict (entryid,searchdef,kana,kanji,fulldef)
		           values (<cfqueryparam value="#word.entryid#">,<cfqueryparam value="#searchdef#">,<cfqueryparam value="#word.kana#">,<cfqueryparam value="#word.kanji#">,<cfqueryparam value="#fulldef#">)
		</cfquery>
	<cfcatch type="any">
		<cfoutput>#cfcatch.detail# </cfoutput>
		<cfif cfcatch.detail CONTAINS "too long">
			<cfoutput>
				#searchdef#: #len(searchdef)#
				<cfdump var="#fulldef#">
				<cfdump var="#len(fulldef)#">
			</cfoutput>
		</cfif>
	</cfcatch>
	</cftry>
	--->
	
	<br>
	
</cfloop>

</body>
</html>