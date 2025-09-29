// almacen_base_logic.dart
import 'package:flutter/material.dart';
import 'datos_almacen.dart';
import 'wingest_almacen.dart';
import '../app_bar.dart';
import 'poppup_confimacion_almacen.dart';

/// Mixin con TODA la lógica Y widgets comunes
/// Las pantallas solo configuran parámetros específicos
mixin AlmacenBaseLogic<T extends StatefulWidget> on State<T> {
  // ========================================
  // VARIABLES COMPARTIDAS
  // ========================================

  List<Map<String, dynamic>> todasLasMuestras = [];
  List<Map<String, dynamic>> muestrasFiltradas = [];
  Set<int> muestrasSeleccionadas = <int>{};

  DateTime? fechaFiltro;
  String? tipoMuestraFiltro;
  DateTime? fechaAccionNueva;

  bool isLoading = false;
  bool isLoadingUpdate = false;

  final Color primaryColor = const Color(0xFFE85A2B);
  final Color accentColor = const Color(0xFF8BC34A);

  // ========================================
  // CONFIGURACIÓN ESPECÍFICA - Cada pantalla implementa
  // ========================================

  List<Map<String, dynamic>> cargarMuestrasEspecificas();
  String get campoFechaFiltro;
  Future<bool> actualizarFechasEspecificas(List<int> ids, String fecha);
  String get mensajeExito;

  // CONFIGURACIÓN UI - Cada pantalla define
  String get tituloAppBar;
  String get labelFiltroFecha;
  String get labelAccion;
  String get textoBotonAccion;
  String get columnaFechaTabla;
  String get mensajeVacio;
  String get tipoAccion;


  // ========================================
  // LÓGICA COMÚN - Reutilizable exacta
  // ========================================

  void cargarMuestras() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        todasLasMuestras = cargarMuestrasEspecificas();
        aplicarFiltros();
        isLoading = false;
      });
    });
  }

  void aplicarFiltros() {
    setState(() {
      muestrasFiltradas = List.from(todasLasMuestras);

      if (fechaFiltro != null) {
        String fechaBuscar = AlmacenDatos.formatearFechaParaBD(fechaFiltro!);
        muestrasFiltradas = muestrasFiltradas.where((muestra) {
          return muestra[campoFechaFiltro] == fechaBuscar;
        }).toList();
      }

      if (tipoMuestraFiltro != null && tipoMuestraFiltro!.isNotEmpty) {
        muestrasFiltradas = muestrasFiltradas.where((muestra) {
          return muestra['tipo'] == tipoMuestraFiltro;
        }).toList();
      }

      limpiarSeleccionesInvalidas();
    });
  }

  void limpiarSeleccionesInvalidas() {
    Set<int> idsFiltrados = muestrasFiltradas
        .map((m) => m['id'] as int)
        .toSet();
    muestrasSeleccionadas.removeWhere((id) => !idsFiltrados.contains(id));
  }

  void limpiarFiltros() {
    setState(() {
      fechaFiltro = null;
      tipoMuestraFiltro = null;
      muestrasSeleccionadas.clear();
      aplicarFiltros();
    });
  }

  void toggleSelectAll(bool? selectAll) {
    setState(() {
      if (selectAll == true) {
        muestrasSeleccionadas.addAll(
          muestrasFiltradas.map((m) => m['id'] as int),
        );
      } else {
        muestrasSeleccionadas.clear();
      }
    });
  }

  void toggleMuestraSeleccion(int id, bool? selected) {
    setState(() {
      if (selected == true) {
        muestrasSeleccionadas.add(id);
      } else {
        muestrasSeleccionadas.remove(id);
      }
    });
  }

  bool? get selectAllState {
    if (muestrasSeleccionadas.isEmpty) return false;
    if (muestrasSeleccionadas.length == muestrasFiltradas.length) return true;
    return null;
  }

  Future<void> actualizarFechas() async {
  // Validación 1: Debe haber fecha seleccionada
  if (fechaAccionNueva == null) {
    mostrarError('Por favor selecciona una fecha');
    return;
  }

  // Validación 2: Debe haber muestras seleccionadas
  if (muestrasSeleccionadas.isEmpty) {
    mostrarError('Por favor selecciona al menos una muestra');
    return;
  }

  // ========================================
  // ⭐ NUEVO: MOSTRAR POPUP DE CONFIRMACIÓN
  // ========================================
  
  final bool? confirmar = await ConfirmacionAlmacenPopup.show(
    context,
    tipoAccion: tipoAccion, // "envío" o "recepción" desde la vista
    cantidadMuestras: muestrasSeleccionadas.length,
    fechaSeleccionada: fechaAccionNueva!,
    accentColor: accentColor,
  );

  // Si el usuario canceló (cerró el popup o presionó Cancelar)
  if (confirmar != true) {
    print('❌ Usuario canceló la operación de $tipoAccion');
    return; // Salir sin hacer nada
  }

  // ========================================
  // CONTINUAR CON LA ACTUALIZACIÓN
  // ========================================
  
  print('✅ Usuario confirmó la operación de $tipoAccion');

  setState(() {
    isLoadingUpdate = true;
  });

  try {
    String fechaFormateada = AlmacenDatos.formatearFechaParaBD(
      fechaAccionNueva!,
    );
    
    bool success = await actualizarFechasEspecificas(
      muestrasSeleccionadas.toList(),
      fechaFormateada,
    );

    if (success) {
      await Future.delayed(const Duration(milliseconds: 800));
      mostrarExito('${muestrasSeleccionadas.length} muestras $mensajeExito');

      cargarMuestras();
      setState(() {
        muestrasSeleccionadas.clear();
        fechaAccionNueva = null;
      });
    } else {
      mostrarError('Error al actualizar fechas');
    }
  } catch (e) {
    mostrarError('Error: $e');
  } finally {
    setState(() {
      isLoadingUpdate = false;
    });
  }
}

  void mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void mostrarExito(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: accentColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Color getTipoColorText(String? tipo) {
    switch (tipo?.toLowerCase()) {
      case 'tejido':
        return Colors.green.shade700;
      case 'suelo':
        return Colors.brown.shade700;
      case 'semilla':
        return Colors.amber.shade800;
      default:
        return Colors.grey.shade700;
    }
  }

  // ========================================
  // WIDGETS COMPLETOS - Heredados directamente
  // ========================================

  /// Widget de filtros - PARAMÉTRICO
  Widget buildFiltros() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: SandiaDatePicker(
              label: labelFiltroFecha, // ← Paramétrico
              selectedDate: fechaFiltro,
              onChanged: (fecha) {
                setState(() {
                  fechaFiltro = fecha;
                  aplicarFiltros();
                });
              },
              hintText: 'Todas las fechas',
              accentColor: accentColor,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: limpiarFiltros,
                    icon: const Icon(Icons.clear, size: 18),
                    label: const Text('Limpiar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Widget de estadísticas - PARAMÉTRICO
  Widget buildStatsCard() {

    return AlmacenStatsCard(
      totalMuestras: todasLasMuestras.length,
      muestrasFiltradas: muestrasFiltradas.length,
      muestrasSeleccionadas: muestrasSeleccionadas.length,
      accentColor: accentColor,
    );
  }

  /// Widget de panel de acciones - PARAMÉTRICO
  Widget buildPanelAcciones() {
    return MassiveActionPanel(
      selectedDate: fechaAccionNueva,
      onDateChanged: (fecha) {
        setState(() {
          fechaAccionNueva = fecha;
        });
      },
      onUpdatePressed: actualizarFechas,
      dateLabel: labelAccion, // ← Paramétrico
      buttonText: textoBotonAccion, // ← Paramétrico
      selectedCount: muestrasSeleccionadas.length,
      isLoading: isLoadingUpdate,
      accentColor: accentColor,
    );
  }

  /// Widget de tabla completa - PARAMÉTRICO
  Widget buildTabla() {
    if (muestrasFiltradas.isEmpty) {
      return buildEstadoVacio();
    }

    return Container(
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
      child: Column(
        children: [
          buildHeaderTabla(),
          Divider(height: 1, color: Colors.grey.shade300),
          Expanded(
            child: ListView.builder(
              itemCount: muestrasFiltradas.length,
              itemBuilder: (context, index) => buildFilaTabla(index),
            ),
          ),
        ],
      ),
    );
  }

  /// Header de tabla - PARAMÉTRICO
  Widget buildHeaderTabla() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Checkbox(
              tristate: true,
              value: selectAllState,
              onChanged: toggleSelectAll,
              activeColor: accentColor,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),

          Expanded(
            flex: 3,
            child: Text(
              'Código',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: accentColor,
                fontSize: 14,
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              'Tipo',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: accentColor,
                fontSize: 14,
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: Text(
              columnaFechaTabla, // ← Paramétrico
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: accentColor,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Fila individual de tabla - PARAMÉTRICO
  Widget buildFilaTabla(int index) {
    Map<String, dynamic> muestra = muestrasFiltradas[index];
    int id = muestra['id'];
    bool isSelected = muestrasSeleccionadas.contains(id);

    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? accentColor.withOpacity(0.1)
            : (index.isEven ? Colors.grey.shade50 : Colors.white),
      ),
      child: InkWell(
        onTap: () => toggleMuestraSeleccion(id, !isSelected),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: Checkbox(
                  value: isSelected,
                  onChanged: (selected) => toggleMuestraSeleccion(id, selected),
                  activeColor: accentColor,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),

              Expanded(
                flex: 3,
                child: Text(
                  muestra['codigo'] ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              Expanded(
                flex: 2,
                child: Text(
                  muestra['tipo'] ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: getTipoColorText(muestra['tipo']),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              Expanded(
                flex: 3,
                child: Text(
                  AlmacenDatos.formatearFechaParaMostrar(
                    muestra[campoFechaFiltro],
                  ),
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Estado vacío - PARAMÉTRICO
  Widget buildEstadoVacio() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            fechaFiltro != null
                ? 'No hay muestras para la fecha seleccionada'
                : mensajeVacio, // ← Paramétrico
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          if (fechaFiltro != null || tipoMuestraFiltro != null)
            ElevatedButton(
              onPressed: limpiarFiltros,
              child: const Text('Limpiar filtros'),
            ),
        ],
      ),
    );
  }

  /// SCAFFOLD COMPLETO - Heredado directamente
  Widget buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar.buildAppBar(
        context,
        tituloAppBar,
        appBarColor: primaryColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                buildFiltros(),
                if (muestrasFiltradas.isNotEmpty) buildPanelAcciones(),
                buildStatsCard(),
                Expanded(child: buildTabla()),
              ],
            ),
    );
  }
}
