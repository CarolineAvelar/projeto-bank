import 'package:flutter/material.dart';
import '../../components/editor.dart';
import '../../models/contato.dart';
import '../../database/app_database.dart';

class FormularioContato extends StatefulWidget {
  const FormularioContato({super.key});

  @override
  State<FormularioContato> createState() => _FormularioContatoState();
}

class _FormularioContatoState extends State<FormularioContato> {
  final TextEditingController _controladorNome = TextEditingController();
  final TextEditingController _controladorConta = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Contato'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Editor(
              controlador: _controladorNome,
              rotulo: 'Nome',
              dica: 'Ex: Maria Oliveira',
              icone: Icons.person,
              tipoTeclado: TextInputType.text,
            ),
            Editor(
              controlador: _controladorConta,
              rotulo: 'Número da conta',
              dica: '0000',
              icone: Icons.numbers,
              tipoTeclado: TextInputType.number,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                child: const Text('Salvar'),
                onPressed: () async {
                  final String nome = _controladorNome.text;
                  final int? conta = int.tryParse(_controladorConta.text);

                  
                // valida se os campos foram preenchidos corretamente
                  if (nome.isNotEmpty && conta != null) {

                    // cria um novo objeto "Contato" com os valores digitados
                    final contatoCriado = Contato(
                      nome: nome,
                      numeroConta: conta,
                    );

                    // chama a função que salva o contato no banco de dados
                    // atribui o id resultado da operação
                    final idGerado = await salvarContato(contatoCriado);

                    // imprime no console (útil para depuração)
                    debugPrint('Contato salvo: id: $idGerado | nome: ${contatoCriado.nome}, conta: ${contatoCriado.numeroConta}');

                    // fecha o formulário e volta para a tela anterior
                    if (context.mounted) {
                      Navigator.pop(context);
                    }

                  } else {
                    // caso algum campo esteja incorreto, exibe uma mensagem de aviso
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Preencha todos os campos corretamente.',
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}