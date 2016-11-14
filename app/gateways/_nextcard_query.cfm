		select * from cards 
		where idDeck = <cfqueryparam value="#arguments.idDeck#">
		
		<cfif nextCardType EQ "new">
			and ((status = 0) or (status = 2))
			and ((dateDue < <cfqueryparam value="#dateFormat(now(),"yyyy-mm-dd")# #timeFormat(now(),"HH:mm:ss")#">) or (dateDue is null))
			
		order by 
		
		<cfif reviewFailed EQ 2>
			status asc,
		<cfelseif reviewFailed EQ 1>
			status desc,
		</cfif>
		
		<!--- new card order --->
		<cfif newCardOrder EQ 0>
			idCard asc,
		<cfelseif newCardOrder EQ 1>
			idCard desc,
		<cfelse>
			rand(),
		</cfif>
			
		<cfelseif	nextCardType EQ "review">
			and ((status = 1) or (status = 2))
			and (dateDue < <cfqueryparam value="#dateFormat(now(),"yyyy-mm-dd")# #timeFormat(now(),"HH:mm:ss")#">)
			
		order by 
		
		<cfif reviewFailed EQ 2>
			status asc,
		<cfelse>
			status desc,
		</cfif>
		
		<!--- review card order ---><!--- newer, older, order due, random --->
		<cfif reviewOrder EQ 0>
			idCard desc,
		<cfelseif reviewOrder EQ 1>
			idCard asc,
		<cfelseif reviewOrder EQ 2>
			dateDue asc,
		<cfelse>
			rand(),
		</cfif>
		
		</cfif>
		
		dateDue asc