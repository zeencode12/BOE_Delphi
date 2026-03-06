unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Unit1;

type
  TFormLogin = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edUser: TEdit;
    edPass: TEdit;
    btnLogin: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormLogin: TFormLogin;
implementation

{$R *.dfm}

procedure TFormLogin.FormCreate(Sender: TObject);
begin
  edPass.PasswordChar := '*';
end;

procedure TFormLogin.btnLoginClick(Sender: TObject);
begin

  if (edUser.Text = 'admin') and (edPass.Text = '123') then
  begin
    Form1.Show;
    FormLogin.Hide;
  end
  else
  begin
    ShowMessage('Username atau Password salah');
  end;

end;

end.
