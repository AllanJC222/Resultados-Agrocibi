// tablas/tabla_resultados_mixin.dart
import 'package:flutter/material.dart';
import '../sistema_datos.dart';
import '../app_bar.dart';

/// Mixin con TODA la lógica común de tablas de resultados
/// Las tablas específicas solo configuran parámetros
mixin TablaResultadosMixin<T extends StatefulWidget> on State<T> {
  
  // ========================================
  // CONFIGURACIÓN ESPECÍFICA - Cada tabla implementa
  // ========================================
  
  /// ID del análisis (1=Virus, 2=Nematodos, 3=Hongos, 4=Bacteriología)
  int get idAnalisis;
  
  /// Construye las columnas específicas del análisis (después de las comunes)
  List<DataColumn> buildColumnasEspecificas();
  
  /// Construye una fila específica del análisis
  DataRow buildFilaEspecifica(Map<String, dynamic> resultado, int index);
  
  // ========================================
  // VARIABLES COMPARTIDAS - Heredadas automáticamente
  // ========================================
  
  List<Map<String, dynamic>> resultados = [];
  List<Map<String, dynamic>> resultadosFiltrados = [];
  bool isLoading = false;
  
  // Controlador de filtro universal
  final TextEditingController filtroUniversalController = TextEditingController();
  
  // Paginación
  int paginaActual = 0;
  static const int resultadosPorPagina = 10;
  
  // Datos del análisis (auto-configurados)
  late Analisis? analisis;
  late Color colorAnalisis;
  late String tituloAnalisis;
  
  // ========================================
  // INICIALIZACIÓN AUTOMÁTICA
  // ========================================
  
  @override
  void initState() {
    super.initState();
    // Auto-configuración basada en idAnalisis
    analisis = SistemaDatos.getAnalisisPorId(idAnalisis);
    colorAnalisis = analisis?.color ?? Colors.grey;
    tituloAnalisis = analisis?.nombre ?? 'Análisis';
    cargarResultados(); // ← Carga automática
  }
  
  @override
  void dispose() {
    filtroUniversalController.dispose();
    super.dispose();
  }
  
  // ========================================
  // LÓGICA COMÚN - Reutilizable exacta
  // ========================================
  
  /// Carga los resultados desde sistema_datos
  void cargarResultados() {
    setState(() {
      isLoading = true;
    });
    
    try {
      // Simular delay de carga
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          resultados = SistemaDatos.getResultadosPorAnalisis(idAnalisis);
          aplicarFiltros();
          isLoading = false;
        });
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      mostrarError('Error al cargar resultados: $e');
    }
  }
  
  /// Aplica filtros a los resultados
  void aplicarFiltros() {
    setState(() {
      String busqueda = filtroUniversalController.text;
      
      if (busqueda.isEmpty) {
        // Si no hay búsqueda, mostrar todos
        resultadosFiltrados = List.from(resultados);
      } else {
        // Filtrar por coincidencia en cualquier campo
        resultadosFiltrados = resultados.where((resultado) {
          return _coincideEnAlgunCampo(resultado, busqueda);
        }).toList();
      }
      
      paginaActual = 0; // Reset paginación
    });
  }
  
  /// Método helper para búsqueda universal
  bool _coincideEnAlgunCampo(Map<String, dynamic> resultado, String busqueda) {
    String busquedaLower = busqueda.toLowerCase();
    
    // Revisa cada valor del Map
    for (var valor in resultado.values) {
      if (valor == null) continue; // Evita nulls
      
      String valorStr = valor.toString().toLowerCase();
      
      // Si encuentra coincidencia, ya no sigue buscando
      if (valorStr.contains(busquedaLower)) {
        return true;
      }
    }
    
    return false; // No encontró nada
  }
  
  /// Obtiene resultados paginados
  List<Map<String, dynamic>> get resultadosPaginados {
    int inicio = paginaActual * resultadosPorPagina;
    int fin = (inicio + resultadosPorPagina).clamp(0, resultadosFiltrados.length);
    
    if (inicio >= resultadosFiltrados.length) return [];
    return resultadosFiltrados.sublist(inicio, fin);
  }
  
  /// Obtiene número total de páginas
  int get totalPaginas {
    return (resultadosFiltrados.length / resultadosPorPagina).ceil();
  }
  
  // ========================================
  // WIDGETS COMUNES - Heredados automáticamente
  // ========================================
  
  /// Widget de filtros
  Widget buildFiltros() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          // Campo universal (ocupa más espacio)
          Expanded(
            flex: 2, // 75% del ancho
            child: TextField(
              controller: filtroUniversalController,
              decoration: InputDecoration(
                hintText: 'Buscar en todos los campos...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              onChanged: (_) => aplicarFiltros(), // Filtra en tiempo real
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Botón limpiar
          Expanded(
            flex: 1, // 25% del ancho
            child: ElevatedButton.icon(
              onPressed: () {
                filtroUniversalController.clear(); // Limpia campo
                aplicarFiltros(); // Reaplica filtros
              },
              icon: const Icon(Icons.clear),
              label: const Text('Limpiar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Widget de estadísticas
  Widget buildEstadisticas() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: colorAnalisis.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Mostrando ${resultadosPaginados.length} de ${resultadosFiltrados.length} resultados',
            style: TextStyle(color: colorAnalisis, fontWeight: FontWeight.w600),
          ),
          Text(
            'Página ${totalPaginas > 0 ? paginaActual + 1 : 0} de $totalPaginas',
            style: TextStyle(color: colorAnalisis, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
  
  /// Contenido principal
  Widget buildContenidoPrincipal() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: colorAnalisis),
            const SizedBox(height: 16),
            const Text('Cargando resultados...'),
          ],
        ),
      );
    }
    
    if (resultadosFiltrados.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              filtroUniversalController.text.isNotEmpty
                  ? 'No se encontraron resultados con los filtros aplicados'
                  : 'No hay resultados para $tituloAnalisis',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (filtroUniversalController.text.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  filtroUniversalController.clear();
                  aplicarFiltros();
                },
                child: const Text('Limpiar filtros'),
              ),
          ],
        ),
      );
    }
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DataTable(
            headingRowColor: MaterialStateColor.resolveWith(
              (states) => colorAnalisis.withOpacity(0.1),
            ),
            dataRowMinHeight: 50,
            dataRowMaxHeight: 60,
            columns: buildColumnasCompletas(),
            rows: resultadosPaginados
                .asMap()
                .entries
                .map((entry) => buildFilaEspecifica(entry.value, entry.key))
                .toList(),
          ),
        ),
      ),
    );
  }
  
  /// Construye columnas completas (comunes + específicas)
  List<DataColumn> buildColumnasCompletas() {
    return [
      // Columnas comunes
      DataColumn(
        label: Text(
          'Código',
          style: TextStyle(fontWeight: FontWeight.bold, color: colorAnalisis),
        ),
      ),
      DataColumn(
        label: Text(
          'Tipo',
          style: TextStyle(fontWeight: FontWeight.bold, color: colorAnalisis),
        ),
      ),
      DataColumn(
        label: Text(
          'Método',
          style: TextStyle(fontWeight: FontWeight.bold, color: colorAnalisis),
        ),
      ),
      DataColumn(
        label: Text(
          'Variante',
          style: TextStyle(fontWeight: FontWeight.bold, color: colorAnalisis),
        ),
      ),
      
      // Columnas específicas (implementadas por cada hijo)
      ...buildColumnasEspecificas(),
      
      // Columna de acciones
      DataColumn(
        label: Text(
          'Acciones',
          style: TextStyle(fontWeight: FontWeight.bold, color: colorAnalisis),
        ),
      ),
    ];
  }
  
  /// Paginación
  Widget buildPaginacion() {
    if (totalPaginas <= 1) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Botón anterior
          ElevatedButton.icon(
            onPressed: paginaActual > 0
                ? () {
                    setState(() {
                      paginaActual--;
                    });
                  }
                : null,
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('Anterior'),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorAnalisis,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
          
          // Indicador de páginas
          Row(
            children: [
              for (int i = 0; i < totalPaginas && i < 5; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        paginaActual = i;
                      });
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: i == paginaActual
                            ? colorAnalisis
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          '${i + 1}',
                          style: TextStyle(
                            color: i == paginaActual
                                ? Colors.white
                                : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (totalPaginas > 5) const Text('...'),
            ],
          ),
          
          // Botón siguiente
          ElevatedButton.icon(
            onPressed: paginaActual < totalPaginas - 1
                ? () {
                    setState(() {
                      paginaActual++;
                    });
                  }
                : null,
            icon: const Icon(Icons.arrow_forward, size: 18),
            label: const Text('Siguiente'),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorAnalisis,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // ========================================
  // HELPERS COMUNES - Reutilizables
  // ========================================
  
  /// Muestra error al usuario
  void mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red),
    );
  }
  
  /// Widget común para botón eliminar (sin acción)
  Widget buildBotonEliminar(Map<String, dynamic> resultado) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red, size: 20),
      onPressed: () {
        // Sin acción como pediste
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Función no disponible'))
        );
      },
      tooltip: 'Eliminar (no disponible)',
    );
  }
  
  /// Widget común para celda de presencia
  Widget buildCeldaPresencia(bool? presencia) {
    if (presencia == null) {
      return const Text('-', style: TextStyle(color: Colors.grey));
    }
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          presencia ? Icons.check_circle : Icons.cancel,
          color: presencia ? Colors.green : Colors.red,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          presencia ? 'Sí' : 'No',
          style: TextStyle(
            color: presencia ? Colors.green : Colors.red,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
  
  /// Helper para celdas comunes (código, tipo, método, variante)
  List<DataCell> buildCeldasComunes(Map<String, dynamic> resultado, int index) {
    return [
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
    ];
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
  String formatearFecha(dynamic fecha) {
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
  
  // ========================================
  // SCAFFOLD COMPLETO - Heredado automáticamente
  // ========================================
  
  Widget buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar.buildAppBar(
        context,
        'Resultados: $tituloAnalisis',
        appBarColor: colorAnalisis,
      ),
      body: Column(
        children: [
          buildFiltros(),
          buildEstadisticas(),
          Expanded(child: buildContenidoPrincipal()),
          buildPaginacion(),
        ],
      ),
    );
  }
}