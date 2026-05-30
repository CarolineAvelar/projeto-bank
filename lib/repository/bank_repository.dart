// importa o model de transferência.
// o repository precisa conhecer esse tipo para buscar e salvar transferências.
import '../models/transferencia.dart';

// importa o model de contato.
// o repository precisa conhecer esse tipo para buscar e salvar contatos.
import '../models/contato.dart';

// importa a configuração que define se usaremos persistência local ou remota.
import 'configuracao_persistencia.dart';

// importa o banco local com um apelido.
//
// usamos "as bancoLocal" para evitar conflito de nomes,
// pois o app_database.dart possui funções com nomes como:
// buscarContatos()
// salvarContato()
// buscarTransferencias()
// salvarTransferencia()
import '../database/app_database.dart' as bancoLocal;

// importa a camada de serviço da API.
// essa classe contém as requisições HTTP para o backend no Render.
import '../services/api_service.dart';

// classe abstrata que define as operações necessárias para o app.
//
// ela funciona como um contrato.
//
// qualquer classe que implementar BankRepository deverá obrigatoriamente
// implementar estes métodos.
abstract class BankRepository {
  // busca a lista de transferências.
  Future<List<Transferencia>> buscarTransferencias();

  // salva uma nova transferência.
  Future<void> salvarTransferencia(Transferencia transferencia);

  // busca a lista de contatos.
  Future<List<Contato>> buscarContatos();

  // salva um novo contato.
  Future<void> salvarContato(Contato contato);
}

// implementação do repository usando SQLite local.
//
// esta classe reaproveita as funções já existentes no app_database.dart.
class BankRepositoryLocal implements BankRepository {
  @override
  Future<List<Transferencia>> buscarTransferencias() {
    // busca as transferências no banco local SQLite.
    return bancoLocal.buscarTransferencias();
  }

  @override
  Future<void> salvarTransferencia(Transferencia transferencia) async {
    // salva a transferência no banco local SQLite.
    //
    // a função salvarTransferencia do SQLite retorna um id,
    // mas aqui não precisamos usar esse retorno.
    await bancoLocal.salvarTransferencia(transferencia);
  }

  @override
  Future<List<Contato>> buscarContatos() {
    // busca os contatos no banco local SQLite.
    return bancoLocal.buscarContatos();
  }

  @override
  Future<void> salvarContato(Contato contato) async {
    // salva o contato no banco local SQLite.
    //
    // a função salvarContato do SQLite retorna um id,
    // mas aqui também não precisamos usar esse retorno.
    await bancoLocal.salvarContato(contato);
  }
}

// implementação do repository usando API remota.
//
// esta classe reaproveita os métodos criados no ApiService.
class BankRepositoryRemoto implements BankRepository {
  @override
  Future<List<Transferencia>> buscarTransferencias() {
    // busca as transferências na API remota.
    return ApiService.buscarTransferencias();
  }

  @override
  Future<void> salvarTransferencia(Transferencia transferencia) async {
    // salva a transferência na API remota.
    await ApiService.salvarTransferencia(transferencia);
  }

  @override
  Future<List<Contato>> buscarContatos() {
    // busca os contatos na API remota.
    return ApiService.buscarContatos();
  }

  @override
  Future<void> salvarContato(Contato contato) async {
    // salva o contato na API remota.
    await ApiService.salvarContato(contato);
  }
}

// classe responsável por entregar o repository correto para as telas.
//
// as telas chamarão:
// RepositorioBank.instancia
//
// e não precisarão saber se estão usando SQLite ou API.
class RepositorioBank {
  // getter que retorna uma implementação de BankRepository.
  static BankRepository get instancia {
    // verifica qual origem foi definida na configuração.
    switch (ConfiguracaoPersistencia.origem) {
      // se a origem configurada for local,
      // retorna o repository que usa SQLite.
      case OrigemPersistencia.local:
        return BankRepositoryLocal();

      // se a origem configurada for remota,
      // retorna o repository que usa API.
      case OrigemPersistencia.remota:
        return BankRepositoryRemoto();
    }
  }
}