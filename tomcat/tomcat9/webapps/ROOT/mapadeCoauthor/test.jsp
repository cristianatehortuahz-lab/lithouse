<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*" %>
<%@ page import="org.apache.commons.io.IOUtils" %>
<%@ page import="edu.cornell.mannlib.vitro.webapp.controller.VitroRequest" %>
<%@ page import="edu.cornell.mannlib.vitro.webapp.rdfservice.RDFService" %>

<%
    VitroRequest vreq = new VitroRequest(request);
    RDFService rdf = vreq.getRDFService();

    String query = 
        "PREFIX vivo: <http://vivoweb.org/ontology/core#>\n" +
        "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n" +
        "PREFIX vlocal: <http://research-hub.urosario.edu.co/ontology/vlocal#>\n" +
        "SELECT ?p ?grant ?grantType ?grantLabel\n" +
        "WHERE {\n" +
        "  ?p a vlocal:UREntity .\n" +
        "  FILTER(regex(str(?p), \"ricardo-abello-galvis\", \"i\"))\n" +
        "  ?p vivo:relatedBy ?role .\n" +
        "  ?role vivo:relates ?grant .\n" +
        "  ?grant a ?grantType .\n" +
        "  FILTER (?grantType = vivo:Grant)\n" +
        "  OPTIONAL { ?grant rdfs:label ?grantLabel }\n" +
        "} \n" +
        "LIMIT 100";

    try {
        InputStream in = rdf.sparqlSelectQuery(query, RDFService.ResultFormat.JSON);
        out.print(IOUtils.toString(in, "UTF-8"));
    } catch (Exception e) {
        out.print("{\"error\": \"" + e.getMessage() + "\"}");
    }
%>
