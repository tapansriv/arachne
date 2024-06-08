package org.arachne.profiling;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import java.io.FileReader;
import java.util.Iterator;

public class ProfileGraph {

    public ProfileNode root;
    public ProfileGraph() {}

    private ProfileNode parseJsonObject(JSONObject profile, ProfileNode parent) {
        String name = (String) profile.get("name");
        if (name.equals("QUERY")) {
            // initial case, 1 child
            JSONArray children = (JSONArray) profile.get("children");
            JSONObject childJson = (JSONObject) children.get(0);

        }

        String extraInfo = (String)profile.get("extra_info");
        ProfileNode current;
        if (extraInfo == null || extraInfo == "") {
            current = new ProfileNode(
                    (Long) profile.get("cardinality"),
                    (Double) profile.get("timing"),
                    (String) profile.get("name"),
                    parent
            );
        } else {
            current = new ProfileNode(
                    (Long) profile.get("cardinality"),
                    (Double) profile.get("timing"),
                    (String) profile.get("name"),
                    extraInfo,
                    parent
            );
        }
        JSONArray children = (JSONArray) profile.get("children");
        // System.out.println(
        //         children.size() + " " +
        //         ((Long)profile.get("cardinality")).toString() + " " +
        //         ((Double)profile.get("timing")).toString() + " " +
        //         (String)profile.get("name")
        // );

        for (int i = 0; i < children.size(); i++) {
            JSONObject childJson = (JSONObject)children.get(i);
            ProfileNode child = parseJsonObject(childJson, current);
            current.addChild(child);
        }
        System.out.println(current);
        return current;
    }

    public void parseProfile(String filename, String schemaName) {
        JSONParser parser = new JSONParser();
        try {
            String file;
            if (schemaName.equals("tpcds")) {
                file = System.getProperty("user.home") + "/arachneDB/calcite_profiles/" + filename;
                // file = System.getProperty("user.home") + "/arachneDB/calcite_profiles/sf2000/" + filename;
                // file = System.getProperty("user.home") + "/arachneDB/calcite_profiles/sf10tb/" + filename;
            } else if (schemaName.equals("ldbc")) {
                file = System.getProperty("user.home") + "/arachneDB/ldbc/profiles/" + filename;
            } else {
                throw new RuntimeException("Illegal schema name provided; should be tpcds, ldbc");
            }
            JSONObject jsonObject = (JSONObject) parser.parse(new FileReader(file));

            String name = (String)jsonObject.get("name");
            if (name.equals("Query")) {
                JSONArray children = (JSONArray)jsonObject.get("children");
                JSONObject childJson = (JSONObject) children.get(0); // initial case: 1 child
                jsonObject = childJson;
            }

            this.root = parseJsonObject(jsonObject, null);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
