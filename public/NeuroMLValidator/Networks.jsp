<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!--------

File:      Networks.jsp
Author:    Padraig Gleeson

           This file has been developed as part of the neuroConstruct project
           This work has been funded by the Wellcome Trust

---------->
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="neuro.css" />
        <title>Suggestions for NeuroML v2.0 networks & NineML</title>
        <%GeneralUtils.setCurrentPageRef("Netv2");%>
    </head>
    <body>
 
    
        <%@ include file="header.jsp" %>
        
      <h1>List of suggestions for NeuroML v2.0 network elements/NineML User Layer</h1>
        

        <br/>
        <table id="highlighted" align="center" >
            <tr>
                <td>The following are some initial thoughts on the elements needed for network descriptions in NeuroML v2.0 based on discussions in the
                    <a href="http://www.incf.org/core/programs/modeling">INCF Multiscale Modelling Program</a>.<br/><br/>
                    See <a href="../neuroml2.php">here</a> for how this package relates to other developments towards NeuroML 2.</td>
            </tr>
        </table>

        <br/>
        <br/>

        <p>A key distinction in <a href="http://neuroml.org/NeuroMLValidator/Latest.jsp?spec=NetworkML">NetworkML version 1.x</a> is between:</p>
        <ul>
            <li><b>Template based representations:</b> a concise description of a network in terms of a template from which to
                generate many instances of cell positions and connections, e.g. <i>"place 200 cells
                    randomly in a 3D region"</i>
                (<a href="ViewNeuroMLFile.jsp?localFile=NeuroMLFiles/Examples/NetworkML/SimpleNetworkTemplate.xml">example in v1.8.1</a>).</li>
            <li><b>Instance based representations:</b> an explicit listing of all instances of cell positions and connections
                (<a href="ViewNeuroMLFile.jsp?localFile=NeuroMLFiles/Examples/NetworkML/SimpleNetworkInstance.xml">example in v1.8.1</a>).</li>
        </ul>
        <p>While there are <a href="http://www.neuroml.org/tool_support.php">an increasing number of tools</a> which support the instance based representation of NetworkML v1.x, 
            one of the main drawbacks of this version is the narrow range of templates for expressing the wide range of structures and connectivities
            encountered in neuronal network models. Another shortcoming of the current version is that it is not possible to create hierarchical networks,
            e.g. <i>"create a subnetwork of 3 populations
        (2 laid out on regular 3D grids, and one randomly placed in a rectangular box above the others) and repeat that network on a 3x3 grid"</i>.
        Below is an image of the type of network which needs to be created.</p>
        <br>
        
        <p align="center"><a name="nCnet" href="images/Netv2.png"><img alt="Hierarchical network" src="images/Netv2.png" align="middle" width="500"/></a></p>
        <br>
            
            
            <p>Members of the NeuroML initiative are participating in the
            <a href="http://www.incf.org/core/programs/modeling">INCF Multiscale Modelling Program</a> which is developing standards for 
            expressing large scale network models (under the name NineML) and the elements for describing networks in NeuroML v2.0 will be compatible with the standards
            developed there.</p>

        <p>The following are some elements which would extend the range of network structures which could be expressed in NeuroML version 2.0, and which could
            be useful input into the specification of the NineML User Layer. They are based on initial discussions between Robert Cannon, Padraig Gleeson and 
            Hans Ekkehard Plesser at CNS09 in Berlin, and further developed by Robert and Padraig after the meeting. </p>
        
        <p>A basic <a href="#JavaAPI">Java API</a> has also been developed which can generate XML examples in this format.</p>

        <br>
        <br>
        <h3>Elements in network descriptions</h3>
        <p>The proposed network elements here follow the conventions being used in the development of NeuroML version 2.0 (e.g. using the attribute <b>id</b> for identifying each
        element and the element name for referencing; using camelCaseNaming for elements and attributes) which in turn are based on SBML conventions. The NineML examples are based
        on the latest proposed NineML User Layer document.</p>


        <h3>&nbsp;&nbsp;&nbsp;&lt;population></h3>
        <p>A <b>population</b> consists of a homogeneous collection of cells or sub-networks etc. It is always contained within a <b>network</b>.
            This element indicates that a single unit should be instantiated one or more times. A <b>population</b> contains:</p>
        <ul>
            <li>An <b>id</b> attribute that is unique within this <b>network</b>.</li>
            <li>An attribute to reference to the unit to be repeated which is either a <b>cell</b> definition, or a <b>network</b>. The <b>cell</b> could potentially be defined in
            NeuroML version 2.0 in the same file, or be linked to an external definition (e.g. in the NineML Abstraction Layer, or an abstract cell model in SBML).
            If the unit is a <b>network</b>, this would normally be defined in the same file.
            Note that all cell positions, connections, etc. defined in the <b>network</b> are repeated for each unit instance of the <b>population</b>.
            If the <b>network</b> unit contains stochastic elements (e.g. randomly placed cells, random connections) it is assumed that a different 
            instance of the network is generated for each <b>population</b> unit.</li>
            
            <li>A <b>layout</b> subelement which specifies how the population should be laid out on some <b>space</b>.</li>
        </ul>


        <h3>&nbsp;&nbsp;&nbsp;&lt;space></h3>

        <p>This refers to the medium/space in which elements can be placed. Examples include 1D to 3D grids, and 1D to 3D Euclidean space.
        For now, the following spaces are assumed to be predefined: <i>Euclidean_1D</i>, <i>Euclidean_2D</i>, <i>Euclidean_3D</i>, <i>Grid_1D</i>, <i>Grid_2D</i>, <i>Grid_3D</i>.
        The <b>space</b> element could potentially include some extra information giving <b>structure</b> to the space, e.g. how the grid is laid out in 3D.
        </p>
        <p>Other examples of <b>space</b>s which may need to be added in future include 2D manifolds in 3D space.</p>

        <h3>&nbsp;&nbsp;&nbsp;&lt;region></h3>

        <p>A subset of a <b>space</b> into which to place cells, e.g. rectangular box defining a region in 3D space.</p>

        <h3>&nbsp;&nbsp;&nbsp;&lt;layout></h3>

        <p>How population elements should be laid out on (a <b>region</b> of) its <b>space</b>. Examples include: a grid based layout
            (which specifies the size of the grid in x, y, z dimensions); random layout of a number of cells in a 3D <b>region</b>.</p>



        <h3>&nbsp;&nbsp;&nbsp;&lt;network></h3>

        <p>A network is a unit which contains a number of cells in populations, sub- and supersets of those cells and synaptic connections
            between the cells. A <b>network</b> element contains:</p>
            <ul>
                <li>A unique attribute <b>id</b>.</li>
                <li>A set of <b>space</b> definitions relevant for the populations in that network.</li>
                <li>A set of <b>regions</b> associated with the <b>space</b>s.</li>
                <li>A number of <b>population</b> elements to create the cells of the network (or to create instances of subnetworks of 
                    cells & connections).</li>
                <li>A number of <b>cellSet</b> elements to define convenient sets of cells (within or across <b>population</b>s) for making
                    <b>connection</b>s, applying <b>input</b>s, recording variables, etc.</li>
                <li>A number of <b>connection</b> elements, for the synaptic connections between <b>population</b>s or <b>cellSet</b>s.</li>
                <li>A number of <b>input</b> elements for applying electrical or synaptic stimulation to the <b>population</b>s or <b>cellSet</b>s.</li>
            </ul>


        <h3>&nbsp;&nbsp;&nbsp;&lt;cellSet></h3>

        <p>A convenient way to build sets of cells from existing <b>population</b>s (this element does not create any new cells!) which can be used, e.g. as
            the source or target of <b>connection</b>s, a target for <b>input</b>s, etc. It is envisioned that a type of 
            <a href="http://www.w3schools.com/xpath/xpath_syntax.asp">XPath</a> can be used to select across
        <b>population</b>s (e.g. <b>select="NetworkA/PopulationB[0-10] | NetworkA/PopulationC[*]</b>) but this needs further work.</p>
        <p>The name <b>cellSet</b> is used as opposed
        to <b>set</b> since <b>&lt;cellSet id="mySet" select="NetworkA"></b> should refer to all cells as opposed to all cells & connections, etc.</p>
        <p>Examples shown below and the <a href="#JavaAPI">Java API</a> do not include this element yet.</p>

        <h3>&nbsp;&nbsp;&nbsp;&lt;connection></h3>

        <p>A set of synaptic connections between a source <b>population</b> or <b>cellSet</b> and a target <b>population</b> or <b>cellSet</b>.</p>
        <p>Examples shown below and the <a href="#JavaAPI">Java API</a> do not include this element yet.</p>

        <h3>&nbsp;&nbsp;&nbsp;&lt;input></h3>

        <p>Used for applying electrical or synaptic stimulation to a specified <b>population</b> or <b>cellSet</b>.</p>
        <p>Examples shown below and the <a href="#JavaAPI">Java API</a> do not include this element yet.</p>

        <br>

        <h3>Relation to NineML</h3>
        <p>The scope of the elements described is close to that of the NineML User Layer. This language allows definitions of <b>group</b>s
            of <b>component</b>s (which could themselves be <b>group</b>s or cells/spiking nodes defined in the NineML Abstraction Layer) which can be linked by
            <b>connection</b>s. This generic structure should allow a wider range of models beyond neural networks to be defined in the language,
            NeuroML v2.0 will focus on neuron models connected by synapses, and so the structure reflects those entities. There will hopefully
            be a direct mapping from network elements in NeuroML v2.0 to the corresponding elements in NineML, as illustrated in the example files below.</p>

        <a name="JavaAPI">&nbsp;</a>
        <h3>Java API for generating networks in NeuroML v2.0/NineML</h3>
        
        
        <p>A basic API in Java for generating NeuroML v2.0 network files (and NineML User Layer files) based on the above elements is available from the NeuroML
            SourceForge <a href="http://subversion.tigris.org/">Subversion</a> repository. To check this out use:</p>

        <p align="center"><b>svn co https://neuroml.svn.sourceforge.net/svnroot/neuroml/DemoVer2.0/NMLVer2_Test .</b></p>

        <p>Some "handmade" NeuroML v2.0 network description files are available in the
            <a href="http://neuroml.svn.sourceforge.net/viewvc/neuroml/DemoVer2.0/NMLVer2_Test/web/NeuroMLFiles/">web/NeuroMLFiles</a>
            directory. Included there are some other NeuroML version 2
            example files for cells, ion channels etc. See <a href="../neuroml2.php">here</a> for more details.</p>

        <p>The main Java classes for creating networks are in the
            <a href="http://neuroml.svn.sourceforge.net/viewvc/neuroml/DemoVer2.0/NMLVer2_Test/src/java/org/neuroml/network/">src/java/org/neuroml/network/</a>
            folder.</p>

        <p>Once checked out, these files can be compiled using <b>./make.sh</b> (Linux/Mac) or <b>make.bat</b> (Win). </p>

        <p>To execute a basic
            <a href="http://neuroml.svn.sourceforge.net/viewvc/neuroml/DemoVer2.0/NMLVer2_Test/src/java/org/neuroml/network/Demo.java?view=markup">demo</a>
            which generates a number of NeuroML v2.0/NetworkML v1.0 and NineML files, type: <b>./run.sh -test</b> (Linux/Mac) or <b>run.bat -test</b> (Win).
        This demo also checks the validity of these generated files as well as the "handmade" example files against the
        <a href="http://neuroml.org/NeuroMLValidator/Latest.jsp?spec=NetworkML">NetworkML v1.x Schema</a>, a prototype
        <a href="http://neuroml.svn.sourceforge.net/viewvc/neuroml/DemoVer2.0/lems/Schemas/NeuroML2/NeuroML_v2alpha.xsd?view=markup">NeuroML v2.0 Schema</a>
        and a very simple <a href="http://neuroml.svn.sourceforge.net/viewvc/neuroml/DemoVer2.0/lems/Schemas/NineML/NineML_v0.1.xsd?view=markup">NineML v0.1 Schema</a>.
        </p>

        <br>
        <h3>Example of hierarchical network in NeuroML version 2.0</h3>

            <p>This is one of the examples of the files in NeuroML v2.0 format generated by the Java API. It can be downloaded
                <a href="http://neuroml.svn.sourceforge.net/viewvc/neuroml/DemoVer2.0/NMLVer2_Test/examples/HyperColumnNet_pre_gen_v2.xml?view=markup">here</a>.</p>

        <table border =0 bgcolor="#F3F3F3" width ="70%" cellpadding=5 style="font-family: system">
            <tr><td><p><%
    XMLFile fileToView1 = new XMLFile();
    fileToView1.setXMLURL("http://neuroml.svn.sourceforge.net/viewvc/neuroml/DemoVer2.0/NMLVer2_Test/examples/HyperColumnNet_pre_gen_v2.xml");
    out.println(fileToView1.toHTMLString(false, true));
                    %></p>
                </td>
            </tr>
        </table>

        <br>
        <h3>Example of hierarchical network in NineML</h3>

            <p>This is one of the examples of the files in NineML format generated by the Java API. It can be downloaded
                <a href="http://neuroml.svn.sourceforge.net/viewvc/neuroml/DemoVer2.0/NMLVer2_Test/examples/HyperColumnNet_pre_gen.9ml?view=markup">here</a>.</p>

        <table border =0 bgcolor="#F3F3F3" width ="70%" cellpadding=5 style="font-family: system">
            <tr><td><p><%
    XMLFile fileToView2 = new XMLFile();
    fileToView2.setXMLURL("http://neuroml.svn.sourceforge.net/viewvc/neuroml/DemoVer2.0/NMLVer2_Test/examples/HyperColumnNet_pre_gen.9ml");
    out.println(fileToView2.toHTMLString(false, true));
                    %></p>
                </td>
            </tr>
        </table>

        <br>
        <h3>Generating the network</h3>

        <p>Once a network description is generated with this API, the instances of the network can be generate by calling <b>generate(seed)</b>
            on the <a href="http://neuroml.svn.sourceforge.net/viewvc/neuroml/DemoVer2.0/NMLVer2_Test/src/java/org/neuroml/network/Network.java?view=markup">Network</a> class. Using a different <b>seed</b> will produce a different network for stochastic layouts (e.g. randomly placed in a 3D region).</p>

        <p>The generated network can be saved in a provisional
            <a href="http://neuroml.svn.sourceforge.net/viewvc/neuroml/DemoVer2.0/NMLVer2_Test/examples/HyperColumnNet_gen_v1.xml?view=markup">NeuroML v2.0 instance based network file</a>
            or as a valid <a href="http://neuroml.svn.sourceforge.net/viewvc/neuroml/DemoVer2.0/NMLVer2_Test/examples/HyperColumnNet_gen_v2.xml?view=markup">NeuroML v1.x instance based file</a>.



        <p>The generated NetworkML v1.x representation of the network can be visualised in compatible applications, e.g.
            <a href="http://www.neuroConstruct.org">neuroConstruct</a> as in the <a href="#nCnet">figure above</a>,
            or the <a href="http://www.neuroml.org/X3D_tools.php">X3D visualisation tool</a> on the NeuroML website. A screenshot of the generated X3D file
        viewed in the OctagaPlayer is shown below:</p>

        <br>
        <p align="center">
            <a name="X3D" href="images/octaga.png">
                <img alt="Hierarchical network in X3D" src="images/octaga.png" align="middle" width="500"/>
            </a>
        </p>


        <br>
        <br>

        
        <%@ include file="footer.jsp" %>

    </body>
</html>