$content = Get-Content 'c:\Users\cristian.atehortua\Desktop\HUB-UR\Nuevo_entorno_local\tomcat\tomcat9\webapps\ROOT\mapadeCoauthor\coauthorNetwork_backup.jsp' -Raw -Encoding UTF8

$q_int = "PREFIX vivo: <http://vivoweb.org/ontology/core#>\n"+
"PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n"+
"PREFIX vlocal: <http://research-hub.urosario.edu.co/ontology/vlocal#>\n"+
"SELECT ?id ?name (COALESCE(?grp,'Sin facultad') AS ?groupLabel) "+
"(COUNT(DISTINCT ?doc) AS ?totalDocs) (COUNT(DISTINCT ?grantDoc) AS ?grants)\n"+
"WHERE {\n"+
"  ?person a vlocal:UREntity; rdfs:label ?name .\n"+
"  {\n"+
"    ?person vivo:relatedBy ?NA.\n"+
"    ?NA a vivo:Authorship; vivo:relates ?doc.\n"+
"    FILTER(?person != ?doc)\n"+
"  } UNION {\n"+
"    VALUES ?roleType { vivo:InvestigatorRole vivo:PrincipalInvestigatorRole vivo:CoPrincipalInvestigatorRole <http://purl.obolibrary.org/obo/BFO_0000053> }\n"+
"    ?person vivo:relatedBy ?role.\n"+
"    ?role a ?roleType; vivo:relates ?grantDoc.\n"+
"    ?grantDoc a vivo:Grant.\n"+
"  }\n"+
"  OPTIONAL {\n"+
"    VALUES ?posType { vivo:FacultyAdministrativePosition vivo:FacultyPosition vivo:NonFacultyAcademicPosition }\n"+
"    VALUES ?orgType { vivo:Division vivo:AcademicDepartment vivo:Library }\n"+
"    ?person vivo:relatedBy ?posRel. ?posRel a ?posType; vivo:relates ?orgUnit.\n"+
"    ?orgUnit a ?orgType; rdfs:label ?grp.\n"+
"  }\n"+
"  BIND(REPLACE(STR(?person),'.*/([^/]+)$','$1') AS ?id)\n"+
"} GROUP BY ?id ?name ?grp"

$q_ext = "PREFIX vivo: <http://vivoweb.org/ontology/core#>\n"+
"PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n"+
"PREFIX vlocal: <http://research-hub.urosario.edu.co/ontology/vlocal#>\n"+
"PREFIX foaf: <http://xmlns.com/foaf/0.1/>\n"+
"SELECT ?id ?name ('external' AS ?groupLabel) "+
"(COUNT(DISTINCT ?doc) AS ?totalDocs) (COUNT(DISTINCT ?grantDoc) AS ?grants)\n"+
"WHERE {\n"+
"  ?person a foaf:Person; rdfs:label ?name .\n"+
"  MINUS { ?person a vlocal:UREntity }\n"+
"  {\n"+
"    ?person vivo:relatedBy ?NA.\n"+
"    ?NA a vivo:Authorship; vivo:relates ?doc.\n"+
"    FILTER(?person != ?doc)\n"+
"  } UNION {\n"+
"    VALUES ?roleType { vivo:InvestigatorRole vivo:PrincipalInvestigatorRole vivo:CoPrincipalInvestigatorRole <http://purl.obolibrary.org/obo/BFO_0000053> }\n"+
"    ?person vivo:relatedBy ?role.\n"+
"    ?role a ?roleType; vivo:relates ?grantDoc.\n"+
"    ?grantDoc a vivo:Grant.\n"+
"  }\n"+
"  BIND(REPLACE(STR(?person),'.*/([^/]+)$','$1') AS ?id)\n"+
"} GROUP BY ?id ?name"

$q_edges_int = "PREFIX vivo: <http://vivoweb.org/ontology/core#>\n"+
"PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n"+
"PREFIX vlocal: <http://research-hub.urosario.edu.co/ontology/vlocal#>\n"+
"SELECT ?sID ?tID (COUNT(DISTINCT ?doc) AS ?jointTotalDocs) (COUNT(DISTINCT ?grantDoc) AS ?jointGrants)\n"+
"WHERE {\n"+
"  {\n"+
"    ?p1 a vlocal:UREntity; vivo:relatedBy ?NA1.\n"+
"    ?p2 a vlocal:UREntity; vivo:relatedBy ?NA2.\n"+
"    ?NA1 a vivo:Authorship; vivo:relates ?doc.\n"+
"    ?doc vivo:relatedBy ?NA2.\n"+
"    FILTER(?p1 != ?p2 && ?p1 != ?doc && ?p2 != ?doc)\n"+
"    BIND(REPLACE(STR(?p1),'.*/([^/]+)$','$1') AS ?sIID)\n"+
"    BIND(REPLACE(STR(?p2),'.*/([^/]+)$','$1') AS ?tIID)\n"+
"    FILTER(STR(?sIID) < STR(?tIID))\n"+
"  } UNION {\n"+
"    VALUES ?roleType { vivo:InvestigatorRole vivo:PrincipalInvestigatorRole vivo:CoPrincipalInvestigatorRole <http://purl.obolibrary.org/obo/BFO_0000053> }\n"+
"    ?p1 a vlocal:UREntity; vivo:relatedBy ?R1.\n"+
"    ?p2 a vlocal:UREntity; vivo:relatedBy ?R2.\n"+
"    ?R1 a ?roleType; vivo:relates ?grantDoc.\n"+
"    ?grantDoc a vivo:Grant; vivo:relatedBy ?R2.\n"+
"    ?R2 a ?roleType.\n"+
"    FILTER(?p1 != ?p2 && ?p1 != ?grantDoc && ?p2 != ?grantDoc)\n"+
"    BIND(REPLACE(STR(?p1),'.*/([^/]+)$','$1') AS ?sIID)\n"+
"    BIND(REPLACE(STR(?p2),'.*/([^/]+)$','$1') AS ?tIID)\n"+
"    FILTER(STR(?sIID) < STR(?tIID))\n"+
"  }\n"+
"  BIND(STR(?sIID) AS ?sID)\n"+
"  BIND(STR(?tIID) AS ?tID)\n"+
"} GROUP BY ?sID ?tID"

$q_edges_ext = "PREFIX vivo: <http://vivoweb.org/ontology/core#>\n"+
"PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n"+
"PREFIX vlocal: <http://research-hub.urosario.edu.co/ontology/vlocal#>\n"+
"PREFIX foaf: <http://xmlns.com/foaf/0.1/>\n"+
"SELECT ?sID ?tID (COUNT(DISTINCT ?doc) AS ?jointTotalDocs) (COUNT(DISTINCT ?grantDoc) AS ?jointGrants)\n"+
"WHERE {\n"+
"  {\n"+
"    ?p1 a vlocal:UREntity; vivo:relatedBy ?NA1.\n"+
"    ?NA1 a vivo:Authorship; vivo:relates ?doc.\n"+
"    ?doc vivo:relatedBy ?NA2.\n"+
"    ?NA2 a vivo:Authorship; vivo:relates ?p2.\n"+
"    ?p2 a foaf:Person.\n"+
"    MINUS { ?p2 a vlocal:UREntity }\n"+
"    FILTER(?p1 != ?p2 && ?p1 != ?doc && ?p2 != ?doc)\n"+
"    BIND(REPLACE(STR(?p1),'.*/([^/]+)$','$1') AS ?sIID)\n"+
"    BIND(REPLACE(STR(?p2),'.*/([^/]+)$','$1') AS ?tIID)\n"+
"    FILTER(STR(?sIID) < STR(?tIID))\n"+
"  } UNION {\n"+
"    VALUES ?roleType { vivo:InvestigatorRole vivo:PrincipalInvestigatorRole vivo:CoPrincipalInvestigatorRole <http://purl.obolibrary.org/obo/BFO_0000053> }\n"+
"    ?p1 a vlocal:UREntity; vivo:relatedBy ?R1.\n"+
"    ?p2 a foaf:Person; vivo:relatedBy ?R2.\n"+
"    MINUS { ?p2 a vlocal:UREntity }\n"+
"    ?R1 a ?roleType; vivo:relates ?grantDoc.\n"+
"    ?grantDoc a vivo:Grant; vivo:relatedBy ?R2.\n"+
"    ?R2 a ?roleType.\n"+
"    FILTER(?p1 != ?p2 && ?p1 != ?grantDoc && ?p2 != ?grantDoc)\n"+
"    BIND(REPLACE(STR(?p1),'.*/([^/]+)$','$1') AS ?sIID)\n"+
"    BIND(REPLACE(STR(?p2),'.*/([^/]+)$','$1') AS ?tIID)\n"+
"    FILTER(STR(?sIID) < STR(?tIID))\n"+
"  }\n"+
"  BIND(STR(?sIID) AS ?sID)\n"+
"  BIND(STR(?tIID) AS ?tID)\n"+
"} GROUP BY ?sID ?tID"

$content = [regex]::Replace($content, 'String Q_INTERNAL =[\s\S]*?\} GROUP BY \?id \?name \?grp";', "String Q_INTERNAL = \r\n" + $q_int + ";")
$content = [regex]::Replace($content, 'String Q_EXTERNAL =[\s\S]*?\} GROUP BY \?id \?name";', "String Q_EXTERNAL = \r\n" + $q_ext + ";")
$content = [regex]::Replace($content, 'String Q_EDGES_INT =[\s\S]*?\} GROUP BY \?sID \?tID";', "String Q_EDGES_INT = \r\n" + $q_edges_int + ";")
$content = [regex]::Replace($content, 'String Q_EDGES_EXT =[\s\S]*?\} GROUP BY \?sID \?tID";', "String Q_EDGES_EXT = \r\n" + $q_edges_ext + ";")

# Also fix the Java maths. In the old logic, totalDocs was (pubs + grants), so jp = totalDocs - jointGrants.
# In the new logic, UNION ensures distinct vars. So totalDocs purely measures pubs, grants purely measures grants.
$content = $content -replace 'int pubsVal = Math.max\(0, total - gts\);', 'int pubsVal = total;'
$content = $content -replace 'int jp = Math.max\(0, total - jg\);', 'int jp = total;'

Set-Content -Path 'c:\Users\cristian.atehortua\Desktop\HUB-UR\Nuevo_entorno_local\tomcat\tomcat9\webapps\ROOT\mapadeCoauthor\coauthorNetwork.jsp' -Value $content -Encoding UTF8
