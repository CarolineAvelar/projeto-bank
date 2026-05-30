import 'package:flutter/material.dart';
import '../../components/editor.dart';
import '../../models/transferencia.dart';
import "../../database/app_database.dart";

class FormularioTransferencia extends StatefulWidget {
  final int? numeroConta;

  const FormularioTransferencia({super.key, this.numeroConta});

  @override
  State<StatefulWidget> createState() {
    return FormularioTransferenciaState();
  }
}

class FormularioTransferenciaState extends State<FormularioTransferencia> {
  
  static const _tituloAppBar = 'Criando Transferência';
  static const _rotuloCampoValor = 'Valor';
  static const _dicaCampoValor = '0,00';

  static const _rotuloCampoNumeroConta = 'Número Conta';
  static const _dicaCampoNumeroConta = '0000';
  static const _textBotaoConfirmar = 'Confirmar';

  final TextEditingController _controladorCampoNumeroConta = TextEditingController();
  final TextEditingController _controladorCampoValor = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.numeroConta != null) {
      _controladorCampoNumeroConta.text = widget.numeroConta.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tituloAppBar),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Editor(
              controlador: _controladorCampoNumeroConta,
              rotulo: _rotuloCampoNumeroConta,
              dica: _dicaCampoNumeroConta,
              tipoTeclado: TextInputType.number,
            ),

            Editor(
              controlador: _controladorCampoValor,
              rotulo: _rotuloCampoValor,
              dica: _dicaCampoValor,
              icone: Icons.monetization_on,
              tipoTeclado: TextInputType.numberWithOptions(decimal: true),
            ),

            ElevatedButton(
              child: Text(_textBotaoConfirmar),
              onPressed: () {
                debugPrint("Clicou no Confirmar!");

                _criaTransferencia(
                  context,
                  _controladorCampoNumeroConta,
                  _controladorCampoValor,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

void _criaTransferencia(
  BuildContext context,
  TextEditingController controladorCampoNumeroConta,
  TextEditingController controladorCampoValor,
) async {

  final int? numeroConta = int.tryParse(controladorCampoNumeroConta.text);
  final double? valor = double.tryParse(controladorCampoValor.text);

  if (numeroConta != null && valor != null) {

    final transferenciaCriada = Transferencia(valor, numeroConta);

    try {
      await salvarTransferencia(transferenciaCriada);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transferência salva com sucesso!')),
        );

        Navigator.pop(context);
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    }

  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preencha todos os campos corretamente.')),
    );
  }
}
