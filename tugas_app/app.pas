unit app;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.IOUtils,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.Layouts, FMX.ExtCtrls, Beranda,
  FMX.Objects, FMX.Ani;

type
  TFormLogin = class(TForm)
    Button1: TButton;
    edUser: TEdit;
    edPass: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Rectangle1: TRectangle;
    RectAnimation1: TRectAnimation;
    procedure Button1Click(Sender: TObject);
  private
  public
  end;

var
  FormLogin: TFormLogin;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}


procedure TFormLogin.Button1Click(Sender: TObject);
begin
  if (edUser.Text = 'admin') and (edPass.Text = '12345') then
  begin
    ShowMessage('Login berhasil');

    FormBeranda.Show;
    FormLogin.Hide;
  end
  else
  begin
    ShowMessage('Username atau Password salah');
    edPass.Text := '';
    edPass.SetFocus;
  end;
end;

end.
