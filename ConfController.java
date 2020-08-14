package org.apache.hadoop.conf;

import java.io.*;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.Set;
import java.util.HashSet;
import java.util.HashMap;
import org.apache.hadoop.conf.Configuration;

public class ConfController {
    private static final String reconf_systemRootDir = "/root/parameter_test_controller/shared/";

    private static String reconf_vvmode = "";
    private static String reconf_parameter = "";
    public static String getReconfParameter() {
        return ConfController.reconf_parameter;
    }
    private static List<String> reconf_component_list = new ArrayList<String>();
    private static String reconf_component = "";
    private static String reconf_v1 = "";
    private static String reconf_v2 = "";
    private static String reconf_point = "";
    private static int reconf_point_int = 0; 
    
    private static int reconf_init_point_index = 0;

    // load just once
    static {
	loadSharedVariables();
    }

    private static void loadSharedVariables() {
        try {
            BufferedReader reader;
            reader = new BufferedReader(new FileReader(new File(reconf_systemRootDir + "reconf_vvmode")));
            reconf_vvmode = reader.readLine();
            reader.close();

            reader = new BufferedReader(new FileReader(new File(reconf_systemRootDir + "reconf_parameter")));
            reconf_parameter = reader.readLine();
            reader.close();

            reader = new BufferedReader(new FileReader(new File(reconf_systemRootDir + "reconf_component")));
            reconf_component = reader.readLine();
            final String SEPERATOR = "%";
            String[] contents = reconf_component.toString().trim().split(SEPERATOR);
            for (String c : contents) {
                myPrint("add component " + c + " into reconf_component_list");
                reconf_component_list.add(c);
            }
            reader.close();

            reader = new BufferedReader(new FileReader(new File(reconf_systemRootDir + "reconf_v1")));
            reconf_v1 = reader.readLine();
            reader.close();

            reader = new BufferedReader(new FileReader(new File(reconf_systemRootDir + "reconf_v2")));
            reconf_v2 = reader.readLine();
            reader.close();

            reader = new BufferedReader(new FileReader(new File(reconf_systemRootDir + "reconf_point")));
            reconf_point = reader.readLine();
            reader.close();
            reconf_point_int = Integer.valueOf(reconf_point);

            if (!reconf_vvmode.equals("v1v1") && !reconf_vvmode.equals("v2v2") && !reconf_vvmode.equals("v1v2") && 
                !reconf_vvmode.equals("none")) {
                myPrint("ERROR : wrong value of reconf_vvmode " + reconf_vvmode);
                System.exit(1);
            }
      
	    myPrint("reconf_vvmode=" + reconf_vvmode + ", reconf_parameter=" + reconf_parameter + 
		", reconf_component=" + reconf_component + ", reconf_v1=" + reconf_v1 + ", reconf_v2=" + reconf_v2 +
		", reconf_point=" + reconf_point);
        } catch (Exception e) {
            myPrint("ERROR : loadSharedVariables");
            e.printStackTrace();
        }
    }

    public static class ComponentConf {
	public Object componentObj = null;
	public String group = "";
	public Set<Configuration> confSet = new HashSet<Configuration>();
        public int index = 0;

	public ComponentConf(Object o, String g, Configuration c, int i) {
	    this.componentObj = o;
	    this.group = g;
	    this.confSet.add(c);
            this.index = i;
	}

        public String componentWithIndex() {
           return this.group + "." + this.index;
        }
    }

    private static List<ComponentConf> table = new ArrayList<ComponentConf>();
    private static Map<String, Integer> componentIndexMap = new HashMap<String, Integer>();

    private static synchronized ComponentConf findEntryByComponentObj(Object o) {
        for (ComponentConf entry : table) {
	    if (o.equals(entry.componentObj)) {
	        return entry;
	    }
	}
	return null;
    }

    public static synchronized ComponentConf findEntryByConf(Configuration c) {
        for (ComponentConf entry : table) {
	    if (entry.confSet.contains(c)) {
	        return entry;
	    }
	}
	return null;
    }

    private static boolean isConfShared(Configuration c) {
	return (findEntryByConf(c) != null) ? true : false;
    }

    public static boolean enableExtend = true;

    public static synchronized void extendMyConf(Configuration originalConf, Configuration extendedConf) {
        ComponentConf entry = Configuration.findEntryByConf(originalConf);
        if (entry == null || enableExtend == false) {
            return;
        } else {
            myPrint("add extended conf " + extendedConf.hashCode() + " that extends conf " +
                originalConf.hashCode() + " into componenet " + entry.componentWithIndex() + "'s conf set");
            entry.confSet.add(extendedConf);
        }
    }

    public static synchronized Configuration registerMyComponent(Object componentObj, String componentGroup, 
        Configuration originConf) {
        try {
            if (originConf == null) {
                myPrint("INFO: originConf is null");
                return originConf;
            }

            if (componentObj == null) {
                myPrint("INFO: componentObj is null, we don't handle static function this time");
                return originConf;
            }
             
            // check if component object is registered before
            ComponentConf entryRegistered = findEntryByComponentObj(componentObj);
            if (entryRegistered != null) {
                // check group
                if (!entryRegistered.group.equals(componentGroup)) {
                    myPrint("WARN: registered component " + entryRegistered.componentWithIndex() +
                        " is being registered with a different group " + componentGroup);
                    //return originConf;
                } 

                // if originConf already exists in confset, do nothing.
                if (entryRegistered.confSet.contains(originConf)) {
                    myPrint("INFO: registered component " + entryRegistered.componentWithIndex() +
          	        " is being registered with already-exisiting conf " + originConf.hashCode());
                    return originConf;
                } else { // if originConf NOT exists in confset, check if shared with other componnets objs.
                    Configuration uniqueConf = null; 
                    
                    myPrint("WARN: try to add registered component " + entryRegistered.componentWithIndex() +
          	        "'s conf set with conf " + originConf.hashCode());
                    
                    if (isConfShared(originConf)) {
                        ComponentConf shareEntry = findEntryByConf(originConf);
                        // clone configuration object
                        enableExtend = false;
                        uniqueConf = new Configuration(originConf);
                        enableExtend = true;
                        myPrint("ERROR: conf " + originConf.hashCode() + " is shared with component " +
                            shareEntry.componentWithIndex() + ", let clone and return new conf " + 
                            uniqueConf.hashCode());
                    } else {
                        uniqueConf = originConf;
                        //myPrint("originConf " + originConf.hashCode() + " is unique for registering as "
                        //    + componentGroup);
                    }
                    entryRegistered.confSet.add(uniqueConf);
                    return uniqueConf; 
                }
            } 
            
            // for unregistered new component obj
            Configuration uniqueConf = null; 
            int myIndex = 0;
            ComponentConf newComponentConf = null;
            
            if (isConfShared(originConf)) {
                ComponentConf shareEntry = findEntryByConf(originConf);
                // clone configuration object
                enableExtend = false;
                uniqueConf = new Configuration(originConf);
                enableExtend = true;
                myPrint("INFO: conf " + originConf.hashCode() + " is shared with component " +
                    shareEntry.componentWithIndex() + ", let clone and return new conf " + 
                    uniqueConf.hashCode());
            } else {
                uniqueConf = originConf;
                myPrint("originConf " + originConf.hashCode() + " is unique for registering as "
                    + componentGroup);
            }

            // increment component index map
            Integer fetchedIndex = componentIndexMap.get(componentGroup);
            if (fetchedIndex == null) {
                myIndex = 1;
            } else {
                myIndex = fetchedIndex + 1;
            }
            componentIndexMap.put(componentGroup, myIndex);
            
            // add newComponentConf entry into table
            newComponentConf = new ComponentConf(componentObj, componentGroup, uniqueConf, myIndex);
            myPrint("registerMyComponent for comoponent " + newComponentConf.componentWithIndex() + 
                " uniqueConf " + uniqueConf.hashCode() + " originConf " + originConf.hashCode());
            table.add(newComponentConf);

            return uniqueConf;
        } catch(Exception e) {
              myPrint("ERROR: bug");
              System.exit(1);
        }

        // should not reach here
        myPrint("ERROR: should not reach here in registerMyComponent");
        return null;
    }

    public static String whichV(Configuration conf, String para, String v) {
        if (reconf_vvmode.equals("none")) {
            return v;
        }

        // parameter does not match, return v
        if (!para.equals(reconf_parameter)) 
            return v;

        // decide value for reconf_parameter with mode v1v1/v2v2/v1v2
        if (reconf_vvmode.equals("v1v1"))
            return reconf_v1;
        
        if (reconf_vvmode.equals("v2v2"))
            return reconf_v2;

        if (reconf_vvmode.equals("v1v2")) {
            // check which component entry this conf belongs to
            ComponentConf entry = findEntryByConf(conf);
            if (entry == null) {
                //myPrint("WARN: this conf is not used by any registered components");
                return v;
            }

            // component group does not match, set with v1
            if (!reconf_component_list.contains(entry.group))
                return reconf_v1;

            // assign v1 or v2 inside focused component group
            if (reconf_point_int == -1) { // set odd components with v2
                if ((entry.index % 2) == 1) {
                    myPrint("return v2 for " + entry.componentWithIndex());
                    return reconf_v2;
                } else {
                    return reconf_v1;
                }
            } else if (reconf_point_int == -2) { // set even components with v2
                if ((entry.index % 2) == 0) {
                    myPrint("return v2 for " + entry.componentWithIndex());
                    return reconf_v2;
                } else {
                    return reconf_v1;
                }
            } else if (reconf_point_int == -3) { // set v2 for all components in this group
                myPrint("return v2 for " + entry.componentWithIndex());
                return reconf_v2;
            } else { // set v2 to component whose index is reconf_point_int
                if (entry.index == reconf_point_int) {
                    myPrint("return v2 for " + entry.componentWithIndex());
                    return reconf_v2;
                } else {
                    return reconf_v1;
                }
            }
        }
        
        // should not reach here
        myPrint("ERROR: should not reach here in whichV");
        return v;
    }

    public static void myPrint(String str) { System.out.println("msx-confcontroller " + str);}
}
    
/*
    public static void checkReconfAtShutdown(componentObject componentObj, String component, Configuration uniqueConf) {
	if (componentObj == null || uniqueConf == null)
	    return;
        myPrint("" + component + " stop " + componentObj.hashCode() + ", value is " + uniqueConf.get(reconf_parameter));
	Integer confToRemove = new Integer(uniqueConf.hashCode());
	String v = confComponentMap.remove(confToRemove);
	if (v == null) {
	    myPrint("WARN : conf " + confToRemove + " not existed in confInstanceList when removing.");
	}
    }*/
