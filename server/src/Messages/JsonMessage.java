package Messages;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class JsonMessage
{
    public String action;
    public String operation;  // operation need to do.
    public String target;  // target server. server:app_server,else: corresponding music_app api server.
    public String sql_or_param;  // sql sentence
}
