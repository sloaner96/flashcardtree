<cfinclude template="_header.cfm">

<div class="main-content">
    <div class="containit">

        <div class="wide-horz-divider"><!--  --></div>

        <div class="full-width clearfix pt0">
        
<!---        	
					<p class="success"><strong>Thanks!</strong> Your email was successfully sent.  We should be in touch soon.</p>
					--->
              <div class="one-half  border-vert-right pt20">
                 <div class="padright">
                 
								 		<cfoutput>
                  		<form action="#Nav('contact')#" id="contactForm" method="post">
                 		</cfoutput>
								 
								  			<ol class="forms">
                  				<li>

                                    <label for="yourName">Name <span class="required">*</span></label>
                  					<input type="text" name="yourName" id="yourName" value="" class="requiredField" style="width:430px;"/>
                                </li>
                  				<li>
                                    <label for="email">Email <span class="required">*</span></label>
                  					<input type="text" name="email" id="email" value="" class="requiredField email" style="width:430px;"/>
                                </li>

                  				<li class="textarea">
                                    <label for="commentsText">Comments <span class="required">*</span></label>
                  					<textarea name="comments" id="commentsText" rows="4" cols="56" class="requiredField" style="width:430px;"></textarea>
                  				</li>
<!---                  				<li class="inline">
                                    <input type="checkbox" name="sendCopy" id="sendCopy" value="true" class="nostyle"/>
                                    <label for="sendCopy">Send a copy of this email to yourself</label>

                                </li>--->
                  				<li class="screenReader">
                                    <label for="checking" class="screenReader">If you want to submit this form, do not enter anything in this field</label>
                                    <input type="text" name="checking" id="checking" class="screenReader" value="" />
                                </li>
                            </ol>
                            <div class="clear"></div>
                            <div><input type="hidden" name="submitted" id="submitted" value="true"/></div>

                            <div class="form-button-left"><button type="submit" class="form-button"><span>Send Information</span></button></div>
                  		</form>

                        <!--<p class="success"><strong>Thanks!</strong> Your email was successfully sent.  We should be in touch soon.</p>
                        <p class="errors"><strong>Ooops!</strong> There was an error somewhere. Please retry or mail the geeks.</p>
                        <p class="notification"><strong>Please note!</strong> You should lorem <a href="#">Mauris</a> dictum libero id justo.</p>-->
                </div>
              </div>
              <div class="one-half-last pt20">
              <div class="padleft">
                  <h1>Contact CEL Creations</h1>

                  <p>To get in touch with us please fill out the form to your left or email us directly at <a href="#">info@celcreations.com</a></p>

               </div>
              </div>
        </div>



    </div>
</div>

<cfinclude template="_footer.cfm">