// Importações necessárias
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../../models/transferencia.dart';
import '../../database/app_database.dart';
import 'formulario.dart';

class ListaTransferencias extends StatefulWidget {
  const ListaTransferencias({super.key});

  @override
  State<ListaTransferencias> createState() => _ListaTransferenciasState();
}

class _ListaTransferenciasState extends State<ListaTransferencias> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferências'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),

      // Uso do FutureBuilder — substitui a lista fixa e busca os dados do banco de forma assíncrona
      body: FutureBuilder<List<Transferencia>>(
        future: buscarTransferencias(), // busca transferências no banco SQLite

        builder: (context, snapshot) {
          switch (snapshot.connectionState) {

            // Enquanto o Future está em andamento, exibe um indicador de carregamento
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());

            // Quando o Future termina, analisa o resultado
            case ConnectionState.done:
              if (snapshot.hasError) {
                // Exibe mensagem se houver erro de conexão ou consulta
                return const Center(child: Text('Erro ao carregar transferências.'));
              }

              // Se não houver erro, obtém os dados retornados
              final transferencias = snapshot.data ?? [];

              // Caso não existam registros, mostra uma mensagem amigável
              if (transferencias.isEmpty) {
                return const Center(child: Text('Nenhuma transferência encontrada.'));
              }

              // Novo: formatação de valores monetários no padrão brasileiro (R$ 1.234,56)
              final formatador = NumberFormat.simpleCurrency(locale: 'pt_BR');

              // Criação dinâmica da lista com ListView.builder()
              return ListView.builder(
                itemCount: transferencias.length,
                itemBuilder: (context, index) {
                  final transferencia = transferencias[index];
                  return Card(
                    margin: const EdgeInsets.all(8), // espaço entre os cartões
                    child: ListTile(
                      leading: const Icon(
                        Icons.monetization_on,
                        color: Colors.green, // ícone colorido para melhor visualização
                      ),
                      // Exibe o valor formatado corretamente
                      title: Text(formatador.format(transferencia.valor)),
                      subtitle: Text('Conta: ${transferencia.numeroConta}'),
                    ),
                  );
                },
              );

            // Estado padrão (casos raros, como desconexão)
            default:
              return const SizedBox.shrink();
          }
        },
      ),

      // Botão flutuante — abre o formulário de nova transferência
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // Usa async/await em vez de then() → código mais limpo e legível
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const FormularioTransferencia()),
          );

          // Atualiza a tela ao voltar do formulário
          setState(() {});
        },
      ),
    );
  }
}