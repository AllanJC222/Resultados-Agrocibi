// tabla_resultados_virus.dart
import 'package:flutter/material.dart';
import 'tabla_base.dart';

/// Tabla de resultados específica para análisis de Virus
/// Campos específicos: Presencia, CT/Absorbancia
class TablaResultadosVirus extends TablaResultadosBase {
  const TablaResultadosVirus({super.key}) : super(idAnalisis: 1);
  
  @override
  State<TablaResultadosVirus> createState() => _TablaResultadosVirusState();
}

class _TablaResultadosVirusState extends TablaResultadosBaseState<TablaResultadosVirus> {
  
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
      // Alternar color de filas para mejor legibilidad
      color: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          return index.isEven ? Colors.grey.shade50 : Colors.white;
        },
      ),
      cells: [
        // ========================================
        // CELDAS COMUNES (definidas en base)
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
        // CELDAS ESPECÍFICAS DE VIRUS
        // ========================================
        
        // Presencia con ícono y color
        DataCell(
          buildCeldaPresencia(resultado['presencia']),
        ),
        
        // CT/Absorbancia
        DataCell(
          _buildCeldaCtAbsorbancia(resultado),
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
              // Botón eliminar (sin acción como pediste)
              buildBotonEliminar(resultado),
            ],
          ),
        ),
      ],
    );
  }
  
  // ========================================
  // MÉTODOS HELPER ESPECÍFICOS DE VIRUS
  // ========================================
  
  /// Construye celda de CT/Absorbancia con formato específico
  Widget _buildCeldaCtAbsorbancia(Map<String, dynamic> resultado) {
    final valor = resultado['ctAbsorbancia']?.toString() ?? '';
    final metodo = resultado['metodo']?.toString() ?? '';
    
    if (valor.isEmpty) {
      return Text(
        '-',
        style: TextStyle(color: Colors.grey.shade500),
      );
    }
    
    // Determinar si es CT o Absorbancia según el método
    String unidad = '';
    Color? colorValor;
    
    if (metodo.toLowerCase().contains('pcr')) {
      // Para PCR es CT
      unidad = ' CT';
      double? valorNumerico = double.tryParse(valor);
      if (valorNumerico != null) {
        // CT < 30 = positivo fuerte, CT > 35 = negativo/débil
        if (valorNumerico < 30) {
          colorValor = Colors.red.shade700; // Positivo fuerte
        } else if (valorNumerico > 35) {
          colorValor = Colors.green.shade700; // Negativo
        } else {
          colorValor = Colors.orange.shade700; // Intermedio
        }
      }
    } else if (metodo.toLowerCase().contains('elisa')) {
      // Para ELISA es Absorbancia
      unidad = ' Abs';
      double? valorNumerico = double.tryParse(valor);
      if (valorNumerico != null) {
        // Abs > 0.3 = positivo, Abs < 0.1 = negativo
        if (valorNumerico > 0.3) {
          colorValor = Colors.red.shade700; // Positivo
        } else if (valorNumerico < 0.1) {
          colorValor = Colors.green.shade700; // Negativo
        } else {
          colorValor = Colors.orange.shade700; // Intermedio
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
  
  /// Obtiene color para chip de tipo de muestra
  Color _getTipoMuestraColor(String? tipo) {
    switch (tipo?.toLowerCase()) {
      case 'tejido foliar':
        return Colors.green.shade100;
      case 'suelo':
        return Colors.brown.shade100;
      case 'semilla':
        return Colors.amber.shade100;
      case 'agua':
        return Colors.blue.shade100;
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