import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:printing/printing.dart';

import 'package:share_plus/share_plus.dart';

import '../models/relatorio_checklist.dart';
import '../services/pdf_service.dart';

class AssinaturaPage extends StatefulWidget {
  final RelatorioChecklist relatorio;

  const AssinaturaPage({
    super.key,
    required this.relatorio,
  });

  @override
  State<AssinaturaPage> createState() => _AssinaturaPageState();
}

class _AssinaturaPageState extends State<AssinaturaPage> {
  final TextEditingController nomeController = TextEditingController();

  final SignatureController assinaturaController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  DateTime dataAtual = DateTime.now();

  Uint8List? assinaturaBytes;

  void limparAssinatura() {
    assinaturaController.clear();
  }

  Future<void> salvarAssinatura() async {
    if (assinaturaController.isNotEmpty) {
      final data = await assinaturaController.toPngBytes();
      setState(() {
        assinaturaBytes = data;
      });

      debugPrint("Assinatura salva com sucesso!");
    }
  }

  Future<void> gerarPdf() async {
    widget.relatorio.nomeResponsavel =
        nomeController.text;

    widget.relatorio.dataAprovacao =
        "${dataAtual.day}/${dataAtual.month}/${dataAtual.year}";

    widget.relatorio.assinaturaBytes =
        assinaturaBytes;

    final pdfBytes =
        await PdfService.gerarPdf(
          widget.relatorio,
        );

    await Printing.layoutPdf(
      onLayout: (format) async => pdfBytes,
    );
  }

  Future<void> compartilharPdf() async {
    widget.relatorio.nomeResponsavel = nomeController.text;

    widget.relatorio.dataAprovacao =
        "${dataAtual.day}/${dataAtual.month}/${dataAtual.year}";

    widget.relatorio.assinaturaBytes = assinaturaBytes;

    // 1. gerar PDF
    final pdfBytes = await PdfService.gerarPdf(widget.relatorio);
    // 🔧 ALTERAÇÃO: montar nome do arquivo PDF
    final nomeProjeto = widget.relatorio.nomeProjeto.trim().isEmpty
        ? 'sem_nome'
        : widget.relatorio.nomeProjeto.trim().replaceAll(' ', '_');

    final fileName = 'checklist_painel_$nomeProjeto.pdf';
    // 2. Compartilhar
    await Share.shareXFiles(
      [
        // 🔧 ALTERAÇÃO: nome dinâmico do arquivo
        XFile.fromData(
          pdfBytes,
          name: fileName,
          mimeType: 'application/pdf',
        ),
      ],
      text: 'Relatório do Painel',
    );
  }

  @override
  void dispose() {
    assinaturaController.dispose();
    nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assinatura do Checklist"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text("Nome do responsável (C44)"),
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite o nome",
              ),
            ),

            const SizedBox(height: 16),

            Text(
              "Data (F44): ${dataAtual.day}/${dataAtual.month}/${dataAtual.year}",
            ),

            const SizedBox(height: 20),

            const Text("Assinatura (G44)"),

            const SizedBox(height: 10),

            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Signature(
                controller: assinaturaController,
                backgroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                ElevatedButton(
                  onPressed: limparAssinatura,
                  child: const Text("Limpar"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: salvarAssinatura,
                  child: const Text("Salvar"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (assinaturaBytes != null)
              const Text("Assinatura capturada com sucesso ✅"),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: compartilharPdf,
              icon: const Icon(Icons.share),
              label: const Text(
                'Gerar & Compartilhar',
              ),              
            ),
          ],
        ),
      ),
    );
  }
}