unit usecase.actions;

interface

uses
  serializable.response,
  servidor.components,
  models.contracts,
  serializable.notafiscal;

type
  TAction = class
  private
    FComponent: IComponent;
    FFactory: IFactoryModels;

  protected
    procedure ConfigurarComponente;
    procedure AlimetarNFC(Value: TNotaFiscal);
  public
    constructor Create;

    function Emitir(Value: TNotaFiscal): TResponse;
  end;

implementation

uses
  System.SysUtils,
  models.factory,
  ACBrDFeSSL,
  pcnConversao,
  pcnConversaoNFe,
  blcksock,
  ACBrDFeUtil;

procedure TAction.AlimetarNFC(Value: TNotaFiscal);
begin
  with FComponent.ACBrNFe.NotasFiscais.Add.NFe do
  begin
    Ide.natOp := 'VENDA';
    Ide.indPag := ipVista;
    Ide.modelo := 65;
    Ide.serie := 1;
    Ide.nNF := StrToInt(FFactory.Ide.nNF);
    Ide.cNF := GerarCodigoDFe(Ide.nNF);
    Ide.dEmi := now;
    Ide.dSaiEnt := now;
    Ide.hSaiEnt := now;
    Ide.tpNF := tnSaida;
    Ide.tpEmis := TpcnTipoEmissao(FFactory.Ide.tpEmis);
    Ide.tpAmb := TpcnTipoAmbiente(FFactory.Ide.tpAmb);
    Ide.cUF := UFtoCUF(FFactory.Emitente.Endereco.UF);
    Ide.cMunFG := StrToInt(FFactory.Emitente.Endereco.xMun);
    Ide.finNFe := TpcnFinalidadeNFe(FFactory.Ide.finNFe);
    Ide.tpImp := tiNFCe;
    Ide.indFinal := cfConsumidorFinal;
    Ide.indPres := pcPresencial;
    Ide.indIntermed := iiSemOperacao;

    Emit.CNPJCPF := FFactory.Emitente.CNPJCPF;
    Emit.IE := FFactory.Emitente.IE;
    Emit.xNome := FFactory.Emitente.xNome;
    Emit.xFant := FFactory.Emitente.xFant;

    Emit.EnderEmit.fone := FFactory.Emitente.fone;
    Emit.EnderEmit.CEP := FFactory.Emitente.Endereco.CEP;
    Emit.EnderEmit.xLgr := FFactory.Emitente.Endereco.xLgr;
    Emit.EnderEmit.nro := FFactory.Emitente.Endereco.nro;
    Emit.EnderEmit.xCpl := FFactory.Emitente.Endereco.xCpl;
    Emit.EnderEmit.xBairro := FFactory.Emitente.Endereco.xBairro;
    Emit.EnderEmit.cMun := FFactory.Emitente.Endereco.cMun;
    Emit.EnderEmit.xMun := FFactory.Emitente.Endereco.xMun;
    Emit.EnderEmit.UF := FFactory.Emitente.Endereco.UF;
    Emit.EnderEmit.cPais := FFactory.Emitente.Endereco.cPais;
    Emit.EnderEmit.xPais := FFactory.Emitente.Endereco.xPais;
    Emit.IEST := '';
    var Ok: Boolean;
    Emit.CRT := StrToCRT(Ok, IntToStr(FFactory.Emitente.CRT.ToInteger + 1));

    Retirada.CNPJCPF := '';
    Retirada.xLgr := '';
    Retirada.nro := '';
    Retirada.xCpl := '';
    Retirada.xBairro := '';
    Retirada.cMun := 0;
    Retirada.xMun := '';
    Retirada.UF := '';

    Entrega.CNPJCPF := '';
    Entrega.xLgr := '';
    Entrega.nro := '';
    Entrega.xCpl := '';
    Entrega.xBairro := '';
    Entrega.cMun := 0;
    Entrega.xMun := '';
    Entrega.UF := '';

    with Det.New do
    begin
      Prod.nItem := Value.produto[0].nItem;
      Prod.cProd := Value.produto[0].cProd;
      Prod.cEAN := Value.produto[0].cEAN;
      Prod.xProd := Value.produto[0].xProd;
      Prod.NCM := Value.produto[0].NCM;
      Prod.EXTIPI := Value.produto[0].EXTIPI;
      Prod.CFOP := Value.produto[0].CFOP;
      Prod.uCom := Value.produto[0].uCom;
      Prod.qCom := Value.produto[0].qCom;
      Prod.vUnCom := Value.produto[0].vUnCom;
      Prod.vProd := Value.produto[0].vProd;

      Prod.cEANTrib := Value.produto[0].cEAN;
      Prod.uTrib := Value.produto[0].uCom;
      Prod.qTrib := Value.produto[0].qCom;
      Prod.vUnTrib := Value.produto[0].vUnCom;

      Prod.vOutro := 0;
      Prod.vFrete := 0;
      Prod.vSeg := 0;
      Prod.vDesc := 0;

      Prod.CEST := Value.produto[0].CEST;

      Prod.cBarra := Value.produto[0].cBarra;
      Prod.cBarraTrib := Value.produto[0].cBarra;

      with Imposto do
      begin
        vTotTrib := 0;

        with ICMS do
        begin

          if Emit.CRT in [crtSimplesExcessoReceita, crtRegimeNormal] then
            CST := cst00
          else
            CSOSN := csosn102;

          orig := oeNacional;
          modBC := dbiValorOperacao;


          vBC := 0;
          pICMS := 18;

          vICMS := (vBC * pICMS);
          modBCST := dbisMargemValorAgregado;
          pMVAST := 0;
          pRedBCST := 0;
          vBCST := 0;
          pICMSST := 0;
          vICMSST := 0;
          pRedBC := 0;

          pCredSN := 5;
          vCredICMSSN := 50;
          vBCFCPST := 100;
          pFCPST := 2;
          vFCPST := 2;
          vBCSTRet := 0;
          pST := 0;
          vICMSSubstituto := 0;
          vICMSSTRet := 0;

          vBCFCPSTRet := 0;
          pFCPSTRet := 0;
          vFCPSTRet := 0;
          pRedBCEfet := 0;
          vBCEfet := 0;
          pICMSEfet := 0;
          vICMSEfet := 0;

          vICMSSTDeson := 0;

          motDesICMSST := mdiOutros;

          pFCPDif := 0;

          vFCPDif := 0;

          vFCPEfet := 0;

          with ICMSUFDest do
          begin
            vBCUFDest := 0.00;
            pFCPUFDest := 0.00;
            pICMSUFDest := 0.00;
            pICMSInter := 0.00;
            pICMSInterPart := 0.00;
            vFCPUFDest := 0.00;
            vICMSUFDest := 0.00;
            vICMSUFRemet := 0.00;
          end;
        end;

        with PIS do
        begin
          CST := pis99;
          PIS.vBC := 0;
          PIS.pPIS := 0;
          PIS.vPIS := 0;

          PIS.qBCProd := 0;
          PIS.vAliqProd := 0;
          PIS.vPIS := 0;
        end;

        with PISST do
        begin
          vBC := 0;
          pPIS := 0;
          qBCProd := 0;
          vAliqProd := 0;
          vPIS := 0;

          IndSomaPISST := ispNenhum;
        end;

        with COFINS do
        begin
          CST := cof99;
          COFINS.vBC := 0;
          COFINS.pCOFINS := 0;
          COFINS.vCOFINS := 0;

          COFINS.qBCProd := 0;
          COFINS.vAliqProd := 0;
        end;

        with COFINSST do
        begin
          vBC := 0;
          pCOFINS := 0;
          qBCProd := 0;
          vAliqProd := 0;
          vCOFINS := 0;

          indSomaCOFINSST := iscNenhum;
        end;
      end;
    end;

    Total.ICMSTot.vBC := 0;
    Total.ICMSTot.vICMS := 0;
    Total.ICMSTot.vBCST := 0;
    Total.ICMSTot.vST := 0;
    Total.ICMSTot.vProd := 100;
    Total.ICMSTot.vFrete := 0;
    Total.ICMSTot.vSeg := 0;
    Total.ICMSTot.vDesc := 0;
    Total.ICMSTot.vII := 0;
    Total.ICMSTot.vIPI := 0;
    Total.ICMSTot.vPIS := 0;
    Total.ICMSTot.vCOFINS := 0;
    Total.ICMSTot.vOutro := 0;
    Total.ICMSTot.vNF := 100;

    Total.ICMSTot.vFCPUFDest := 0.00;
    Total.ICMSTot.vICMSUFDest := 0.00;
    Total.ICMSTot.vICMSUFRemet := 0.00;

    Total.ISSQNtot.vServ := 0;
    Total.ISSQNtot.vBC := 0;
    Total.ISSQNtot.vISS := 0;
    Total.ISSQNtot.vPIS := 0;
    Total.ISSQNtot.vCOFINS := 0;

    Total.retTrib.vRetPIS := 0;
    Total.retTrib.vRetCOFINS := 0;
    Total.retTrib.vRetCSLL := 0;
    Total.retTrib.vBCIRRF := 0;
    Total.retTrib.vIRRF := 0;
    Total.retTrib.vBCRetPrev := 0;
    Total.retTrib.vRetPrev := 0;

    Transp.modFrete := mfSemFrete; // NFC-e não pode ter FRETE

    with pag.New do
    begin
      tPag := TpcnFormaPagamento(Value.pagamento[0].tPag);
      vPag := Value.pagamento[0].valor;
    end;

    InfAdic.infCpl := '';
    InfAdic.infAdFisco := '';

    with InfAdic.obsCont.New do
    begin
      xCampo := 'ObsCont';
      xTexto := 'Texto';
    end;

    with InfAdic.obsFisco.New do
    begin
      xCampo := 'ObsFisco';
      xTexto := 'Texto';
    end;

    infIntermed.CNPJ := '';
    infIntermed.idCadIntTran := '';
  end;
end;

procedure TAction.ConfigurarComponente;
begin
  FComponent.ACBrNFe.Configuracoes.Certificados.URLPFX :=
    FFactory.Configuracoes.Certificado.URL;
  FComponent.ACBrNFe.Configuracoes.Certificados.ArquivoPFX :=
    FFactory.Configuracoes.Certificado.Caminho;
  FComponent.ACBrNFe.Configuracoes.Certificados.Senha :=
    FFactory.Configuracoes.Certificado.Senha;
  FComponent.ACBrNFe.Configuracoes.Certificados.NumeroSerie :=
    FFactory.Configuracoes.Certificado.serie;

  FComponent.ACBrNFe.SSL.DescarregarCertificado;

  with FComponent.ACBrNFe.Configuracoes.Geral do
  begin
    SSLLib := TSSLLib(FFactory.Configuracoes.SSLLib);
    SSLCryptLib := TSSLCryptLib(FFactory.Configuracoes.SSLCryptLib);
    SSLHttpLib := TSSLHttpLib(FFactory.Configuracoes.SSLHttpLib);
    SSLXmlSignLib := TSSLXmlSignLib(FFactory.Configuracoes.SSLXmlSignLib);

    AtualizarXMLCancelado := FFactory.Configuracoes.AtualizarXMLCancelado;

    Salvar := FFactory.Configuracoes.Salvar;
    ExibirErroSchema := FFactory.Configuracoes.ExibirErroSchema;
    RetirarAcentos := FFactory.Configuracoes.RetirarAcentos;
    FormatoAlerta := FFactory.Configuracoes.FormatoAlerta;
    FormaEmissao := TpcnTipoEmissao(FFactory.Configuracoes.FormaEmissao);
    ModeloDF := TpcnModeloDF(FFactory.Configuracoes.ModeloDF);
    VersaoDF := TpcnVersaoDF(FFactory.Configuracoes.VersaoDF);

    IdCSC := FFactory.Configuracoes.IdCSC;
    CSC := FFactory.Configuracoes.CSC;
    VersaoQRCode := TpcnVersaoQrCode(FFactory.Configuracoes.VersaoQRCode);
  end;

  with FComponent.ACBrNFe.Configuracoes.WebServices do
  begin
    UF := FFactory.Configuracoes.WebService.UF;
    var
      Ok: Boolean;
    Ambiente := StrToTpAmb(Ok,
      IntToStr(FFactory.Configuracoes.WebService.Ambiente + 1));
    Visualizar := FFactory.Configuracoes.WebService.Visualizar;
    Salvar := FFactory.Configuracoes.WebService.Salvar;

    AjustaAguardaConsultaRet := FFactory.Configuracoes.WebService.
      AjustaAguardaConsultaRet;

    AguardarConsultaRet := FFactory.Configuracoes.WebService.
      AguardarConsultaRet;

    Tentativas := FFactory.Configuracoes.WebService.Tentativas;

    IntervaloTentativas := FFactory.Configuracoes.WebService.
      IntervaloTentativas;

    TimeOut := FFactory.Configuracoes.WebService.TimeOut;
    ProxyHost := FFactory.Configuracoes.WebService.ProxyHost;
    ProxyPort := FFactory.Configuracoes.WebService.ProxyPort;
    ProxyUser := FFactory.Configuracoes.WebService.ProxyUser;
    ProxyPass := FFactory.Configuracoes.WebService.ProxyPass;
  end;

  FComponent.ACBrNFe.SSL.SSLType := TSSLType(FFactory.Configuracoes.SSLType);

  with FComponent.ACBrNFe.Configuracoes.Arquivos do
  begin
    Salvar := FFactory.Configuracoes.Arquivo.Salvar;
    SepararPorMes := FFactory.Configuracoes.Arquivo.SepararPorMes;
    AdicionarLiteral := FFactory.Configuracoes.Arquivo.AdicionarLiteral;
    EmissaoPathNFe := FFactory.Configuracoes.Arquivo.EmissaoPathNFe;
    SalvarEvento := FFactory.Configuracoes.Arquivo.SalvarEvento;
    SepararPorCNPJ := FFactory.Configuracoes.Arquivo.SepararPorCNPJ;
    SepararPorModelo := FFactory.Configuracoes.Arquivo.SepararPorModelo;
    PathSchemas := FFactory.Configuracoes.Arquivo.PathSchemas;
    PathNFe := FFactory.Configuracoes.Arquivo.PathNFe;
    PathInu := FFactory.Configuracoes.Arquivo.PathInu;
    PathEvento := FFactory.Configuracoes.Arquivo.PathEvento;
    PathSalvar := FFactory.Configuracoes.Arquivo.PathSalvar;
  end;

  FComponent.ACBrNFe.DANFE.Logo := FFactory.Configuracoes.Logo;
  FComponent.ACBrNFe.DANFE.PathPDF := FFactory.Configuracoes.PathPDF;
end;

constructor TAction.Create;
begin
  FComponent := TComponentes.Create(nil);
  FFactory := TFactoryModels.New;
end;

function TAction.Emitir(Value: TNotaFiscal): TResponse;
begin;
  Result := TResponse.Create;
  ConfigurarComponente;
  AlimetarNFC(Value);

  FComponent.ACBrNFe.NotasFiscais.ImprimirPDF;
  Result.id := TGUID.NewGuid.ToString();
  Result.ambiente :=  TpAmbToStr(TpcnTipoAmbiente(FFactory.Configuracoes.WebService.Ambiente));
  Result.created := now;
  Result.status := 100;
  Result.motivo := 'Emitida a NFC';
  Result.protocolo := '123456567';
  Result.chave := FComponent.ACBrNFe.NotasFiscais.Items[0].NFe.infNFe.ID;
  Result.xml :=   FComponent.ACBrNFe.NotasFiscais.Items[0].NomeArq;
end;

end.
