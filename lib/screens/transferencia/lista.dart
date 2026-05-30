import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// importa o model de transferência.
import '../../models/transferencia.dart';

// importa o formulário de nova transferência.
import 'formulario.dart';

// ALTERAÇÃO:
// importa o repository.
// agora a tela não precisa saber se os dados vêm do SQLite ou da API.
import '../../repository/bank_repository.dart';

class ListaTransferencias extends StatefulWidget {
  const ListaTransferencias({super.key});

  @override
  State<ListaTransferencias> createState() {
    return _ListaTransferenciasState();
  }
}

class _ListaTransferenciasState extends State<ListaTransferencias> {
  static const _tituloAppBar = 'Transferências';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // barra superior da tela.
      appBar: AppBar(
        title: const Text(_tituloAppBar),
      ),

      // o FutureBuilder continua sendo usado porque tanto SQLite quanto API
      // trabalham com operações assíncronas.
      body: FutureBuilder<List<Transferencia>>(
        // ALTERAÇÃO:
        // antes, a tela chamava diretamente buscarTransferencias()
        // do app_database.dart.
        //
        // agora, ela chama o repository.
        // o repository decide se busca no SQLite ou na API.
        future: RepositorioBank.instancia.buscarTransferencias(),

        builder: (context, snapshot) {
          // enquanto os dados estão sendo carregados,
          // exibimos um indicador de carregamento.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // se ocorrer erro, exibimos uma mensagem amigável.
          if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao carregar transferências.'),
            );
          }

          // se não houver dados, exibimos uma mensagem.
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Nenhuma transferência encontrada.'),
            );
          }

          // se chegou aqui, temos uma lista de transferências.
          final transferencias = snapshot.data!;

          return ListView.builder(
            // quantidade de transferências.
            itemCount: transferencias.length,

            // constrói cada item da lista.
            itemBuilder: (context, indice) {
              final transferencia = transferencias[indice];

              return ItemTransferencia(transferencia);
            },
          );
        },
      ),

      // botão para cadastrar uma nova transferência.
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),

        onPressed: () async {
          // abre o formulário de transferência.
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const FormularioTransferencia(),
            ),
          );

          // ao voltar do formulário, recarrega a lista.
          //
          // isso funciona tanto para SQLite quanto para API.
          setState(() {});
        },
      ),
    );
  }
}

// widget responsável por exibir uma transferência na lista.
class ItemTransferencia extends StatelessWidget {
  final Transferencia _transferencia;

  const ItemTransferencia(this._transferencia, {super.key});

  @override
  Widget build(BuildContext context) {
    // formata o valor monetário no padrão brasileiro.
    final formato = NumberFormat.simpleCurrency(locale: 'pt_BR');

    return Card(
      child: ListTile(
        leading: const Icon(Icons.monetization_on),

        // exibe o valor formatado.
        title: Text(formato.format(_transferencia.valor)),

        // exibe o número da conta.
        subtitle: Text('Conta: ${_transferencia.numeroConta}'),
      ),
    );
  }
}