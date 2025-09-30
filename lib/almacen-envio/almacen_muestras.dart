import 'package:flutter/material.dart';
import 'datos_almacen.dart';
import '../app_bar.dart';
import '../popip_muestra.dart';
import 'wingest_almacen.dart';
import '../sistema_datos.dart';

/// Vista mínima de lista de almacén - solo estructura básica
class ListaAlmacenView extends StatefulWidget {
  const ListaAlmacenView({super.key});

  @override
  State<ListaAlmacenView> createState() => _ListaAlmacenViewState();
}

class _ListaAlmacenViewState extends State<ListaAlmacenView> {
  List<Map<String, dynamic>> muestras = [];
  List<Map<String, dynamic>> muestrasFiltradas = [];
  bool isLoading = false;

  final TextEditingController filtroController =
      TextEditingController(); // ← AGREGAR

  final Color primaryColor = const Color(0xFFE85A2B);
  final Color accentColor = const Color(0xFF8BC34A);

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  @override
  void dispose() {
    filtroController.dispose();
    super.dispose();
  }

  void _cargarDatos() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        muestras = AlmacenDatos.getMuestrasAlmacen();
        muestrasFiltradas = List.from(muestras); // ← LÍNEA NUEVA
        isLoading = false;
      });
    });
  }

  /// Filtro universal - busca en todos los campos
  Widget _buildFiltros() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: filtroController,
              decoration: InputDecoration(
                hintText: 'Buscar en todas las muestras...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              onChanged: (_) => aplicarFiltros(),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            flex: 1,
            child: ElevatedButton.icon(
              onPressed: () {
                filtroController.clear();
                aplicarFiltros();
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

  /// Aplica filtro buscando en todos los campos
  void aplicarFiltros() {
    setState(() {
      String busqueda = filtroController.text;

      if (busqueda.isEmpty) {
        muestrasFiltradas = List.from(muestras);
      } else {
        muestrasFiltradas = muestras.where((muestra) {
          return _coincideEnAlgunCampo(muestra, busqueda);
        }).toList();
      }
    });
  }

  /// Busca la coincidencia en todos los valores del Map
  bool _coincideEnAlgunCampo(Map<String, dynamic> muestra, String busqueda) {
    String busquedaLower = busqueda.toLowerCase();

    for (var valor in muestra.values) {
      if (valor == null) continue;

      String valorStr = valor.toString().toLowerCase();

      if (valorStr.contains(busquedaLower)) {
        return true;
      }
    }

    return false;
  }

  /// Abre popup con detalles - usa datos por defecto de SistemaDatos
  void _verDetalles(Map<String, dynamic> muestra) {
    showDialog(
      context: context,
      builder: (context) => MuestraPopup(muestra: SistemaDatos.muestra),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar.buildAppBar(
        context,
        'Lista de Muestras\nAlmacén',
        appBarColor: primaryColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildFiltros(), // ← AGREGAR ESTA LÍNEA
                _buildEncabezado(),
                Expanded(child: _buildCuerpo()),
              ],
            ),
    );
  }

  /// Encabezado con estadísticas - reutiliza AlmacenStatsCard
  Widget _buildEncabezado() {
    return AlmacenStatsCard(
      totalMuestras: muestras.length,
      muestrasFiltradas: muestrasFiltradas.length,
      muestrasSeleccionadas: 0,
      accentColor: accentColor,
    );
  }

  /// Cuerpo principal - lista simple con cards
  Widget _buildCuerpo() {
    if (muestrasFiltradas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              filtroController.text.isNotEmpty
                  ? 'No se encontraron muestras con ese criterio'
                  : 'No hay muestras en el almacén',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            if (filtroController.text.isNotEmpty) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  filtroController.clear();
                  aplicarFiltros();
                },
                child: const Text('Limpiar filtro'),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: muestrasFiltradas.length,
      itemBuilder: (context, index) =>
          _buildFilaMuestra(muestrasFiltradas[index]),
    );
  }

  /// Fila individual de muestra - card simple con botón detalles
  Widget _buildFilaMuestra(Map<String, dynamic> muestra) {
  return Card(
    margin: const EdgeInsets.only(bottom: 8),
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: _getColorEstado(muestra),
        child: Text(
          muestra['codigo'].toString().split('-').last,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
      title: Text('${muestra['codigo']} - ${muestra['tipo']}'),
      subtitle: Text('${muestra['finca']} | ${muestra['lote']}'),
      
      // 🎯 AQUÍ ESTÁ EL CAMBIO - trailing ahora es una Row con 2 botones
      trailing: Row(
        mainAxisSize: MainAxisSize.min, // ← IMPORTANTE: que solo ocupe lo necesario
        children: [
          // Botón de info (el que ya tenías)
          IconButton(
            icon: Icon(Icons.info_outline, color: accentColor),
            onPressed: () => _verDetalles(muestra),
            tooltip: 'Ver detalles',
          ),
          
          // Botón de eliminar (nuevo)
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
            onPressed: () => _verDetalles(muestra), // ← llamamos el popup
            tooltip: 'Eliminar muestra',
          ),
        ],
      ),
    ),
  );
}

  /// Color según estado de envío
  Color _getColorEstado(Map<String, dynamic> muestra) {
    if (muestra['fechaRecepcion'] != null) return Colors.green;
    if (muestra['fechaEnvio'] != null) return Colors.orange;
    return Colors.red;
  }
}
