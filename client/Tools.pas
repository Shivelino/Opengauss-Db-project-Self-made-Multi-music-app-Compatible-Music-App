unit Tools;

interface

uses
  Winapi.Networking.Sockets, Datasnap.DBClient, Datasnap.Win.MConnect,
  Datasnap.Win.SConnect, System.Win.ScktComp, System.JSON, IdTCPClient, IdGlobal,
  Winapi.Messages, System.SysUtils, System.Variants, System.Classes;

// 函数声明
function isEmpty(str: string): Boolean;

function isLegalChar(c: char): Boolean;

// 类型声明
type
  SocketClient = class
    host: string;
    port: Integer;
    client: TIdTCPClient;

    procedure prepare();
    function send(message: TJSONObject): Boolean;
    function receive(waitTime: Integer): string;
  end;

  JsonMessageSend = class  // json message to send.
    message: TJSONObject;
    procedure param_init(action: string; operation: string; target: string; sql_or_param: string);

  end;

implementation

uses
  Login;

function isEmpty(str: string): Boolean;  // 判空
begin
  if str = '' then
    Result := True
  else
    Result := False;
end;

function isLegalChar(c: char): Boolean;  // 判断合法字符
begin
  if (c in ['a'..'z']) or (c in ['A'..'Z']) or (c in ['0'..'9']) then
    Result := True
  else
    Result := False;
end;

procedure SocketClient.prepare();
begin
// params
//  host := '192.168.5.136';
  host := main_host;
  port := 4040;
  client := TIdTCPClient.Create(nil);
// client init and connect
  client.Host := host;
  client.Port := port;
  client.Connect();
end;

function SocketClient.send(message: TJSONObject): Boolean;
begin
  try
    prepare();
  except
    on e: Exception do
    begin
      Result := False;
      Exit
    end;
  end;
  client.Socket.WriteLn(message.ToString(), IndyTextEncoding(TEncoding.UTF8));
  Result := True;
end;

function SocketClient.receive(waitTime: Integer): string;
begin
// extraordinarily long string must send several times.
  var bag_num_str := client.Socket.ReadLn('', waitTime, 9000, IndyTextEncoding(TEncoding.UTF8));
  if bag_num_str = '' then
  begin
    result := '';
  end;
  var bag_num := StrToInt(bag_num_str);
  var receive_str := '';
  var i: Integer;
  for i := 0 to bag_num do
  begin
    var tmp := client.Socket.ReadLn('', 500, 9000, IndyTextEncoding(TEncoding.UTF8));
    receive_str := receive_str + tmp;
  end;
  result := receive_str;
end;

procedure JsonMessageSend.param_init(action: string; operation: string; target: string; sql_or_param: string);
begin
  message := TJSONObject.Create;
  message.AddPair('action', action);
  message.AddPair('operation', operation);
  message.AddPair('target', target);
  message.AddPair('sql_or_param', sql_or_param);
end;

end.

