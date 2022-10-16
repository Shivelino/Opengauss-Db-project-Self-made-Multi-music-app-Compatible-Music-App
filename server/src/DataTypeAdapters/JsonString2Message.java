package DataTypeAdapters;

import Messages.JsonMessage;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.databind.ObjectMapper;

// TEST
//class PhoneBoxBean
//{
//    public String boxName;
//    public String boxColor;
//}
//
//@JsonIgnoreProperties(ignoreUnknown = true)
//class Phone
//{
//    public String color;  // must be public, or field not found.
//    public String name;
//    public PhoneBoxBean phoneBox;
//    public int price;
//}

public class JsonString2Message
{
    static public JsonMessage translate(String client_json_str)
    {
        ObjectMapper mapper = new ObjectMapper();
        try
        {
            return mapper.readValue(client_json_str, JsonMessage.class);
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        return null;
    }

    public static void main(String[] args)
    {
//        System.out.println(System.getProperty("user.dir"));  // pwd
        String str = JsonReader.readJsonFile("./src/testJson.json");
        translate(str);
    }
}
