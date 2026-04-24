<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="org.json.*" %>
<%@ page import="org.apache.commons.io.IOUtils" %>
<%@ page import="edu.cornell.mannlib.vitro.webapp.controller.VitroRequest" %>
<%@ page import="edu.cornell.mannlib.vitro.webapp.rdfservice.RDFService" %>

<%!
    // Ejecuta SPARQL en formato XML
    String runQuery(RDFService rdf, String query) {
        try {
            InputStream in = rdf.sparqlSelectQuery(query, RDFService.ResultFormat.XML);
            return IOUtils.toString(in, "UTF-8");
        } catch (Exception e) {
            return "<error>" + e.getMessage() + "</error>";
        }
    }

    // Extrae binding dentro del XML convertido a JSON
    String getXMLBinding(JSONObject result, String var) {
        try {
            Object bindingsObj = result.get("binding");
            JSONArray arr;
            if (bindingsObj instanceof JSONObject) {
                arr = new JSONArray();
                arr.put((JSONObject) bindingsObj);
            } else {
                arr = (JSONArray) bindingsObj;
            }
            for (int i = 0; i < arr.length(); i++) {
                JSONObject b = arr.getJSONObject(i);
                if (b.getString("name").equals(var)) {
                    if (b.has("literal") && b.get("literal") instanceof String) return b.getString("literal");
                    if (b.has("literal") && b.get("literal") instanceof JSONObject) return b.getJSONObject("literal").optString("content", "");
                    if (b.has("uri")) return b.getString("uri");
                }
            }
        } catch (Exception e) {
            return "";
        }
        return "";
    }

    JSONArray buildNodesArray(String xml) throws Exception {
        JSONObject jo = XML.toJSONObject(xml);
        JSONArray bindings = jo.getJSONObject("sparql").getJSONObject("results").optJSONArray("result");
        JSONArray arr = new JSONArray();
        if (bindings != null) {
            for (int i = 0; i < bindings.length(); i++) {
                JSONObject b = bindings.getJSONObject(i);
                JSONObject node = new JSONObject();
                int pubsVal = 0, grantsVal = 0;
                try { pubsVal = Integer.parseInt(getXMLBinding(b, "pubs")); } catch(Exception e) {}
                try { grantsVal = Integer.parseInt(getXMLBinding(b, "grants")); } catch(Exception e) {}
                
                node.put("pubs", pubsVal);
                node.put("grants", grantsVal);
                node.put("name",  getXMLBinding(b, "name"));
                node.put("id",    getXMLBinding(b, "id"));
                node.put("label", getXMLBinding(b, "name"));
                node.put("group", getXMLBinding(b, "groupLabel"));
                arr.put(node);
            }
        }
        return arr;
    }

    JSONArray buildEdgesArray(String xmlEdges, boolean isGrant) throws Exception {
        JSONObject joEdges = XML.toJSONObject(xmlEdges);
        JSONArray bindingsEdges = joEdges.getJSONObject("sparql").getJSONObject("results").optJSONArray("result");
        JSONArray edgesAll = new JSONArray();
        if (bindingsEdges != null) {
            for (int i = 0; i < bindingsEdges.length(); i++) {
                JSONObject b = bindingsEdges.getJSONObject(i);
                String sID = getXMLBinding(b, "sID");
                String tID = getXMLBinding(b, "tID");
                
                // Ignorar filas dudosas
                if(sID == null || sID.isEmpty() || tID == null || tID.isEmpty()) continue;
                
                JSONObject edge = new JSONObject();
                int jointVal = 0;
                if (isGrant) {
                    try { jointVal = Integer.parseInt(getXMLBinding(b, "jointGrants")); } catch(Exception e) {}
                    edge.put("jointGrants", jointVal);
                } else {
                    try { jointVal = Integer.parseInt(getXMLBinding(b, "jointPubs")); } catch(Exception e) {}
                    edge.put("jointPubs", jointVal);
                }
                edge.put("id", sID + ":" + tID);
                edge.put("source", sID);
                edge.put("target", tID);
                edgesAll.put(edge);
            }
        }
        return edgesAll;
    }
%>

<%
    VitroRequest vreq = new VitroRequest(request);
    RDFService rdf = vreq.getRDFService();
    JSONObject finalJson = new JSONObject();

    // vivo:Grant excluido de biboClasses
    String biboClasses = "bibo:AcademicArticle bibo:Book bibo:Chapter fabio:Comment vivo:EditorialArticle vivo:WorkingPaper vivo:Abstract vivo:ConferencePaper vivo:ConferencePoster bibo:Letter bibo:Report vivo:Review obo:ERO_0000071 vivo:Speech bibo:Thesis vivo:Video";

    // 1. EDGES INTERNAL PUBS
    String qEdgesInternalPubs =
        "PREFIX vivo: <http://vivoweb.org/ontology/core#>\n" +
        "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n" +
        "PREFIX vlocal: <http://research-hub.urosario.edu.co/ontology/vlocal#>\n" +
        "PREFIX bibo: <http://purl.org/ontology/bibo/>\n" +
        "PREFIX fabio: <http://purl.org/spar/fabio/>\n" +
        "PREFIX obo: <http://purl.obolibrary.org/obo/>\n" +
        "SELECT ?sID ?tID (COUNT(DISTINCT ?doc) AS ?jointPubs)\n" +
        "WHERE {\n" +
        "  VALUES ?publi { " + biboClasses + " }\n" +
        "  ?p1 a vlocal:UREntity; vivo:relatedBy ?NA.\n" +
        "  ?NA a vivo:Authorship; vivo:relates ?doc.\n" +
        "  ?doc a ?publi; vivo:relatedBy ?NA1.\n" +
        "  ?NA1 a vivo:Authorship; vivo:relates ?p2.\n" +
        "  ?p2 a vlocal:UREntity.\n" +
        "  FILTER(?p1 != ?p2)\n" +
        "  BIND(REPLACE(STR(?p1), '.*/([^/]+)$', '$1') AS ?sIID)\n" +
        "  BIND(REPLACE(STR(?p2), '.*/([^/]+)$', '$1') AS ?tIID)\n" +
        "  FILTER(STR(?sIID) < STR(?tIID))\n" +
        "  BIND(STR(?sIID) AS ?sID)\n" +
        "  BIND(STR(?tIID) AS ?tID)\n" +
        "} GROUP BY ?sID ?tID";
    finalJson.put("edgesInternalPubs", buildEdgesArray(runQuery(rdf, qEdgesInternalPubs), false));

    // 2. EDGES ALL PUBS
    String qEdgesAllPubs =
        "PREFIX vivo: <http://vivoweb.org/ontology/core#>\n" +
        "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n" +
        "PREFIX vlocal: <http://research-hub.urosario.edu.co/ontology/vlocal#>\n" +
        "PREFIX bibo: <http://purl.org/ontology/bibo/>\n" +
        "PREFIX fabio: <http://purl.org/spar/fabio/>\n" +
        "PREFIX obo: <http://purl.obolibrary.org/obo/>\n" +
        "SELECT ?sID ?tID (COUNT(DISTINCT ?doc) AS ?jointPubs)\n" +
        "WHERE {\n" +
        "  VALUES ?publi { " + biboClasses + " }\n" +
        "  ?p1 a vlocal:UREntity; vivo:relatedBy ?NA.\n" +
        "  ?NA a vivo:Authorship; vivo:relates ?doc.\n" +
        "  ?doc a ?publi; vivo:relatedBy ?NA1.\n" +
        "  ?NA1 a vivo:Authorship; vivo:relates ?p2.\n" +
        "  VALUES ?person { vlocal:UREntity <http://xmlns.com/foaf/0.1/Person> }\n" +
        "  ?p2 a ?person.\n" +
        "  FILTER(?p1 != ?p2)\n" +
        "  BIND(REPLACE(STR(?p1), '.*/([^/]+)$', '$1') AS ?sIID)\n" +
        "  BIND(REPLACE(STR(?p2), '.*/([^/]+)$', '$1') AS ?tIID)\n" +
        "  BIND(STR(?sIID) AS ?sID)\n" +
        "  BIND(STR(?tIID) AS ?tID)\n" +
        "} GROUP BY ?sID ?tID";
    finalJson.put("edgesAllPubs", buildEdgesArray(runQuery(rdf, qEdgesAllPubs), false));

    // 3. EDGES INTERNAL GRANTS
    String qEdgesInternalGrants =
        "PREFIX vivo: <http://vivoweb.org/ontology/core#>\n" +
        "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n" +
        "PREFIX vlocal: <http://research-hub.urosario.edu.co/ontology/vlocal#>\n" +
        "SELECT ?sID ?tID (COUNT(DISTINCT ?grant) AS ?jointGrants)\n" +
        "WHERE {\n" +
        "  ?p1 a vlocal:UREntity; vivo:relatedBy ?role1.\n" +
        "  ?role1 vivo:relates ?grant.\n" +
        "  ?grant a vivo:Grant; vivo:relatedBy ?role2.\n" +
        "  ?role2 vivo:relates ?p2.\n" +
        "  ?p2 a vlocal:UREntity.\n" +
        "  FILTER(?p1 != ?p2)\n" +
        "  BIND(REPLACE(STR(?p1), '.*/([^/]+)$', '$1') AS ?sIID)\n" +
        "  BIND(REPLACE(STR(?p2), '.*/([^/]+)$', '$1') AS ?tIID)\n" +
        "  FILTER(STR(?sIID) < STR(?tIID))\n" +
        "  BIND(STR(?sIID) AS ?sID)\n" +
        "  BIND(STR(?tIID) AS ?tID)\n" +
        "} GROUP BY ?sID ?tID";
    finalJson.put("edgesInternalGrants", buildEdgesArray(runQuery(rdf, qEdgesInternalGrants), true));

    // 4. EDGES ALL GRANTS
    String qEdgesAllGrants =
        "PREFIX vivo: <http://vivoweb.org/ontology/core#>\n" +
        "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n" +
        "PREFIX vlocal: <http://research-hub.urosario.edu.co/ontology/vlocal#>\n" +
        "SELECT ?sID ?tID (COUNT(DISTINCT ?grant) AS ?jointGrants)\n" +
        "WHERE {\n" +
        "  ?p1 a vlocal:UREntity; vivo:relatedBy ?role1.\n" +
        "  ?role1 vivo:relates ?grant.\n" +
        "  ?grant a vivo:Grant; vivo:relatedBy ?role2.\n" +
        "  ?role2 vivo:relates ?p2.\n" +
        "  VALUES ?person { vlocal:UREntity <http://xmlns.com/foaf/0.1/Person> }\n" +
        "  ?p2 a ?person.\n" +
        "  FILTER(?p1 != ?p2)\n" +
        "  BIND(REPLACE(STR(?p1), '.*/([^/]+)$', '$1') AS ?sIID)\n" +
        "  BIND(REPLACE(STR(?p2), '.*/([^/]+)$', '$1') AS ?tIID)\n" +
        "  BIND(STR(?sIID) AS ?sID)\n" +
        "  BIND(STR(?tIID) AS ?tID)\n" +
        "} GROUP BY ?sID ?tID";
    finalJson.put("edgesAllGrants", buildEdgesArray(runQuery(rdf, qEdgesAllGrants), true));


    // 5. NODES INTERNAL
    // Se utilizan sub-queries tal como VIVO las requiere para evitar productos cartesianos (explosión de memoria)
    String qNodesInternal =
        "PREFIX vivo: <http://vivoweb.org/ontology/core#>\n" +
        "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n" +
        "PREFIX vlocal: <http://research-hub.urosario.edu.co/ontology/vlocal#>\n" +
        "PREFIX bibo: <http://purl.org/ontology/bibo/>\n" +
        "PREFIX fabio: <http://purl.org/spar/fabio/>\n" +
        "PREFIX obo: <http://purl.obolibrary.org/obo/>\n" +
        "SELECT DISTINCT ?id ?name ?groupLabel ?pubs ?grants \n" +
        "WHERE {\n" +
        " { SELECT DISTINCT ?id ?p2 (MAX(?Oname) AS ?name) WHERE {\n" +
        "     ?p2 a vlocal:UREntity.\n" +
        "     OPTIONAL { ?p2 rdfs:label ?Oname. }\n" +
        "     BIND(REPLACE(STR(?p2), '.*/([^/]+)$', '$1') AS ?id).\n" +
        "   } GROUP BY ?id ?p2\n" +
        " }\n" +
        " { SELECT DISTINCT ?p2 (COUNT(DISTINCT ?pub) AS ?pubs) WHERE {\n" +
        "     ?p2 a vlocal:UREntity.\n" +
        "     OPTIONAL {\n" +
        "       VALUES ?publi { " + biboClasses + " }\n" +
        "       ?p2 vivo:relatedBy ?NA.\n" +
        "       ?NA a vivo:Authorship; vivo:relates ?pub.\n" +
        "       ?pub a ?publi.\n" +
        "     }\n" +
        "   } GROUP BY ?p2\n" +
        " }\n" +
        " { SELECT DISTINCT ?p2 (COUNT(DISTINCT ?grant) AS ?grants) WHERE {\n" +
        "     ?p2 a vlocal:UREntity.\n" +
        "     OPTIONAL {\n" +
        "       ?p2 vivo:relatedBy ?role.\n" +
        "       ?role vivo:relates ?grant.\n" +
        "       ?grant a vivo:Grant.\n" +
        "     }\n" +
        "   } GROUP BY ?p2\n" +
        " }\n" +
        " { SELECT DISTINCT ?p2 (COALESCE(MAX(?unidad), 'external') AS ?groupLabel) WHERE {\n" +
        "     ?p2 a vlocal:UREntity.\n" +
        "     OPTIONAL {\n" +
        "       VALUES ?position {vivo:FacultyAdministrativePosition vivo:FacultyPosition vivo:NonFacultyAcademicPosition}\n" +
        "       VALUES ?facultad {vivo:Division vivo:AcademicDepartment vivo:Library}\n" +
        "       ?p2 vivo:relatedBy ?NA1. ?NA1 a ?position; vivo:relates ?unidAcad.\n" +
        "       ?unidAcad a ?facultad ; rdfs:label ?unidad.\n" +
        "     }\n" +
        "   } GROUP BY ?p2\n" +
        " }\n" +
        "}";
    JSONArray nodesInternal = buildNodesArray(runQuery(rdf, qNodesInternal));
    finalJson.put("nodesInternal", nodesInternal);

    // 6. NODES ALL
    String qNodesExternal =
        "PREFIX vivo: <http://vivoweb.org/ontology/core#>\n" +
        "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n" +
        "PREFIX vlocal: <http://research-hub.urosario.edu.co/ontology/vlocal#>\n" +
        "PREFIX bibo: <http://purl.org/ontology/bibo/>\n" +
        "PREFIX fabio: <http://purl.org/spar/fabio/>\n" +
        "PREFIX obo: <http://purl.obolibrary.org/obo/>\n" +
        "SELECT DISTINCT ?id ?name ?groupLabel ?pubs ?grants \n" +
        "WHERE {\n" +
        " { SELECT DISTINCT ?id ?p2 (MAX(?Oname) AS ?name) WHERE {\n" +
        "     ?p2 a <http://xmlns.com/foaf/0.1/Person>.\n" +
        "     FILTER NOT EXISTS { ?p2 a vlocal:UREntity }\n" +
        "     OPTIONAL { ?p2 rdfs:label ?Oname. }\n" +
        "     BIND(REPLACE(STR(?p2), '.*/([^/]+)$', '$1') AS ?id).\n" +
        "   } GROUP BY ?id ?p2\n" +
        " }\n" +
        " { SELECT DISTINCT ?p2 (COUNT(DISTINCT ?pub) AS ?pubs) WHERE {\n" +
        "     ?p2 a <http://xmlns.com/foaf/0.1/Person>.\n" +
        "     FILTER NOT EXISTS { ?p2 a vlocal:UREntity }\n" +
        "     OPTIONAL {\n" +
        "       VALUES ?publi { " + biboClasses + " }\n" +
        "       ?p2 vivo:relatedBy ?NA.\n" +
        "       ?NA a vivo:Authorship; vivo:relates ?pub.\n" +
        "       ?pub a ?publi.\n" +
        "     }\n" +
        "   } GROUP BY ?p2\n" +
        " }\n" +
        " { SELECT DISTINCT ?p2 (COUNT(DISTINCT ?grant) AS ?grants) WHERE {\n" +
        "     ?p2 a <http://xmlns.com/foaf/0.1/Person>.\n" +
        "     FILTER NOT EXISTS { ?p2 a vlocal:UREntity }\n" +
        "     OPTIONAL {\n" +
        "       ?p2 vivo:relatedBy ?role.\n" +
        "       ?role vivo:relates ?grant.\n" +
        "       ?grant a vivo:Grant.\n" +
        "     }\n" +
        "   } GROUP BY ?p2\n" +
        " }\n" +
        " { SELECT DISTINCT ?p2 (COALESCE(MAX(?unidad), 'external') AS ?groupLabel) WHERE {\n" +
        "     ?p2 a <http://xmlns.com/foaf/0.1/Person>.\n" +
        "     FILTER NOT EXISTS { ?p2 a vlocal:UREntity }\n" +
        "     OPTIONAL {\n" +
        "       VALUES ?position {vivo:FacultyAdministrativePosition vivo:FacultyPosition vivo:NonFacultyAcademicPosition}\n" +
        "       VALUES ?facultad {vivo:Division vivo:AcademicDepartment}\n" +
        "       ?p2 vivo:relatedBy ?NA1. ?NA1 a ?position; vivo:relates ?unidAcad.\n" +
        "       ?unidAcad a ?facultad ; rdfs:label ?unidad.\n" +
        "     }\n" +
        "   } GROUP BY ?p2\n" +
        " }\n" +
        "}";
    JSONArray nodesExternal = buildNodesArray(runQuery(rdf, qNodesExternal));
    JSONArray nodesAll = new JSONArray();
    for (int i = 0; i < nodesInternal.length(); i++) nodesAll.put(nodesInternal.getJSONObject(i));
    for (int i = 0; i < nodesExternal.length(); i++) nodesAll.put(nodesExternal.getJSONObject(i));
    finalJson.put("nodesAll", nodesAll);

    // Salida Final
    out.print(finalJson.toString(2));
%>