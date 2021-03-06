unit DTLeitorOFX;

interface

uses
  System.SysUtils, System.Classes;

type
  TOFXItem = class
    MovType: String;
    MovDate: TDateTime;
    Value: Currency;
    ID: string;
    Document: string;
    Description: string;
  end;

type
  TDTLeitorOFX = class(TComponent)
  private
    FOFXFile: string;
    FListItems: TList;
    FPositivarDebito: Boolean;
    procedure Clear;
    procedure Delete(iIndex: integer);
    function Add: TOFXItem;
    function InfLine(sLine: string): string;
    function FindString(sSubString, sString: string): boolean;
    procedure setPositivarDebito(const Value: Boolean);
    function PrimeiraPalavra(S : String) : String;
  protected

  public
    BankID: String;
    BranchID: string;
    AccountID: string;
    AccountType: string;
    BankName: string;
    DateStart: string;
    DateEnd: string;
    FinalBalance: String;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Import: boolean;
    function Get(iIndex: integer): TOFXItem;
    function Count: integer;
  published
    property CaminhoArqOFX: string read FOFXFile write FOFXFile;
    property PositivarDebito:Boolean read FPositivarDebito write setPositivarDebito;

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('DT Inovacao', [TDTLeitorOFX]);
end;

{ TDTLeitorOFX }

function TDTLeitorOFX.PrimeiraPalavra(S : String) : String;
var
i : Integer;
begin
i := Pos('\' ,S);
if i > 0 then
Result := Copy(S,1,i-1)
else
Result := S;
end;

function TDTLeitorOFX.Add: TOFXItem;
var
  oItem: TOFXItem;
begin
  oItem := TOFXItem.Create;
  FListItems.Add(oItem);
  Result := oItem;
end;

procedure TDTLeitorOFX.Clear;
begin
    while FListItems.Count > 0 do
    Delete(0);
    FListItems.Clear;
end;

function TDTLeitorOFX.Count: integer;
begin
    Result := FListItems.Count;
end;

constructor TDTLeitorOFX.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FListItems := TList.Create;
end;

procedure TDTLeitorOFX.Delete(iIndex: integer);
begin
     TOFXItem(FListItems.Items[iIndex]).Free;
     FListItems.Delete(iIndex);
end;

destructor TDTLeitorOFX.Destroy;
begin
  Clear;
  FListItems.Free;
  inherited Destroy;
end;

function TDTLeitorOFX.FindString(sSubString, sString: string): boolean;
begin
    Result := Pos(UpperCase(sSubString), UpperCase(sString)) > 0;
end;

function TDTLeitorOFX.Get(iIndex: integer): TOFXItem;
begin
    Result := TOFXItem(FListItems.Items[iIndex]);
end;

function TDTLeitorOFX.Import: boolean;
var
  oFile: TStringList;
  i: integer;
  bOFX: boolean;
  oItem: TOFXItem;
  sLine: string;
  Valor:string;
begin
  Clear;
  DateStart := '';
  DateEnd   := '';
  bOFX      := false;
  if not FileExists(FOFXFile) then
    raise Exception.Create('File not found!');
  oFile := TStringList.Create;
  try
    oFile.LoadFromFile(FOFXFile);
    i := 0;

    while i < oFile.Count do
    begin
      sLine := oFile.Strings[i];
      if FindString('<OFX>', sLine) or FindString('<OFC>', sLine) then
        bOFX := true;

      if bOFX then
      begin
        // Bank
        if FindString('<BANKID>', sLine) then
          BankID := InfLine(sLine);

        // Bank Name
        if FindString('<ORG>', sLine) then
          BankName := InfLine(sLine);

        // Agency
        if FindString('<BRANCHID>', sLine) then
          BranchID := InfLine(sLine);

        // Account
        if FindString('<ACCTID>', sLine) then
          AccountID := InfLine(sLine);

        // Account type
        if FindString('<ACCTTYPE>', sLine) then
          AccountType := InfLine(sLine);


        // Date Start and Date End
        if FindString('<DTSTART>', sLine) then
        begin
          if Trim(sLine) <> '' then
            DateStart :=
              DateToStr(EncodeDate(StrToIntDef(copy(InfLine(sLine), 1, 4), 0),
              StrToIntDef(copy(InfLine(sLine), 5, 2), 0),
              StrToIntDef(copy(InfLine(sLine), 7, 2), 0)));
        end;
        if FindString('<DTEND>', sLine) then
        begin
          if Trim(sLine) <> '' then
            DateEnd :=
              DateToStr(EncodeDate(StrToIntDef(copy(InfLine(sLine), 1, 4), 0),
              StrToIntDef(copy(InfLine(sLine), 5, 2), 0),
              StrToIntDef(copy(InfLine(sLine), 7, 2), 0)));
        end;

        // Final
        if FindString('<LEDGER>', sLine) or FindString('<BALAMT>', sLine) then
          FinalBalance := InfLine(sLine);

        // Movement
        if FindString('<STMTTRN>', sLine) then
        begin
          oItem := Add;
          while not FindString('</STMTTRN>', sLine) do
          begin
            Inc(i);
            sLine := oFile.Strings[i];

          if FindString('<TRNTYPE>', sLine) then
          begin
             if (InfLine(sLine) = '0') or (InfLine(sLine) = 'CREDIT') OR (InfLine(sLine) = 'DEP') then
                oItem.MovType := 'C'
             else
             if (InfLine(sLine) = '1') or (InfLine(sLine) = 'DEBIT') OR (InfLine(sLine) = 'XFER') then
                oItem.MovType := 'D'
              else
                oItem.MovType := 'OTHER';
            end;

            if FindString('<DTPOSTED>', sLine) then
              oItem.MovDate :=
                EncodeDate(StrToIntDef(copy(InfLine(sLine), 1, 4), 0),
                StrToIntDef(copy(InfLine(sLine), 5, 2), 0),
                StrToIntDef(copy(InfLine(sLine), 7, 2), 0));

            if FindString('<FITID>', sLine) then
              oItem.ID := InfLine(sLine);

            if FindString('<CHKNUM>', sLine) or FindString('<CHECKNUM>', sLine) then
              oItem.Document := InfLine(sLine);

            if FindString('<MEMO>', sLine) then
              oItem.Description := InfLine(sLine);

            if FindString('<TRNAMT>', sLine) then
            begin
              valor       :=  InfLine(sLine);
              Valor       := Valor.Replace('.',',');
              if FPositivarDebito then
              begin
                  if StrToFloat( valor ) < 0 then
                  begin
                      oItem.Value := StrToFloat( valor ) * -1;
                  end else begin
                      oItem.Value := StrToFloat( valor );
                  end;
              end else begin
                  oItem.Value := StrToFloat( valor );
              end;
            end;

            if oItem.Document = '' then
            oItem.Document := PrimeiraPalavra(oItem.ID);

          end;
        end;
      end;
      Inc(i);
    end;
    Result := bOFX;
  finally
    oFile.Free;
  end;
end;

function TDTLeitorOFX.InfLine(sLine: string): string;
var
  iTemp: integer;
begin
  Result := '';
  sLine := Trim(sLine);
  if FindString('>', sLine) then
  begin
    sLine := Trim(sLine);
    iTemp := Pos('>', sLine);
    if Pos('</', sLine) > 0 then
      Result := copy(sLine, iTemp + 1, Pos('</', sLine) - iTemp - 1)
    else
      // allows you to read the whole line when there is no completion of </ on the same line
      // made by weberdepaula@gmail.com
      Result := copy(sLine, iTemp + 1, length(sLine));
  end;
end;

procedure TDTLeitorOFX.setPositivarDebito(const Value: Boolean);
begin
  FPositivarDebito := Value;
end;

end.
