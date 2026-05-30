import 'package:flutter/material.dart';
import 'formulario_contato.dart';
import '../../models/contato.dart';
import '../../database/app_database.dart';
import '../transferencia/formulario.dart';

class ListaContatos extends StatefulWidget {
  final List<Contato> _contatos = []; // Lista interna para atualização dinâmica

  ListaContatos({super.key});

  @override
  State<ListaContatos> createState() => _ListaContatosState();
}

class _ListaContatosState extends State<ListaContatos> {
  static const _tituloAppBar = "Contatos";

  @override
  void initState() {
    super.initState();
    _carregarContatosDoBanco(); // Carrega contatos já existentes
  }

  void _carregarContatosDoBanco() async {
    final contatosDoBanco = await buscarContatos();
    setState(() {
      widget._contatos.addAll(contatosDoBanco);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(_tituloAppBar)),

      body: widget._contatos.isEmpty
          ? const Center(child: Text("Nenhum contato encontrado."))
          : ListView.builder(
              itemCount: widget._contatos.length,
              itemBuilder: (context, index) {
                final contato = widget._contatos[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(contato.nome),
                    subtitle: Text('Conta: ${contato.numeroConta}'),
                    onTap: () {
	                    Navigator.of(context).push(
	                      MaterialPageRoute(
	                        builder: (context) => FormularioTransferencia(
	                          numeroConta: contato.numeroConta,
	                        ), // fecha builder
	                      ), // fecha Material
	                    ); // Navigator
	                  }, // onTap
                  ), // listTile
                ); // Card
              },//itemBuilder:
            ), //ListView.builde

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FormularioContato(),
            ),
          ).then((contatoRecebido) async {
            if (contatoRecebido != null) {
              // Atualiza a lista dinamicamente
              setState(() {
                widget._contatos.add(contatoRecebido);
              });
            } else {
              // Se quiser, também podemos recarregar do banco caso o usuário feche o formulário sem retornar contato
              final contatosDoBanco = await buscarContatos();
              setState(() {
                widget._contatos.clear();
                widget._contatos.addAll(contatosDoBanco);
              });
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}