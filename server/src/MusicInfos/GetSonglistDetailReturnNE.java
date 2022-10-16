package MusicInfos;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class GetSonglistDetailReturnNE
{
    public int code;
    public SongInfoNE[] songs;
}
