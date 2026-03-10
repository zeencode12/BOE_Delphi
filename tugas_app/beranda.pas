unit beranda;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.JSON, System.Net.HttpClient, System.Net.URLClient,
  System.Net.HttpClientComponent,
  FMX.DialogService,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.StdCtrls, FMX.Objects, FMX.Edit, FMX.Controls.Presentation,
  FMX.Grid, FMX.Grid.Style, FMX.ScrollBox, FMX.Layouts, System.Rtti,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TFormBeranda = class(TForm)

    imgCoffee: TImage;
    imgLatte: TImage;
    imgTea: TImage;
    imgCroissant: TImage;

    btnCoffee: TButton;
    btnLatte: TButton;
    btnTea: TButton;
    btnCroissant: TButton;

    edTotal: TEdit;
    edBayar: TEdit;
    edKembali: TEdit;

    StringGrid1: TStringGrid;

    btnSimpan: TButton;
    Button1: TButton;
    btnHapus: TButton;

    procedure FormCreate(Sender: TObject);
    procedure btnCoffeeClick(Sender: TObject);
    procedure btnLatteClick(Sender: TObject);
    procedure btnTeaClick(Sender: TObject);
    procedure btnCroissantClick(Sender: TObject);
    procedure edBayarChange(Sender: TObject);
    procedure btnSimpanClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnHapusClick(Sender: TObject);

  private
    procedure SetupGrid;
    procedure TambahItem(nama: string; harga: Integer);
    procedure HitungTotal;
    procedure HitungKembali;
    procedure PreviewTransaksi;
    procedure KirimTransaksi;
    procedure ResetTransaksi;

  public
  end;

var
  FormBeranda: TFormBeranda;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

procedure TFormBeranda.FormCreate(Sender: TObject);
begin
  SetupGrid;

  edTotal.ReadOnly := True;
  edKembali.ReadOnly := True;

  edBayar.KeyboardType := TVirtualKeyboardType.NumberPad;
end;

procedure TFormBeranda.SetupGrid;
var
  col: TStringColumn;
begin
  StringGrid1.BeginUpdate;
  try
    StringGrid1.ClearColumns;

    col := TStringColumn.Create(StringGrid1);
    col.Header := 'Menu';
    col.Parent := StringGrid1;

    col := TStringColumn.Create(StringGrid1);
    col.Header := 'Harga';
    col.Parent := StringGrid1;

    col := TStringColumn.Create(StringGrid1);
    col.Header := 'Qty';
    col.Parent := StringGrid1;

    col := TStringColumn.Create(StringGrid1);
    col.Header := 'Subtotal';
    col.Parent := StringGrid1;

    StringGrid1.RowCount := 1;

  finally
    StringGrid1.EndUpdate;
  end;
end;

procedure TFormBeranda.TambahItem(nama: string; harga: Integer);
var
  row,i,qty,subtotal: Integer;
begin

  // jika grid belum siap
  if StringGrid1.ColumnCount = 0 then
    SetupGrid;

  if StringGrid1.RowCount < 1 then
    StringGrid1.RowCount := 1;

  for i := 1 to StringGrid1.RowCount - 1 do
  begin
    if StringGrid1.Cells[0,i] = nama then
    begin
      qty := StrToIntDef(StringGrid1.Cells[2,i],0) + 1;
      StringGrid1.Cells[2,i] := IntToStr(qty);

      subtotal := qty * harga;
      StringGrid1.Cells[3,i] := IntToStr(subtotal);

      HitungTotal;
      Exit;
    end;
  end;

  row := StringGrid1.RowCount;
  StringGrid1.RowCount := row + 1;

  StringGrid1.Cells[0,row] := nama;
  StringGrid1.Cells[1,row] := IntToStr(harga);
  StringGrid1.Cells[2,row] := '1';
  StringGrid1.Cells[3,row] := IntToStr(harga);

  HitungTotal;
end;

procedure TFormBeranda.HitungTotal;
var
  i,total: Integer;
begin
  total := 0;

  for i := 1 to StringGrid1.RowCount - 1 do
    total := total + StrToIntDef(StringGrid1.Cells[3,i],0);

  edTotal.Text := IntToStr(total);

  HitungKembali;
end;

procedure TFormBeranda.HitungKembali;
var
  bayar,total: Integer;
begin
  bayar := StrToIntDef(edBayar.Text,0);
  total := StrToIntDef(edTotal.Text,0);

  edKembali.Text := IntToStr(bayar - total);
end;

procedure TFormBeranda.edBayarChange(Sender: TObject);
begin
  HitungKembali;
end;

procedure TFormBeranda.btnCoffeeClick(Sender: TObject);
begin
  TambahItem('Coffee',15000);
end;

procedure TFormBeranda.btnLatteClick(Sender: TObject);
begin
  TambahItem('Latte',20000);
end;

procedure TFormBeranda.btnTeaClick(Sender: TObject);
begin
  TambahItem('Tea',10000);
end;

procedure TFormBeranda.btnCroissantClick(Sender: TObject);
begin
  TambahItem('Croissant',18000);
end;

procedure TFormBeranda.btnHapusClick(Sender: TObject);
var
  row,i: Integer;
begin

  if StringGrid1.RowCount <= 1 then
  begin
    TDialogService.ShowMessage('Tidak ada data');
    Exit;
  end;

  row := StringGrid1.Row;

  if row <= 0 then
  begin
    TDialogService.ShowMessage('Pilih data yang ingin dihapus');
    Exit;
  end;

  for i := row to StringGrid1.RowCount - 2 do
  begin
    StringGrid1.Cells[0,i] := StringGrid1.Cells[0,i+1];
    StringGrid1.Cells[1,i] := StringGrid1.Cells[1,i+1];
    StringGrid1.Cells[2,i] := StringGrid1.Cells[2,i+1];
    StringGrid1.Cells[3,i] := StringGrid1.Cells[3,i+1];
  end;

  StringGrid1.RowCount := StringGrid1.RowCount - 1;

  HitungTotal;
end;

procedure TFormBeranda.Button1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFormBeranda.PreviewTransaksi;
var
  i: Integer;
  teks: string;
begin
  teks := 'Daftar Pesanan:' + sLineBreak + sLineBreak;

  for i := 1 to StringGrid1.RowCount - 1 do
  begin
    teks := teks +
      StringGrid1.Cells[0,i] + ' x' +
      StringGrid1.Cells[2,i] + ' = ' +
      StringGrid1.Cells[3,i] + sLineBreak;
  end;

  teks := teks + sLineBreak +
    'Total : ' + edTotal.Text + sLineBreak +
    'Bayar : ' + edBayar.Text + sLineBreak +
    'Kembali : ' + edKembali.Text;

  TDialogService.ShowMessage(teks);
end;

procedure TFormBeranda.btnSimpanClick(Sender: TObject);
begin

  if StrToIntDef(edBayar.Text,0) < StrToIntDef(edTotal.Text,0) then
  begin
    TDialogService.ShowMessage('Uang bayar kurang');
    Exit;
  end;

  PreviewTransaksi;

  KirimTransaksi;

end;

procedure TFormBeranda.KirimTransaksi;
var
  i: Integer;
  jsonObj: TJSONObject;
  jsonArray: TJSONArray;
  item: TJSONObject;
  http: TNetHTTPClient;
  response: IHTTPResponse;
  stream: TStringStream;
begin

  if StringGrid1.RowCount <= 1 then
  begin
    TDialogService.ShowMessage('Belum ada pesanan');
    Exit;
  end;

  jsonObj := TJSONObject.Create;
  jsonArray := TJSONArray.Create;

  try

    for i := 1 to StringGrid1.RowCount - 1 do
    begin
      item := TJSONObject.Create;

      item.AddPair('nama', StringGrid1.Cells[0,i]);
      item.AddPair('harga', StringGrid1.Cells[1,i]);
      item.AddPair('qty', StringGrid1.Cells[2,i]);
      item.AddPair('subtotal', StringGrid1.Cells[3,i]);

      jsonArray.AddElement(item);
    end;

    jsonObj.AddPair('menu', jsonArray);
    jsonObj.AddPair('total', edTotal.Text);
    jsonObj.AddPair('bayar', edBayar.Text);
    jsonObj.AddPair('kembali', edKembali.Text);

    http := TNetHTTPClient.Create(nil);
    stream := TStringStream.Create(jsonObj.ToJSON, TEncoding.UTF8);

    try

      http.CustomHeaders['Content-Type'] := 'application/json';

      response := http.Post(
        'http://localhost:8080/app/api/transaksi.php',
        stream
      );

      TDialogService.ShowMessage('Respon server : ' + response.ContentAsString);

      ResetTransaksi;

    finally
      http.Free;
      stream.Free;
    end;

  finally
    jsonObj.Free;
  end;

end;

procedure TFormBeranda.ResetTransaksi;
begin
  SetupGrid;

  edTotal.Text := '0';
  edBayar.Text := '';
  edKembali.Text := '';
end;

end.
