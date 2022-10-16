unit MainWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, System.Actions, Vcl.ActnList, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.ExtCtrls, Winapi.Networking.Sockets, Datasnap.DBClient,
  Datasnap.Win.MConnect, Datasnap.Win.SConnect, System.Win.ScktComp, System.JSON,
  IdTCPClient, IdGlobal, Vcl.Menus, Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls,
  Vcl.ActnMenus, ShellAPI, Winapi.TlHelp32, Vcl.ComCtrls, Mmsystem;

type
  TMainForm = class(TForm)
    MainWindowGridpanel: TGridPanel;
    lblAccountInfoNickname: TLabel;
    strGridSonglists: TStringGrid;
    strGridSongs: TStringGrid;
    edtAddSonglist: TEdit;
    cbbAddSonglistMusiApp: TComboBox;
    btnAddSonglistSubmit: TButton;
    pmSongAlter: TPopupMenu;
    pmSonglistAlter: TPopupMenu;
    btnUpdateAccountInfo: TButton;
    btnShowKnownSongs: TButton;
    lblTitle: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnAddSonglistSubmitClick(Sender: TObject);
    procedure strGridSonglistsClick(Sender: TObject);
    procedure strGridSongsDblClick(Sender: TObject);
    procedure pmSongClickAdd(Sender: TObject);
    procedure pmSongClickDelete(Sender: TObject);
    procedure pmSongClickRefresh(Sender: TObject);
    procedure StrGridSongsRefresh();
    procedure pmSonglistClickDelete(Sender: TObject);
    procedure strGridSonglistsDblClick(Sender: TObject);
    procedure StrGridSonglistsRefresh();
    procedure cbbAddSonglistMusiAppDropDown(Sender: TObject);
    procedure pmSonglistClickRefresh(Sender: TObject);
    procedure btnUpdateAccountInfoClick(Sender: TObject);
    procedure lblAccountInfoNicknameRefresh(new_nickname: string);
    procedure btnShowKnownSongsClick(Sender: TObject);
    procedure pmSongClickSongPlay(Sender: TObject);
    procedure pmSongClickSongStop(Sender: TObject);
    procedure SongStop();
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  ClientSocket1: TClientSocket;
  mainwindow_account: string;
  songlists_keys: TArray<string>;
  songs_keys: TArray<string>;
  cbbAddSonglistMusiAppHintBool: Boolean = True;
  songlists_str: string;
  current_songlist_name: string; // 记录当前歌单名字
  is_all_songs: Boolean = False;
  handle_play: NativeUInt;

implementation

uses
  Login, Tools, UpdateAccountInfo;
{$R *.dfm}

procedure TMainForm.btnAddSonglistSubmitClick(Sender: TObject);
begin
  var jm := JsonMessageSend.Create();  // json message
  jm.param_init('add_songlist', 'no_client_sql', 'server', Format('%s`%s`%s', [LoginForm.edtAccount.Text, edtAddSonglist.Text, cbbAddSonglistMusiApp.Text]));

  var socket_client := SocketClient.Create();
  socket_client.send(jm.message);
  var ret := socket_client.receive(8000);

  if ret = '__TRUE__' then
    StrGridSonglistsRefresh()
  else
    ShowMessage('操作失败')
end;

procedure TMainForm.btnShowKnownSongsClick(Sender: TObject);
begin
// 查询所有songs
  is_all_songs := True;

  var jm := JsonMessageSend.Create();
  jm.param_init('select_songs_*', 'select', 'server', 'SELECT * FROM get_all_songs;');

  var socket_client := SocketClient.Create();
  socket_client.send(jm.message);
  var ret := socket_client.receive(500);
  if ret = 'null' then
  begin
    strGridSongs.RowCount := 1;
  end
  else
  begin
    var ids_sos := ret.Split(['&&&']);

    var songs_str := ids_sos[0];
    songs_keys := ids_sos[1].Split(['#']);

    var songs_arr := songs_str.split(['#']);
    strGridSongs.RowCount := Length(songs_arr) + 1;
    var i: Integer;  // 遍历index
    for i := 1 to Length(songs_arr) do
    begin
      var song_name__singers__album := songs_arr[i - 1].Split(['`']);
      strGridSongs.Cells[0, i] := song_name__singers__album[0];
      strGridSongs.Cells[1, i] := song_name__singers__album[1];
      strGridSongs.Cells[2, i] := song_name__singers__album[2];
    end;
  end;

end;

procedure TMainForm.btnUpdateAccountInfoClick(Sender: TObject);
begin
  Application.CreateForm(TUpdateAccountInfoForm, UpdateAccountInfoForm);
  UpdateAccountInfoForm.Show;
end;

procedure TMainForm.cbbAddSonglistMusiAppDropDown(Sender: TObject);
begin
  if cbbAddSonglistMusiAppHintBool then
  begin
    ShowMessage('目前仅支持2种音乐App: QQ音乐和网易云音乐。选项中，0表示在软件中新建歌单，1表示导入QQ音乐歌单，2表示导入网易云音乐歌单');
    cbbAddSonglistMusiAppHintBool := False;
  end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SongStop();
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  LoginForm := TLoginForm.Create(self);

  if (LoginForm.ShowModal = mrOk) and (not isEmpty(LoginForm.edtAccount.Text)) and (not isEmpty(LoginForm.edtPassword.Text)) then
  begin
    var jm := JsonMessageSend.Create();
    jm.param_init('select_bigAccount_loginCheck', 'select', 'server', Format('SELECT password,nickname FROM BigAccount WHERE account=''%s'';', [LoginForm.edtAccount.Text]));

    var socket_client := SocketClient.Create();
    if (not socket_client.send(jm.message)) then
    begin
      ShowMessage('服务器连接失败。服务器连接检查目前仅在登录时检查，若连接失败则不能启动软件。');
      Application.Terminate;
    end;
    var ret := socket_client.receive(700);
    var pw_nickname := ret.Split(['`']);

    if pw_nickname[0] = LoginForm.edtPassword.Text then
    begin
      ShowMessage('登录成功');
      // 歌曲表格头初始化
      strGridSongs.DrawingStyle := gdsClassic;
      strGridSongs.Cells[0, 0] := UTF8Encode('歌曲');
      strGridSongs.Cells[1, 0] := UTF8Encode('歌手');
      strGridSongs.Cells[2, 0] := UTF8Encode('专辑');
      // 初始化歌单数据
      StrGridSonglistsRefresh();
      // 初始化App下拉列表
      cbbAddSonglistMusiApp.Items.Add('0');
      cbbAddSonglistMusiApp.Items.Add('1');
      cbbAddSonglistMusiApp.Items.Add('2');

      mainwindow_account := LoginForm.edtAccount.Text; // 存储当前账户
      lblAccountInfoNickname.Caption := '用户昵称' + Chr(10) + pw_nickname[1]; //标签显示当前账户

      MainForm.Show
    end
    else
    begin
      ShowMessage('登录失败，请输入正确的账号和密码');
      Application.Terminate;
    end;
  end
  else
  begin
    ShowMessage('账号和密码不能为空');
    Application.Terminate;
  end;
end;

procedure TMainForm.strGridSonglistsClick(Sender: TObject);
begin
  StrGridSongsRefresh();
end;

procedure TMainForm.strGridSonglistsDblClick(Sender: TObject);
begin
  pmSonglistAlter.Items.Clear;
  var mi := TMenuItem.Create(self);
  mi.Caption := '删除';
  mi.OnClick := pmSonglistClickDelete;
  pmSonglistAlter.Items.Add(mi);

  mi := TMenuItem.Create(self);
  mi.Caption := '刷新';
  mi.OnClick := pmSonglistClickRefresh;
  pmSonglistAlter.Items.Add(mi);

  mi := TMenuItem.Create(self);
  mi.Caption := '-';
  pmSonglistAlter.Items.Add(mi);

  mi := TMenuItem.Create(self);
  mi.Caption := '退出';
  pmSonglistAlter.Items.Add(mi);

  pmSonglistAlter.Popup(mouse.CursorPos.X, mouse.CursorPos.Y);
end;

procedure TMainForm.strGridSongsDblClick(Sender: TObject);  // 双击选项菜单
begin
  pmSongAlter.Items.Clear;

  var mi := TMenuItem.Create(self);
  mi.Caption := '添加到歌单';
  if songlists_str <> 'null' then
  begin
    var songlists_arr := songlists_str.split([',']);
    var i: Integer;
    for i := 0 to Length(songlists_arr) - 1 do
    begin
      var sub_menu_items := TMenuItem.Create(self);
      sub_menu_items.Caption := songlists_arr[i];
      sub_menu_items.OnClick := pmSongClickAdd;  // 点击选项发socket
      mi.Add(sub_menu_items);
    end;
  end;
  pmSongAlter.Items.Add(mi);

  mi := TMenuItem.Create(self);
  mi.Caption := '刷新';
  mi.OnClick := pmSongClickRefresh;
  pmSongAlter.Items.Add(mi);

  mi := TMenuItem.Create(self);
  mi.Caption := '-';
  pmSongAlter.Items.Add(mi);

  mi := TMenuItem.Create(self);
  mi.Caption := '播放';
  mi.OnClick := pmSongClickSongPlay;
  pmSongAlter.Items.Add(mi);

  mi := TMenuItem.Create(self);
  mi.Caption := '停止';
  mi.OnClick := pmSongClickSongStop;
  pmSongAlter.Items.Add(mi);

  mi := TMenuItem.Create(self);
  mi.Caption := '-';
  pmSongAlter.Items.Add(mi);

  mi := TMenuItem.Create(self);
  mi.Caption := '删除';
  mi.OnClick := pmSongClickDelete;
  pmSongAlter.Items.Add(mi);

  mi := TMenuItem.Create(self);
  mi.Caption := '退出';
  pmSongAlter.Items.Add(mi);

  pmSongAlter.Popup(mouse.CursorPos.X, mouse.CursorPos.Y);
end;

procedure TMainForm.pmSongClickAdd(Sender: TObject);
begin
  var selected_songlist_name := StringReplace(TMenuItem(Sender).Caption, '&', '', [rfReplaceAll]); // 不知道为什么程序会往caption中嵌入&字符

  var jm := JsonMessageSend.Create();
  jm.param_init('insert_songlists_has_songs', 'insert', 'server', Format('INSERT INTO songlists_has_songs VALUES((SELECT songlist_id FROM songlists WHERE songlist_name=''%s'' AND account=''%s''), %s);', [selected_songlist_name, mainwindow_account, songs_keys[strGridSongs.Row - 1]]));

  var socket_client := SocketClient.Create();
  socket_client.send(jm.message);
  var ret := socket_client.receive(500);

  if ret = '__TRUE__' then
    ShowMessage('操作成功')
  else if ret = '__FALSE__' then
    ShowMessage('操作失败')
end;

procedure TMainForm.pmSongClickDelete(Sender: TObject);
begin
  var selected_songlist_name := strGridSonglists.Cells[strGridSonglists.Col, strGridSonglists.Row];

  var jm := JsonMessageSend.Create();
  jm.param_init('delete_songlists_has_songs', 'delete', 'server', 'DELETE FROM songlists_has_songs WHERE ' + Format('songlist_id=(SELECT songlist_id FROM songlists WHERE songlist_name=''%s'' AND account=''%s'') AND ', [selected_songlist_name, LoginForm.edtAccount.Text]) + Format('song_id=(SELECT song_id FROM songs WHERE song_name=''%s'' AND song_id IN ', [strGridSongs.Cells[0, strGridSongs.Row]]) + '(SELECT song_id FROM songlists_has_songs WHERE songlist_id = ' + Format('(SELECT songlist_id FROM songlists WHERE songlist_name=''%s'' AND account=''%s'')));', [selected_songlist_name, LoginForm.edtAccount.Text]));

  var socket_client := SocketClient.Create();
  socket_client.send(jm.message);
  var ret := socket_client.receive(500);

  if ret = '__TRUE__' then
    StrGridSongsRefresh()
  else if ret = '__FALSE__' then
    ShowMessage('操作失败');
end;

procedure TMainForm.pmSongClickRefresh(Sender: TObject);
begin
  StrGridSongsRefresh();
end;

procedure TMainForm.StrGridSongsRefresh();
begin
  is_all_songs := False;

  current_songlist_name := strGridSonglists.Cells[strGridSonglists.Col, strGridSonglists.Row];

  var jm := JsonMessageSend.Create();
  jm.param_init('select_songs', 'select', 'server', 'SELECT table3.song_id,table3.song_name,string_agg(table3.singer_name, '','') AS song_singers_name,table3.album_name AS song_album_name FROM ' + '(SELECT table2.song_id,table2.song_name,table2.album_name,singers.singer_name FROM ' + '(SELECT table1.song_id,table1.song_name,table1.singer_id,albums.album_name FROM ' + '(SELECT songs.song_id,songs.song_name,songs.album_id,songs_has_singers.singer_id ' +
    'FROM songs,songs_has_singers WHERE songs.song_id=songs_has_singers.song_id AND ' + 'songs.song_id IN (SELECT song_id FROM songs WHERE song_id IN ' + '(SELECT song_id FROM songlists_has_songs WHERE songlist_id= ' + Format('(SELECT songlist_id FROM songlists WHERE songlist_name=''%s'' AND account=''%s'')))) AS table1 ', [strGridSonglists.Cells[strGridSonglists.Col, strGridSonglists.Row], LoginForm.edtAccount.Text]) + 'LEFT JOIN albums ON albums.album_id=table1.album_id) AS table2 ' + 'LEFT JOIN singers ON singers.singer_id=table2.singer_id) AS table3 ' + 'GROUP BY (table3.song_id,table3.song_name,table3.album_name);');

  var socket_client := SocketClient.Create();
  socket_client.send(jm.message);
  var ret := socket_client.receive(1000);
  if ret = 'null' then
  begin
    strGridSongs.RowCount := 1;
  end
  else
  begin
    var ids_sos := ret.Split(['&&&']);

    var songs_str := ids_sos[0];
    songs_keys := ids_sos[1].Split(['#']);

    var songs_arr := songs_str.split(['#']);
    strGridSongs.RowCount := Length(songs_arr) + 1;
    var i: Integer;  // 遍历index
    for i := 1 to Length(songs_arr) do
    begin
      var song_name__singers__album := songs_arr[i - 1].Split(['`']);
      strGridSongs.Cells[0, i] := song_name__singers__album[0];
      strGridSongs.Cells[1, i] := song_name__singers__album[1];
      strGridSongs.Cells[2, i] := song_name__singers__album[2];
    end;
  end;
end;

procedure TMainForm.pmSonglistClickDelete(Sender: TObject);
begin
  var selected_songlist_name := strGridSonglists.Cells[strGridSonglists.Col, strGridSonglists.Row];
  var jm := JsonMessageSend.Create();
  jm.param_init('delete_songlists', 'delete', 'server', Format('DELETE FROM songlists_has_songs WHERE songlist_id=(SELECT songlist_id FROM songlists WHERE songlist_name=''%s'' AND account=''%s'');&&&DELETE FROM songlists WHERE songlist_id=(SELECT songlist_id FROM songlists WHERE songlist_name=''%s'' AND account=''%s'');', [strGridSonglists.Cells[strGridSonglists.Col, strGridSonglists.Row], LoginForm.edtAccount.Text, strGridSonglists.Cells[strGridSonglists.Col, strGridSonglists.Row], LoginForm.edtAccount.Text]));

  var socket_client := SocketClient.Create();
  socket_client.send(jm.message);
  var ret := socket_client.receive(1000);
  if ret = '__TRUE__' then
    StrGridSonglistsRefresh()
  else
    ShowMessage('操作失败')
end;

procedure TMainForm.StrGridSonglistsRefresh();
begin
  var jm := JsonMessageSend.Create();
  jm.param_init('select_songlists', 'select', 'server', Format('SELECT songlist_id,songlist_name FROM Songlists WHERE account=''%s'';', [LoginForm.edtAccount.Text]));

  var socket_client := SocketClient.Create();
  socket_client.send(jm.message);
  var ret := socket_client.receive(500);
  if ret <> 'null' then
  begin
    var ids_sls := ret.Split(['&&&']);

    songlists_str := ids_sls[0];
    songlists_keys := ids_sls[1].Split([',']);

    var songlists_arr := songlists_str.split([',']);
    var i: Integer;  // 遍历index
    strGridSonglists.RowCount := Length(songlists_arr);
    for i := 0 to Length(songlists_arr) - 1 do
      strGridSonglists.Cells[0, i] := songlists_arr[i];
  end
  else
  begin
    strGridSonglists.RowCount := 0;
    strGridSonglists.Cells[0, 0] := '';
  end;
end;

procedure TMainForm.pmSonglistClickRefresh(Sender: TObject);
begin
  StrGridSonglistsRefresh();
end;

procedure TMainForm.lblAccountInfoNicknameRefresh(new_nickname: string);
begin
  lblAccountInfoNickname.Caption := '用户昵称' + Chr(10) + new_nickname;
end;

procedure TMainForm.pmSongClickSongPlay(Sender: TObject);
begin
  SongStop(); // stop first
  var jm := JsonMessageSend.Create();
  jm.param_init('select_song_mid&&get_play_url', 'select', 'music_server', Format('SELECT app_id,song_mid FROM songs WHERE song_id=''%s'';', [songs_keys[strGridSongs.Row - 1]]));

  var socket_client := SocketClient.Create();
  socket_client.send(jm.message);
  var ret := socket_client.receive(1500);

  var tmp1: WideString := Format('-u "%s"', [ret]);
  var tmp2: PWideChar := PWideChar(tmp1);
// ep: ShellExecute(handle, 'operation', target, params, folder, SW_SHOWNORMAL);
  var folder: widestring := ExtractFileDir(ParamStr(0)) + '\playUrlMusic';
  handle_play := ShellExecute(handle, 'open', 'playUrlMusic.exe', tmp2, PWideChar(folder), SW_HIDE);
end;

procedure TMainForm.pmSongClickSongStop(Sender: TObject);
begin
  SongStop();
end;

procedure TMainForm.SongStop();
begin
  const PROCESS_TERMINATE = $0001;
  var ExeFileName: string;
  var ContinueLoop: Boolean;
  var FSnapshotHandle: THandle;
  var FProcessEntry32: TProcessEntry32;
  begin
    ExeFileName := 'playUrlMusic.exe';
    FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
    ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
    while integer(ContinueLoop) <> 0 do
    begin
      if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) = UpperCase(ExeFileName))) then
        TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0), FProcessEntry32.th32ProcessID), 0);
      ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
    end;
  end;
end;

end.

