package MusicInfos;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class SongInfoNE
{
    public String name;
    public int id;
    public SingerInfoNE[] ar;
    public AlbuminfoNE al;
}
