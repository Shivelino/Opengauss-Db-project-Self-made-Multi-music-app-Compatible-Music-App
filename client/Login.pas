unit Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls;

type
  TLoginForm = class(TForm)
    btnLogin: TButton;
    edtAccount: TEdit;
    edtPassword: TEdit;
    lblTitle: TLabel;
    btnSignUp: TButton;
    btnAdmin: TButton;
    edthost: TEdit;
    btnAddHost: TButton;
    procedure btnSignUpClick(Sender: TObject);
    procedure btnAdminClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure btnAddHostClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LoginForm: TLoginForm;
  admin_login: Boolean = False;
  main_host: string;

implementation

uses
  SignUp, Admin;
{$R *.dfm}

procedure TLoginForm.btnAddHostClick(Sender: TObject);
begin
  if LoginForm.edthost.Text = '' then
  begin
    ShowMessage('服务器ip必须输入');
    Application.Terminate;
  end;
  main_host := LoginForm.edthost.Text;
  ShowMessage('成功设置服务器ip');
end;

procedure TLoginForm.btnAdminClick(Sender: TObject);
begin
  admin_login := True;
  var AdminForm := TAdminForm.Create(self);
  AdminForm.PrepareWindow();
  AdminForm.Show();  // 创建管理员管理界面
end;

procedure TLoginForm.btnLoginClick(Sender: TObject);
begin
  if admin_login then
  begin
    ShowMessage('正在进行管理员登录，不能登陆。软件将退出，请不要做出过分操作。');
  end;
end;

procedure TLoginForm.btnSignUpClick(Sender: TObject);
begin
  var SignUpForm := TSignUpForm.Create(self);
  SignUpForm.PrepareWindow();
  SignUpForm.Show();  // 创建注册界面
end;

end.

