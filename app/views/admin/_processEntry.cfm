<!---
<cfoutput>entryIndex: #entryIndex#<br></cfoutput>

<cfset entry = txml.jmdict.xmlChildren[112].xmlChildren>
<cfset entry = txml.jmdict.xmlChildren[50].xmlChildren>
--->
<cfset entry = txml.jmdict.xmlChildren[entryIndex].xmlChildren>

<cfset word = structNew()>
<cfset word.entryid = "">
<cfset word.kanji = "">
<cfset word.kanjialt = "">
<cfset word.kana = "">
<!---<cfset word.partOfSpeech = "">--->
<!---<cfset word.definitionMisc = "">--->
<cfset word.definition = arrayNew(1)>

<cfloop from="1" to="#arrayLen(entry)#" index="i">
	<cfset type = entry[i].xmlName>
	<!---
	type: #type#<br>
	--->
	<cfif type EQ "ent_seq">
		<cfset word.entryid = entry[i].xmlText>
	<cfelseif type EQ "k_ele">
		<!--- kanji details --->
		<cfif word.kanji EQ "">
			<cfset word.kanji = entry[i].xmlChildren[1].xmlText>
		<cfelse>
			<cfset word.kanjialt = listAppend(word.kanjialt,entry[i].xmlChildren[1].xmlText)>
		</cfif>
		<!---
		<cfoutput>entry[i].xmlChildren[1].xmlText=#entry[i].xmlChildren[1].xmlText#</cfoutput><br>
		--->
	<cfelseif type EQ "r_ele">
		<!--- kana details --->
		<cfset word.kana = entry[i].xmlChildren[1].xmlText>
	<cfelseif type EQ "info">
		<!--- info about edict changes --->
	<cfelseif type EQ "sense">
		<!--- definition, etc. --->
		<cfset arrayAppend(word.definition,structNew())>
		<cfset definitionIndex = arrayLen(word.definition)>
		<cfset word.definition[definitionIndex].pos = "">
		<cfset word.definition[definitionIndex].kanji = "">
		<cfset word.definition[definitionIndex].misc = "">
		<cfset word.definition[definitionIndex].def = "">
		<!---
		sense<br>
		--->
		<cfloop from="1" to="#arrayLen(entry[i].xmlChildren)#" index="defindex">
			<cfif entry[i].xmlChildren[defindex].xmlName EQ "pos">
				<!--- part of speech --->
				<cfset word.definition[definitionIndex].pos = listAppend(word.definition[definitionIndex].pos,entry[i].xmlChildren[defindex].xmlText)>
			<cfelseif entry[i].xmlChildren[defindex].xmlName EQ "xref">
				<!--- alternate kanji writings --->
				<cfset word.definition[definitionIndex].kanji = listAppend(word.definition[definitionIndex].kanji,entry[i].xmlChildren[defindex].xmlText)>
			<cfelseif ((entry[i].xmlChildren[defindex].xmlName EQ "misc") OR (entry[i].xmlChildren[defindex].xmlName EQ "s_inf"))>
				<!--- other info like 'usually written in kana' etc. --->
				<cfset word.definition[definitionIndex].misc = listAppend(word.definition[definitionIndex].misc,entry[i].xmlChildren[defindex].xmlText)>
			<cfelseif entry[i].xmlChildren[defindex].xmlName EQ "gloss">
				<!--- definition --->
				<cfset word.definition[definitionIndex].def = listAppend(word.definition[definitionIndex].def,entry[i].xmlChildren[defindex].xmlText)>
			</cfif>
		</cfloop>
		
	</cfif>
	
</cfloop>