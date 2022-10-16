package MusicInfos;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class SingerInfoQQ
{
    public String mid;
    public String name;
}
