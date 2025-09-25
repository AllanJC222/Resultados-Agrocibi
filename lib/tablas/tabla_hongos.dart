// tabla_resultados_hongos.dart
import 'package:flutter/material.dart';
import 'tabla_base.dart';

/// Tabla de resultados específica para análisis de Hongos
/// Campos específicos: Presencia (tejido), Conteo UFC/g (suelo)
class TablaResultadosHongos extends TablaResultadosBase {
  const TablaResultadosHongos({super.key}) : super(idAnalisis: 3);
  
  @override
  State<TablaResultadosHongos> createState() => _TablaResultadosHongosState();
}

class _TablaResultadosHongosState extends TablaResultadosBaseState<TablaResultadosHongos> {
  
  // ========================================
  // IMPLEMENTACIÓN DE MÉTODOS ABSTRACTOS
  // ========================================
  
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
        // CELDAS ESPECÍFICAS DE HONGOS
        // ========================================
        
        // Presencia (principalmente para tejido)
        DataCell(
          buildCeldaPresencia(resultado['presencia']),
        ),
        
        // Conteo UFC/g (principalmente para suelo)
        DataCell(
          _buildCeldaConteo(resultado),
        ),
        
        // Nivel de riesgo basado en conteo o presencia
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
  // MÉTODOS HELPER ESPECÍFICOS DE HONGOS
  // ========================================
  
  /// Construye celda de conteo UFC/g con formato
  Widget _buildCeldaConteo(Map<String, dynamic> resultado) {
    final conteo = resultado['conteo'];
    
    if (conteo == null) {
      return Text(
        '-',
        style: TextStyle(color: Colors.grey.shade500),
      );
    }
    
    int conteoInt = conteo is int ? conteo : int.tryParse(conteo.toString()) ?? 0;
    
    // Determinar color según nivel de conteo
    Color colorConteo;
    if (conteoInt == 0) {
      colorConteo = Colors.green.shade700; // Sin hongos
    } else if (conteoInt < 100) {
      colorConteo = Colors.orange.shade700; // Bajo
    } else if (conteoInt < 500) {
      colorConteo = Colors.red.shade600; // Medio
    } else {
      colorConteo = Colors.red.shade800; // Alto
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
  
  /// Construye celda de nivel de riesgo
  Widget _buildCeldaNivel(Map<String, dynamic> resultado) {
    final presencia = resultado['presencia'];
    final conteo = resultado['conteo'];
    final tipoMuestra = resultado['tipoMuestra']?.toString().toLowerCase() ?? '';
    
    String nivel;
    Color colorNivel;
    IconData icono;
    
    if (tipoMuestra.contains('tejido')) {
      // Para tejido, usar presencia
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
      // Para suelo, usar conteo
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