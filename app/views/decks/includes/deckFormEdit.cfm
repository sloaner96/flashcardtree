	<!--- deck name --->
	<label for="deckName">Name</label>  <cfinput type="text" name="deckName" required="true" message="Please enter a name" value="#request.currentDeck.deckName#"><br>
	
	<!--- language option --->
	<label for="idDeck">Language</label>
	<cfselect query="request.languageCodes" name="idLang" value="idLang" display="langName_en" queryposition="below" selected="#request.currentDeck.idLang#">
		<option value="0">This isn't a language study deck</option>
	</cfselect>
	<cftooltip tooltip="If you're studying a foreign language you can select it here to enable language specific study features."><img src="/public/img/box-question.gif"></cftooltip>
	<br>
	
	<!--- sharing options --->
	<label for="back">Share</label>
	<input type="checkbox" name="enableSharing" value="1" id="cb_enableSharing" class="mycheckbox" <cfif request.currentDeck.enableSharing EQ 1>checked</cfif> />
	<label for="cb_enableSharing" class="tags">Enable Sharing <cftooltip tooltip="Share your decks with the Flashcard Tree community so that other users can study the decks you create!"><img src="/public/img/box-question.gif"></cftooltip> </label> <br>
	<br>
	
	<div style="clear:both;"></div>
	
	<label for="front">Default Layout Front</label>
	<cftextarea name="layoutFront" 
	            richtext="true"
							skin="default"
							toolbar="Flashcard_Basic" 
							value="#request.currentDeck.layoutFront#" height="300" width="700" html="true" />
	<br>
	
	<!---
	<label for="back">Back</label>
	<cftextarea name="back" rows="4" cols="40" value="#request.back#" />
	--->
	<label for="back">Default Layout Back</label>
	<cftextarea name="layoutBack" 
	            richtext="true"
							skin="default"
							toolbar="Flashcard_Basic" 
							value="#request.currentDeck.layoutBack#" height="300" width="700" html="true" />
	<br>
	
	<div style="clear:both;"></div>