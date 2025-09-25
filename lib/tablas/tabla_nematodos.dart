// tabla_resultados_nematodos.dart
import 'package:flutter/material.dart';
import 'tabla_base.dart';

/// Tabla de resultados específica para análisis de Nematodos
/// Campos específicos: Juveniles por gramo (no maneja presencia)
class TablaResultadosNematodos extends TablaResultadosBase {
  const TablaResultadosNematodos({super.key}) : super(idAnalisis: 2);
  
  @override
  State<TablaResultadosNematodos> createState() => _TablaResultadosNematodosState();
}

class _TablaResultadosNematodosState extends TablaResultadosBaseState<TablaResultadosNematodos> {
  
  // ========================================
  // IMPLEMENTACIÓN DE MÉTODOS ABSTRACTOS
  // ========================================
  
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
      // Alternar color de filas
      color: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          return index.isEven ? Colors.grey.shade50 : Colors.white;
        },
      ),
      cells: [
        // ========================================
        // CELDAS COMUNES
        // ========================================
        
        // Código de muestra
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              resultado['codigoMuestra'] ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
        
        // Tipo de muestra con chip
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Chip(
              label: Text(
                resultado['tipoMuestra'] ?? '',
                style: const TextStyle(fontSize: 12),
              ),
              backgroundColor: _getTipoMuestraColor(resultado['tipoMuestra']),
              side: BorderSide.none,
            ),
          ),
        ),
        
        // Método
        DataCell(
          Text(
            resultado['metodo'] ?? '',
            style: const TextStyle(fontSize: 14),
          ),
        ),
        
        // Variante con estilo
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: colorAnalisis.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              resultado['variante'] ?? '',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: colorAnalisis,
              ),
            ),
          ),
        ),
        
        // ========================================
        // CELDAS ESPECÍFICAS DE NEMATODOS
        // ========================================
        
        // Juveniles por gramo con formato y color
        DataCell(
          _buildCeldaJuveniles(resultado),
        ),
        
        // Nivel de infestación basado en juveniles
        DataCell(
          _buildCeldaNivel(resultado),
        ),
        
        // Fecha formateada
        DataCell(
          Text(
            _formatearFecha(resultado['fecha']),
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        
        // Acciones
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [            
              // Botón eliminar (sin acción)
              buildBotonEliminar(resultado),
            ],
          ),
        ),
      ],
    );
  }
  
  // ========================================
  // MÉTODOS HELPER ESPECÍFICOS DE NEMATODOS
  // ========================================
  
  /// Construye celda de juveniles con formato y color
  Widget _buildCeldaJuveniles(Map<String, dynamic> resultado) {
    final juveniles = resultado['juveniles'];
    
    if (juveniles == null) {
      return Text(
        '-',
        style: TextStyle(color: Colors.grey.shade500),
      );
    }
    
    int juvenilesInt = juveniles is int ? juveniles : int.tryParse(juveniles.toString()) ?? 0;
    
    // Determinar color según nivel de juveniles
    Color colorJuveniles;
    if (juvenilesInt == 0) {
      colorJuveniles = Colors.green.shade700; // Sin nematodos
    } else if (juvenilesInt < 20) {
      colorJuveniles = Colors.orange.shade700; // Bajo
    } else if (juvenilesInt < 50) {
      colorJuveniles = Colors.red.shade600; // Medio
    } else {
      colorJuveniles = Colors.red.shade800; // Alto
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
  
  /// Construye celda de nivel de infestación
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
  
  /// Obtiene color para chip de tipo de muestra
  Color _getTipoMuestraColor(String? tipo) {
    switch (tipo?.toLowerCase()) {
      case 'tejido foliar':
        return Colors.green.shade100;
      case 'suelo':
        return Colors.brown.shade100;
      default:
        return Colors.grey.shade100;
    }
  }
  
  /// Formatea fecha para mostrar
  String _formatearFecha(dynamic fecha) {
    if (fecha == null) return '-';
    
    String fechaStr = fecha.toString();
    try {
      DateTime fechaDateTime = DateTime.parse(fechaStr);
      return '${fechaDateTime.day.toString().padLeft(2, '0')}/'
             '${fechaDateTime.month.toString().padLeft(2, '0')}/'
             '${fechaDateTime.year}';
    } catch (e) {
      return fechaStr;
    }
  }
}