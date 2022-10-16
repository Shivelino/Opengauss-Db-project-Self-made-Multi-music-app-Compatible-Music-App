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
    ShowMessage('������ip��������');
    Application.Terminate;
  end;
  main_host := LoginForm.edthost.Text;
  ShowMessage('�ɹ����÷�����ip');
end;

procedure TLoginForm.btnAdminClick(Sender: TObject);
begin
  admin_login := True;
  var AdminForm := TAdminForm.Create(self);
  AdminForm.PrepareWindow();
  AdminForm.Show();  // ��������Ա�������
end;

procedure TLoginForm.btnLoginClick(Sender: TObject);
begin
  if admin_login then
  begin
    ShowMessage('���ڽ��й���Ա��¼�����ܵ�½��������˳����벻Ҫ�������ֲ�����');
  end;
end;

procedure TLoginForm.btnSignUpClick(Sender: TObject);
begin
  var SignUpForm := TSignUpForm.Create(self);
  SignUpForm.PrepareWindow();
  SignUpForm.Show();  // ����ע�����
end;

end.

