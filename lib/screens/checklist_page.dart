import 'package:flutter/material.dart';
import '../models/relatorio_checklist.dart';
import 'package:checklist_painel/screens/assinatura_page.dart';

class ChecklistPage extends StatefulWidget {
  final RelatorioChecklist relatorio;

  const ChecklistPage({
    super.key,
    required this.relatorio
    });

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  final List<String> itensTeste = [
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

  final Map<String, String> status = {};
  final Map<String, TextEditingController> observacoes = {};

  @override
  void initState() {
    super.initState();

    for (var item in itensTeste) {
      status[item] = '';
      observacoes[item] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in observacoes.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checklist de Testes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: itensTeste.length,
                itemBuilder: (context, index) {
                  final item = itensTeste[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 12),

                          DropdownButtonFormField<String>(
                            value: status[item]!.isEmpty ? null : status[item],
                            decoration: const InputDecoration(
                              labelText: 'Status',
                              border: OutlineInputBorder(),
                            ),
                            hint: const Text('Selecione'),
                            items: const [
                              DropdownMenuItem(
                                value: 'Aprovado',
                                child: Text('Aprovado'),
                              ),
                              DropdownMenuItem(
                                value: 'Recusado',
                                child: Text('Recusado'),
                              ),
                              DropdownMenuItem(
                                value: 'N/A',
                                child: Text('N/A'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                status[item] = value!;
                              });
                            },
                          ),

                          const SizedBox(height: 12),

                          TextField(
                            controller: observacoes[item],
                            decoration: const InputDecoration(
                              labelText: 'Observação',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('VOLTAR'),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final itensPendentes = status.entries
                          .where((entry) => entry.value.isEmpty)
                          .toList();

                      if (itensPendentes.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Existem ${itensPendentes.length} testes sem status definido.',
                            ),
                          ),
                        );
                        return;
                      }

                      widget.relatorio.statusTestes =
                          Map.from(status);

                      widget.relatorio.observacoesTestes =
                          observacoes.map(
                            (key, value) =>
                                MapEntry(key, value.text),
                          );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Todos os testes preenchidos. Próxima etapa: Tela de Assinatura.',
                          ),
                        ),
                      );

                      // Futuramente:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AssinaturaPage(relatorio: widget.relatorio,),
                        ),
                      );
                    },
                    child: const Text('FINALIZAR'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}