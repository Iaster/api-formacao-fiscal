unit models.endereco;

interface

uses
  System.SysUtils,
  System.IniFiles,
  models.contracts;

type
  TEndereco = class(TInterfacedObject, IEndereco)
  private
    FIni: TIniFile;

    constructor Create(Value: TIniFile);
    destructor Destroy; override;
  public
    class function New(Value: TIniFile): IEndereco;

    function CEP(Value: Integer): IEndereco; overload;
    function CEP: Integer; overload;
    function xLgr(Value: String): IEndereco; overload;
    function xLgr: String; overload;
    function nro(Value: String): IEndereco; overload;
    function nro: String; overload;
    function xCpl(Value: String): IEndereco; overload;
    function xCpl: String; overload;
    function xBairro(Value: String): IEndereco; overload;
    function xBairro: String; overload;
    function xMun(Value: String): IEndereco; overload;
    function xMun: String; overload;
    function cMun(Value: Integer): IEndereco; overload;
    function cMun: Integer; overload;
    function UF(Value: String): IEndereco; overload;
    function UF: String; overload;
    function cPais(Value: Integer): IEndereco; overload;
    function cPais: Integer; overload;
    function xPais(Value: String): IEndereco; overload;
    function xPais: String; overload;
  end;

implementation

{ TEndereco }

function TEndereco.CEP(Value: Integer): IEndereco;
begin
  Result := Self;
  FIni.WriteInteger('EMITENTE', 'CEP', Value);
end;

function TEndereco.CEP: Integer;
begin
  FIni.ReadInteger('EMITENTE', 'CEP', Result);
end;

function TEndereco.cMun: Integer;
begin
  FIni.ReadInteger('EMITENTE', 'cMun', Result);
end;

function TEndereco.cMun(Value: Integer): IEndereco;
begin
  Result := Self;
  FIni.WriteInteger('EMITENTE', 'cMun', Value);
end;

function TEndereco.cPais: Integer;
begin
  FIni.ReadInteger('EMITENTE', 'cPais', 1058);
end;

function TEndereco.cPais(Value: Integer): IEndereco;
begin
  Result := Self;
  FIni.WriteInteger('EMITENTE', 'cPais', Value);
end;

constructor TEndereco.Create(Value: TIniFile);
begin
  FIni := Value;
end;

destructor TEndereco.Destroy;
begin

  inherited;
end;

class function TEndereco.New(Value: TIniFile): IEndereco;
begin
  Result := Self.Create(Value);
end;

function TEndereco.nro(Value: String): IEndereco;
begin
  Result := Self;
  FIni.WriteString('EMITENTE', 'nro', Value);
end;

function TEndereco.nro: String;
begin
  FIni.ReadString('EMITENTE', 'nro', Result);
end;

function TEndereco.UF: String;
begin
  FIni.ReadString('EMITENTE', 'UF', Result);
end;

function TEndereco.UF(Value: String): IEndereco;
begin
  Result := Self;
  FIni.WriteString('EMITENTE', 'UF', Value);
end;

function TEndereco.xBairro(Value: String): IEndereco;
begin
  Result := Self;
  FIni.WriteString('EMITENTE', 'xBairro', Value);
end;

function TEndereco.xBairro: String;
begin
  FIni.ReadString('EMITENTE', 'xBairro', Result);
end;

function TEndereco.xCpl(Value: String): IEndereco;
begin
  Result := Self;
  FIni.WriteString('EMITENTE', 'xCpl', Value);
end;

function TEndereco.xCpl: String;
begin
  FIni.ReadString('EMITENTE', 'xCpl', Result);
end;

function TEndereco.xLgr(Value: String): IEndereco;
begin
  Result := Self;
  FIni.WriteString('EMITENTE', 'xLgr', Value);
end;

function TEndereco.xLgr: String;
begin
  FIni.ReadString('EMITENTE', 'xLgr', Result);
end;

function TEndereco.xMun: String;
begin
  FIni.ReadString('EMITENTE', 'xMun', Result);
end;

function TEndereco.xMun(Value: String): IEndereco;
begin
  Result := Self;
  FIni.WriteString('EMITENTE', 'xMun', Value);
end;

function TEndereco.xPais: String;
begin
  FIni.ReadString('EMITENTE', 'xPais', 'BRASIL');
end;

function TEndereco.xPais(Value: String): IEndereco;
begin
  Result := Self;
  FIni.WriteString('EMITENTE', 'xPais', Value);
end;

end.
