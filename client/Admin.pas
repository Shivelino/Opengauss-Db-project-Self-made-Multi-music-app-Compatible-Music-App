unit Admin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Grids, Vcl.Menus;

type
  TAdminForm = class(TForm)
    lblAdminLogin: TLabel;
    edtAdminPassword: TEdit;
    btnAdminLogin: TButton;
    strGridUsers: TStringGrid;
    edtAdminUser: TEdit;
    pmUsers: TPopupMenu;
    procedure PrepareWindow();
    procedure btnAdminLoginClick(Sender: TObject);
    procedure strGridUsersDblClick(Sender: TObject);
    procedure pmUsersClickDelete(Sender: TObject);
    procedure strGridUsersRefresh();
    procedure pmUsersClickRefresh(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AdminForm: TAdminForm;

implementation

uses
  Tools, Login;
{$R *.dfm}

procedure TAdminForm.btnAdminLoginClick(Sender: TObject);
begin
  if (isEmpty(edtAdminUser.Text)) or (isEmpty(edtAdminPassword.Text)) then
  begin
    ShowMessage('管理员账号和密码不能为空');
    Exit
  end;

  var jm := JsonMessageSend.Create();
  jm.param_init('db_admin_login', 'no_client_sql', 'server', Format('%s&&&%s', [edtAdminUser.Text, edtAdminPassword.Text]));

  var socket_client := SocketClient.Create();
  socket_client.send(jm.message);
  var ret := socket_client.receive(500);

  if ret = '__TRUE__' then
  begin
    ShowMessage('管理员账号登录成功');
    strGridUsersRefresh();
  end
  else
    ShowMessage('管理员账号登录失败')
end;

procedure TAdminForm.PrepareWindow();
begin
  strGridUsers.Cells[0, 0] := '账号';
  strGridUsers.Cells[1, 0] := '密码';
  strGridUsers.Cells[2, 0] := '昵称';
end;

procedure TAdminForm.strGridUsersDblClick(Sender: TObject);
begin
  pmUsers.Items.Clear;
  var mi := TMenuItem.Create(self);
  mi.Caption := '删除';
  mi.OnClick := pmUsersClickDelete;
  pmUsers.Items.Add(mi);

  mi := TMenuItem.Create(self);
  mi.Caption := '刷新';
  mi.OnClick := pmUsersClickRefresh;
  pmUsers.Items.Add(mi);

  mi := TMenuItem.Create(self);
  mi.Caption := '-';
  pmUsers.Items.Add(mi);

  mi := TMenuItem.Create(self);
  mi.Caption := '退出';
  pmUsers.Items.Add(mi);

  pmUsers.Popup(mouse.CursorPos.X, mouse.CursorPos.Y);
end;

procedure TAdminForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  var jm := JsonMessageSend.Create();
  jm.param_init('db_admin_exit', 'delete', 'server', '');

  var socket_client := SocketClient.Create();
  socket_client.send(jm.message);
  var ret := socket_client.receive(500);
  if ret = '__TRUE__' then
    admin_login := False
  else
  begin
    ShowMessage('管理员用户管理退出失败，请重启应用');
    Application.Terminate;
  end;
end;

procedure TAdminForm.pmUsersClickDelete(Sender: TObject);
begin
  var jm := JsonMessageSend.Create();
  jm.param_init('delete_users', 'delete', 'server', Format('%s', [strGridUsers.Cells[0, strGridUsers.Row]]));

  var socket_client := SocketClient.Create();
  socket_client.send(jm.message);
  var ret := socket_client.receive(1000);
  strGridUsersRefresh();
end;

procedure TAdminForm.strGridUsersRefresh();
begin
  var jm2 := JsonMessageSend.Create();
  jm2.param_init('select_bigaccount_adminAlter', 'select', 'server', Format('SELECT * FROM bigaccount;', []));

  var socket_client2 := SocketClient.Create();
  socket_client2.send(jm2.message);
  var ret2 := socket_client2.receive(1000);

  var users := ret2.Split([',']);
  var i: Integer;  // 遍历index
  strGridUsers.RowCount := Length(users) + 1;
  for i := 1 to Length(users) do
  begin
    var account__pw__nickname := users[i - 1].Split(['`']);
    strGridUsers.Cells[0, i] := account__pw__nickname[0];
    strGridUsers.Cells[1, i] := account__pw__nickname[1];
    strGridUsers.Cells[2, i] := account__pw__nickname[2];
  end;
end;

procedure TAdminForm.pmUsersClickRefresh(Sender: TObject);
begin
  strGridUsersRefresh();
end;

end.

