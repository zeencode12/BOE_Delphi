program Project4;

uses
  System.StartUpCopy,
  FMX.Forms,
  app in 'app.pas' {FormLogin},
  beranda in 'beranda.pas' {FormBeranda};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormLogin, FormLogin);
  Application.CreateForm(TFormBeranda, FormBeranda);
  Application.Run;
end.
