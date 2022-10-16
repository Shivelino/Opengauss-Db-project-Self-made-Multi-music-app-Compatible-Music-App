package MusicInfos;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class SonglistInfoQQ
{
    public String dissname; // songlist name
    public String songids;
    public SongInfoQQ[] songlist;  // song detail info
}