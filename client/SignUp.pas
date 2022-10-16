unit SignUp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Grids, Vcl.Clipbrd, System.Win.ScktComp, System.JSON,
  IdTCPClient, IdGlobal;
  // IdGlobal������Id�ĸ��ֱ���

type
  TSignUpForm = class(TForm)
    edtAccount: TEdit;
    edtPassword: TEdit;
    edtNickname: TEdit;
    cbbProvinces: TComboBox;
    cbbCities: TComboBox;
    cbbCounties: TComboBox;
    strGridMusicAppAccount: TStringGrid;
    btnSubmit: TButton;
    btnInsert: TButton;
    btnDelete: TButton;
    procedure strGridMusicAppAccountKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure strGridMusicAppAccountKeyPress(Sender: TObject; var Key: Char);
    procedure cbbProvincesSelect(Sender: TObject);
    procedure cbbCitiesSelect(Sender: TObject);
    procedure btnSubmitClick(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure PrepareWindow; // ׼������
    procedure ClearEndRow;
  end;

var
  SignUpForm: TSignUpForm;

implementation

uses
  Tools;
{$R *.dfm}

procedure TSignUpForm.PrepareWindow;
begin
// ʡ��������
  var jm := JsonMessageSend.Create();
  jm.param_init('select_provinces_*', 'select', 'server', 'SELECT * FROM provinces;');

  var socket_client := SocketClient.Create();
  socket_client.send(jm.message);
  var ret := socket_client.receive(500);

  var provinces := ret.split([',']);
  var i: Integer;  // ����index
  for i := 0 to Length(provinces) - 1 do
    cbbProvinces.Items.Add(provinces[i]);

// �˺ű����ʾ
  strGridMusicAppAccount.Cells[0, 0] := UTF8Encode('�˺�����App');
  strGridMusicAppAccount.Cells[1, 0] := UTF8Encode('�˺�');
  strGridMusicAppAccount.Cells[2, 0] := UTF8Encode('�˺�����');
  strGridMusicAppAccount.Cells[3, 0] := UTF8Encode('�˺�Cookie');
end;

procedure TSignUpForm.btnDeleteClick(Sender: TObject);
begin
// ɾ��ĩ���˺�
  if strGridMusicAppAccount.RowCount > 2 then
    strGridMusicAppAccount.RowCount := strGridMusicAppAccount.RowCount - 1;
end;

procedure TSignUpForm.btnInsertClick(Sender: TObject);
begin
// �������˺ţ����˺ű��϶�һ��
  var last_row_index := strGridMusicAppAccount.RowCount - 1;
  if (strGridMusicAppAccount.Cells[0, last_row_index] = '') or (strGridMusicAppAccount.Cells[1, last_row_index] = '') or (strGridMusicAppAccount.Cells[2, last_row_index] = '') then
  begin
    ShowMessage('��������һ���˺ŵı�������֮��������˺�');
    Exit
  end;
  strGridMusicAppAccount.RowCount := strGridMusicAppAccount.RowCount + 1;
  ClearEndRow;
end;

procedure TSignUpForm.btnSubmitClick(Sender: TObject);
begin
// �жϱ�������
  if (edtAccount.Text = '') or (edtPassword.Text = '') or (edtNickname.Text = '') then
  begin
    ShowMessage('�˺ţ�������ǳƲ���Ϊ��');
    Exit
  end;
  if (cbbProvinces.Text = '') or (cbbCities.Text = '') or (cbbCounties.Text = '') then
  begin
    ShowMessage('������Ϣ�������������Ƽ�����Ϣ');
    Exit
  end;

  // �ж�
  var i: Integer;
  for i := 1 to strGridMusicAppAccount.RowCount - 1 do
  begin
    if (strGridMusicAppAccount.Cells[0, i] = '') or (strGridMusicAppAccount.Cells[1, i] = '') or (strGridMusicAppAccount.Cells[2, i] = '') then
    begin
      ShowMessage('����App�˺ű����Ϣ������������г�Cookie���Ϊ�����ֶ�');
      Exit
    end;
  end;

// ����ע������
  var jm := JsonMessageSend.Create();
  jm.param_init('insert_bigAccountSignUp', 'insert', 'server', 'INSERT INTO BigAccount VALUES (''' + edtAccount.Text + ''',''' + edtPassword.Text + ''',''' + edtNickname.Text + ''');&&&' + Format('INSERT INTO Area VALUES (''%s'', (SELECT province_id FROM provinces WHERE province_name=''%s''),(SELECT city_id FROM cities WHERE city_name=''%s'' AND province_id=(SELECT province_id FROM provinces WHERE province_name=''%s'')), ', [edtAccount.Text, cbbProvinces.Text, cbbCities.Text, cbbProvinces.Text]) + Format('(SELECT county_id FROM counties WHERE county_name=''%s'' AND city_id=(SELECT city_id FROM cities WHERE city_name=''%s'' AND province_id=(SELECT province_id FROM provinces WHERE province_name=''%s''))));',
    [cbbCounties.Text, cbbCities.Text, cbbProvinces.Text]));

  var socket_client := SocketClient.Create();
  socket_client.send(jm.message);
  var ret := socket_client.receive(1000);

  if ret = '__TRUE__' then
  begin
    ShowMessage('�����û��ɹ�');
    var hWndClose := FindWindow(nil, PChar('SignUp'));    //���ݴ���������Ҫ�رյĴ��ھ��
    SendMessage(hWndClose, WM_CLOSE, 0, 0)
  end
  else
  begin
    ShowMessage('�����û�ʧ��')
  end;
end;

procedure TSignUpForm.cbbCitiesSelect(Sender: TObject);
begin
// �ؼ���������
  var jm := JsonMessageSend.Create();
  jm.param_init('select_counties_limitCityName', 'select', 'server', 'SELECT * FROM counties WHERE city_id=(SELECT city_id FROM cities WHERE city_name=''' + cbbCities.Text + ''' AND province_id = (SELECT province_id FROM provinces WHERE province_name=''' + cbbProvinces.Text + '''));');

  var socket_client := SocketClient.Create();
  socket_client.send(jm.message);
  var ret := socket_client.receive(1000);

  var cities := ret.split([',']);
  var i: Integer;  // ����index
  cbbCounties.Clear;
  for i := 0 to Length(cities) - 1 do
  begin
    cbbCounties.Items.Add(cities[i]);
  end;
end;

procedure TSignUpForm.cbbProvincesSelect(Sender: TObject);
begin
// �ؼ���������
  var jm := JsonMessageSend.Create();
  jm.param_init('select_cities_limitProvinceName', 'select', 'server', 'SELECT * FROM cities WHERE province_id=(SELECT province_id FROM provinces WHERE province_name=''' + cbbProvinces.Text + ''');');  // ���ͳɹ�

  var socket_client := SocketClient.Create();
  socket_client.send(jm.message);
  var ret := socket_client.receive(500);

  var cities := ret.split([',']);
  var i: Integer;  // ����index
  cbbCities.Clear;
  for i := 0 to Length(cities) - 1 do
  begin
    cbbCities.Items.Add(cities[i]);
  end;

end;

procedure TSignUpForm.ClearEndRow;
var
  i: Integer;
begin
  for i := 0 to strGridMusicAppAccount.ColCount - 1 do
  begin
    strGridMusicAppAccount.Cells[i, strGridMusicAppAccount.RowCount - 1] := '';
  end;
end;

procedure TSignUpForm.strGridMusicAppAccountKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = vk_Insert then
  begin
    strGridMusicAppAccount.RowCount := strGridMusicAppAccount.RowCount + 1;
    ClearEndRow;
  end
  else if Key = vk_Delete then
  begin
    if strGridMusicAppAccount.RowCount > 2 then
      strGridMusicAppAccount.RowCount := strGridMusicAppAccount.RowCount - 1;
  end
  else if Key = vk_Return then
  begin
    if strGridMusicAppAccount.Col < strGridMusicAppAccount.ColCount - 1 then
      strGridMusicAppAccount.Col := strGridMusicAppAccount.Col + 1
    else
      strGridMusicAppAccount.Col := 0;
  end
  else if Key = VK_BACK then  // backspace���˹���
  begin
    var s := strGridMusicAppAccount.Cells[strGridMusicAppAccount.Col, strGridMusicAppAccount.Row];
    strGridMusicAppAccount.Cells[strGridMusicAppAccount.Col, strGridMusicAppAccount.Row] := s.Substring(0, s.Length - 1);
  end
  else if (ssCtrl in Shift) and (Char(Key) in ['V', 'v']) then  // ctrl+v���ƹ���
  begin
    var s := strGridMusicAppAccount.Cells[strGridMusicAppAccount.Col, strGridMusicAppAccount.Row];
    strGridMusicAppAccount.Cells[strGridMusicAppAccount.Col, strGridMusicAppAccount.Row] := s + Clipboard.AsText;
  end;
end;

procedure TSignUpForm.strGridMusicAppAccountKeyPress(Sender: TObject; var Key: Char);
begin
  if (isLegalChar(Key)) then
  begin
    var s := strGridMusicAppAccount.Cells[strGridMusicAppAccount.Col, strGridMusicAppAccount.Row];
    strGridMusicAppAccount.Cells[strGridMusicAppAccount.Col, strGridMusicAppAccount.Row] := s + Key;
  end;
end;

end.

