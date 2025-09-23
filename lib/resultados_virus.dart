import 'package:flutter/material.dart';
import 'resultados_base.dart';
import '../widgets.dart';

class ResultadosVirus extends ResultadosBase {
  const ResultadosVirus({
    Key? key,
    required super.metodo,
  }) : super(key: key);
  
  @override
  State<ResultadosVirus> createState() => _ResultadosVirusState();
}

class _ResultadosVirusState extends ResultadosBaseState<ResultadosVirus> {
  
  @override
  Widget buildCamposEspecificos() {
    final List<Widget> campos = [];
    
    // Según el método de virus
    switch (widget.metodo.idMetodo) {
      case 1: // ELISA
      case 2: // PCR
        // Checkbox de presencia
        campos.add(SandiaCheckbox(
          label: "Presencia",
          value: presenciaValue,
          onChanged: (value) {
            setState(() {
              presenciaValue = value ?? false;
            });
          },
          color: colorAnalisis,
        ));
        
        campos.add(const SizedBox(height: 20));
        
        // Campo numérico (Absorbancia para ELISA, CT para PCR)
        campos.add(SandiaInputField(
          label: widget.metodo.idMetodo == 1 ? "Absorbancia" : "CT",
          controller: valorNumericoController,
          keyboardType: TextInputType.number,
          isRequired: true,
        ));
        break;
        
      case 3: // Prueba Rápida AGDIA
        // Solo checkbox de presencia
        campos.add(SandiaCheckbox(
          label: "Presencia",
          value: presenciaValue,
          onChanged: (value) {
            setState(() {
              presenciaValue = value ?? false;
            });
          },
          color: colorAnalisis,
        ));
        break;
        
      default:
        campos.add(const Center(
          child: Text('Método no configurado'),
        ));
    }
    
    return Column(children: campos);
  }
  
  @override
  bool validarCampos() {
    // Primero validar que haya variante
    if (!super.validarCampos()) return false;
    
    // Para ELISA y PCR validar que haya valor numérico
    if (widget.metodo.idMetodo == 1 || widget.metodo.idMetodo == 2) {
      return valorNumericoController.text.isNotEmpty;
    }
    
    return true;
  }
}