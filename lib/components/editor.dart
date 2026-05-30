import 'package:flutter/material.dart';

class Editor extends StatelessWidget {
  final TextEditingController? controlador;
  final String? rotulo;
  final String? dica;
  final IconData? icone;

  // Novo parâmetro: tipo de teclado
  final TextInputType? tipoTeclado;  

  const Editor({
    this.controlador,
    this.rotulo,
    this.dica,
    this.icone,
    this.tipoTeclado,    
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controlador,
        style: const TextStyle(fontSize: 25.0),

        decoration: InputDecoration(
          icon: icone != null ? Icon(icone) : null,
          labelText: rotulo,
          hintText: dica,
        ),

        // Caso o tipoTeclado seja nulo, o Flutter usará o padrão de texto
        keyboardType: tipoTeclado ?? TextInputType.text,        
      ),
    );
  }
}