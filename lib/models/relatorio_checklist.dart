import 'dart:typed_data';

class RelatorioChecklist {
  // Dados do Projeto
  String nomeProjeto;
  String dataProjeto;
  String identificacaoPainel;

  // Dados dos Testes
  List<String> nomeRealizacaoTestes;
  String setorTestes;
  String dataTestes;

  // Dados da Montagem
  List<String> nomeRealizacaoMontagem;
  String setorMontagem;
  String dataMontagem;

  // Checklist
  Map<String, String> statusTestes;
  Map<String, String> observacoesTestes;

  // Aprovação
  String nomeResponsavel;
  String dataAprovacao;

  // Assinatura
  String? assinaturaBase64;
  Uint8List? assinaturaBytes;

  RelatorioChecklist({
    this.nomeProjeto = '',
    this.dataProjeto = '',
    this.identificacaoPainel = '',

    // LISTAS CORRETAS (NÃO SÃO STRING MAIS)
    List<String>? nomeRealizacaoTestes,
    this.setorTestes = '',
    this.dataTestes = '',

    List<String>? nomeRealizacaoMontagem,
    this.setorMontagem = '',
    this.dataMontagem = '',

    Map<String, String>? statusTestes,
    Map<String, String>? observacoesTestes,

    this.nomeResponsavel = '',
    this.dataAprovacao = '',
    this.assinaturaBase64,
    this.assinaturaBytes,

  })  : nomeRealizacaoTestes = nomeRealizacaoTestes ?? [],
        nomeRealizacaoMontagem = nomeRealizacaoMontagem ?? [],
        statusTestes = statusTestes ?? {},
        observacoesTestes = observacoesTestes ?? {};
}