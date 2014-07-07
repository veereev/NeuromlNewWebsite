<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@page import="org.neuroml.validator.utils.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>
<%@page import="org.neuroml.validator.utils.*"%>
<%@page import="org.neuroml.validator.validation.*"%>
<!--------

File:      Latest.jsp
Author:    Padraig Gleeson

           This file has been developed as part of the neuroConstruct project
           This work has been funded by the Medical Research Council

---------->
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="application.css" />    
<script type="text/javascript" src="http://spike.la.asu.edu/NeuroMLValidator/public/javascripts/jquery-1.7.1.min.js"></script>
  <script type="text/javascript" src="http://spike.la.asu.edu/NeuroMLValidator/public/javascripts/jquery.dropotron-1.0.js"></script>
<script type="text/javascript">
var j = jQuery.noConflict();
      j(function() {
          j('#menu > ul').dropotron({
              mode: 'fade',
              globalOffsetY: 11,
              offsetY: -15
          });
      });
  </script>
        
<%
    
    String specPart = null;
    String format = "HTML";
    

    String currVer = GeneralProperties.getCurrentVersionShort();
    String currVerFull = GeneralProperties.getCurrentSchemaVersion();
    
    Enumeration names = request.getParameterNames();
    
    
    while (names.hasMoreElements())
    {
        String nextName = (String)names.nextElement();
        //out.println("Name: "+ nextName+ ", value: "+ request.getParameterValues(nextName)[0]);
       
        if (nextName.equals(Parameters.SPEC_PART))
        {
            specPart = request.getParameterValues(nextName)[0];
        }
        
        if (nextName.equals(Parameters.VIEW_FORMAT))
        {
            format = request.getParameterValues(nextName)[0];
        }
    }

    
    
    if (specPart!=null)
    {
        String pre = "<meta http-equiv=\"REFRESH\" content=\"0;url=";
        
        String url = "Transform.jsp?localFile=NeuroMLFiles/Schemata/v"
                    +currVerFull;  
        
        if (format.toLowerCase().indexOf("xml")>=0||format.toLowerCase().indexOf("xsl")>=0)
        {
            url = "ViewNeuroMLFile.jsp?localFile=NeuroMLFiles/Schemata/v"
                    +currVerFull;
        }
        
        if (specPart.toLowerCase().indexOf("morphml")>=0)
        {
            url = url +"/Level1/MorphML_v"+currVer+".xsd&xslFile=NeuroMLFiles/Schemata/XSD_Readable.xsl";
        }
        else if (specPart.toLowerCase().indexOf("meta")>=0)
        {
            url = url +"/Level1/Metadata_v"+currVer+".xsd&xslFile=NeuroMLFiles/Schemata/XSD_Readable.xsl";
        }
        else if (specPart.toLowerCase().indexOf("channelml")>=0)
        {
            url = url +"/Level2/ChannelML_v"+currVer+".xsd&xslFile=NeuroMLFiles/Schemata/XSD_Readable.xsl";
        }
        else if (specPart.toLowerCase().indexOf("biophysics")>=0)
        {
            url = url +"/Level2/Biophysics_v"+currVer+".xsd&xslFile=NeuroMLFiles/Schemata/XSD_Readable.xsl";
        }
        else if (specPart.toLowerCase().indexOf("network")>=0)
        {
            url = url +"/Level3/NetworkML_v"+currVer+".xsd&xslFile=NeuroMLFiles/Schemata/XSD_Readable.xsl";
        }
        else if (specPart.toLowerCase().indexOf("level1")>=0)
        {
            url = url +"/Level1/NeuroML_Level1_v"+currVer+".xsd&xslFile=NeuroMLFiles/Schemata/XSD_Readable.xsl";
        }
        else if (specPart.toLowerCase().indexOf("level2")>=0)
        {
            url = url +"/Level2/NeuroML_Level2_v"+currVer+".xsd&xslFile=NeuroMLFiles/Schemata/XSD_Readable.xsl";
        }
        else if (specPart.toLowerCase().indexOf("level3")>=0)
        {
            url = url +"/Level3/NeuroML_Level3_v"+currVer+".xsd&xslFile=NeuroMLFiles/Schemata/XSD_Readable.xsl";
        }

        //out.println(pre + url +"\">");
        
        response.sendRedirect(url);

    }
    else
    {
    

%>
        <title>Latest NeuroML version (version <%=currVerFull%>)</title>
</head>
    <body>
    <div id="wrapper">
        <%@ include file="header.jsp" %>
        <div class="oveflowcontent">

        
        <h3>Current version of the NeuroML specifications (version <%=currVerFull%>):</h3>
        
        

        <br/>
        There are three Levels of compliance to the NeuroML standards:
        <ul>
            <li style="padding:5px ; margin-left: 10px"><a href="Latest.jsp?<%=Parameters.SPEC_PART%>=Level1">Level 1</a> 
        is focused on the anatomical aspects of the cells. This consists of a schema for metadata, 
        <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=Metadata">Metadata_v<%=currVer%>.xsd</a> (which can be also used to describe 
        elements at any subsequent level), and the main MorphML schema, <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=MorphML">MorphML_v<%=currVer%>.xsd</a>. 
        Valid morphology files can be mapped to <a href="http://www.neuron.yale.edu/neuron/">NEURON</a> or <a href="http://www.genesis-sim.org/GENESIS/">GENESIS</a> format.</li>
        
            <li style="padding:5px ; margin-left: 10px"> <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=Level2">Level 2</a> adds the ability
            to include information on the biophysical properties of cells (specific capacitance, axial resistance, location and density of 
            membrane conductances, etc.) <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=Biophysics">Biophysics_v<%=currVer%>.xsd</a>,
            and on the properties of specific channel and synaptic mechanisms, <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=ChannelML">ChannelML_v<%=currVer%>.xsd</a>. 
            <a href="Samples.jsp">Examples</a> are given for valid ChannelML files which can be mapped to 
            scripts for the <a href="http://www.neuron.yale.edu/neuron/">NEURON</a> and <a href="http://www.genesis-sim.org/GENESIS/">GENESIS</a> 
            simulators.
            
            Any Level 1 or Level 2 XML file to will be compliant to <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=Level2">NeuroML_Level2_v<%=currVer%>.xsd</a></li>
        
            <li style="padding:5px ; margin-left: 10px"> <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=Level3">Level 3</a> allows 
            specification of cell placement and network connectivity. The core of this is specified in <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=NetworkML">NetworkML_v<%=currVer%>.xsd</a></li>
        </ul>


        
        <p>In readable (HTML) format:</p>
      
        <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=MorphML">MorphML</a>
        <br />
        <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=Metadata">Metadata</a>
        <br />
        <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=ChannelML">ChannelML</a>
        <br />
        <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=Biophysics">Biophysics</a>
        <br />
        <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=NetworkML">NetworkML</a>
        
        
        <br />
        
        <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=Level1">NeuroML Level 1</a>
        <br />
        <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=Level2">NeuroML Level 2</a>
        <br />
        <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=Level3">NeuroML Level 3</a>
        
        
        
        <p>In original XSL format:</p>
        
        <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=MorphML&<%=Parameters.VIEW_FORMAT%>=XML">MorphML</a>
        <br />
        <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=Metadata&<%=Parameters.VIEW_FORMAT%>=XML">Metadata</a>
        <br />
        <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=ChannelML&<%=Parameters.VIEW_FORMAT%>=XML">ChannelML</a>
        <br />
        <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=Biophysics&<%=Parameters.VIEW_FORMAT%>=XML">Biophysics</a>
        <br />
        <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=NetworkML&<%=Parameters.VIEW_FORMAT%>=XML">NetworkML</a>
        
        
        <br />
        
        <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=Level1&<%=Parameters.VIEW_FORMAT%>=XML">NeuroML Level 1</a>
        <br />
        <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=Level2&<%=Parameters.VIEW_FORMAT%>=XML">NeuroML Level 2</a>
        <br />
        <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=Level3&<%=Parameters.VIEW_FORMAT%>=XML">NeuroML Level 3</a>
        <br />
        
  
        <br />
  
        


        <p>&nbsp;</p>
        <p>&nbsp;</p>
        <p>&nbsp;</p>

      <%@ include file="footer.jsp" %>
      </div></div>
      
        

<%  
    }
    

%></div></div>
        
    </body>
</html>
