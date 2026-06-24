import 'package:flutter/material.dart';
import 'screens/checklist_page.dart';
import 'models/relatorio_checklist.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import 'services/pdf_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(const ChecklistApp());
}

class ChecklistApp extends StatelessWidget {
  const ChecklistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checklist de Painel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const DadosPainelPage(),
    );
  }
}

class DadosPainelPage extends StatefulWidget {
  const DadosPainelPage({super.key});

  @override
  State<DadosPainelPage> createState() => _DadosPainelPageState();
}

class _DadosPainelPageState extends State<DadosPainelPage> {
  // ---------------------------
  // CONTROLLERS GERAIS
  // ---------------------------
  final projetoController = TextEditingController();
  final dataController = TextEditingController();
  final painelController = TextEditingController();

  // TESTES
  final TextEditingController testeController = TextEditingController();
  final TextEditingController setorTesteController = TextEditingController();
  final TextEditingController dataTesteController = TextEditingController();

  // MONTAGEM
  final TextEditingController montagemController = TextEditingController();
  final TextEditingController setorMontagemController = TextEditingController();
  final TextEditingController dataMontagemController = TextEditingController();

  // ---------------------------
  // LISTAS (MULTI USUÁRIOS)
  // ---------------------------
  final List<String> responsaveisTeste = [];
  final List<String> responsaveisMontagem = [];

  final relatorio = RelatorioChecklist();

  Future<String> uploadPdf(Uint8List pdfBytes) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('pdfs/relatorio_${DateTime.now().millisecondsSinceEpoch}.pdf');

    await ref.putData(pdfBytes);

    return await ref.getDownloadURL();
  }

  @override
  void dispose() {
    projetoController.dispose();
    dataController.dispose();
    painelController.dispose();
    testeController.dispose();
    setorTesteController.dispose();
    dataTesteController.dispose();
    montagemController.dispose();
    setorMontagemController.dispose();
    dataMontagemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checklist de Painel'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // ---------------------------
          // PROJETO
          // ---------------------------
          const Text(
            'Dados do Projeto',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: projetoController,
                    decoration: const InputDecoration(labelText: 'Nome do Projeto'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: dataController,
                    decoration: const InputDecoration(labelText: 'Data'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: painelController,
                    decoration: const InputDecoration(labelText: 'Identificação do Painel'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ---------------------------
          // TESTES
          // ---------------------------
          const Text(
            'Dados dos Testes',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: testeController,
                          decoration: const InputDecoration(
                            labelText: 'Nome dos Testadores (Adicionar)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (testeController.text.trim().isEmpty) return;

                          setState(() {
                            responsaveisTeste.add(testeController.text.trim());
                            testeController.clear();
                          });
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: responsaveisTeste.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(responsaveisTeste[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              responsaveisTeste.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: setorTesteController,
                    decoration: const InputDecoration(labelText: 'Setor'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: dataTesteController,
                    decoration: const InputDecoration(labelText: 'Data Início/Fim'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ---------------------------
          // MONTAGEM
          // ---------------------------
          const Text(
            'Dados da Montagem do Painel',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: montagemController,
                          decoration: const InputDecoration(
                            labelText: 'Nome dos Montadores do Painel (Adicionar)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (montagemController.text.trim().isEmpty) return;

                          setState(() {
                            responsaveisMontagem.add(montagemController.text.trim());
                            montagemController.clear();
                          });
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: responsaveisMontagem.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(responsaveisMontagem[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              responsaveisMontagem.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: setorMontagemController,
                    decoration: const InputDecoration(labelText: 'Setor'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: dataMontagemController,
                    decoration: const InputDecoration(labelText: 'Data Início/Fim'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ---------------------------
          // BOTÃO FINAL
          // ---------------------------
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                relatorio.nomeProjeto = projetoController.text;
                relatorio.dataProjeto = dataController.text;
                relatorio.identificacaoPainel = painelController.text;

                relatorio.nomeRealizacaoTestes = List.from(responsaveisTeste);
                relatorio.setorTestes = setorTesteController.text;
                relatorio.dataTestes = dataTesteController.text;

                relatorio.nomeRealizacaoMontagem = List.from(responsaveisMontagem);
                relatorio.setorMontagem = setorMontagemController.text;
                relatorio.dataMontagem = dataMontagemController.text;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChecklistPage(relatorio: relatorio),
                  ),
                );
              },
              child: const Text('PRÓXIMO'),
            ),
          ),
          const SizedBox(height: 12),

          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                try {
                  // 1. GERAR PDF
                  final pdfBytes = await PdfService.gerarPdf(relatorio);

                  print("PDF gerado com sucesso!");
                  print("Tamanho do PDF: ${pdfBytes.length} bytes");

                  // 2. COMPARTILHAR DIRETO (SEM FIREBASE)
                  await Share.shareXFiles(
                    [
                      XFile.fromData(
                        pdfBytes,
                        name: 'fileName',
                        mimeType: 'application/pdf',
                      ),
                    ],
                    text: 'Relatório do painel',
                  );

                } catch (e) {
                  print("Erro ao gerar PDF: $e");
                }
              },
              child: const Text('GERAR PDF E COMPARTILHAR'),
            ),
          ),
        ],
      ),
    );
  }
}