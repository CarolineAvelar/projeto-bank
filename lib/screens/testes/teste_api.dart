import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/transferencia.dart';
import '../../models/contato.dart';

class TesteApi extends StatefulWidget {
  const TesteApi({super.key});

  @override
  State<TesteApi> createState() => _TesteApiState();
}

class _TesteApiState extends State<TesteApi> {
  String _resultado = 'nenhum teste executado ainda';
  bool _carregando = false;

  Future<void> _testarConexao() async {
    setState(() {
      _carregando = true;
      _resultado = 'testando conexão com a api...';
    });

    try {
      final mensagem = await ApiService.testarConexaoBanco();

      setState(() {
        _resultado = mensagem;
      });
    } catch (erro) {
      setState(() {
        _resultado = 'erro ao testar conexão: $erro';
      });
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  Future<void> _listarTransferencias() async {
    setState(() {
      _carregando = true;
      _resultado = 'buscando transferências...';
    });

    try {
      final transferencias = await ApiService.buscarTransferencias();

      setState(() {
        _resultado = transferencias.isEmpty
            ? 'nenhuma transferência encontrada na api'
            : transferencias.join('\n');
      });
    } catch (erro) {
      setState(() {
        _resultado = 'erro ao buscar transferências: $erro';
      });
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  Future<void> _criarTransferenciaTeste() async {
    setState(() {
      _carregando = true;
      _resultado = 'criando transferência de teste...';
    });

    try {
      final transferencia = Transferencia(25.50, 1234);

      await ApiService.salvarTransferencia(transferencia);

      setState(() {
        _resultado = 'transferência de teste criada com sucesso';
      });
    } catch (erro) {
      setState(() {
        _resultado = 'erro ao criar transferência: $erro';
      });
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  Future<void> _listarContatos() async {
    setState(() {
      _carregando = true;
      _resultado = 'buscando contatos...';
    });

    try {
      final contatos = await ApiService.buscarContatos();

      setState(() {
        _resultado = contatos.isEmpty
            ? 'nenhum contato encontrado na api'
            : contatos.join('\n');
      });
    } catch (erro) {
      setState(() {
        _resultado = 'erro ao buscar contatos: $erro';
      });
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  Future<void> _criarContatoTeste() async {
    setState(() {
      _carregando = true;
      _resultado = 'criando contato de teste...';
    });

    try {
      final contato = Contato(
        nome: 'Contato Flutter',
        numeroConta: 4321,
      );

      await ApiService.salvarContato(contato);

      setState(() {
        _resultado = 'contato de teste criado com sucesso';
      });
    } catch (erro) {
      setState(() {
        _resultado = 'erro ao criar contato: $erro';
      });
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teste da API'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: _carregando ? null : _testarConexao,
                child: const Text('Testar conexão com o banco remoto'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _carregando ? null : _listarTransferencias,
                child: const Text('Listar transferências da API'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _carregando ? null : _criarTransferenciaTeste,
                child: const Text('Criar transferência teste na API'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _carregando ? null : _listarContatos,
                child: const Text('Listar contatos da API'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _carregando ? null : _criarContatoTeste,
                child: const Text('Criar contato teste na API'),
              ),
              const SizedBox(height: 24),
              if (_carregando)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              const SizedBox(height: 24),
              Text(
                _resultado,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}