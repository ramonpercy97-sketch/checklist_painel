import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'models/relatorio_checklist.dart';
import 'screens/checklist_page.dart';
import 'services/pdf_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ChecklistApp());
}

class ChecklistApp extends StatelessWidget {
  const ChecklistApp({super.key});

  // ==========================
  // CORES DO APLICATIVO
  // ==========================
  static const Color corPrimaria = Color(0xFF1565C0);
  static const Color corFundo = Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checklist de Painéis',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: corPrimaria,
          primary: corPrimaria,
          brightness: Brightness.light,
        ),

        scaffoldBackgroundColor: corFundo,

        appBarTheme: const AppBarTheme(
          backgroundColor: corPrimaria,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),

        cardTheme: CardThemeData(
          elevation: 3,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: corPrimaria,
            foregroundColor: Colors.white,
            elevation: 2,
            minimumSize: const Size(0, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),

          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(14),
            ),
            borderSide: BorderSide(
              color: corPrimaria,
              width: 2,
            ),
          ),
        ),
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
  // ==========================
  // DADOS DO PROJETO
  // ==========================
  final projetoController = TextEditingController();
  final dataController = TextEditingController();
  final painelController = TextEditingController();

  // ==========================
  // TESTES
  // ==========================
  final testeController = TextEditingController();
  final setorTesteController = TextEditingController();
  final dataTesteController = TextEditingController();

  // ==========================
  // MONTAGEM
  // ==========================
  final montagemController = TextEditingController();
  final setorMontagemController = TextEditingController();
  final dataMontagemController = TextEditingController();

  // ==========================
  // LISTAS
  // ==========================
  final List<String> responsaveisTeste = [];
  final List<String> responsaveisMontagem = [];

  final relatorio = RelatorioChecklist();

  Future<String> uploadPdf(Uint8List pdfBytes) async {
    final ref = FirebaseStorage.instance.ref().child(
      'pdfs/relatorio_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );

    await ref.putData(pdfBytes);

    return ref.getDownloadURL();
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

  Widget cardPadrao({
    required IconData icone,
    required String titulo,
    required Widget child,
  })  {
    return Card(
      elevation: 8,
      shadowColor: Colors.black12,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xffEAF2FF),
                  child: Icon(
                    icone,
                    color: const Color(0xff0F4CBA),
                  ),
                ),

                const SizedBox(width: 15),

                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            child,

          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FB),

      body: SingleChildScrollView(
        child: Column(
          children: [

            //==================================================
            // CABEÇALHO
            //==================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 60,
                bottom: 35,
              ),
              decoration: const BoxDecoration(
                color: Color(0xff0F4CBA),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),
              child: const Column(
                children: [

                  Icon(
                    Icons.assignment_turned_in_rounded,
                    color: Colors.white,
                    size: 60,
                  ),

                  SizedBox(height: 16),

                  Text(
                    "CHECKLIST DO PAINEL",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    "Interactive Automação",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [

                  //==================================================
                  // CARD DADOS DO PROJETO
                  //==================================================

                  Card(
                    elevation: 5,
                    shadowColor: Colors.black12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const Row(
                            children: [

                              Icon(
                                Icons.folder_open,
                                color: Color(0xff0F4CBA),
                              ),

                              SizedBox(width: 8),

                              Text(
                                "Dados do Projeto",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 18),

                          TextField(
                            controller: projetoController,
                            decoration: const InputDecoration(
                              labelText: "Nome do Projeto",
                              prefixIcon: Icon(Icons.business),
                            ),
                          ),

                          SizedBox(height: 16),

                          TextField(
                            controller: dataController,
                            decoration: const InputDecoration(
                              labelText: "Data",
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                          ),

                          SizedBox(height: 16),

                          TextField(
                            controller: painelController,
                            decoration: const InputDecoration(
                              labelText: "Identificação do Painel",
                              prefixIcon: Icon(Icons.confirmation_number),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  //==================================================
                  // CARD DADOS DOS TESTES
                  //==================================================

                  cardPadrao(
                    icone: Icons.science,
                    titulo: "Dados dos Testes",
                    child: Column(
                      children: [

                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: testeController,
                                decoration: const InputDecoration(
                                  labelText: "Nome dos Testadores",
                                  prefixIcon: Icon(Icons.person_add),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              onPressed: () {
                                if (testeController.text.trim().isEmpty) return;

                                setState(() {
                                  responsaveisTeste.add(
                                    testeController.text.trim(),
                                  );
                                  testeController.clear();
                                });
                              },
                              icon: const Icon(Icons.add),
                              label: const Text("Adicionar"),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: responsaveisTeste.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 0,
                              color: Colors.grey.shade100,
                              child: ListTile(
                                leading: const Icon(Icons.person),
                                title: Text(responsaveisTeste[index]),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      responsaveisTeste.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        TextField(
                          controller: setorTesteController,
                          decoration: const InputDecoration(
                            labelText: "Setor",
                            prefixIcon: Icon(Icons.factory),
                          ),
                        ),

                        const SizedBox(height: 16),

                        TextField(
                          controller: dataTesteController,
                          decoration: const InputDecoration(
                            labelText: "Data de Início/Fim",
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  //==================================================
                  // CARD MONTAGEM
                  //==================================================

                  cardPadrao(
                    icone: Icons.precision_manufacturing,
                    titulo: "Dados da Montagem",
                    child: Column(
                      children: [

                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: montagemController,
                                decoration: const InputDecoration(
                                  labelText: "Nome dos Montadores",
                                  prefixIcon: Icon(Icons.engineering),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              onPressed: () {
                                if (montagemController.text.trim().isEmpty) return;

                                setState(() {
                                  responsaveisMontagem.add(
                                    montagemController.text.trim(),
                                  );
                                  montagemController.clear();
                                });
                              },
                              icon: const Icon(Icons.add),
                              label: const Text("Adicionar"),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: responsaveisMontagem.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 0,
                              color: Colors.grey.shade100,
                              child: ListTile(
                                leading: const Icon(Icons.person),
                                title: Text(responsaveisMontagem[index]),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      responsaveisMontagem.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        TextField(
                          controller: setorMontagemController,
                          decoration: const InputDecoration(
                            labelText: "Setor",
                            prefixIcon: Icon(Icons.factory),
                          ),
                        ),

                        const SizedBox(height: 16),

                        TextField(
                          controller: dataMontagemController,
                          decoration: const InputDecoration(
                            labelText: "Data de Início/Fim",
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text(
                        "PRÓXIMO",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0F4CBA),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () {

                        relatorio.nomeProjeto = projetoController.text;
                        relatorio.dataProjeto = dataController.text;
                        relatorio.identificacaoPainel = painelController.text;

                        relatorio.nomeRealizacaoTestes =
                            List.from(responsaveisTeste);
                        relatorio.setorTestes =
                            setorTesteController.text;
                        relatorio.dataTestes =
                            dataTesteController.text;

                        relatorio.nomeRealizacaoMontagem =
                            List.from(responsaveisMontagem);
                        relatorio.setorMontagem =
                            setorMontagemController.text;
                        relatorio.dataMontagem =
                            dataMontagemController.text;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChecklistPage(
                              relatorio: relatorio,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}