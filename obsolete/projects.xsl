<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  
  <!-- 20051007 this code is untested and probably not ready. -->

  <xsl:template match="project">
    <xsl:choose>
      <xsl:when test="@object = 'main'"> 
	<xsl:choose>
	  <xsl:when test="$transformControlFile = 'orbitShort.xml'">
	    <xsl:call-template name="projects_main_short_view"/>
	  </xsl:when>
	  <xsl:when test="$transformControlFile = 'orbitAllAuthors.xml'">
	    <xsl:call-template name="projects_main_AllAuthors_view"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:call-template name="projects_main_long_view"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!-- Object Type = AUX: Another object is including a project object -->
	<xsl:apply-templates/> <!-- TODO -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  

<!-- Short format -->
  <xsl:template name="projects_main_short_view">

    <!-- project heading -->
	<xsl:value-of disable-output-escaping="yes" select="name/main"/>
    <xsl:call-template name="labelview">
      <xsl:with-param name="element" select="name/sub"/>
      <xsl:with-param name="prefix" select="' : '"/>
    </xsl:call-template>
    <xsl:if test="acronyme">
      (<xsl:value-of select="acronyme"/>)
    </xsl:if>
    <br/>



<!-- first person -->
	<xsl:choose>
	<xsl:when test="string-length(organisation[1]/person[1]/identifier)">
		<a><xsl:attribute name="href">?service=external/Person&amp;sp=<xsl:value-of select="organisation[1]/person[1]/identifier"/></xsl:attribute>
 		   <xsl:call-template name="labelview">
 			   <xsl:with-param name="element" select="organisation[1]/person[1]/name/last"/>
 			   <xsl:with-param name="prefix" select="''"/>
		   </xsl:call-template>
		   <xsl:call-template name="labelview">
			   <xsl:with-param name="element" select="organisation[1]/person[1]/name/first"/>
    		   <xsl:with-param name="prefix" select="', '"/>
    	   </xsl:call-template>
       </a>
    </xsl:when> 
	<xsl:otherwise>
 		   <xsl:call-template name="labelview">
 			   <xsl:with-param name="element" select="organisation[1]/person[1]/name/last"/>
 			   <xsl:with-param name="prefix" select="''"/>
		   </xsl:call-template>
		   <xsl:call-template name="labelview">
			   <xsl:with-param name="element" select="organisation[1]/person[1]/name/first"/>
    		   <xsl:with-param name="prefix" select="', '"/>
    	   </xsl:call-template>
	</xsl:otherwise>
	</xsl:choose>   


<!-- first organisation -->
    <xsl:if test="organisation[1]/name/sub">
	<xsl:text>, </xsl:text>
		<xsl:variable name="orgId">
			<xsl:call-template name="getOrganisationId">
				<xsl:with-param name="orgid" select="organisation[1]/name/sub"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="string-length($orgId)">
				<a>
					<xsl:attribute name="href">?service=external/Organisation&amp;sp=<xsl:value-of select="$orgId"/></xsl:attribute>
		 			<xsl:value-of select="organisation[1]/name/sub"/>
		       </a>
		    </xsl:when>
 		    <xsl:otherwise>
	 			<xsl:value-of select="organisation[1]/name/sub"/>
		    </xsl:otherwise>
		</xsl:choose>
	</xsl:if>	
    <xsl:choose>
      <xsl:when test="organisation[2] or organisation[1]/person[2]">&#160;[et al.]</xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
    <br/>
  </xsl:template>
  
  
<!-- Format AllAuthors --> 
 <xsl:template name="projects_main_AllAuthors_view">

<!-- person -->
	<xsl:choose>
	<xsl:when test="string-length(organisation[1]/person[1]/identifier)">
	<a><xsl:attribute name="href">?service=external/Person&amp;sp=<xsl:value-of select="organisation[1]/person[1]/identifier"/></xsl:attribute>
 		  <xsl:call-template name="labelview">
		    <xsl:with-param name="element" select="organisation[1]/person[1]/name/last"/>
		    <xsl:with-param name="prefix" select="''"/>
		  </xsl:call-template>
		  <xsl:call-template name="labelview">
		    <xsl:with-param name="element" select="organisation[1]/person[1]/name/first"/>
		    <xsl:with-param name="prefix" select="', '"/>
		  </xsl:call-template> 
	</a>
    </xsl:when> 
	<xsl:otherwise>
 		  <xsl:call-template name="labelview">
		    <xsl:with-param name="element" select="organisation[1]/person[1]/name/last"/>
		    <xsl:with-param name="prefix" select="''"/>
		  </xsl:call-template>
		  <xsl:call-template name="labelview">
		    <xsl:with-param name="element" select="organisation[1]/person[1]/name/first"/>
		    <xsl:with-param name="prefix" select="', '"/>
		  </xsl:call-template> 
 	</xsl:otherwise>
	</xsl:choose> 		  			       		  
 	      <xsl:for-each select="organisation[1]/person[position()!=1]">
       <xsl:choose>
        <xsl:when test="string-length(identifier) > 0">
 			<a><xsl:attribute name="href">?service=external/Person&amp;sp=<xsl:value-of select="identifier"/></xsl:attribute>
				  <xsl:call-template name="labelview">
				    <xsl:with-param name="element" select="name/last"/>
				    <xsl:with-param name="prefix" select="' ; '"/>
				  </xsl:call-template>
				  <xsl:call-template name="labelview">
				    <xsl:with-param name="element" select="name/first"/>
				    <xsl:with-param name="prefix" select="', '"/>
				  </xsl:call-template>      		  
			</a>
        </xsl:when>
            <xsl:otherwise>
				  <xsl:call-template name="labelview">
				    <xsl:with-param name="element" select="name/last"/>
				    <xsl:with-param name="prefix" select="' ; '"/>
				  </xsl:call-template>
				  <xsl:call-template name="labelview">
				    <xsl:with-param name="element" select="name/first"/>
				    <xsl:with-param name="prefix" select="', '"/>
				  </xsl:call-template>      	                  
            </xsl:otherwise>
      </xsl:choose>
   	  </xsl:for-each> 
	      <xsl:for-each select="organisation[position()!=1]/person">
       <xsl:choose>
        <xsl:when test="string-length(identifier) > 0">
 			<a><xsl:attribute name="href">?service=external/Person&amp;sp=<xsl:value-of select="identifier"/></xsl:attribute>
				  <xsl:call-template name="labelview">
				    <xsl:with-param name="element" select="name/last"/>
				    <xsl:with-param name="prefix" select="' ; '"/>
				  </xsl:call-template>
				  <xsl:call-template name="labelview">
				    <xsl:with-param name="element" select="name/first"/>
				    <xsl:with-param name="prefix" select="', '"/>
				  </xsl:call-template>      		  
			</a>
        </xsl:when>
            <xsl:otherwise>
				  <xsl:call-template name="labelview">
				    <xsl:with-param name="element" select="name/last"/>
				    <xsl:with-param name="prefix" select="' ; '"/>
				  </xsl:call-template>
				  <xsl:call-template name="labelview">
				    <xsl:with-param name="element" select="name/first"/>
				    <xsl:with-param name="prefix" select="', '"/>
				  </xsl:call-template>      	                  
            </xsl:otherwise>
      </xsl:choose>
   	  </xsl:for-each> 
  <br/>

 
<!-- Title -->
		<xsl:value-of disable-output-escaping="yes" select="name/main"/>
    <xsl:call-template name="labelview">
      <xsl:with-param name="element" select="name/sub"/>
      <xsl:with-param name="prefix" select="' : '"/>
    </xsl:call-template> 
    <xsl:if test="acronyme">
      (<xsl:value-of select="acronyme"/>)
    </xsl:if>
   <br/>
      
<!-- Duration -->	
	<xsl:choose>
      <xsl:when test="dates/start and dates/end">
              <xsl:text>From </xsl:text>
		      <xsl:value-of select="substring(dates/start,7,2)"/>
              <xsl:text>-</xsl:text>		      
		      <xsl:value-of select="substring(dates/start,5,2)"/>
              <xsl:text>-</xsl:text>
		      <xsl:value-of select="substring(dates/start,1,4)"/> 
              <xsl:text> to </xsl:text>             	
		      <xsl:value-of select="substring(dates/end,7,2)"/>
              <xsl:text>-</xsl:text>		      
		      <xsl:value-of select="substring(dates/end,5,2)"/>
              <xsl:text>-</xsl:text>
		      <xsl:value-of select="substring(dates/end,1,4)"/> 
	  </xsl:when>
	  <xsl:otherwise>
              <xsl:text>From </xsl:text>
		      <xsl:value-of select="substring(dates/start,7,2)"/>
              <xsl:text>-</xsl:text>		      
		      <xsl:value-of select="substring(dates/start,5,2)"/>
              <xsl:text>-</xsl:text>
		      <xsl:value-of select="substring(dates/start,1,4)"/> 
	  </xsl:otherwise>
	</xsl:choose>	  	  
		      <xsl:call-template name="labelview">
			<xsl:with-param name="element" select="dates/end/@authority_type_eng"/>
			<xsl:with-param name="prefix" select="' Type of end date: '"/>
		      </xsl:call-template>
		      <br/>
		      <xsl:call-template name="labelview">
			<xsl:with-param name="element" select="status/@authority_eng"/>
			<xsl:with-param name="prefix" select="' Project status: '"/>
		      </xsl:call-template>

   <br/>
 </xsl:template> 
 
 
<!-- Long format -->
  <xsl:template name="projects_main_long_view">
    <div style="margin-bottom:5px;">
    <table border="0" width="100%" cellspacing="0">
    <tr>
	<td style="width:90px;" valign="top"><b>Title</b></td>
	<td style="width:3px;">&#160;</td>
	<td valign="top">

	  <xsl:for-each select="name">
	    <div style="margin-bottom:5px;">
			<xsl:value-of disable-output-escaping="yes" select="main"/>
			<xsl:call-template name="labelview">
		    <xsl:with-param name="element" select="sub"/>
		    <xsl:with-param name="prefix" select="': '"/>
	 	    </xsl:call-template>
	    <xsl:if test="string-length(acronyme)">
		    (<xsl:value-of select="acronyme"/>)
        </xsl:if>
       </div> 
	  </xsl:for-each> <!-- title -->

	</td>
    </tr>
 

  
<!-- TODO Goes into Organisation_aux !!!!!!!!!  -->

      <tr>
	<td style="width:90px;" valign="top"><b>Partner/s</b></td>
	<td style="width:3px;">&#160;</td>
	<td valign="top">
	
<xsl:for-each select="organisation">

    <div style="margin-bottom:5px;">
		 <xsl:if test="string-length(@authority_type_eng) > 0">
	      	<xsl:call-template name="labelview">
	        <xsl:with-param name="element" select="@authority_type_eng"/>
	        <xsl:with-param name="prefix" select="'Type: ('"/>
	      	</xsl:call-template>
		 </xsl:if>
		 
	<xsl:choose>
  		<xsl:when test="string-length(@authority_type_eng) > 0">
	 	      <xsl:call-template name="labelview">
		      <xsl:with-param name="element" select="@authority_role_eng"/>
	          <xsl:with-param name="prefix" select="'). ('"/>
		      </xsl:call-template>
	    	  <xsl:text>) </xsl:text>
 	        <br/> 	
  		</xsl:when> 
  		<xsl:otherwise>
	 	      <xsl:call-template name="labelview">
	          <xsl:with-param name="element" select="@role"/>
	          <xsl:with-param name="prefix" select="'('"/>
		      </xsl:call-template>
		   	  <xsl:text>) </xsl:text>
 	        <br/> 	
  		</xsl:otherwise> 
    </xsl:choose>	 

	<xsl:variable name="orgId">
			<xsl:call-template name="getOrganisationId">  
			<xsl:with-param name="orgid" select="name/sub"/>
	      	</xsl:call-template>
	</xsl:variable>

    <xsl:choose>
	<xsl:when test="string-length($orgId)">
			<a>
				<xsl:attribute name="href">?service=external/Organisation&amp;sp=<xsl:value-of select="$orgId"/></xsl:attribute>
 				<xsl:value-of select="name/sub"/>
		    </a>

		<xsl:choose>
  			<xsl:when test="string-length(name/sub)">
  		    	<xsl:call-template name="labelview">
				<xsl:with-param name="element" select="name/main"/>
				<xsl:with-param name="prefix" select="'. '"/>
		      	</xsl:call-template> 
			</xsl:when>
		<xsl:otherwise>
		      	<xsl:call-template name="labelview">
				<xsl:with-param name="element" select="name/main"/>
				<xsl:with-param name="prefix" select="''"/>
		      	</xsl:call-template>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:when>
	    
     <xsl:otherwise>
		      <xsl:call-template name="labelview">
			<xsl:with-param name="element" select="name/sub"/>
			<xsl:with-param name="prefix" select="''"/>
		      </xsl:call-template>
 
 		<xsl:choose>
  			<xsl:when test="string-length(name/sub)">
  		    	<xsl:call-template name="labelview">
				<xsl:with-param name="element" select="name/main"/>
				<xsl:with-param name="prefix" select="'. '"/>
		      	</xsl:call-template> 
			</xsl:when>
			<xsl:otherwise>
		      	<xsl:call-template name="labelview">
				<xsl:with-param name="element" select="name/main"/>
				<xsl:with-param name="prefix" select="''"/>
		      	</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
 
  		<xsl:if test="string-length(country) > 0">
 	      	<xsl:call-template name="labelview">
			<xsl:with-param name="element" select="country"/>
			<xsl:with-param name="prefix" select="' - ('"/>
	      	</xsl:call-template>
   	  		<xsl:text>) </xsl:text>	 
 		</xsl:if>
	 </xsl:otherwise>
  	</xsl:choose>

  <xsl:choose> 		    
   	<xsl:when test="/ddf/@user_id = 'darcdarwin'">  
		<xsl:text>. </xsl:text>
		    <xsl:value-of select="substring-after(contact/post/street, ',')"/>
	 	</xsl:when>

  	  <xsl:otherwise>     
	  	    <xsl:choose>
			   <xsl:when test="string-length(contact/post/street)">
			      <xsl:call-template name="labelview">
		          <xsl:with-param name="element" select="contact/post/building"/>
				  <xsl:with-param name="prefix" select="'. Building '"/>
			      </xsl:call-template>
			   </xsl:when>
	         		<xsl:otherwise>
			      <xsl:call-template name="labelview">
				  <xsl:with-param name="element" select="contact/post/building"/>
				  <xsl:with-param name="prefix" select="'Building '"/>
			      </xsl:call-template>
	          		</xsl:otherwise>
	  	    </xsl:choose>
 
		   <xsl:if test="/ddf/@user_id != 'darcdarwin'">
		      <xsl:call-template name="labelview">
	        <xsl:with-param name="element" select="contact/post/street"/>
			<xsl:with-param name="prefix" select="'. '"/>
		      </xsl:call-template>

		      <xsl:call-template name="labelview">
			<xsl:with-param name="element" select="contact/post/zipcode"/>
			<xsl:with-param name="prefix" select="'. '"/>
		      </xsl:call-template>
		  </xsl:if>
 
  		
        <xsl:choose>
		   <xsl:when test="string-length(contact/post/street)">
		      <xsl:call-template name="labelview">
	        <xsl:with-param name="element" select="contact/post/city"/>
			<xsl:with-param name="prefix" select="'. '"/>
		      </xsl:call-template>
		  </xsl:when>
                  <xsl:otherwise>
		      <xsl:call-template name="labelview">
			<xsl:with-param name="element" select="contact/post/city"/>
			<xsl:with-param name="prefix" select="''"/>
		      </xsl:call-template>
                 </xsl:otherwise>
  		</xsl:choose>		
 
        <xsl:choose>
		   <xsl:when test="string-length(contact/post/city)">
		      <xsl:call-template name="labelview">
	        <xsl:with-param name="element" select="contact/post/country"/>
			<xsl:with-param name="prefix" select="'. '"/>
		      </xsl:call-template>
		  </xsl:when>
                  <xsl:otherwise>
		      <xsl:call-template name="labelview">
			<xsl:with-param name="element" select="contact/post/country"/>
			<xsl:with-param name="prefix" select="''"/>
		      </xsl:call-template>
                 </xsl:otherwise>
  		</xsl:choose>	

   </xsl:otherwise>	
  </xsl:choose>
  	
<!-- Contact --> 
	      <xsl:if test="string-length(contact/url) > 0">
	      <br/>
	        <xsl:text>Homepage: </xsl:text> 	      	      
        	<a><xsl:attribute name="href"><xsl:value-of select="contact/url"/>
            </xsl:attribute><xsl:value-of select="contact/url"/></a>
   	      </xsl:if>
   	        <xsl:if test="string-length(contact/email) > 0">
	        <xsl:text> Email: </xsl:text> 
        	<a><xsl:attribute name="href">mailto:<xsl:value-of select="contact/email"/>
            </xsl:attribute><xsl:value-of select="contact/email"/></a>
          </xsl:if>
	      <xsl:if test="string-length(contact/tel) > 0">
	        <br/> 
	      </xsl:if>
  	      <xsl:call-template name="labelview">
		<xsl:with-param name="element" select="contact/tel"/>
		<xsl:with-param name="prefix" select="'Tel: '"/>
	      </xsl:call-template>
	   	  <xsl:call-template name="labelview">
		<xsl:with-param name="element" select="contact/fax"/>
		<xsl:with-param name="prefix" select="'  Fax: '"/>
	      </xsl:call-template>
	        <br/> 
	      <xsl:if test="string-length(person/name/last) > 0">
	        <xsl:text></xsl:text> 
	      </xsl:if>
	      
     <xsl:for-each select="person[name/first or name/last]"> 

<!-- Role -->
		  <xsl:choose>
		    <xsl:when test="string-length(@authority_role_eng)">
		  <xsl:call-template name="labelview">
		    <xsl:with-param name="element" select="@authority_role_eng"/>
		    <xsl:with-param name="prefix" select="' '"/>
		  </xsl:call-template>
		      <xsl:text>: </xsl:text> 
		    </xsl:when>
		    <xsl:otherwise>
		    </xsl:otherwise>
		  </xsl:choose>
	<xsl:choose>
	<xsl:when test="string-length(identifier)">
		<a><xsl:attribute name="href">?service=external/Person&amp;sp=<xsl:value-of select="identifier"/></xsl:attribute>
		  <xsl:call-template name="labelview">
		    <xsl:with-param name="element" select="name/last"/>
		    <xsl:with-param name="prefix" select="''"/>
		  </xsl:call-template>
		  <xsl:call-template name="labelview">
		    <xsl:with-param name="element" select="name/first"/>
		    <xsl:with-param name="prefix" select="', '"/>
		  </xsl:call-template>
 	      <xsl:if test="string-length(identifier) > 0">
     	  <xsl:text> (</xsl:text>
	      <xsl:call-template name="labelview">
	        <xsl:with-param name="element" select="identifier"/>
	        <xsl:with-param name="prefix" select="'Cwisno.: '"/>
	      </xsl:call-template>
	    <xsl:text>)&#160;</xsl:text>
	    </xsl:if>
	        </a>
    </xsl:when> 
	<xsl:otherwise>
		  <xsl:call-template name="labelview">
		    <xsl:with-param name="element" select="name/last"/>
		    <xsl:with-param name="prefix" select="''"/>
		  </xsl:call-template>
		  <xsl:call-template name="labelview">
		    <xsl:with-param name="element" select="name/first"/>
		    <xsl:with-param name="prefix" select="', '"/>
		  </xsl:call-template>
 	      <xsl:if test="string-length(identifier) > 0">
	     	  <xsl:text> (</xsl:text>
		      <xsl:call-template name="labelview">
		        <xsl:with-param name="element" select="identifier"/>
		        <xsl:with-param name="prefix" select="'Cwisno.: '"/>
		      </xsl:call-template>
		    <xsl:text>)&#160;</xsl:text>
	      </xsl:if>
	</xsl:otherwise>
	</xsl:choose>  	    	
   </xsl:for-each> <!-- person -->
  </div> 
</xsl:for-each> <!-- organisation -->

	</td>
	</tr>




<!-- Abstract -->  
    <xsl:if test="abstract">
    <xsl:text>&#160;</xsl:text>	
	<tr>
	<td style="width:90px;" valign="top"><b>Abstract</b></td>
	<td style="width:3px;">&#160;</td>
	<td valign="top">
	  <xsl:for-each select="abstract">
	    <div style="margin-bottom:5px;">
   	    <xsl:value-of disable-output-escaping="yes" select="."/>
        </div> 
        </xsl:for-each> <!-- abstract -->
	</td>
    </tr>
    </xsl:if>
 
 
	

<!-- Classification -->  
    <xsl:if test="class">
    <xsl:text>&#160;</xsl:text>	
	<tr>
	<td style="width:90px;" valign="top"><b>Classification</b></td>
	<td style="width:3px;">&#160;</td>
	<td valign="top">
	  <xsl:for-each select="class">
	    <div style="margin-bottom:5px;">
   	    <xsl:value-of select="."/>
        </div> 
        </xsl:for-each> <!-- class -->
	</td>
    </tr>
    </xsl:if>
        
<!-- Keyword -->
   <xsl:if test="keyword">
   <xsl:text>&#160;</xsl:text>	
	<tr>
	<td style="width:90px;" valign="top"><b>Keyword/s</b></td>
	<td style="width:5x;">&#160;</td>
	<td valign="top">
	  <xsl:for-each select="keyword">
	    <div style="margin-bottom:5px;">
   	    <xsl:value-of select="."/>
        </div> 
        </xsl:for-each> <!-- keyword -->
	</td>
    </tr>
    </xsl:if> 

<!-- Homepage -->	
   <xsl:if test="www">
    <xsl:text>&#160;</xsl:text>	
	<tr>
	<td style="width:90px;" valign="top"><b>Link</b></td>
	<td style="width:5x;">&#160;</td>
	<td valign="top">    
	  <xsl:for-each select="www">
	    <div style="margin-bottom:5px;">
	<a><xsl:attribute name="href"><xsl:value-of select="url"/>
    </xsl:attribute><xsl:value-of select="text/@authority_eng"/>Click here</a>
        </div> 
    </xsl:for-each> <!-- www -->
	</td>
    </tr>
    </xsl:if>  

<!-- Note -->
   <xsl:if test="string-length(note) > 0">
    <xsl:text>&#160;</xsl:text>	
	<tr>
	<td style="width:90px;" valign="top"><b>Note</b></td>
	<td style="width:3px;">&#160;</td>
	<td valign="top">
	  <xsl:for-each select="note">
	    <div style="margin-bottom:5px;">
   	    <xsl:value-of disable-output-escaping="yes" select="."/>
        </div> 
        </xsl:for-each> <!-- note -->
	</td>
    </tr>
  </xsl:if>
  
<!-- Duration -->	
	<xsl:choose>
      <xsl:when test="dates/start and dates/end">
	    <xsl:text>&#160;</xsl:text>	
		  <tr>		 
        <td style="width:90px;" valign="top"><b>Duration </b></td>
    	<td style="width:3px;">&#160;</td>
	    <td valign="top">
	      <div style="margin-bottom:5px;">
              <xsl:text>From </xsl:text>
		      <xsl:value-of select="substring(dates/start,7,2)"/>
              <xsl:text>-</xsl:text>		      
		      <xsl:value-of select="substring(dates/start,5,2)"/>
              <xsl:text>-</xsl:text>
		      <xsl:value-of select="substring(dates/start,1,4)"/> 
              <xsl:text> to </xsl:text>             	
		      <xsl:value-of select="substring(dates/end,7,2)"/>
              <xsl:text>-</xsl:text>		      
		      <xsl:value-of select="substring(dates/end,5,2)"/>
              <xsl:text>-</xsl:text>
		      <xsl:value-of select="substring(dates/end,1,4)"/> 
        	</div> 
          </td>
         </tr>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>&#160;</xsl:text>	
		  <tr>		 
           <td style="width:90px;" valign="top"><b>Duration </b></td>
    	   <td style="width:3px;">&#160;</td>
	       <td valign="top">
	    	<div style="margin-bottom:5px;">
              <xsl:text>From </xsl:text>
		      <xsl:value-of select="substring(dates/start,7,2)"/>
              <xsl:text>-</xsl:text>		      
		      <xsl:value-of select="substring(dates/start,5,2)"/>
              <xsl:text>-</xsl:text>
		      <xsl:value-of select="substring(dates/start,1,4)"/> 
        	</div> 
           </td>
          </tr>
	  </xsl:otherwise>
	</xsl:choose>

<!-- Project status -->
   <xsl:if test="status/@authority_eng">
	    <xsl:text>&#160;</xsl:text>	
		  <tr>		 
        <td style="width:90px;" valign="top"><b>Project status: </b></td>
    	<td style="width:3px;">&#160;</td>
	    <td valign="top">
	      <div style="margin-bottom:5px;">
           <xsl:call-template name="labelview">
			<xsl:with-param name="element" select="status/@authority_eng"/>
			<xsl:with-param name="prefix" select="''"/>
		      </xsl:call-template>
		   </div>
		 </td>
		</tr>
    </xsl:if>


<!-- Department and cross organisation -->
    <tr>
  	<td style="width:90px;" valign="top"><b>DTU Data</b></td>
	<td style="width:3px;">&#160;</td>
	<td valign="top">
	<xsl:for-each select="local">
	    <div style="margin-bottom:1px;">
		<xsl:if test="field[@tag = 'Institute owner']">
	        <xsl:call-template name="labelview">
	          <xsl:with-param name="element" select="field[@tag = 'Institute owner']"/>
	          <xsl:with-param name="prefix" select="'Credited department: '"/>
	        </xsl:call-template>
	    </xsl:if>
	    </div>
		<xsl:if test="field[@tag = 'Sub organisation']">
	        <xsl:call-template name="labelview">
	          <xsl:with-param name="element" select="field[@tag = 'Sub organisation']"/>
	          <xsl:with-param name="prefix" select="'Cross organisation: '"/>
	        </xsl:call-template>
	    </xsl:if>
    </xsl:for-each>
	</td>
    </tr>

    </table>
   </div>
  </xsl:template>
  
</xsl:stylesheet>
