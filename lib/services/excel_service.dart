import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../models/relatorio_checklist.dart';

class ExcelService {
  static Future<String> gerarExcel(
    RelatorioChecklist r,
  ) async {

    final ByteData data = await rootBundle.load(
      'assets/templates/checklist_modelo.xlsx',
    );

    final bytes = data.buffer.asUint8List();

    final excel = Excel.decodeBytes(bytes);

    final sheet = excel.tables.values.first;

    // =========================
    // DADOS GERAIS
    // =========================

    sheet.cell(
      CellIndex.indexByString('E4'),
    ).value = TextCellValue(r.nomeProjeto);

    sheet.cell(
      CellIndex.indexByString('E5'),
    ).value = TextCellValue(r.dataProjeto);

    sheet.cell(
      CellIndex.indexByString('E6'),
    ).value = TextCellValue(r.identificacaoPainel);

    // =========================
    // TESTES
    // =========================

    sheet.cell(
      CellIndex.indexByString('C9'),
    ).value = TextCellValue(
      r.nomeRealizacaoTestes.join(', '),
    );

    sheet.cell(
      CellIndex.indexByString('F9'),
    ).value = TextCellValue(
      r.setorTestes,
    );

    sheet.cell(
      CellIndex.indexByString('H9'),
    ).value = TextCellValue(
      r.dataTestes,
    );

    // =========================
    // MONTAGEM
    // =========================     
    sheet.cell(
       CellIndex.indexByString('C13'),
     ).value = TextCellValue(
       r.nomeRealizacaoMontagem.join(', '),
    );
    sheet.cell(
      CellIndex.indexByString('F13'),
    ).value = TextCellValue(
      r.setorMontagem,
    );

    sheet.cell(
      CellIndex.indexByString('H13'),
    ).value = TextCellValue(
      r.dataMontagem,
    );

    // =========================
    // APROVAÇÃO
    // =========================

    sheet.cell(
      CellIndex.indexByString('C44'),
    ).value = TextCellValue(
      r.nomeResponsavel,
    );

    sheet.cell(
      CellIndex.indexByString('F44'),
    ).value = TextCellValue(
      r.dataAprovacao,
    );

    // =========================
    // SALVAR ARQUIVO
    // =========================

    final dir =
        await getApplicationDocumentsDirectory();

    final file = File(
      '${dir.path}/checklist_preenchido.xlsx',
    );

    final excelBytes = excel.encode();

    await file.writeAsBytes(
      excelBytes!,
    );
  
    return file.path;
  }
}