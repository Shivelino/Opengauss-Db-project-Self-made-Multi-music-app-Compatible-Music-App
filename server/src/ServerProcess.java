import DataTypeAdapters.JsonString2Message;
import DbWorkers.DbWorkerOpenGauss;
import Messages.JsonMessage;
import MusicAppApis.MusicApi;
import MusicInfos.*;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.charset.StandardCharsets;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

class MainProcess
{
    private DbWorkerOpenGauss db_worker;
    private final MusicApi music_api;

    public MainProcess()
    {
        music_api = new MusicApi();
        db_worker = new DbWorkerOpenGauss("192.168.5.136", "26000", "server_db", "db_user", "Bigdata@123");
    }

    private String SingleColumnSelect(String sql, String column_name)
    {
        try
        {
            ResultSet result = db_worker.executeQuery(sql);
            if (result.isBeforeFirst())  // if before first row
                result.next();
            ArrayList<String> l = new ArrayList<>();
            while (!result.isAfterLast() && !result.wasNull())
            {
                l.add(result.getString(column_name));
                result.next();
            }
            StringBuilder send_str_builder = new StringBuilder();
            for (String str : l)
                send_str_builder.append(",").append(str.trim());
            return new String(send_str_builder.substring(1).getBytes(), StandardCharsets.UTF_8);
        }
        catch (SQLException e)
        {
            return null;
        }
    }

    private String MultiColumnsSelect(String sql, String[] column_names)
    {
        try
        {
            ResultSet result = db_worker.executeQuery(sql);
            if (result.isBeforeFirst())  // if before first row
                result.next();
            ArrayList<String> l = new ArrayList<>();
            while (!result.isAfterLast() && !result.wasNull())
            {
                StringBuilder tmp = new StringBuilder();
                for (String column : column_names)
                    tmp.append("`").append(result.getString(column).trim());
                l.add(tmp.substring(1));
                result.next();
            }
            StringBuilder send_str_builder = new StringBuilder();
            for (String str : l)
                send_str_builder.append(",").append(str.trim());
            return new String(send_str_builder.substring(1).getBytes(), StandardCharsets.UTF_8);
        }
        catch (SQLException e)
        {
            return null;
        }
    }

    private String SingleSqlOther(String sql)
    {
        String result = "__TRUE__";
        if (db_worker.executeOther(sql))  // db_worker return false means NO ERROR
            result = "__FALSE__";
        return result;
    }

    private String SplitSqlOther(String sqls_str)
    {
        String[] sqls = sqls_str.split("&&&");
        String result = "__TRUE__";  // execute successful
        for (String sql : sqls)
        {
            if (db_worker.executeOther(sql))  // db_worker return false means NO ERROR
                result = "__FALSE__";
        }
        return result;
    }

    public String run(JsonMessage message)
    {
        switch (message.action)
        {
            case "select_provinces_*":  // select all provinces
                return SingleColumnSelect(message.sql_or_param, "province_name");
            case "select_cities_limitProvinceName":  // select cities by province_name
                return SingleColumnSelect(message.sql_or_param, "city_name");
            case "select_counties_limitCityName":  // select counties by city_name
                return SingleColumnSelect(message.sql_or_param, "county_name");
            case "insert_bigAccountSignUp":  // insert new user
            case "delete_songlists":  // delete selected songlist
                return SplitSqlOther(message.sql_or_param);
            case "select_bigAccount_loginCheck":  // login check select
                return MultiColumnsSelect(message.sql_or_param, new String[]{"password", "nickname"});
            case "select_songlists":
            {
                ResultSet result = db_worker.executeQuery(message.sql_or_param);
                try
                {
                    if (result.isBeforeFirst())  // if before first row
                        result.next();
                    ArrayList<String> l = new ArrayList<>();
                    ArrayList<String> l_id = new ArrayList<>();
                    while (!result.isAfterLast() && !result.wasNull())
                    {
                        l.add(result.getString("songlist_name").trim());
                        l_id.add(String.valueOf(result.getInt("songlist_id")).trim());
                        result.next();
                    }
                    StringBuilder send_str_builder1 = new StringBuilder();
                    StringBuilder send_str_builder2 = new StringBuilder();
                    for (String str : l)
                        send_str_builder1.append(",").append(str.trim());
                    for (String str : l_id)
                        send_str_builder2.append(",").append(str.trim());
                    return new String((send_str_builder1.substring(1) + "&&&" + send_str_builder2.substring(
                            1)).getBytes(), StandardCharsets.UTF_8);
                }
                catch (SQLException e)
                {
                    e.printStackTrace();
                }
                break;
            }
            case "select_songs":
            case "select_songs_*":
            {
                ResultSet result = db_worker.executeQuery(message.sql_or_param);
                try
                {
                    if (result.isBeforeFirst())  // if before first row
                        result.next();
                    ArrayList<String> l = new ArrayList<>();
                    ArrayList<String> l_id = new ArrayList<>();
                    while (!result.isAfterLast() && !result.wasNull())
                    {
                        String song_name = result.getString("song_name").trim();
                        String song_singers_name = result.getString("song_singers_name").trim();
                        String song_album_name = result.getString("song_album_name") == null ? "no album" :
                                result.getString("song_album_name");
                        l.add(song_name + '`' + song_singers_name + '`' + song_album_name);
                        l_id.add(String.valueOf(result.getInt("song_id")).trim());
                        result.next();
                    }
                    StringBuilder send_str_builder1 = new StringBuilder();
                    StringBuilder send_str_builder2 = new StringBuilder();
                    for (String str : l)
                        send_str_builder1.append("#").append(str.trim());
                    for (String str : l_id)
                        send_str_builder2.append("#").append(str.trim());
                    return new String((send_str_builder1.substring(1) + "&&&" + send_str_builder2.substring(
                            1)).getBytes(), StandardCharsets.UTF_8);
                }
                catch (SQLException e)
                {
                    e.printStackTrace();
                }
                break;
            }
            case "insert_songlists_has_songs":  // insert songlists_has_songs EQUAL TO songlists add song
            case "delete_songlists_has_songs":  // delete songlists_has_songs EQUAL TO songlists delete song
            case "update_bigaccount_password":  // update password
            case "update_bigaccount_nickname":  // update nickname
                return SingleSqlOther(message.sql_or_param);
            case "add_songlist":
                try
                {
                    String[] params = message.sql_or_param.split(
                            "`");  // 0:account,1:songlist_name/app_songlist_id,2:app_id
                    if (params[2].equals("0"))
                    {

                        String sql = String.format(
                                "CALL insert_songlists('%s','%s',%s,'%s',0,Array[]::integer[],Array[]::integer[],Array[]::integer[],Array[]::integer[]);",
                                params[1], params[0], params[2], params[0]);
                        db_worker.executeOther(sql);
                    }
                    else if (params[2].equals("1"))
                    {
                        ObjectMapper mapper = new ObjectMapper();
                        GetSonglistDetailReturnQQ api_return = mapper.readValue(
                                music_api.getSonglistDetailQQ(new String[]{"id", params[1]}),
                                GetSonglistDetailReturnQQ.class);
                        //                    System.out.println(api_return);
                        SonglistInfoQQ songlistInfo = api_return.data;
                        String sl_name = songlistInfo.dissname, sl_account = params[0], sl_app_id = params[2], sl_mid =
                                params[1];
                        int so_nums = songlistInfo.songlist.length;
                        String[] so_names_arr = new String[so_nums], so_albums_arr = new String[so_nums], so_mids_arr =
                                new String[so_nums], so_singers = new String[so_nums];
                        for (int i = 0; i < so_nums; i++)
                        {
                            SongInfoQQ song = songlistInfo.songlist[i];
                            so_names_arr[i] = song.songname.replace("'", "''");
                            so_albums_arr[i] = song.albumname.replace("'", "''");
                            so_mids_arr[i] = song.songmid.replace("'", "''");
                            StringBuilder singers = new StringBuilder();
                            for (int j = 0; j < song.singer.length; j++)
                                singers.append("`").append(song.singer[j].name.replace("'", "''"));
                            so_singers[i] = new String(singers.substring(1).getBytes(), StandardCharsets.UTF_8);
                        }
                        String sql = String.format(
                                "CALL insert_songlists('%s','%s',%s,'%s',%d,Array['%s'],Array['%s'],Array['%s'],Array['%s']);",
                                sl_name, sl_account, sl_app_id, sl_mid, so_nums, String.join("','", so_names_arr),
                                String.join("','", so_albums_arr), String.join("','", so_mids_arr),
                                String.join("','", so_singers));
                        db_worker.executeOther(sql);
                    }
                    else if (params[2].equals("2"))
                    {
                        ObjectMapper mapper = new ObjectMapper();
                        GetSonglistDetailReturnNE api_return = mapper.readValue(music_api.getSonglistDetailNE(
                                        new String[]{"limit", "1000", "offset", "0", "id", params[1]}),
                                GetSonglistDetailReturnNE.class);
                        SongInfoNE[] songInfos = api_return.songs;
                        String sl_name = music_api.getSonglistDetailNoSongsNE(new String[]{"id", params[1]}).split(
                                "\"")[11], sl_account = params[0], sl_app_id = params[2], sl_mid = params[1];
                        int so_nums = songInfos.length;
                        String[] so_names_arr = new String[so_nums], so_albums_arr = new String[so_nums], so_mids_arr =
                                new String[so_nums], so_singers = new String[so_nums];
                        for (int i = 0; i < so_nums; i++)
                        {
                            SongInfoNE song = songInfos[i];
                            so_names_arr[i] = song.name.replace("'", "''");
                            so_albums_arr[i] = song.al.name.replace("'", "''");
                            so_mids_arr[i] = String.valueOf(song.id).replace("'", "''");
                            StringBuilder singers = new StringBuilder();
                            for (int j = 0; j < song.ar.length; j++)
                                singers.append("`").append(song.ar[j].name.replace("'", "''"));
                            so_singers[i] = new String(singers.substring(1).getBytes(), StandardCharsets.UTF_8);
                        }
                        String sql = String.format(
                                "CALL insert_songlists('%s','%s',%s,'%s',%d,Array['%s'],Array['%s'],Array['%s'],Array['%s']);",
                                sl_name, sl_account, sl_app_id, sl_mid, so_nums, String.join("','", so_names_arr),
                                String.join("','", so_albums_arr), String.join("','", so_mids_arr),
                                String.join("','", so_singers));
                        db_worker.executeOther(sql);
                    }
                    return "__TRUE__";
                }
                catch (Exception e)
                {
                    return "__FALSE__";
                }
            case "db_admin_login":
                // database admin login

                String[] user_and_pw = message.sql_or_param.split("&&&");
                if (!user_and_pw[0].equals("joe") || !user_and_pw[1].equals("Bigdata@123"))
                    return "__FALSE__";
                try
                {
                    db_worker = new DbWorkerOpenGauss("192.168.5.136", "26000", "server_db", "joe", "Bigdata@123");
                    return "__TRUE__";
                }
                catch (Exception e)
                {
                    return "__FALSE__";
                }
            case "db_admin_exit":
                // database admin exit EQUAL TO db_user login

                try
                {
                    db_worker = new DbWorkerOpenGauss("192.168.5.136", "26000", "server_db", "db_user", "Bigdata@123");
                    return "__TRUE__";
                }
                catch (Exception e)
                {
                    return "__FALSE__";
                }
            case "select_bigaccount_adminAlter":
                // admin select all users
                return MultiColumnsSelect(message.sql_or_param, new String[]{"account", "password", "nickname"});
            case "delete_users":
                // delete selected user
                String sql = String.format("CALL delete_bigaccount('%s')", message.sql_or_param);
                return SingleSqlOther(sql);
            case "select_song_mid&&get_play_url":
                // get play url
                try
                {
                    ResultSet result = db_worker.executeQuery(message.sql_or_param);
                    if (result.isBeforeFirst())  // if before first row
                        result.next();
                    ArrayList<String> l = new ArrayList<>();
                    ArrayList<String> l_mid = new ArrayList<>();
                    while (!result.isAfterLast() && !result.wasNull())
                    {
                        l.add(result.getString("app_id").trim());
                        l_mid.add(result.getString("song_mid").trim());
                        result.next();
                    }
                    StringBuilder send_str_builder1 = new StringBuilder();
                    StringBuilder send_str_builder2 = new StringBuilder();
                    for (String str : l)
                        send_str_builder1.append(",").append(str.trim());
                    for (String str : l_mid)
                        send_str_builder2.append(",").append(str.trim());
                    if (send_str_builder1.substring(1).equals("1"))  // qq music
                    {
                        String[] params = new String[]{"justPlayUrl", "all", "songmid", send_str_builder2.substring(
                                1), "quality", "128"};
                        return music_api.getPlayUrlQQ(params);
                    }
                    else if (send_str_builder1.substring(1).equals("2"))  // netease music
                    {
                        String[] params =
                                new String[]{"limit", "1000", "offset", "0", "id", send_str_builder2.substring(1)};
                        return music_api.getPlayUrlNE(params);
                    }
                }
                catch (Exception e)
                {
                    return null;
                }
                break;
        }
        return null;
    }
}

public class ServerProcess
{
    public static void main(String[] args)
    {
        try
        {
            MainProcess mainProcess = new MainProcess();

            ServerSocket server = new ServerSocket(4040);  //创建一个ServerSocket监听4040端口
            BufferedReader receiver;  // 创建BufferedReader用于读取数据
            PrintWriter sender;  //创建PrintWriter，用于发送数据

            while (true)
            {
                Socket socket = server.accept();  // 等待请求,接收到请求后使用socket进行通信
                receiver = new BufferedReader(new InputStreamReader(socket.getInputStream()));
                String line = receiver.readLine();
                System.out.println("received from client: " + line);
                JsonMessage message = JsonString2Message.translate(line);
                assert message != null;
                String send_str = mainProcess.run(message);  // logic run
                if (send_str == null)
                    send_str = "null";
                System.out.println("send_str is " + send_str);

                sender = new PrintWriter(socket.getOutputStream());  //创建PrintWriter，用于发送数据
                int bag_num = (send_str.length() % 3000 == 0) ? 0 : 1 + send_str.length() / 3000;
                sender.println(bag_num);
                for (int i = 0; i < bag_num; i++)
                    sender.println(send_str.substring(i * 3000, Math.min((i + 1) * 3000, send_str.length())));
                sender.flush();
            }
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
    }
}
