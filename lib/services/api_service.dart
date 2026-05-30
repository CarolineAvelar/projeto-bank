// biblioteca padrão do dart usada para converter dados entre json e objetos dart.
//
// usaremos:
// jsonDecode → para transformar uma resposta json da api em dados que o dart entende.
// jsonEncode → para transformar objetos/mapas do dart em json antes de enviar para a api.
import 'dart:convert';

// importa o pacote http, responsável por fazer requisições http.
//
// o apelido "http" permite usar métodos como:
// http.get()
// http.post()
import 'package:http/http.dart' as http;

// importa o model Transferencia.
//
// esse model será usado para:
// - transformar json vindo da api em objeto Transferencia;
// - transformar objeto Transferencia em json para envio à api.
import '../models/transferencia.dart';

// importa o model Contato.
//
// esse model será usado para:
// - transformar json vindo da api em objeto Contato;
// - transformar objeto Contato em json para envio à api.
import '../models/contato.dart';

// classe responsável por centralizar toda a comunicação com a api remota.
//
// a ideia é evitar que as telas do aplicativo tenham que lidar diretamente com:
// - urls;
// - requisições get;
// - requisições post;
// - jsonEncode;
// - jsonDecode;
// - statusCode.
//
// assim, as telas apenas chamam métodos simples como:
// ApiService.buscarTransferencias()
// ApiService.salvarContato(contato)
class ApiService {
  // endereço base da api publicada no render.
  //
  // atenção:
  // substitua este endereço pela url real da sua api.
  //
  // exemplo:
  // static const String baseUrl = 'https://bank-api-aula.onrender.com';
  static const String baseUrl = 'https://sua-api.onrender.com';

  // método responsável por testar se:
  // 1. o flutter consegue acessar a api;
  // 2. a api consegue acessar o banco postgresql remoto.
  //
  // esse método chama a rota:
  // GET /teste-banco
  //
  // retorna uma string com a mensagem enviada pela api.
  static Future<String> testarConexaoBanco() async {
    // realiza uma requisição http do tipo get para a rota /teste-banco.
    //
    // Uri.parse transforma a string da url em um objeto Uri,
    // que é o formato esperado pelo pacote http.
    final resposta = await http.get(
      Uri.parse('$baseUrl/teste-banco'),
    );

    // verifica se o status da resposta é diferente de 200.
    //
    // status 200 significa que a requisição foi concluída com sucesso.
    // caso contrário, lançamos uma exceção.
    if (resposta.statusCode != 200) {
      throw Exception('erro ao testar conexão com o banco');
    }

    // converte o corpo da resposta de json para um objeto dart.
    //
    // exemplo de resposta esperada:
    // {
    //   "mensagem": "conexão com o banco realizada com sucesso",
    //   "dataHoraBanco": "..."
    // }
    final dados = jsonDecode(resposta.body);

    // retorna apenas o conteúdo da chave "mensagem".
    return dados['mensagem'];
  }

  // método responsável por buscar todas as transferências cadastradas
  // no banco remoto.
  //
  // esse método chama a rota:
  // GET /transferencias
  //
  // retorna uma lista de objetos Transferencia.
  static Future<List<Transferencia>> buscarTransferencias() async {
    // realiza uma requisição http do tipo get para a rota /transferencias.
    final resposta = await http.get(
      Uri.parse('$baseUrl/transferencias'),
    );

    // verifica se a api respondeu com status 200.
    //
    // status 200 indica sucesso na busca/listagem.
    if (resposta.statusCode != 200) {
      throw Exception('erro ao buscar transferências');
    }

    // converte o corpo da resposta json para uma lista dinâmica.
    //
    // exemplo de resposta esperada:
    // [
    //   {
    //     "id": 1,
    //     "valor": "150.75",
    //     "numero_conta": 1234
    //   }
    // ]
    final List<dynamic> dados = jsonDecode(resposta.body);

    // percorre cada item da lista recebida da api.
    //
    // cada item é convertido em um objeto Transferencia
    // por meio do método Transferencia.fromJson().
    //
    // ao final, o resultado é convertido para List<Transferencia>.
    return dados.map((item) {
      return Transferencia.fromJson(item);
    }).toList();
  }

  // método responsável por salvar uma nova transferência no banco remoto.
  //
  // esse método chama a rota:
  // POST /transferencias
  //
  // recebe um objeto Transferencia e envia seus dados em formato json.
  static Future<void> salvarTransferencia(Transferencia transferencia) async {
    // realiza uma requisição http do tipo post para a rota /transferencias.
    final resposta = await http.post(
      Uri.parse('$baseUrl/transferencias'),

      // informa para a api que o corpo da requisição está em formato json.
      headers: {
        'Content-Type': 'application/json',
      },

      // converte o objeto Transferencia para json.
      //
      // primeiro, transferencia.toJson() transforma o objeto em um Map.
      // depois, jsonEncode transforma esse Map em uma string json.
      //
      // exemplo enviado para a api:
      // {
      //   "valor": 25.5,
      //   "numeroConta": 1234
      // }
      body: jsonEncode(transferencia.toJson()),
    );

    // verifica se a api respondeu com status 201.
    //
    // status 201 significa "created",
    // ou seja, a transferência foi criada com sucesso.
    if (resposta.statusCode != 201) {
      throw Exception('erro ao salvar transferência');
    }

    // se chegou até aqui, significa que a transferência foi salva.
    // como o método retorna Future<void>, não precisamos retornar nenhum valor.
  }

  // método responsável por buscar todos os contatos cadastrados
  // no banco remoto.
  //
  // esse método chama a rota:
  // GET /contatos
  //
  // retorna uma lista de objetos Contato.
  static Future<List<Contato>> buscarContatos() async {
    // realiza uma requisição http do tipo get para a rota /contatos.
    final resposta = await http.get(
      Uri.parse('$baseUrl/contatos'),
    );

    // verifica se a api respondeu com status 200.
    //
    // status 200 indica sucesso na busca/listagem.
    if (resposta.statusCode != 200) {
      throw Exception('erro ao buscar contatos');
    }

    // converte o corpo da resposta json para uma lista dinâmica.
    //
    // exemplo de resposta esperada:
    // [
    //   {
    //     "id": 1,
    //     "nome": "Maria Oliveira",
    //     "numero_conta": 1234
    //   }
    // ]
    final List<dynamic> dados = jsonDecode(resposta.body);

    // percorre cada item da lista recebida da api.
    //
    // cada item é convertido em um objeto Contato
    // por meio do método Contato.fromJson().
    //
    // ao final, o resultado é convertido para List<Contato>.
    return dados.map((item) {
      return Contato.fromJson(item);
    }).toList();
  }

  // método responsável por salvar um novo contato no banco remoto.
  //
  // esse método chama a rota:
  // POST /contatos
  //
  // recebe um objeto Contato e envia seus dados em formato json.
  static Future<void> salvarContato(Contato contato) async {
    // realiza uma requisição http do tipo post para a rota /contatos.
    final resposta = await http.post(
      Uri.parse('$baseUrl/contatos'),

      // informa para a api que o corpo da requisição será enviado em json.
      headers: {
        'Content-Type': 'application/json',
      },

      // converte o objeto Contato para json.
      //
      // primeiro, contato.toJson() transforma o objeto em um Map.
      // depois, jsonEncode transforma esse Map em uma string json.
      //
      // exemplo enviado para a api:
      // {
      //   "nome": "Maria Oliveira",
      //   "numeroConta": 1234
      // }
      body: jsonEncode(contato.toJson()),
    );

    // verifica se a api respondeu com status 201.
    //
    // status 201 significa que o contato foi criado com sucesso.
    if (resposta.statusCode != 201) {
      throw Exception('erro ao salvar contato');
    }

    // se chegou até aqui, significa que o contato foi salvo.
    // como o método retorna Future<void>, não precisamos retornar nenhum valor.
  }
}