// tabla_resultados_base.dart
import 'package:flutter/material.dart';
import '../sistema_datos.dart';
import '../app_bar.dart';

/// Clase base abstracta para todas las tablas de resultados
/// Maneja filtros, paginación, estructura común
abstract class TablaResultadosBase extends StatefulWidget {
  final int idAnalisis; // 1=Virus, 2=Nematodos, 3=Hongos, 4=Bacteriología

  const TablaResultadosBase({super.key, required this.idAnalisis});
}

abstract class TablaResultadosBaseState<T extends TablaResultadosBase>
    extends State<T> {
  // ========================================
  // ESTADO COMÚN
  // ========================================

  // Datos y filtros
  List<Map<String, dynamic>> resultados = [];
  List<Map<String, dynamic>> resultadosFiltrados = [];
  bool isLoading = false;

  // Controladores de filtros
  final TextEditingController filtroUniversalController =
      TextEditingController();

  // Paginación
  int paginaActual = 0;
  static const int resultadosPorPagina = 10;

  // Datos del análisis
  late Analisis? analisis;
  late Color colorAnalisis;
  late String tituloAnalisis;

  // ========================================
  // MÉTODOS ABSTRACTOS - Cada hijo implementa
  // ========================================

  /// Construye las columnas específicas del análisis
  List<DataColumn> buildColumnasEspecificas();

  /// Construye una fila específica del análisis
  DataRow buildFilaEspecifica(Map<String, dynamic> resultado, int index);

  // ========================================
  // INICIALIZACIÓN
  // ========================================

  @override
  void initState() {
    super.initState();
    analisis = SistemaDatos.getAnalisisPorId(widget.idAnalisis);
    colorAnalisis = analisis?.color ?? Colors.grey;
    tituloAnalisis = analisis?.nombre ?? 'Análisis';
    cargarResultados();
  }

  @override
  void dispose() {
    filtroUniversalController.dispose();
    super.dispose();
  }

  // ========================================
  // LÓGICA DE DATOS
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
          resultados = SistemaDatos.getResultadosPorAnalisis(widget.idAnalisis);
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
        // 📋 Si no hay búsqueda, mostrar todos
        resultadosFiltrados = List.from(resultados);
      } else {
        // 🔍 Filtrar por coincidencia en cualquier campo
        resultadosFiltrados = resultados.where((resultado) {
          return _coincideEnAlgunCampo(resultado, busqueda);
        }).toList();
      }

      paginaActual = 0; // 🔄 Reset paginación
    });
  }

  // 🔍 Método helper para búsqueda universal
  bool _coincideEnAlgunCampo(Map<String, dynamic> resultado, String busqueda) {
    String busquedaLower = busqueda.toLowerCase();

    // 🔄 Revisa cada valor del Map
    for (var valor in resultado.values) {
      if (valor == null) continue; // 🛡️ Evita nulls

      String valorStr = valor.toString().toLowerCase();

      // ✅ Si encuentra coincidencia, ya no sigue buscando
      if (valorStr.contains(busquedaLower)) {
        return true;
      }
    }

    return false; // ❌ No encontró nada
  }

  /// Obtiene resultados paginados
  List<Map<String, dynamic>> get resultadosPaginados {
    int inicio = paginaActual * resultadosPorPagina;
    int fin = (inicio + resultadosPorPagina).clamp(
      0,
      resultadosFiltrados.length,
    );

    if (inicio >= resultadosFiltrados.length) return [];
    return resultadosFiltrados.sublist(inicio, fin);
  }

  /// Obtiene número total de páginas
  int get totalPaginas {
    return (resultadosFiltrados.length / resultadosPorPagina).ceil();
  }

  // ========================================
  // UI PRINCIPAL
  // ========================================

  @override
  Widget build(BuildContext context) {
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

  // ========================================
  // WIDGETS DE FILTROS
  // ========================================

  Widget buildFiltros() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          // 🔍 CAMPO UNIVERSAL (ocupa más espacio)
          Expanded(
            flex: 2, // 75% del ancho
            child: TextField(
              controller: filtroUniversalController,
              decoration: InputDecoration(
                hintText:
                    'Buscar', // 💡 Hint descriptivo
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              onChanged: (_) => aplicarFiltros(), // 🔄 Filtra en tiempo real
            ),
          ),

          const SizedBox(width: 16),

          // 🗑️ BOTÓN LIMPIAR (más pequeño)
          Expanded(
            flex: 1, // 25% del ancho
            child: ElevatedButton.icon(
              onPressed: () {
                filtroUniversalController.clear(); // 🧹 Limpia campo
                aplicarFiltros(); // 🔄 Reaplica filtros
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

  // ========================================
  // WIDGET DE ESTADÍSTICAS
  // ========================================

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

  // ========================================
  // CONTENIDO PRINCIPAL
  // ========================================

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

  // ========================================
  // PAGINACIÓN
  // ========================================

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
  // MÉTODOS UTILITARIOS
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Función no disponible')));
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
}
