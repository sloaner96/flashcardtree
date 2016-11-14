<h2>Welcome to Flashcard Tree!</h2>
<!---
<br>
<ruby style="font-family:MS Mincho;font-size:18pt;font-weight:bold;">日本語<rp>(</rp><rt>にほんご</rt><rp>)</rp>は難しいですか？</ruby>
<br>
<br><ruby style="font-family:MS Mincho;font-size:18pt;font-weight:bold;">日本語<rp>(</rp><rt>にほんご</rt><rp>)</rp>は難<rt>む</rt>しいですか？</ruby>
<br><br>

<ruby style="font-family:MS Mincho;font-size:18pt;font-weight:bold;">
ケーキを<ruby>食<rt>た</rt></ruby>べかけた<ruby>時<rt>とき</rt></ruby>に、<ruby>電話<rt>でんわ</rt></ruby>が<ruby>掛<rt>か</rt></ruby>かって<ruby>来<rt>き</rt></ruby>た。
</ruby>

<ruby style="font-family:Arial">日本語<rp>(</rp><rt>にほんご</rt><rp>)</rp>は難しいですか？</ruby><br>
<ruby style="font-family:Times New Roman">日本語<rp>(</rp><rt>にほんご</rt><rp>)</rp>は難しいですか？</ruby><br>
<ruby style="font-family:">日本語<rp>(</rp><rt>にほんご</rt><rp>)</rp>は難しいですか？</ruby><br>
<ruby>日本<rp>(</rp><rt>にほん</rt><rp>)</rp></ruby>
--->
<cfform name="ftest" method="post" action="/?event=index.index">

<cfinput type="checkbox" name="cbox">

<cftextarea name="front" 
            richtext="true"
						skin="default"
						toolbar="Default" />

<cftextarea name="back" 
            richtext="true"
						skin="default"
						toolbar="Basic" />

<cfinput type="submit" name="fsubmit" value="submit">

</cfform>

<cfdump var="#form#">

<!---
<cfinvoke component="gateways.cards" 
          method="getNextCard" 
					idDeck="16" 
					returnvariable="tval" 
					newcardorder="0"
					newcardtiming="2"
					reviewfailed="0"
					newcardmax="1">
					
<cfdump var="#tval#">
					
<h3>next interval</h3> 

<cfset currentDifficulty = 2.5>
<cfset currentRepetition = 0>
<cfset pass = 1>

<!--- pass rating --->
<cfif pass EQ 1>

<cfif currentRepetition EQ 0>
	<!--- 1 day --->
	<cfset nextInterval = 1>
<cfelseif currentRepetition EQ 1>
	<!--- 3 days --->
	<cfset nextInterval = 3>
<cfelseif currentRepetition GT 1>
</cfif>

</cfif>

<cfoutput>nextInterval = #nextInterval#</cfoutput>
--->