// tablas/tabla_hongos.dart
import 'package:flutter/material.dart';
import 'tabla_base.dart';

class TablaResultadosHongos extends StatefulWidget {
  const TablaResultadosHongos({super.key});
  
  @override
  State<TablaResultadosHongos> createState() => _TablaResultadosHongosState();
}

class _TablaResultadosHongosState extends State<TablaResultadosHongos> 
    with TablaResultadosMixin {
  
  @override
  int get idAnalisis => 3;
  
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
          'Conteo UFC/g',
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
        DataCell(buildCeldaPresencia(resultado['presencia'])),
        DataCell(_buildCeldaConteo(resultado)),
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
  
  Widget _buildCeldaConteo(Map<String, dynamic> resultado) {
    final conteo = resultado['conteo'];
    
    if (conteo == null) {
      return Text('-', style: TextStyle(color: Colors.grey.shade500));
    }
    
    int conteoInt = conteo is int ? conteo : int.tryParse(conteo.toString()) ?? 0;
    
    Color colorConteo;
    if (conteoInt == 0) {
      colorConteo = Colors.green.shade700;
    } else if (conteoInt < 100) {
      colorConteo = Colors.orange.shade700;
    } else if (conteoInt < 500) {
      colorConteo = Colors.red.shade600;
    } else {
      colorConteo = Colors.red.shade800;
    }
    
    return Text(
      '$conteoInt UFC/g',
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: colorConteo,
      ),
    );
  }
  
  Widget _buildCeldaNivel(Map<String, dynamic> resultado) {
    final presencia = resultado['presencia'];
    final conteo = resultado['conteo'];
    final tipoMuestra = resultado['tipoMuestra']?.toString().toLowerCase() ?? '';
    
    String nivel;
    Color colorNivel;
    IconData icono;
    
    if (tipoMuestra.contains('tejido')) {
      if (presencia == true) {
        nivel = 'Positivo';
        colorNivel = Colors.red;
        icono = Icons.warning;
      } else if (presencia == false) {
        nivel = 'Negativo';
        colorNivel = Colors.green;
        icono = Icons.check_circle;
      } else {
        nivel = 'Sin datos';
        colorNivel = Colors.grey;
        icono = Icons.help_outline;
      }
    } else {
      int conteoInt = conteo is int ? conteo : int.tryParse(conteo.toString()) ?? 0;
      
      if (conteoInt == 0) {
        nivel = 'Sin detección';
        colorNivel = Colors.green;
        icono = Icons.check_circle;
      } else if (conteoInt < 100) {
        nivel = 'Bajo';
        colorNivel = Colors.orange;
        icono = Icons.warning;
      } else if (conteoInt < 500) {
        nivel = 'Medio';
        colorNivel = Colors.red.shade600;
        icono = Icons.error;
      } else {
        nivel = 'Alto';
        colorNivel = Colors.red.shade800;
        icono = Icons.dangerous;
      }
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