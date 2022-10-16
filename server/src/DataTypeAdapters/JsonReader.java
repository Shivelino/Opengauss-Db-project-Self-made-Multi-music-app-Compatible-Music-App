package DataTypeAdapters;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;

public class JsonReader  // Read json file
{
    public static String readJsonFile(String fileName)
    {
        String jsonStr;
        try
        {
            File jsonFile = new File(fileName);
            FileReader fileReader = new FileReader(jsonFile);
            Reader reader = new InputStreamReader(Files.newInputStream(jsonFile.toPath()), StandardCharsets.UTF_8);
            int ch;
            StringBuilder sb = new StringBuilder();
            while ((ch = reader.read()) != -1)
            {
                if (ch != 10 && ch!=13)
                    sb.append((char) ch);
            }
            fileReader.close();
            reader.close();
            jsonStr = sb.toString();
            return jsonStr;
        }
        catch (IOException e)
        {
            e.printStackTrace();
            return null;
        }
    }
}
