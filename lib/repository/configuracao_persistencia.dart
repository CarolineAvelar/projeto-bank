// enum usado para representar as possíveis origens de persistência do app.
//
// local  → os dados serão salvos e buscados no SQLite.
// remota → os dados serão salvos e buscados pela API no Render.
enum OrigemPersistencia {
  local,
  remota,
}

// classe responsável por centralizar a configuração de persistência.
//
// nesta aula, a escolha será feita manualmente no código.
// isso facilita os testes em sala.
class ConfiguracaoPersistencia {
  // define qual origem de dados será usada pelo aplicativo.
  //
  // para usar SQLite local:
  // OrigemPersistencia.local
  //
  // para usar API remota:
  // OrigemPersistencia.remota
  static const OrigemPersistencia origem = OrigemPersistencia.remota;
}