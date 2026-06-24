import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/relatorio_checklist.dart';

class PdfService {
  static const List<String> itensChecklist = [
    'Configuração Drivers',
    'Configuração Sensores',
    'Configuração Instrumentos',
    'Configuração Atuadores',
    'Teste IO Entrada Digital',
    'Teste IO Saída Digital',
    'Teste IO Entrada Analógica',
    'Teste IO Saída Analógica',
    'Teste Interface de Operação (IHM)',
    'Teste da Lógica da Programação',
    'Teste de Estanqueidade',
    'Backup Parâmetros Instrumentos',
    'Backup Parâmetros Inversores',
  ];

  static Future<Uint8List> gerarPdf(
    RelatorioChecklist r,
  ) async {

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,

        build: (context) {

          return pw.Stack(
            children: [

              // CABEÇALHO

              pw.Positioned(
                left: 20,
                top: 20,
                child: pw.Container(
                  width: 555,
                  height: 40,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                  ),
                  child: pw.Row(
                    children: [

                      pw.Container(
                        width: 200,
                        alignment: pw.Alignment.center,
                        child: pw.Text(
                          'interactive',
                          style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),

                      pw.Expanded(
                        child: pw.Container(
                          color: PdfColors.grey800,
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            'Check List Teste Painel',
                            style: pw.TextStyle(
                              color: PdfColors.white,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // PROJETO

              _linha(
                top: 60,
                titulo: 'Nome do Projeto',
                valor: r.nomeProjeto,
              ),

              _linha(
                top: 80,
                titulo: 'Data',
                valor: r.dataProjeto,
              ),

              _linha(
                top: 100,
                titulo: 'Identificação do Painel',
                valor: r.identificacaoPainel,
              ),

              // TESTES

              pw.Positioned(
                left: 20,
                top: 130,
                child: pw.Container(
                  width: 555,
                  height: 60,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                  ),
                  padding: const pw.EdgeInsets.all(5),
                  child: pw.Column(
                    crossAxisAlignment:
                        pw.CrossAxisAlignment.start,
                    children: [

                      pw.Text(
                        'REALIZADORES DOS TESTES',
                        style: pw.TextStyle(
                          fontWeight:
                              pw.FontWeight.bold,
                        ),
                      ),

                      pw.Text(
                        r.nomeRealizacaoTestes.join(
                          '\n',
                        ),
                      ),

                      pw.Text(
                        'Setor: ${r.setorTestes}',
                      ),

                      pw.Text(
                        'Data: ${r.dataTestes}',
                      ),
                    ],
                  ),
                ),
              ),

              // MONTAGEM

              pw.Positioned(
                left: 20,
                top: 200,
                child: pw.Container(
                  width: 555,
                  height: 80,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                  ),
                  padding: const pw.EdgeInsets.all(5),
                  child: pw.Column(
                    crossAxisAlignment:
                        pw.CrossAxisAlignment.start,
                    children: [

                      pw.Text(
                        'REALIZADORES DA MONTAGEM',
                        style: pw.TextStyle(
                          fontWeight:
                              pw.FontWeight.bold,
                        ),
                      ),

                      pw.Text(
                        r.nomeRealizacaoMontagem.join(
                          '\n',
                        ),
                      ),

                      pw.Text(
                        'Setor: ${r.setorMontagem}',
                      ),

                      pw.Text(
                        'Data: ${r.dataMontagem}',
                      ),
                    ],
                  ),
                ),
              ),

              // CHECKLIST

              pw.Positioned(
                left: 20,
                top: 300,
                child: pw.Container(
                  width: 555,
                  child: _tabelaChecklist(r),
                ),
              ),

              // APROVAÇÃO

              pw.Positioned(
                left: 20,
                top: 650,
                child: pw.Container(
                  width: 555,
                  height: 90,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                  ),
                  padding: const pw.EdgeInsets.all(5),
                  child: pw.Row(
                    crossAxisAlignment:
                        pw.CrossAxisAlignment.start,
                    children: [

                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment:
                              pw.CrossAxisAlignment.start,
                          children: [

                            pw.Text(
                              'Responsável',
                              style: pw.TextStyle(
                                fontWeight:
                                    pw.FontWeight.bold,
                              ),
                            ),

                            pw.Text(
                              r.nomeResponsavel,
                            ),
                          ],
                        ),
                      ),

                      pw.SizedBox(width: 20),

                      pw.Column(
                        crossAxisAlignment:
                            pw.CrossAxisAlignment.start,
                        children: [

                          pw.Text(
                            'Data',
                            style: pw.TextStyle(
                              fontWeight:
                                  pw.FontWeight.bold,
                            ),
                          ),

                          pw.Text(
                            r.dataAprovacao,
                          ),
                        ],
                      ),

                      pw.SizedBox(width: 30),

                      if (r.assinaturaBytes != null)
                        pw.Image(
                          pw.MemoryImage(
                            r.assinaturaBytes!,
                          ),
                          width: 150,
                          height: 60,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.TableRow _linhaTabela(
    String titulo,
    String valor,
  ) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(
            titulo,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(valor),
        ),
      ],
    );
  }

  static pw.Widget _cabecalho(
    String texto,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        texto,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }
  static pw.Widget _linha({
    required double top,
    required String titulo,
    required String valor,
  }) {
    return pw.Positioned(
      left: 20,
      top: top,
      child: pw.Container(
        width: 555,
        height: 20,
        decoration: pw.BoxDecoration(
          border: pw.Border.all(),
        ),
        child: pw.Row(
          children: [

            pw.Container(
              width: 200,
              padding: const pw.EdgeInsets.only(
                left: 5,
              ),
              alignment:
                  pw.Alignment.centerLeft,
              child: pw.Text(titulo),
            ),

            pw.Container(
              width: 355,
              padding: const pw.EdgeInsets.only(
                left: 5,
              ),
              alignment:
                  pw.Alignment.centerLeft,
              child: pw.Text(valor),
            ),
          ],
        ),
      ),
    );
  }

  static pw.Widget _celula(
    String texto, {
    bool alinhadoCentro = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        texto,
        textAlign: alinhadoCentro
            ? pw.TextAlign.center
            : pw.TextAlign.left,
      ),
    );
  }
  static pw.Widget _tabelaChecklist(
    RelatorioChecklist r,
  ) {
    return pw.Table(
      border: pw.TableBorder.all(),
      children: [

        pw.TableRow(
          decoration: const pw.BoxDecoration(
            color:PdfColors.grey300,
          ),
          children: [
            _headerCell('#'),
            _headerCell('Descrição'),
            _headerCell('Aprovado'),
            _headerCell('Recusado'),
            _headerCell('N/A'),
            _headerCell('Observação'),
          ],
        ),

        ...List.generate(
          itensChecklist.length,
          (index) {

            final item =
                itensChecklist[index];

            final status =
                r.statusTestes[item] ?? '';

            return pw.TableRow(
              children: [

                _cell(
                  '${index + 1}',
                ),

                _cell(item),

                _cell(
                  status == 'Aprovado'
                      ? 'X'
                      : '',
                ),

                _cell(
                  status == 'Recusado'
                      ? 'X'
                      : '',
                ),

                _cell(
                  status == 'N/A'
                      ? 'X'
                      : '',
                ),

                _cell(
                  r.observacoesTestes[item]
                      ?? '',
                ),
              ],
            );
          },
        ),
      ],
    );
  }
  static pw.Widget _cell(
    String texto,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        texto,
        style: const pw.TextStyle(
          fontSize: 8,
        ),
      ),
    );
  }
  static pw.Widget _headerCell(
    String texto,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(3),
      child: pw.Text(
        texto,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 8,
        ),
      ),
    );
  }
}