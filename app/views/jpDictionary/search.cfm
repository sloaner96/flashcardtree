<cfif request.embedded EQ 0>
	<h2>Japanese-English Dictionary</h2>
</cfif>

<br>

<div id="form-area">
<cfform method="post">
	<label for="jp">Japanese</label>  <cfinput type="text" name="jp" value="#request.frmJp#"><br>
	<label for="en">English</label>  <cfinput type="text" name="en" value="#request.frmEn#"><br>
	<label for="fsubmit"></label>  <cfinput type="submit" name="fsubmit" value="search" class="submit-button">
	<cfif request.embedded EQ 1>
		<cfinput type="button" name="fsubmit" value="cancel" class="submit-button" onclick="javascript:ColdFusion.Window.hide('jpDictWindow');">
	</cfif>
</cfform>
</div>

<br>
<cfset displayedList = "">

<cfif arrayLen(request.searchResults) GT 0>

<div id="searchResults">

<table cellpadding="0" cellspacing="0">
<cfloop from="1" to="#arrayLen(request.searchResults)#" index="setIndex">

<cfset tquery = request.searchResults[setIndex]>
<cfoutput query="tquery" maxrows="10">

<cfif NOT listFind(displayedList,entryId)>

<cfset displayedList = listAppend(displayedList,entryId)>
<tr>
	<td valign="top" width="300" align="center">
		<div id="entry#currentRow#_front" style="margin:10px;">
		<ruby>#tquery.kanji#<rp>(</rp><rt>#tquery.kana#</rt><rp>)</rp></ruby>
		</div>
		
		<cfif tquery.kanjiAlt NEQ "">
			<div style="font-size:8pt;">
			Alternate Spelling: #tquery.kanjiAlt#
			</div>
		</cfif>
		
		<cfif request.userRecord.isAuthenticated()>
			<a href="javascript:addDictionaryCard(#currentRow#);">add flashcard</a>
		</cfif>
		
	</td>
	<td valign="top">
		<cfwddx action="wddx2cfml" input="#tquery.fullDef#" output="definitions">
		
		<div id="entry#currentRow#_back">
		<ol>
		<cfloop from="1" to="#arrayLen(definitions)#" index="defIndex">
		<!---
			<cfloop list="#definitions[defIndex].def#" index="tdef">
				<li>#tdef#</li>
			</cfloop>
			--->
			<cfloop from="1" to="#listLen(definitions[defIndex].def)#" index="defIndex2">
				<li>
					#listGetAt(definitions[defIndex].def,defIndex2)#
					<div style="font-size:8pt;">
						<cfif listLen(definitions[defIndex].pos) GTE defIndex2>#listGetAt(definitions[defIndex].pos,defIndex2)#</cfif> 
						<cfif listLen(definitions[defIndex].kanji) GTE defIndex2>#listGetAt(definitions[defIndex].kanji,defIndex2)#</cfif>
						<cfif listLen(definitions[defIndex].misc) GTE defIndex2>#listGetAt(definitions[defIndex].misc,defIndex2)#</cfif>
					</div>
				</li>
			</cfloop>
<!---			#definitions[defIndex].pos#<br>
			#definitions[defIndex].kanji#<br>
			#definitions[defIndex].misc#--->
			<!---
			<cfif defIndex LT arrayLen(definitions)>
				<hr>
			</cfif>
			--->
		</cfloop>
		</ol>
		</div>
		
	</td>
	
</tr>
</cfif>

</cfoutput>

</cfloop>
</table>

</div>

</cfif>
<!---
<cfdump var="#request.searchResults[1]#">
<cfset tquery = request.searchResults[1]>
<cfoutput query="tquery" maxrows="10">
</cfoutput>
<cfdump var="#request.searchResults#">
--->