// tablas/tabla_bacterias.dart
import 'package:flutter/material.dart';
import 'tabla_base.dart';

class TablaResultadosBacteriologia extends StatefulWidget {
  const TablaResultadosBacteriologia({super.key});
  
  @override
  State<TablaResultadosBacteriologia> createState() => _TablaResultadosBacteriologiaState();
}

class _TablaResultadosBacteriologiaState extends State<TablaResultadosBacteriologia> 
    with TablaResultadosMixin {
  
  @override
  int get idAnalisis => 4;
  
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
          'Conteo UFC',
          style: TextStyle(fontWeight: FontWeight.bold, color: colorAnalisis),
        ),
      ),
      DataColumn(
        label: Text(
          'Dilución',
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
        DataCell(_buildCeldaConteo(resultado)),
        DataCell(_buildCeldaDilucion(resultado)),
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
  
  Widget _buildCeldaConteo(Map<String, dynamic> resultado) {
    final conteo = resultado['conteo'];
    
    if (conteo == null) {
      return Text('-', style: TextStyle(color: Colors.grey.shade500));
    }
    
    int conteoInt = conteo is int ? conteo : int.tryParse(conteo.toString()) ?? 0;
    
    Color colorConteo;
    if (conteoInt == 0) {
      colorConteo = Colors.green.shade700;
    } else if (conteoInt < 500) {
      colorConteo = Colors.orange.shade700;
    } else if (conteoInt < 2000) {
      colorConteo = Colors.red.shade600;
    } else {
      colorConteo = Colors.red.shade800;
    }
    
    String conteoFormateado = _formatearNumero(conteoInt);
    
    return Text(
      '$conteoFormateado UFC',
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: colorConteo,
      ),
    );
  }
  
  Widget _buildCeldaDilucion(Map<String, dynamic> resultado) {
    final dilucion = resultado['dilucion']?.toString();
    
    if (dilucion == null || dilucion.isEmpty) {
      return Text('-', style: TextStyle(color: Colors.grey.shade500));
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Text(
        '1:$dilucion',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.blue.shade700,
        ),
      ),
    );
  }
  
  String _formatearNumero(int numero) {
    String numeroStr = numero.toString();
    if (numeroStr.length <= 3) return numeroStr;
    
    String resultado = '';
    int contador = 0;
    
    for (int i = numeroStr.length - 1; i >= 0; i--) {
      if (contador == 3) {
        resultado = ',$resultado';
        contador = 0;
      }
      resultado = numeroStr[i] + resultado;
      contador++;
    }
    
    return resultado;
  }
}