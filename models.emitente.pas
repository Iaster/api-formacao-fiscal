unit models.emitente;

interface

uses
  System.SysUtils,
  System.IniFiles,
  models.contracts,
  models.endereco;

type
  TEmitente = class(TInterfacedObject, IEmitente)
  private
    FIni: TIniFile;
    LEndereco: IEndereco;

    function GetEndereco: IEndereco;

    constructor Create;
    destructor Destroy; override;
  public
    class function New: IEmitente;

    function CNPJCPF(Value: String): IEmitente; overload;
    function CNPJCPF: String; overload;
    function IE(Value: String): IEmitente; overload;
    function IE: String; overload;
    function xNome(Value: String): IEmitente; overload;
    function xNome: String; overload;
    function xFant(Value: String): IEmitente; overload;
    function xFant: String; overload;
    function fone(Value: String): IEmitente; overload;
    function fone: String; overload;
    function IEST(Value: String): IEmitente; overload;
    function IEST: String; overload;
    function CRT(Value: String): IEmitente; overload;
    function CRT: String; overload;
    function Endereco(Value: IEndereco): IEmitente; overload;
    function Endereco: IEndereco; overload;
  end;

implementation

{ TEmitente }

function TEmitente.CNPJCPF: String;
begin
  FIni.ReadString('EMITENTE', 'CNPJCPF', Result);
end;

constructor TEmitente.Create;
begin
  var LPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+'conf.ini';
  FIni := TIniFile.Create(LPath);
end;

function TEmitente.CNPJCPF(Value: String): IEmitente;
begin
  Result := Self;
  FIni.WriteString('EMITENTE', 'CNPJCPF', Value);
end;

function TEmitente.CRT: String;
begin
  FIni.ReadString('EMITENTE', 'CRT', Result);
end;

destructor TEmitente.Destroy;
begin
  FIni.Free;
  inherited;
end;

function TEmitente.Endereco(Value: IEndereco): IEmitente;
begin
  Result := Self;
  LEndereco := Value;
end;

function TEmitente.Endereco: IEndereco;
begin
  Result := GetEndereco;
end;

function TEmitente.CRT(Value: String): IEmitente;
begin
  Result := Self;
  FIni.WriteString('EMITENTE', 'CRT', Value);
end;

function TEmitente.fone: String;
begin
  FIni.ReadString('EMITENTE', 'fone', Result);
end;

function TEmitente.GetEndereco: IEndereco;
begin
  if not Assigned(LEndereco)
    then LEndereco := TEndereco.New(FIni);
  Result := LEndereco;
end;

function TEmitente.fone(Value: String): IEmitente;
begin
  Result := Self;
  FIni.WriteString('EMITENTE', 'fone', Value);
end;

function TEmitente.IE: String;
begin
  FIni.ReadString('EMITENTE', 'IE', Result);
end;

function TEmitente.IE(Value: String): IEmitente;
begin
  Result := Self;
  FIni.WriteString('EMITENTE', 'IE', Value);
end;

function TEmitente.IEST: String;
begin
  FIni.ReadString('EMITENTE', 'IEST', Result);
end;

function TEmitente.IEST(Value: String): IEmitente;
begin
  Result := Self;
  FIni.WriteString('EMITENTE', 'IEST', Value);
end;

class function TEmitente.New: IEmitente;
begin
  Result := Self.Create;
end;

function TEmitente.xFant(Value: String): IEmitente;
begin
  Result := Self;
  FIni.WriteString('EMITENTE', 'xFant', Value);
end;

function TEmitente.xFant: String;
begin
  FIni.ReadString('EMITENTE', 'xFant', Result);
end;

function TEmitente.xNome(Value: String): IEmitente;
begin
  Result := Self;
  FIni.WriteString('EMITENTE', 'xNome', Value);
end;

function TEmitente.xNome: String;
begin
  FIni.ReadString('EMITENTE', 'xNome', Result);
end;

end.
