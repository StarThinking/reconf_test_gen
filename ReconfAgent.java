package org.apache.hadoop.conf;

import java.io.*;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import org.apache.hadoop.conf.Configuration;

public class ReconfAgent {
    private static final String reconf_systemRootDir = "/root/parameter_test_controller/";

    private static String reconf_vvmode = "";
    private static String reconf_parameter = "";
    public static String getReconfParameter() {
        return ReconfAgent.reconf_parameter;
    }
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
            reader = new BufferedReader(new FileReader(new File(reconf_systemRootDir + "shared/reconf_vvmode")));
            reconf_vvmode = reader.readLine();
            reader.close();

            reader = new BufferedReader(new FileReader(new File(reconf_systemRootDir + "shared/reconf_parameter")));
            reconf_parameter = reader.readLine();
            reader.close();

            reader = new BufferedReader(new FileReader(new File(reconf_systemRootDir + "shared/reconf_component")));
            reconf_component = reader.readLine();
            reader.close();

            reader = new BufferedReader(new FileReader(new File(reconf_systemRootDir + "shared/reconf_v1")));
            reconf_v1 = reader.readLine();
            reader.close();

            reader = new BufferedReader(new FileReader(new File(reconf_systemRootDir + "shared/reconf_v2")));
            reconf_v2 = reader.readLine();
            reader.close();

            reader = new BufferedReader(new FileReader(new File(reconf_systemRootDir + "shared/reconf_point")));
            reconf_point = reader.readLine();
            reader.close();
            reconf_point_int = Integer.valueOf(reconf_point);

            if (!reconf_vvmode.equals("v1v1") && !reconf_vvmode.equals("v2v2") && !reconf_vvmode.equals("v1v2") && !reconf_vvmode.equals("none")) {
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
	public String componentName = "";
	public Configuration conf = null;

	public ComponentConf(Object o, String n, Configuration c) {
	    this.componentObj = o;
	    this.componentName = n;
	    this.conf = c;
	}
    }

    private static List<ComponentConf> table = new ArrayList<ComponentConf>();

    private static ComponentConf findEntryByComponentObj(Object o) {
        for (ComponentConf entry : table) {
	    if (o.equals(entry.componentObj)) {
	        return entry;
	    }
	}
	return null;
    }

    private static boolean isComponentObjRegistered(Object o) {
	return (findEntryByComponentObj(o) != null) ? true : false;
    }
    
    private static ComponentConf findEntryByConf(Configuration c) {
        for (ComponentConf entry : table) {
	    if (c.equals(entry.conf)) {
	        return entry;
	    }
	}
	return null;
    }

    private static boolean isConfShared(Configuration c) {
	return (findEntryByConf(c) != null) ? true : false;
    }

    public synchronized static Configuration performReconf(Object componentObj, String component, Configuration originConf) {
      Configuration uniqueConf = null; 
      String componentObjHcStr = "";
    
      try {
        if (originConf == null) {
            myPrint("WARN: originConf is null");
            return originConf;
        }

        /* check if component instance is already registered */
        if (componentObj != null) {
            componentObjHcStr = Integer.toString(componentObj.hashCode());

	    if (isComponentObjRegistered(componentObj)) {
                ComponentConf entry = findEntryByComponentObj(componentObj);
                // update component name if differs
                if (!entry.componentName.equals(component)) {
                    myPrint("WARN: component " + entry.componentName + " " + componentObjHcStr + 
			" is being registered with a different name " + component);
          	    //entry.componentName = component;
                }
                
                if (entry.conf.equals(originConf)) {
                    myPrint("WARN: registering same component obj " + component + " " + componentObjHcStr +
          	      " with same conf " + originConf.hashCode());
                } else {
                    myPrint("ERROR: registering same component obj " + component + " " + componentObjHcStr +
          	      " with different conf " + originConf.hashCode());
                }
                return originConf; 
            } else {
                if (isConfShared(originConf)) {
          	    ComponentConf entry = findEntryByConf(originConf);
          	    // clone configuration object
                    uniqueConf = new Configuration(originConf);
            	    myPrint("WARN: conf " + originConf.hashCode() + " is shared with component " +
                        entry.componentName + " " + entry.componentObj.hashCode() + 
          	        ", let clone and return new conf " + uniqueConf.hashCode());

                } else {
          	    uniqueConf = originConf;
          	    myPrint("conf " + originConf.hashCode() + " itself is unique for this register for "
          	        + component + " " + componentObjHcStr);
                }
                table.add(new ComponentConf(componentObj, component, uniqueConf));
            }
        } else {
            myPrint("INFO: componentObj is null, we don't handle static function this time");
            return originConf;
        }
      
        myPrint("performReconf for comoponent " + component + " " + componentObjHcStr + " uniqueConf " + uniqueConf.hashCode() + 
	    " originConf " + originConf.hashCode());

        if (reconf_vvmode.equals("none")) {
            myPrint(component + " init, vvmode is none, do nothing");
        }

        if (reconf_vvmode.equals("v1v1")) {
            uniqueConf.set(reconf_parameter, reconf_v1);
            myPrint(component + " init " + componentObjHcStr + ", vvmode is " + reconf_vvmode + 
          		  ". Set value as v1 " + reconf_v1);// + " uniqueConf is " + uniqueConf.hashCode());
        }

        if ((reconf_vvmode.equals("v2v2"))) {
            uniqueConf.set(reconf_parameter, reconf_v2);
            myPrint(component + " init " + componentObjHcStr + ", vvmode is " + reconf_vvmode + 
          		  ". Set value as v2 " + reconf_v2);//  + " uniqueConf is " + uniqueConf.hashCode());
        }

        if (reconf_vvmode.equals("v1v2")) { // reconfiguration injection
            try {
                //synchronized(this) {
                    if (reconf_component.equals(component)) {
                        if (reconf_point_int == -1) { //FF_ODD
                            reconf_init_point_index ++;
                            if ((reconf_init_point_index % 2) == 1) {
                                uniqueConf.set(reconf_parameter, reconf_v2);
                                myPrint(component + " init " + componentObjHcStr + ", PERFORM V1V2 FF_ODD RECONF " + reconf_point +
          				      ". Set value as v2 " + reconf_v2);// + " uniqueConf is " + uniqueConf.hashCode());
                            } else {
                                uniqueConf.set(reconf_parameter, reconf_v1);
                                myPrint(component + " init " + componentObjHcStr + ", irrelevant init point " + reconf_init_point_index +
          				      ". Set value as v1 " + reconf_v1);// + " uniqueConf is " + uniqueConf.hashCode());
                            }
                        } else if (reconf_point_int == -2) { //FF_EVEN
                            reconf_init_point_index ++;
                            if ((reconf_init_point_index % 2) == 0) {
                                uniqueConf.set(reconf_parameter, reconf_v2);
                                myPrint(component + " init " + componentObjHcStr + ", PERFORM V1V2 FF_EVEN RECONF " + reconf_point +
          				      ". Set value as v2 " + reconf_v2);// + " uniqueConf is " + uniqueConf.hashCode());
                            } else {
                                uniqueConf.set(reconf_parameter, reconf_v1);
                                myPrint(component + " init " + componentObjHcStr + ", irrelevant init point " + reconf_init_point_index +
          				      ". Set value as v1 " + reconf_v1);// + " uniqueConf is " + uniqueConf.hashCode());
                            }
          	      } else {
                            reconf_init_point_index ++;
                            if (reconf_point_int == reconf_init_point_index) {
                                uniqueConf.set(reconf_parameter, reconf_v2);
                                myPrint(component + " init " + componentObjHcStr + ", PERFORM V1V2 RECONF " + reconf_point +
          				      ". Set value as v2 " + reconf_v2);// + " uniqueConf is " + uniqueConf.hashCode());
                            } else {
                                uniqueConf.set(reconf_parameter, reconf_v1);
                                myPrint(component + " init " + componentObjHcStr + ", irrelevant init point " + reconf_init_point_index +
          				      " not " + reconf_point +
          				      ". Set value as v1 " + reconf_v1);// + " uniqueConf is " + uniqueConf.hashCode());
                            }
                        }
                    } else { // for other component instances, just configure it to be v1
                        uniqueConf.set(reconf_parameter, reconf_v1);
                        myPrint(component + " init " + componentObjHcStr + ", irrelevant component." +
          			      " Set value as v1 " + reconf_v1);// + " uniqueConf is " + uniqueConf.hashCode()); 
                    }
               // }
            } catch (Exception e) {
                myPrint("ERROR happened during performReconf");
                System.exit(1);
            }
        }
      } catch(Exception e) { // big try-catch for reconf()
            myPrint("ERROR: bug");
            System.exit(1);
      }
      return uniqueConf;
    }

    private static void myPrint(String str) { System.out.println("msx-reconfagent " + str);}
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
