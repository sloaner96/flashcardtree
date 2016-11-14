<cfcomponent output="true">
	<!--- basic application settings --->
	<cfset this.name = "fct_1">
	<cfset this.applicationTimeout = createTimeSpan(0,1,1,10)>
	<cfset this.sessionManagement = true>
	<cfset this.sessionTimeout = createTimeSpan(0,1,10,30)>
	<cfset this.setClientCookies = false>
	<cfset this.timeout = 120>
	<!--- list of custom tag paths --->
	<cfset this.customTagPaths = "">
	
	<!--- page request settings --->
  <cfsetting enablecfoutputonly="false" showdebugoutput="true" requesttimeout="20">
	
	<!--- core application functions --->
	<cffunction name="onApplicationStart" access="public" returntype="boolean" output="true" hint="Start application">
		<!--- <cfoutput>starting app</cfoutput> --->
		<!--- livesessions keeps track of the total number of active user sessions --->
		<!--- this could easily be extended to keep track ip addresses etc. --->
		<cfset application.dsn = "flashcardtree">
		<cfset application.liveSessions = 0>
		<cfset application.baseDir = "C:\inetpub\wwwroot\flashcardtree\">
		<cfset application.sessionDataDir = "#application.BaseDir#private\sessiondata\">
		
		<cfset application.baseURL = "http://127.0.0.1/">
		<cfset application.assetsURL = "#application.BaseURL#public/assets/">
		
		<cfset application.devLogFile = "#application.BaseDir#private\devlog.txt">
		<cfset application.sessionLoggingEnabled = false>
		
		<!--- create a structure for persistent controllers and services --->
		<cfset application.controllers = structNew()>
		<cfset application.gateways = structNew()>
		
		<cfset application.controllers.master = createObject("controllers.master")>
		<cfset application.gateways.master = createObject("gateways.master")>
		
		<cfreturn true>
	</cffunction>
	
	<cffunction name="onSessionStart" access="public" returntype="void" output="true" hint="Start new session">
		<!--- <cfoutput>starting session</cfoutput> --->
		<!--- increment livesessions variable --->
		<cflock scope="application" timeout="1" throwontimeout="false">
			<cfset application.liveSessions++>
		</cflock>
		<cfset session.history = StructNew()>
		<cfset session.history.startTime = Now()>
		<cfset session.history.referrer = cgi.http_referrer>
		<cfset session.history.agent = cgi.http_user_agent>
		<cfset session.history.IP = cgi.remote_addr>
		<cfset session.history.pages = ArrayNew(1)>
		<!---
		<cfset session.data = createObject("controllers.usersRecord").init()>
		--->
		<cfset session.data = structNew()>
		<cfset session.data.master = createObject("data.master")>
		
	</cffunction>

	<cffunction name="onRequestStart" access="public" returntype="boolean" output="false" hint="Process page request">
		<!--- define arguments --->
		<cfargument	name="targetPage"	type="string"	required="true">
		<cfreturn true>
	</cffunction>
	
	<cffunction	name="onRequest" access="public" returntype="void" output="true" hint="Process page request after OnRequestStart">
		<!--- arguments --->
		<!---
		<cfargument	name="targetPage"	type="string"	required="true">
		<cfparam name="url.event" default="index.home">

		<!--- refresh master objects --->
		<cfif isDefined("url.refresh")>
			<cfset application.controllers = structNew()>
			<cfset application.gateways = structNew()>
			<cfset application.controllers.master = createObject("controllers.master")>
			<cfset application.gateways.master = createObject("gateways.master")>
		</cfif>
		
		<!--- create request context --->
		<!---<cfset rc = duplicate(form)>--->
		<cfset rc = structCopy(form)>
		<!--- url variables overwrite form variables --->
		<cfloop collection="#url#" item="urlitem">
			<cfif structKeyExists(rc,urlitem)>
				<cfset structUpdate(rc,urlitem,structFind(url,urlitem))>
			<cfelse>
				<cfset structInsert(rc,urlitem,structFind(url,urlitem))>
			</cfif>
		</cfloop>
		
		<cfset application.controllers.master.process(argumentcollection=rc)>
		--->
		<cfdump var="#session#">
	</cffunction>
	
	<cffunction name="onMissingTemplate" returntype="boolean" output="true" hint="Handles missing page templates">
		<cfargument name="targetPage" required="true" type="string">
		<!--- <cfoutput><p><strong>onMissingTemplate</strong></p></cfoutput> --->
		<!--- from here we can parse information and variables from the url --->
		<cfreturn true>
	</cffunction>
	
	<cffunction	name="onRequestEnd" access="public" returntype="void" output="true"	hint="Post page processing"> 

	</cffunction>
	
 	<cffunction	name="onSessionEnd"	access="public"	returntype="void"	output="false" hint="Terminate session">
 		<!--- arguments --->
		<cfargument	name="sessionScope"	type="struct"	required="true">
		<cfargument	name="applicationScope" type="struct"	required="false" default="#structNew()#">
		<!--- record endtime and save user session to xml --->
		<cfset arguments.sessionScope.endTime = Now()>
		
		<cfif application.sessionLoggingEnabled>
	    <cfwddx action="cfml2wddx" input="#arguments.sessionScope#" output="sessionData">
	    <cffile action="WRITE" file="#arguments.applicationScope.sessionDataDir##arguments.sessionScope.sessionid#_#dateFormat(now(),"mmddyy")#_#timeFormat(now(),"hhmmss")#.xml" output="#sessionData#">
    </cfif>
		
		<!--- decrement livesessions variable --->
		<cflock name="appLock" timeout="5" type="Exclusive">
			<cfset arguments.applicationScope.liveSessions-->
		</cflock>
		
	</cffunction>
	
	<cffunction	name="onApplicationEnd"	access="public"	returntype="void"	output="false" hint="Terminate application">
		<!--- arguments --->
		<cfargument	name="applicationScope"	type="struct"	required="false" default="#StructNew()#">
	</cffunction>
<!---
	<cffunction	name="onError" access="public" returntype="void" output="true" hint="Handles exception outside of try/catch statements">
		<!--- arguments --->
		<cfargument	name="Exception" type="any"	required="true">
		<cfargument	name="EventName" type="string" required="false" default="">
		
		<cfdump var="#Exception#">
		<cfdump var="#EventName#">

		<!---
			<cfif NOT CompareNoCase(arguments.Exception.RootCause.Type,"coldfusion.runtime.AbortException")>
				<!--- this error is thrown when you use cflocation tags, ignore it --->
			<cfelse>
				<!--- error handling --->
				<cfinclude template="app/events/404.cfm">
				<!--- 
				<cfdump var="#Exception#">
				<cfdump var="#EventName#">
				 --->
			</cfif>
			--->
	</cffunction>
	--->
	<cffunction name="devLog" output="false">
		<cfargument name="tout" type="any" required="true">
		<cffile action="append" file="#application.devLogFile#" output="#dateFormat(now(),'mm-dd-yyyy')# #timeFormat(now(),'hh:mm:ss')# #arguments.tout#" addnewline="true">
	</cffunction>
	
	<cffunction name="methodExists" output="true">
		<cfargument name="tobj" type="any" required="true">
		<cfargument name="tmethod" type="string" required="false">
		<cfset amethods = getMetaData(arguments.tobj).functions>
		<cfset lmethods = "">
		<cfloop from="1" to="#arrayLen(amethods)#" index="i">
			<cfif amethods[i].name EQ tmethod>
				<cfreturn true>
			</cfif>
		</cfloop>
		<cfreturn false>
	</cffunction>

</cfcomponent>