// tablas/tabla_virus.dart
import 'package:flutter/material.dart';
import 'tabla_base.dart';

class TablaResultadosVirus extends StatefulWidget {
  const TablaResultadosVirus({super.key});
  
  @override
  State<TablaResultadosVirus> createState() => _TablaResultadosVirusState();
}

class _TablaResultadosVirusState extends State<TablaResultadosVirus> 
    with TablaResultadosMixin {
  
  @override
  int get idAnalisis => 1;
  
  @override
  List<DataColumn> buildColumnasEspecificas() {
    return [
      DataColumn(
        label: Text(
          'Presencia',
          style: TextStyle(fontWeight: FontWeight.bold, color: colorAnalisis),
        ),
      ),
      DataColumn(
        label: Text(
          'CT/Absorbancia',
          style: TextStyle(fontWeight: FontWeight.bold, color: colorAnalisis),
        ),
      ),
      DataColumn(
        label: Text(
          'Fecha',
          style: TextStyle(fontWeight: FontWeight.bold, color: colorAnalisis),
        ),
      ),
    ];
  }
  
  @override
  DataRow buildFilaEspecifica(Map<String, dynamic> resultado, int index) {
    return DataRow(
      color: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          return index.isEven ? Colors.grey.shade50 : Colors.white;
        },
      ),
      cells: [
        ...buildCeldasComunes(resultado, index),
        DataCell(buildCeldaPresencia(resultado['presencia'])),
        DataCell(_buildCeldaCtAbsorbancia(resultado)),
        DataCell(
          Text(
            formatearFecha(resultado['fecha']),
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildBotonEliminar(resultado),
            ],
          ),
        ),
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) => buildScaffold(context);
  
  Widget _buildCeldaCtAbsorbancia(Map<String, dynamic> resultado) {
    final valor = resultado['ctAbsorbancia']?.toString() ?? '';
    final metodo = resultado['metodo']?.toString() ?? '';
    
    if (valor.isEmpty) {
      return Text('-', style: TextStyle(color: Colors.grey.shade500));
    }
    
    String unidad = '';
    Color? colorValor;
    
    if (metodo.toLowerCase().contains('pcr')) {
      unidad = ' CT';
      double? valorNumerico = double.tryParse(valor);
      if (valorNumerico != null) {
        if (valorNumerico < 30) {
          colorValor = Colors.red.shade700;
        } else if (valorNumerico > 35) {
          colorValor = Colors.green.shade700;
        } else {
          colorValor = Colors.orange.shade700;
        }
      }
    } else if (metodo.toLowerCase().contains('elisa')) {
      unidad = ' Abs';
      double? valorNumerico = double.tryParse(valor);
      if (valorNumerico != null) {
        if (valorNumerico > 0.3) {
          colorValor = Colors.red.shade700;
        } else if (valorNumerico < 0.1) {
          colorValor = Colors.green.shade700;
        } else {
          colorValor = Colors.orange.shade700;
        }
      }
    }
    
    return Text(
      '$valor$unidad',
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: colorValor ?? Colors.black87,
      ),
    );
  }
}