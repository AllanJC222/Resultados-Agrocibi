// tabla_resultados_bacteriologia.dart
import 'package:flutter/material.dart';
import 'tabla_base.dart';

/// Tabla de resultados específica para análisis de Bacteriología
/// Campos específicos: Presencia, Conteo (semillas), Dilución
class TablaResultadosBacteriologia extends TablaResultadosBase {
  const TablaResultadosBacteriologia({super.key}) : super(idAnalisis: 4);

  @override
  State<TablaResultadosBacteriologia> createState() =>
      _TablaResultadosBacteriologiaState();
}

class _TablaResultadosBacteriologiaState
    extends TablaResultadosBaseState<TablaResultadosBacteriologia> {
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
      // Alternar color de filas
      color: MaterialStateProperty.resolveWith<Color?>((
        Set<MaterialState> states,
      ) {
        return index.isEven ? Colors.grey.shade50 : Colors.white;
      }),
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
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
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

        // Método con badge especial para PCR
        DataCell(_buildCeldaMetodo(resultado)),

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
        // CELDAS ESPECÍFICAS DE BACTERIOLOGÍA
        // ========================================

        // Presencia con ícono y color
        DataCell(buildCeldaPresencia(resultado['presencia'])),

        // Conteo UFC (principalmente para semillas)
        DataCell(_buildCeldaConteo(resultado)),

        // Dilución utilizada
        DataCell(_buildCeldaDilucion(resultado)),

        // Fecha formateada
        DataCell(
          Text(
            _formatearFecha(resultado['fecha']),
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
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
  // MÉTODOS HELPER ESPECÍFICOS DE BACTERIOLOGÍA
  // ========================================

  /// Construye celda de método con badge especial para PCR
  Widget _buildCeldaMetodo(Map<String, dynamic> resultado) {
    final metodo = resultado['metodo']?.toString() ?? '';

    return Text(metodo, style: const TextStyle(fontSize: 14));
  }

  /// Construye celda de conteo UFC
  Widget _buildCeldaConteo(Map<String, dynamic> resultado) {
    final conteo = resultado['conteo'];

    if (conteo == null) {
      return Text('-', style: TextStyle(color: Colors.grey.shade500));
    }

    int conteoInt = conteo is int
        ? conteo
        : int.tryParse(conteo.toString()) ?? 0;

    // Determinar color según nivel de contaminación
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

    // Formatear número con separadores de miles
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

  /// Construye celda de dilución
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

  /// Obtiene color para chip de tipo de muestra
  Color _getTipoMuestraColor(String? tipo) {
    switch (tipo?.toLowerCase()) {
      case 'tejido foliar':
        return Colors.green.shade100;
      case 'semilla':
        return Colors.amber.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  /// Formatea número con separadores de miles
  String _formatearNumero(int numero) {
    String numeroStr = numero.toString();
    if (numeroStr.length <= 3) return numeroStr;

    // Agregar comas cada 3 dígitos
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
