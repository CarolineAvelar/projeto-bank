import 'package:flutter/material.dart';

// importa o model de transferência.
import '../../models/transferencia.dart';

// importa o componente de campo de texto reutilizável.
import '../../components/editor.dart';

// ALTERAÇÃO:
// importa o repository.
// ele decidirá se a transferência será salva localmente ou remotamente.
import '../../repository/bank_repository.dart';

class FormularioTransferencia extends StatefulWidget {
  // número da conta opcional.
  //
  // ele é usado quando o formulário é aberto a partir de um contato.
  final int? numeroConta;

  const FormularioTransferencia({
    super.key,
    this.numeroConta,
  });

  @override
  State<FormularioTransferencia> createState() {
    return _FormularioTransferenciaState();
  }
}

class _FormularioTransferenciaState extends State<FormularioTransferencia> {
  // controlador do campo número da conta.
  final TextEditingController _controladorCampoNumeroConta =
      TextEditingController();

  // controlador do campo valor.
  final TextEditingController _controladorCampoValor = TextEditingController();

  static const _tituloAppBar = 'Criando Transferência';
  static const _rotuloCampoValor = 'Valor';
  static const _dicaCampoValor = '0,00';
  static const _rotuloCampoNumeroConta = 'Número da conta';
  static const _dicaCampoNumeroConta = '0000';
  static const _textoBotaoConfirmar = 'Confirmar';

  // controla se o app está salvando a transferência.
  //
  // atenção:
  // não pode ser final, pois o valor será alterado no setState.
  //
  // false → não está salvando.
  // true  → está salvando.
  bool _salvando = false;

  @override
  void initState() {
    super.initState();

    // se o formulário recebeu um número de conta,
    // preenche o campo automaticamente.
    if (widget.numeroConta != null) {
      _controladorCampoNumeroConta.text = widget.numeroConta.toString();
    }
  }

  @override
  void dispose() {
    // libera os controladores da memória quando a tela for fechada.
    _controladorCampoNumeroConta.dispose();
    _controladorCampoValor.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // barra superior da tela.
      appBar: AppBar(
        title: const Text(_tituloAppBar),
      ),

      // permite rolagem se o conteúdo não couber na tela.
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // campo para número da conta.
            Editor(
              controlador: _controladorCampoNumeroConta,
              rotulo: _rotuloCampoNumeroConta,
              dica: _dicaCampoNumeroConta,
              tipoTeclado: TextInputType.number,
            ),

            // campo para valor da transferência.
            Editor(
              controlador: _controladorCampoValor,
              rotulo: _rotuloCampoValor,
              dica: _dicaCampoValor,
              icone: Icons.monetization_on,
              tipoTeclado: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),

              // botão responsável por confirmar a transferência.
              child: ElevatedButton(
                // se estiver salvando, desabilita o botão.
                onPressed: _salvando ? null : _criaTransferencia,

                // se estiver salvando, exibe loading.
                // caso contrário, mostra o texto normal.
                child: _salvando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(_textoBotaoConfirmar),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // função responsável por validar e salvar a transferência.
  Future<void> _criaTransferencia() async {
    // tenta converter o texto do campo número da conta para int.
    final int? numeroConta = int.tryParse(
      _controladorCampoNumeroConta.text,
    );

    // troca vírgula por ponto para aceitar entrada como 10,50.
    final textoValor = _controladorCampoValor.text.replaceAll(',', '.');

    // tenta converter o texto do campo valor para double.
    final double? valor = double.tryParse(textoValor);

    // valida número da conta.
    if (numeroConta == null || numeroConta <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Número da conta inválido.'),
        ),
      );
      return;
    }

    // valida valor.
    if (valor == null || valor <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Valor deve ser maior que 0.'),
        ),
      );
      return;
    }

    // cria o objeto transferência.
    final transferenciaCriada = Transferencia(
      valor,
      numeroConta,
    );

    try {
      // indica que o processo de salvamento começou.
      setState(() {
        _salvando = true;
      });

      // ALTERAÇÃO:
      // salva a transferência usando o repository.
      //
      // antes, o formulário chamava diretamente salvarTransferencia()
      // do app_database.dart.
      //
      // agora, ele chama o repository.
      // o repository decide se salva no SQLite ou na API.
      await RepositorioBank.instancia.salvarTransferencia(
        transferenciaCriada,
      );

      // se a tela não estiver mais montada, interrompe.
      if (!mounted) return;

      // exibe mensagem de sucesso.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transferência salva com sucesso.'),
        ),
      );

      // fecha a tela e retorna para a lista.
      Navigator.pop(context);
    } catch (erro) {
      // se a tela não estiver mais montada, interrompe.
      if (!mounted) return;

      // exibe mensagem de erro.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar transferência: $erro'),
        ),
      );
    } finally {
      // o finally executa dando certo ou dando erro.
      //
      // aqui encerramos o estado de salvamento.
      if (mounted) {
        setState(() {
          _salvando = false;
        });
      }
    }
  }
}