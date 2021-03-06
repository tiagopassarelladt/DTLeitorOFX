unit Unit5;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DTLeitorOFX, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Datasnap.DBClient, Vcl.ExtCtrls;

type
  TForm5 = class(TForm)
    DTLeitorOFX1: TDTLeitorOFX;
    DBGrid1: TDBGrid;
    Edit1: TEdit;
    Button1: TButton;
    cdsOfx: TClientDataSet;
    dsOFX: TDataSource;
    cboTipos: TComboBox;
    Button2: TButton;
    lblCredito: TLabel;
    lblDebito: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    DBGrid2: TDBGrid;
    cdsTipos: TClientDataSet;
    dsTipos: TDataSource;
    cdsOfxINDEX: TIntegerField;
    cdsOfxID: TStringField;
    cdsOfxDOCUMENT: TStringField;
    cdsOfxMOVDATE: TDateField;
    cdsOfxMOVTYPE: TStringField;
    cdsOfxVALUE: TFloatField;
    cdsOfxDESCRIPTION: TStringField;
    Button3: TButton;
    cdsTiposTIPO: TStringField;
    cdsTiposMOVTYPE: TStringField;
    cdsTiposVALOR: TFloatField;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

procedure TForm5.Button1Click(Sender: TObject);
var
i:integer;
Index:integer;
Creditos,Debitos:Currency;
begin
        Creditos := 0;
        Debitos  := 0;

        if cdsOfx.Active then
        begin
           cdsOfx.EmptyDataSet;
           cdsTipos.EmptyDataSet;
        end else begin
           cdsOfx.CreateDataSet;
           cdsTipos.CreateDataSet;
        end;
        cboTipos.Items.Clear;

        DTLeitorOFX1.CaminhoArqOFX := Edit1.Text;
        DTLeitorOFX1.Import;

        for i := 0 to DTLeitorOFX1.Count - 1 do
        begin
              if not cdsTipos.Locate('TIPO',DTLeitorOFX1.Get(i).Description,[loCaseInsensitive,loPartialKey]) then
              begin
                    cdsTipos.Append;
                    cdsTipos.FieldByName('TIPO').AsString     := DTLeitorOFX1.Get(i).Description;
                    cdsTipos.FieldByName('MOVTYPE').AsString  := DTLeitorOFX1.Get(i).MovType;
                    cdsTipos.FieldByName('VALOR').AsFloat      := 0;
                    cdsTipos.Post;
              end;
        end;

        for i := 0 to DTLeitorOFX1.Count - 1 do
        begin
              Index := cboTipos.Items.IndexOf(DTLeitorOFX1.Get(i).Description);

              if Index<0 then
              begin
                    cboTipos.Items.Add(DTLeitorOFX1.Get(i).Description);
              end;

              if DTLeitorOFX1.Get(i).MovType = 'C' then
              begin
                   Creditos := Creditos + DTLeitorOFX1.Get(i).Value;
              END ELSE begin
                   Debitos  := Debitos + DTLeitorOFX1.Get(i).Value;
              end;

              if cdsTipos.Locate('TIPO',DTLeitorOFX1.Get(i).Description,[loCaseInsensitive,loPartialKey]) then
              begin
                    cdsTipos.Edit;
                    cdsTipos.FieldByName('VALOR').AsFloat := cdsTipos.FieldByName('VALOR').AsFloat + DTLeitorOFX1.Get(i).Value;
                    cdsTipos.Post;
              end;

              cdsOfx.InsertRecord([
                i,
                DTLeitorOFX1.Get(i).ID,
                DTLeitorOFX1.Get(i).Document,
                DTLeitorOFX1.Get(i).MovDate,
                DTLeitorOFX1.Get(i).MovType,
                DTLeitorOFX1.Get(i).Value,
                DTLeitorOFX1.Get(i).Description
              ]);
        end;

        lblCredito.Caption := FormatFloat('#,##0.00', Creditos);
        lblDebito.Caption  := FormatFloat('#,##0.00', Debitos);
        Memo1.Lines.Clear;
        Memo1.Lines.Add('Banco: ' + DTLeitorOFX1.BankName + #13#10 +
                        'Ag: ' + DTLeitorOFX1.BankID + ' - CC: ' + DTLeitorOFX1.AccountID + #13#10 +
                        'Data Inicial: ' + DTLeitorOFX1.DateStart + ' Data Final: ' + DTLeitorOFX1.DateEnd);
end;

procedure TForm5.Button2Click(Sender: TObject);
begin
      cdsOfx.Filter := 'DESCRIPTION LIKE ' + QuotedStr('%' + cboTipos.Text );
      cdsOfx.Filtered := TRUE;
end;

procedure TForm5.Button3Click(Sender: TObject);
begin
    cdsOfx.Filtered := False;
end;

procedure TForm5.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
ShowScrollBar(DBGrid1.Handle,SB_HORZ ,False);
 if odd(cdsOfx.RecNo) then
    DBGrid1.Canvas.Brush.Color:= $00F8F5E6
 else
    DBGrid1.Canvas.Brush.Color:= clWhite;
    TDbGrid(Sender).Canvas.font.Color:= clBlack;

  if cdsOfxMOVTYPE.AsString = 'D' then
  begin
        TDbGrid(Sender).Canvas.font.Color:= clRed ;
  END ELSE begin
        TDbGrid(Sender).Canvas.font.Color:= clBlack ;
  end;

  if gdSelected in State then
  with (Sender as TDBGrid).Canvas do
  begin
    Brush.Color := $00ECE3BD;
    FillRect(Rect);
    Font.Style := [fsbold]
  end;
  TDbGrid(Sender).DefaultDrawDataCell(Rect, TDbGrid(Sender).columns[datacol].field, State);
end;

procedure TForm5.DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
ShowScrollBar(DBGrid2.Handle,SB_HORZ ,False);
 if odd(cdsTipos.RecNo) then
    DBGrid2.Canvas.Brush.Color:= $00F8F5E6
 else
    DBGrid2.Canvas.Brush.Color:= clWhite;
    TDbGrid(Sender).Canvas.font.Color:= clBlack;

  if cdsTiposMOVTYPE.AsString = 'D' then
  begin
        TDbGrid(Sender).Canvas.font.Color:= clRed ;
  END ELSE begin
        TDbGrid(Sender).Canvas.font.Color:= clBlack ;
  end;

  if gdSelected in State then
  with (Sender as TDBGrid).Canvas do
  begin
    Brush.Color := $00ECE3BD;
    FillRect(Rect);
    Font.Style := [fsbold]
  end;
  TDbGrid(Sender).DefaultDrawDataCell(Rect, TDbGrid(Sender).columns[datacol].field, State);
end;

end.
