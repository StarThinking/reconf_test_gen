package msx.thread;

import java.util.List;
import java.util.Map;
import java.util.ArrayList;

class Multi extends Thread {  
    public void run() {  
        System.out.println("Child Thread is running...");  
        System.out.println("Child Current Thread ID is " + Thread.currentThread().getId() + 
            " Name is " + Thread.currentThread().getName());
    } 

    public static void main(String args[]) throws Exception {  
	Thread.setCreateContext("Parent");
        System.out.println("Parent Current Thread ID is " + Thread.currentThread().getId() + 
            " Name is " + Thread.currentThread().getName());
        Multi t1 = new Multi(); 
        t1.setName("Child Thread");
        System.out.println("Thread Relation: " + Thread.currentThread().getId() + " -> " + t1.getId());
        t1.start();
	//Thread.setCreateContext("None");

        Map<String, List<Long>> contextMap = Thread.getCreateContextMap();
        for (String key : contextMap.keySet()) {
	    System.out.println("context: " + key);
            List<Long> list = contextMap.get(key);
	    if (list != null) {
		for (Long id : list) {
		    System.out.println(id);
		}
	    }
        }
    }  
}  
