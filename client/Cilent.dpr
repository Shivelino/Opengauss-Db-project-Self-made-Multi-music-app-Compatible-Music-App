program Cilent;

uses
  Vcl.Forms,
  Login in 'Login.pas' {LoginForm},
  MainWindow in 'MainWindow.pas' {MainForm},
  SignUp in 'SignUp.pas' {SignUpForm},
  Tools in 'Tools.pas',
  UpdateAccountInfo in 'UpdateAccountInfo.pas' {UpdateAccountInfoForm},
  Admin in 'Admin.pas' {AdminForm};

{$R *.res}


begin
  Application.Initialize;
//  Application.MainFormOnTaskbar := True;
//  Application.CreateForm(TLoginForm, LoginForm);
  Application.CreateForm(TMainForm, MainForm);
  //  Application.CreateForm(TAdminForm, AdminForm);
  //  Application.CreateForm(TUpdateAccountInfoForm, UpdateAccountInfoForm);
  //  Application.CreateForm(TForm1, Form1);
//  Application.CreateForm(TSignUpForm, SignUpForm);
  Application.Run;
end.
