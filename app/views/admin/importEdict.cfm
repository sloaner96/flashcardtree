<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=shift_jis">
</head>
<body>

<cfparam name="part" default="1">
<cfparam name="begin" default="1">
<cfparam name="end" default="2000">

<cfset refresh = 0>
<cfset edictparts = 6>
<cfif NOT isDefined("application.edictfile")>
	<cfset application.edictfiles = structNew()>
	<cfset application.edictfiles.part = 0>
</cfif>

<cfif ((application.edictfiles.part NEQ part) OR (refresh))>
	<cffile action="read" file="#application.baseDir#private\data\edict#part#.txt" variable="tfile">
	<cfset application.edictfiles.part = part>
	<cfset application.edictfiles.xml = xmlParse(tfile,"No","http://www.csse.monash.edu.au/~jwb/jmdict_dtd_h.html")>
</cfif>

<cfset txml = application.edictfiles.xml>

<cfoutput>processing entries #begin# to #end# (total #arrayLen(txml.jmdict.xmlChildren)# entries of part #part#)<br></cfoutput>

<!--- generate links to avoid timeouts --->
<cfset totalEntries = arrayLen(txml.jmdict.xmlChildren)>
<cfset max = 10000>
<cfset totalLinks = ceiling(totalEntries/max)>

<cfoutput>
<cfloop from="1" to="#totalLinks#" index="i">
	<cfset start = (i - 1) * max + 1>
	<cfset stop = i * max>
	<cfif stop GT totalEntries><cfset stop = totalEntries></cfif>
	<a href="/?event=admin.importEdict&part=#part#&begin=#start#&end=#stop#">part #part#: #start# to #stop#</a><br>
</cfloop>

<br>

<cfloop from="1" to="#edictparts#" index="i">
	<a href="/?event=admin.importEdict&part=#i#&begin=1&end=#max#">part #i#</a>
	<cfif i LT edictparts> | </cfif>
</cfloop>

<br>

</cfoutput>
<!---
<cfloop from="#begin#" to="#end#" index="entryIndex">
--->
<cfloop from="#begin#" to="#end#" index="entryIndex">
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
<!---	
	<cfdump var="#fulldef#">
	<cfdump var="#searchdef#">
	<br>
	--->
	<cftry>
		<cfquery datasource="#application.dsn#">
		insert into edict (entryid,searchdef,kana,kanji,kanjialt,fulldef)
		           values (<cfqueryparam value="#word.entryid#">,<cfqueryparam value="#searchdef#">,<cfqueryparam value="#word.kana#">,<cfqueryparam value="#word.kanji#">,<cfqueryparam value="#word.kanjialt#">,<cfqueryparam value="#fulldef#">)
		</cfquery>
	<cfcatch type="any">
	
	<cfif word.entryid EQ 1402540>
		<cfdump var="#word#">
	</cfif>

		<cfquery datasource="#application.dsn#">
		update edict set searchdef = <cfqueryparam value="#searchdef#">,
										 kana = <cfqueryparam value="#word.kana#">,
										 kanji = <cfqueryparam value="#word.kanji#">,
										 kanjialt = <cfqueryparam value="#word.kanjialt#">,
										 fulldef = <cfqueryparam value="#fulldef#">
		where entryid = <cfqueryparam value="#word.entryid#">
		</cfquery>
	
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
	
	<br>
	
</cfloop>
<!---
<cfdump var="#word#">
<cfdump var="#entry#">
<cfabort>

<cfoutput>
<cfset entry = txml.jmdict.xmlChildren[112].xmlChildren>
<cfset entry = txml.jmdict.xmlChildren[50].xmlChildren>
<cfset entryid = entry[1].xmlText>
<cfset japanese = entry[2].xmlChildren[1].xmlText>
<cfset pos = entry[3].xmlChildren[1].xmlText>
<cfset definition = "">
<cfset definition_misc = "">

<cfloop from="1" to="#arrayLen(entry[3].xmlChildren)#" index="defindex">
	<cfif entry[3].xmlChildren[defindex].xmlName EQ "gloss">
		<cfset definition = listAppend(definition,entry[3].xmlChildren[defindex].xmlText)>
	<cfelse>
		<cfset definition_misc = listAppend(definition_misc,entry[3].xmlChildren[defindex].xmlText)>
	</cfif>
</cfloop>

<P>entryid #entryid#</P>
<P>japanese #japanese#</P>
<P>pos #pos#</P>
<P>definition #definition#</P>
<P>definition_misc #definition_misc#</P>

<P>entry</P>
<cfdump var="#entry#">
 
</cfoutput>
--->
<!---
<cfdump var="#txml.jmdict.xmlChildren#">
<cfdump var="#txml.jmdict.xmlChildren[112]#">

<cfoutput>
<cfloop from="1" to="#arrayLen(txml.jmdict.xmlChildren)#" index="i">
	<cfset tval = txml.jmdict.xmlChildren[i].xmlText>
	#tval#<br>
</cfloop>
</cfoutput>
--->


</body>
</html>