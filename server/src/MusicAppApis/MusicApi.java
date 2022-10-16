package MusicAppApis;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.nio.charset.StandardCharsets;

public class MusicApi
{
    private final String neteaseMusic_service_host = "http://127.0.0.1:3000/";
    private final String qqMusic_service1_host = "http://127.0.0.1:3200/";
    private final String qqMusic_service2_host = "http://127.0.0.1:3300/";

    public String sendGet(String host, String api, String[] params) throws Exception
    {
        StringBuilder url_builder = new StringBuilder(host + api + "?");
        for (int i = 0; i < params.length; i += 2)
            url_builder.append(params[i]).append("=").append(params[i + 1]).append("&");  // combine host,api,params
        String url = url_builder.toString();
        url = url.substring(0, url.length() - 1);  // final url request GET execute.

        StringBuilder builder = new StringBuilder();

        URL Url = new URL(url);
        URLConnection conn = Url.openConnection();
        // 设置代理
        //URLConnection conn = Url.openConnection(setProxy(proxyHost, proxyPort));
        // 如果需要设置代理账号密码则添加下面一行
        //conn.setRequestProperty("Proxy-Authorization", "Basic "+Base64.encode("account:password".getBytes()));

        //发送数据包(可以直接抓取浏览器数据包然后复制)
        conn.setRequestProperty("accept", "*/*");
        conn.setRequestProperty("Connection", "Keep-Alive");
        conn.setRequestProperty("User-Agent",
                "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.86 Safari/537.36");
        conn.setRequestProperty("cookie",
                "pgv_pvid=8778949946; fqm_pvqid=4237d437-506f-44ab-a8ac-5aa60b0c1ad1; RK=g3+dJbZVaE; ptcz=7fe08c9e8f1aa3f50f02bb1719ee65ecea52e87453bb4db88064e9ae55d9fb85; euin=ow6P7eoAoiCA7z**; tmeLoginType=2; fqm_sessionid=9bf3d1e1-2d06-4222-bbc1-4401c8821562; pgv_info=ssid=s2430974752; _qpsvr_localtk=0.19085073594735458; login_type=1; psrf_qqunionid=B2E0557FB7D3F8D3DC92022A29AA8ECF; wxrefresh_token=; uin=2144323627; qqmusic_key=Q_H_L_5TyVHyPPv_Vu7Nrv8-K_uDA56PwEtJUAuNf0ZWlSpiB7VdUyAGffzGA; wxopenid=; psrf_qqopenid=63D8A8FC4898B3AF16C8700AB01FE8A0; psrf_qqaccess_token=C1CC8B18D32D6375EA672915DFB09DD5; psrf_access_token_expiresAt=1661521314; qm_keyst=Q_H_L_5TyVHyPPv_Vu7Nrv8-K_uDA56PwEtJUAuNf0ZWlSpiB7VdUyAGffzGA; psrf_qqrefresh_token=4C5F7725CEE669CBEA2B879E59707096; wxunionid=; psrf_musickey_createtime=1653745314");
        conn.connect();
        //接收响应的数据包
        //        Map<String, List<String>> map = conn.getHeaderFields();
        //        Set<String> set = map.keySet();
        //        for (String k : set)
        //        {
        //            String v = conn.getHeaderField(k);
        //            System.out.println(k + ":" + v);
        //        }
        //返回浏览器的输出信息
        BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        String line = reader.readLine();
        line = new String(line.getBytes(), StandardCharsets.UTF_8);  //实现将字符串转成utf-8类型显示
        while (line != null)
        {
            builder.append(line);
            line = reader.readLine();
        }
        reader.close();  //释放资源
        return builder.toString();
    }

    public String sendPost(String host, String api, String[] params) throws Exception
    {
        return null;
    }

    public String getPlayUrlQQ(String[] params)
    {
        try
        {
            String[] results = sendGet(qqMusic_service1_host, "getMusicPlay", params).split("\"");
            if (results.length == 13)
                return results[9];
            else
                return null;
        }
        catch (Exception e)
        {
            return null;
        }
    }

    public String getPlayUrlNE(String[] params)
    {
        try
        {
            String[] results = sendGet(neteaseMusic_service_host, "song/url", params).split("\"");
            if (results.length == 69)
                return results[7];
            else
                return null;
        }
        catch (Exception e)
        {
            return null;
        }
    }

    public String getAccountSonglistsQQ(String[] params)  // FIXME unworked
    {
        try
        {
            return sendGet(qqMusic_service2_host, "user/songlist", params);
        }
        catch (Exception e)
        {
            return null;
        }
    }

    public String getSonglistDetailQQ(String[] params)
    {
        try
        {
            return sendGet(qqMusic_service2_host, "songlist", params);
        }
        catch (Exception e)
        {
            return null;
        }
    }

    public String getSonglistDetailNoSongsNE(String[] params)
    {
        try
        {
            return sendGet(neteaseMusic_service_host, "playlist/detail", params);
        }
        catch (Exception e)
        {
            return null;
        }
    }

    public String getSonglistDetailNE(String[] params)
    {
        try
        {
            return sendGet(neteaseMusic_service_host, "playlist/track/all", params);
        }
        catch (Exception e)
        {
            return null;
        }
    }

    public static void main(String[] args)  // must be root then can 'npm install' or get 'openssl error'
    {
        try
        {
            // String[] params = new String[]{"justPlayUrl", "all", "songmid", "000FTTrx4g7UrH", "quality", "128"};
            // String[] params = new String[]{"id", "2144323627"};
            String[] params = new String[]{"id", "1856342825"};

            MusicApi test = new MusicApi();
            //            String play_url = test.getSonglistDetailQQ(params);  // id 8461706191
            //            String play_url = test.getPlayUrlNE(params);  // id 1856342825
            String songlistDetail = test.getSonglistDetailNE(
                    new String[]{"limit", "1000", "offset", "0", "id", params[1]});
            System.out.println(songlistDetail);
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
    }
}
