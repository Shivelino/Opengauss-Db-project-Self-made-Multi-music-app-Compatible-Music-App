package MusicInfos;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class GetSonglistDetailReturnQQ
{
    public int result;
    public SonglistInfoQQ data;
}
