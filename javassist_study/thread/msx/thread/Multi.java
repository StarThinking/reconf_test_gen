package msx.thread;

import java.util.List;
import java.util.ArrayList;

class Multi extends Thread {  
    public void run() {  
        System.out.println("Child Thread is running...");  
        System.out.println("Child Current Thread ID is " + Thread.currentThread().getId() + 
            " Name is " + Thread.currentThread().getName());
    } 

    public static void main(String args[]) throws Exception {  
        System.out.println("Parent Current Thread ID is " + Thread.currentThread().getId() + 
            " Name is " + Thread.currentThread().getName());
        Multi t1 = new Multi(); 
        t1.setName("Child Thread");
        System.out.println("Thread Relation: " + Thread.currentThread().getId() + " -> " + t1.getId());
        t1.start();

        List<String> createRelationList = Thread.getCreateRelationList();
        for (String relation : createRelationList) {
            System.out.println("relation: " + relation);
        }
    }  
}  
