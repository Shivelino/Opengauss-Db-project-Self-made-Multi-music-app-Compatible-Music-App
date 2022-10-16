unit UpdateAccountInfo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls;

type
  TUpdateAccountInfoForm = class(TForm)
    edtPassword: TEdit;
    edtNickname: TEdit;
    lblUpdatePassword: TLabel;
    lblUpdateNickname: TLabel;
    btnUpdatePassword: TButton;
    btnUpdateNickname: TButton;
    procedure btnUpdatePasswordClick(Sender: TObject);
    procedure btnUpdateNicknameClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UpdateAccountInfoForm: TUpdateAccountInfoForm;
  account: string;

implementation

uses
  Tools, MainWindow;
{$R *.dfm}

procedure TUpdateAccountInfoForm.btnUpdateNicknameClick(Sender: TObject);
begin
  var jm := JsonMessageSend.Create();
  jm.param_init('update_bigaccount_nickname', 'update', 'server', Format('UPDATE bigaccount SET nickname=''%s'' WHERE account=''%s'';', [edtNickname.Text, mainwindow_account]));

  var socket_client := SocketClient.Create();
  socket_client.send(jm.message);
  var ret := socket_client.receive(500);

  if ret = '__TRUE__' then
  begin
    ShowMessage('–ﬁ∏ƒÍ«≥∆≥…π¶');
    MainForm.lblAccountInfoNicknameRefresh(edtNickname.Text);
  end
  else
    ShowMessage('–ﬁ∏ƒÍ«≥∆ ß∞‹')
end;

procedure TUpdateAccountInfoForm.btnUpdatePasswordClick(Sender: TObject);
begin
  var jm := JsonMessageSend.Create();
  jm.param_init('update_bigaccount_password', 'update', 'server', Format('UPDATE bigaccount SET password=''%s'' WHERE account=''%s'';', [edtPassword.Text, mainwindow_account]));

  var socket_client := SocketClient.Create();
  socket_client.send(jm.message);
  var ret := socket_client.receive(500);

  if ret = '__TRUE__' then
    ShowMessage('–ﬁ∏ƒ√‹¬Î≥…π¶')
  else
    ShowMessage('–ﬁ∏ƒ√‹¬Î ß∞‹')
end;

end.

