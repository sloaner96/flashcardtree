<cfcomponent output="true">
	<!--- basic application settings --->
	<cfset this.name = "flashcardtree_1111">
	<cfset this.applicationTimeout = createTimeSpan(0,0,0,10)>
	<cfset this.sessionManagement = true>
	<cfset this.sessionTimeout = createTimeSpan(0,0,0,30)>
	<cfset this.setClientCookies = false>
	<!--- list of custom tag paths --->
	<cfset this.customTagPaths = "">
	
	<!--- page request settings --->
  <cfsetting enablecfoutputonly="false" showdebugoutput="true" requesttimeout="20">
	
	<!--- core application functions --->
	<cffunction name="onApplicationStart" access="public" returntype="boolean" output="true" hint="Start application">
		<!--- <cfoutput>starting app</cfoutput> --->
		<!--- livesessions keeps track of the total number of active user sessions --->
		<!--- this could easily be extended to keep track ip addresses etc. --->
		<cfset application.liveSessions = 0>
		<cfset application.baseDir = "C:\inetpub\wwwroot\flashcardtree\">
		<cfset application.sessionDataDir = "#application.BaseDir#private\sessiondata\">
		
		<cfset application.baseURL = "http://127.0.0.1/">
		<cfset application.assetsURL = "#application.BaseURL#public/assets/">
		
		<cfset application.devLogFile = "#application.BaseDir#private\devlog.txt">
		<cfset application.sessionLoggingEnabled = false>
		
		<!--- create a structure for persistent controllers and services --->
		<cfset application.controllers = structNew()>
		<cfset application.services = structNew()>
		
		<cfset application.controllers.master = createObject("controllers.master")>
		
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
		<cfargument	name="targetPage"	type="string"	required="true">
		<cfparam name="url.event" default="index.home">
		
		<!--- create request context --->
		<cfset var rc = duplicate(form)>
		<!--- url variables overwrite form variables --->
		<cfloop collection="#url#" item="urlitem">
			<cfif structKeyExists(rc,urlitem)>
				<cfset structUpdate(rc,urlitem,structFind(url,urlitem))>
			<cfelse>
				<cfset structInsert(rc,urlitem,structFind(url,urlitem))>
			</cfif>
		</cfloop>
		
		<!---
		<cfset session.data = createObject("controllers.usersRecord").init()>
		--->
		
		<!---
		<cfset session.data.master = createObject("data.master")>
		<cfset tval = session.data.master.process(dataObjectName='usersRecord',dataObjectMethod='isAuthenticated')>
		
		calling isauhenticated via master<br>
		<cfdump var="#tval#">
		
		calling isauhenticated directly<br>
		<cfdump var="#session.data.usersRecord.isAuthenticated()#">
		<cfdump var="#session#">
		--->
		
		<!---
		<cfset tval = session.data.master.process(dataObjectName='usersRecord',dataObjectMethod='setRedirect',redirect='asdfasdf')>
		<cfset tval = session.data.master.process(dataObjectName='usersRecord',dataObjectMethod='getRedirect')>
		<cfdump var="#tval#">
		
		<cfabort>
		--->
		
		<cfset application.controllers.master.process(argumentcollection=rc)>
		
		<cfabort>
		
		
		
		
		<!--- index.home --->
		onrequest
		<!---
		url scope
		<cfdump var="#url#">
		
		form scope
		<cfdump var="#form#">
		
		create request variable <br>
		--->
		
		<cfset var tcontroller = listFirst(url.event,'.')>
		<!--- make sure controller exists --->
		<cfif ((NOT structKeyExists(application.controllers,tcontroller) OR (isDefined("url.refreshControllers"))))>
			<!--- create controller --->
			<cfoutput>creating controller #tcontroller#<br></cfoutput>
			<cfset "application.controllers.#tcontroller#" = createObject("controllers.#tcontroller#").init()>
		</cfif>
		<!---
		<cfdump var="#application.controllers#">
		--->
		<!--- controller process --->
		<cfset evaluate("application.controllers.#tcontroller#.process(argumentcollection=rc)")>
		
		<!---
		<cfabort>
		
		
		
		calling controller<br>		
		<cfinvoke component="controllers.#listFirst(url.event,'.')#" method="process" argumentcollection="#rc#">
		<cfset session.data = createObject("controllers.usersRecord").init()>
		session.data<br>
		<cfset session.data.dump()>
		
		session<br>
		<cfdump var="#session#">
		--->
		
		<!---
		<!--- include requested page --->
		<!--- <cfoutput><p><strong>OnRequest</strong></p></cfoutput> --->
		<cfparam name="url.event" default="index">
		<!--- <cfoutput>including #url.event#<br></cfoutput> --->
		<cfif left(url.event,1) EQ "_">
			<cfinclude template="app/events/404.cfm">
		<cfelseif fileExists("#application.baseDir#app\events\#url.event#.cfm")>
			<cfinclude template="app/events/#url.event#.cfm">
		<cfelseif fileExists("#application.baseDir#app\views\#url.event#.cfm")>
			<cfinclude template="app/views/#url.event#.cfm">
		<cfelse>
			<cfinclude template="app/events/404.cfm">
		</cfif>
		
		<!--- record page to session history --->
		<cflock scope="session" timeout="1" throwontimeout="false">
			<cfset arrayAppend(session.history.pages,cgi.query_string)>
		</cflock>
		--->
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