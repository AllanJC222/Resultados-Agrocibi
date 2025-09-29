// tablas/tabla_nematodos.dart
import 'package:flutter/material.dart';
import 'tabla_base.dart';

class TablaResultadosNematodos extends StatefulWidget {
  const TablaResultadosNematodos({super.key});
  
  @override
  State<TablaResultadosNematodos> createState() => _TablaResultadosNematodosState();
}

class _TablaResultadosNematodosState extends State<TablaResultadosNematodos> 
    with TablaResultadosMixin {
  
  @override
  int get idAnalisis => 2;
  
  @override
  List<DataColumn> buildColumnasEspecificas() {
    return [
      DataColumn(
        label: Text(
          'Juveniles/g',
          style: TextStyle(fontWeight: FontWeight.bold, color: colorAnalisis),
        ),
      ),
      DataColumn(
        label: Text(
          'Nivel',
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
        DataCell(_buildCeldaJuveniles(resultado)),
        DataCell(_buildCeldaNivel(resultado)),
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
  
  Widget _buildCeldaJuveniles(Map<String, dynamic> resultado) {
    final juveniles = resultado['juveniles'];
    
    if (juveniles == null) {
      return Text('-', style: TextStyle(color: Colors.grey.shade500));
    }
    
    int juvenilesInt = juveniles is int ? juveniles : int.tryParse(juveniles.toString()) ?? 0;
    
    Color colorJuveniles;
    if (juvenilesInt == 0) {
      colorJuveniles = Colors.green.shade700;
    } else if (juvenilesInt < 20) {
      colorJuveniles = Colors.orange.shade700;
    } else if (juvenilesInt < 50) {
      colorJuveniles = Colors.red.shade600;
    } else {
      colorJuveniles = Colors.red.shade800;
    }
    
    return Text(
      '$juvenilesInt j/g',
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: colorJuveniles,
      ),
    );
  }
  
  Widget _buildCeldaNivel(Map<String, dynamic> resultado) {
    final juveniles = resultado['juveniles'];
    
    if (juveniles == null) {
      return const Text('-', style: TextStyle(color: Colors.grey));
    }
    
    int juvenilesInt = juveniles is int ? juveniles : int.tryParse(juveniles.toString()) ?? 0;
    
    String nivel;
    Color colorNivel;
    IconData icono;
    
    if (juvenilesInt == 0) {
      nivel = 'Sin detección';
      colorNivel = Colors.green;
      icono = Icons.check_circle;
    } else if (juvenilesInt < 20) {
      nivel = 'Bajo';
      colorNivel = Colors.orange;
      icono = Icons.warning;
    } else if (juvenilesInt < 50) {
      nivel = 'Medio';
      colorNivel = Colors.red.shade600;
      icono = Icons.error;
    } else {
      nivel = 'Alto';
      colorNivel = Colors.red.shade800;
      icono = Icons.dangerous;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorNivel.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: colorNivel.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 14, color: colorNivel),
          const SizedBox(width: 4),
          Text(
            nivel,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorNivel,
            ),
          ),
        ],
      ),
    );
  }
}