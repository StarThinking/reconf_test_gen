import java.util.*;

public class Test {
    public static void main(String[] args) {
	Map<String, List<String>> componentClassListMap = Thread.getComponentClassListMap();
	for (String component : componentClassListMap.keySet()) {
	    System.out.println("component: " + component);
	    List<String> list = componentClassListMap.get(component);
	    for (String c : list) {
		System.out.println("class: " + c);
	    }
	    System.out.println("class num: " + list.size());
	}
    }
}
