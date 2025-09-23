import 'package:flutter/material.dart';
import 'resultados_base.dart';
import '../widgets.dart';

class ResultadosNematodos extends ResultadosBase {
  const ResultadosNematodos({
    Key? key,
    required super.metodo,
  }) : super(key: key);
  
  @override
  State<ResultadosNematodos> createState() => _ResultadosNematodosState();
}

class _ResultadosNematodosState extends ResultadosBaseState<ResultadosNematodos> {
  
  @override
  Widget buildCamposEspecificos() {
    final List<Widget> campos = [];
    
    // Nematodos solo tiene método 4 (Centrifugación)
    if (widget.metodo.idMetodo == 4) {
      // Campo para juveniles por gramos (aplica para tejido y suelo)
      campos.add(SandiaInputField(
        label: "Juveniles por gramos de suelo",
        controller: valorNumericoController,
        keyboardType: TextInputType.number,
        isRequired: true,
      ));
    } else {
      campos.add(const Center(
        child: Text('Método no configurado para Nematodos'),
      ));
    }
    
    return Column(children: campos);
  }
  
  @override
  bool validarCampos() {
    // Primero validar que haya variante
    if (!super.validarCampos()) return false;
    
    // Para centrifugación validar que haya valor de juveniles
    if (widget.metodo.idMetodo == 4) {
      return valorNumericoController.text.isNotEmpty;
    }
    
    return true;
  }
}