package MusicInfos;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class SongInfoQQ
{
    public String albumname;
    public String songname;
    public String songmid;
    public SingerInfoQQ[] singer;
}
