<%@ page import="java.util.*, java.io.*, org.json.*, org.apache.commons.io.IOUtils" %>
<%@ page import="edu.cornell.mannlib.vitro.webapp.controller.VitroRequest" %>
<%@ page import="edu.cornell.mannlib.vitro.webapp.rdfservice.RDFService" %>
<%
    long t0 = System.currentTimeMillis();
    VitroRequest vreq = new VitroRequest(request);
    RDFService rdf = vreq.getRDFService();
    String query = "PREFIX vivo: <http://vivoweb.org/ontology/core#>\n" +
                   "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n" +
                   "PREFIX vlocal: <http://research-hub.urosario.edu.co/ontology/vlocal#>\n" +
                   "SELECT (COUNT(DISTINCT ?p2) AS ?count) WHERE {\n" +
                   "  ?p2 a <http://xmlns.com/foaf/0.1/Person>.\n" +
                   "  FILTER NOT EXISTS { ?p2 a vlocal:UREntity }\n" +
                   "  FILTER EXISTS { ?p2 vivo:relatedBy ?NA. ?NA a vivo:Authorship }\n" +
                   "}";
    try {
        InputStream in = rdf.sparqlSelectQuery(query, RDFService.ResultFormat.JSON);
        String json = IOUtils.toString(in, "UTF-8");
        long t1 = System.currentTimeMillis();
        out.print("Count: " + json + " Time: " + (t1-t0) + "ms");
    } catch (Exception e) {
        out.print("Error: " + e.getMessage());
    }
%>
