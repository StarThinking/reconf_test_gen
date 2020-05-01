import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.DocumentBuilder;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.w3c.dom.Node;
import org.w3c.dom.Element;
import java.io.File;

public class ReadXMLFile {

    private static final String ELEMENT_NAME = "property";
  
    public static void getAllParameters(String xmlPath) {
        try {
    	    File xmlFile = new File(xmlPath);
    	    DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
    	    DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
    	    Document doc = dBuilder.parse(xmlFile);
    
    	    doc.getDocumentElement().normalize();
    	    //System.out.println("Root element :" + doc.getDocumentElement().getNodeName());
    
    	    NodeList nList = doc.getElementsByTagName(ELEMENT_NAME);
    	    for (int i=0; i<nList.getLength(); i++) {
    	        Node nNode = nList.item(i);
    	        if (nNode.getNodeType() == Node.ELEMENT_NODE) {
    	    	    Element eElement = (Element) nNode;
    	    	    //System.out.println("name : " + eElement.getElementsByTagName("name").item(0).getTextContent());
    	    	    //System.out.println("value : " + eElement.getElementsByTagName("value").item(0).getTextContent());
    	    	    //System.out.println("");
		    System.out.println(eElement.getElementsByTagName("name").item(0).getTextContent());
    	        }
    	    }
    	    //System.out.println("number of " + ELEMENT_NAME + " is " + nList.getLength());
        } catch (Exception e) {
    	    e.printStackTrace();
        }
    }
    
    public static void getParameterValue(String xmlPath) {
        try {
    	    File xmlFile = new File(xmlPath);
    	    DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
    	    DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
    	    Document doc = dBuilder.parse(xmlFile);
    
    	    doc.getDocumentElement().normalize();
    	    //System.out.println("Root element :" + doc.getDocumentElement().getNodeName());
    
    	    NodeList nList = doc.getElementsByTagName(ELEMENT_NAME);
    	    for (int i=0; i<nList.getLength(); i++) {
    	        Node nNode = nList.item(i);
    	        if (nNode.getNodeType() == Node.ELEMENT_NODE) {
    	    	    Element eElement = (Element) nNode;
    	    	    System.out.print(eElement.getElementsByTagName("name").item(0).getTextContent());
		    if (eElement.getElementsByTagName("value").item(0) != null) {
			System.out.print(" " + eElement.getElementsByTagName("value").item(0).getTextContent());
		    }
    	    	    System.out.println("");
    	        }
    	    }
    	    //System.out.println("number of " + ELEMENT_NAME + " is " + nList.getLength());
        } catch (Exception e) {
    	    e.printStackTrace();
        }
    }

    public static void main(String args[]) { 
	String xmlPath = args[0];
	//getAllParameters(xmlPath);
	getParameterValue(xmlPath);
    }
}
