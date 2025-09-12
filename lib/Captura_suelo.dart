import 'package:flutter/material.dart';
import 'app_bar.dart';
import 'popup_confirmacion.dart';
import 'popup_nuevo_punto.dart';

/// Vista simple para captura de puntos de suelo
/// Solo agrega puntos con GPS automático y selección de lote
class CapturaSueloView extends StatefulWidget {
  const CapturaSueloView({super.key});

  @override
  State<CapturaSueloView> createState() => _CapturaSueloViewState();
}

class _CapturaSueloViewState extends State<CapturaSueloView> {
  
  // Variables básicas
  List<Map<String, dynamic>> puntosMuestra = [];
  String idMuestra = '';
  String codigoMuestra = '';
  DateTime fechaMuestra = DateTime.now();
  String loteActualMuestra = ''; // Variable agregada para el lote actual
  
  // Colores
  final Color primaryColor = const Color(0xFFE85A2B);
  final Color accentColor = const Color(0xFF8BC34A);

  @override
  void initState() {
    super.initState();
    // Generar datos automáticos de la muestra
    idMuestra = 'SUELO_${DateTime.now().millisecondsSinceEpoch}';
    codigoMuestra = 'SL-${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}';
  }

  // Agregar punto (mostrar popup)
  void agregarPunto() async {
    try {
      // Obtener coordenadas simuladas
      Map<String, double> coordenadas = await obtenerCoordenadas();
      
      // Determinar si debe estar bloqueado el lote
      // Si ya hay puntos, usar el mismo lote (bloqueado)
      // Si es el primer punto, permitir selección libre
      bool loteBloqueado = puntosMuestra.isNotEmpty;
      String loteActual = puntosMuestra.isNotEmpty ? loteActualMuestra : '';
      
      // Mostrar popup de confirmación con todos los parámetros requeridos
      final puntoData = await NuevoPuntoPopup.show(
        context,
        numeroPunto: puntosMuestra.length + 1,
        codigoMuestra: codigoMuestra,
        latitud: coordenadas['latitud']!,
        longitud: coordenadas['longitud']!,
        loteActual: loteActual,
        bloqueado: loteBloqueado,
      );
      
      // Si confirmó, agregar punto
      if (puntoData != null) {
        setState(() {
          puntosMuestra.add({
            'numero': puntoData['numeroPunto'],
            'lote': puntoData['lote'],
            'fecha': DateTime.now().toIso8601String(),
            'latitud': puntoData['latitud'],
            'longitud': puntoData['longitud'],
          });
          
          // Actualizar el lote actual de la muestra
          if (loteActualMuestra.isEmpty) {
            loteActualMuestra = puntoData['lote'];
          }
        });
        mostrarMensaje('Punto ${puntoData['numeroPunto']} agregado');
      }
    } catch (e) {
      mostrarError('Error al obtener GPS');
    }
  }

  // Simular GPS
  Future<Map<String, double>> obtenerCoordenadas() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'latitud': 14.5844 + (DateTime.now().millisecond / 100000),
      'longitud': -90.4975 + (DateTime.now().millisecond / 100000),
    };
  }

  // Eliminar punto
  void eliminarPunto(int index) {
    setState(() {
      puntosMuestra.removeAt(index);
      
      // Si no quedan puntos, resetear el lote actual
      if (puntosMuestra.isEmpty) {
        loteActualMuestra = '';
      }
    });
    mostrarMensaje('Punto eliminado');
  }

  // Guardar muestra
  void guardarMuestra() async {
    if (puntosMuestra.isEmpty) {
      mostrarError('Agregue al menos un punto');
      return;
    }

    // Simular guardado
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mostrar popup de confirmación
    await ConfirmacionPopup.show(context);
    
    // Reset completo para nueva muestra
    setState(() {
      puntosMuestra.clear();
      loteActualMuestra = ''; // Resetear lote para nueva muestra
      idMuestra = 'SUELO_${DateTime.now().millisecondsSinceEpoch}';
      codigoMuestra = 'SL-${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}';
      fechaMuestra = DateTime.now();
    });
  }

  // Mostrar mensajes
  void mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: accentColor),
    );
  }

  void mostrarError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar.buildAppBar(
        context,
        "Captura de muestra\nSuelo exterior",
        appBarColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Información de la muestra
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      "Información de la muestra",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text("Código: $codigoMuestra"),
                    Text("Fecha: ${fechaMuestra.day}/${fechaMuestra.month}/${fechaMuestra.year}"),
                    Text("Puntos: ${puntosMuestra.length}"),
                    if (loteActualMuestra.isNotEmpty)
                      Text("Lote: $loteActualMuestra", 
                           style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Botón agregar punto
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: agregarPunto,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_location, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      puntosMuestra.isEmpty 
                        ? "Agregar primer punto" 
                        : "Agregar punto al lote $loteActualMuestra",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Lista de puntos
            Expanded(
              child: puntosMuestra.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_off, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            "No hay puntos agregados",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Presiona el botón para agregar tu primer punto",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: puntosMuestra.length,
                      itemBuilder: (context, index) {
                        final punto = puntosMuestra[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: accentColor,
                              child: Text('${punto['numero']}',
                                         style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                            title: Text('Punto ${punto['numero']} - Lote: ${punto['lote']}'),
                            subtitle: Text(
                              'Lat: ${punto['latitud'].toStringAsFixed(6)}\n'
                              'Lng: ${punto['longitud'].toStringAsFixed(6)}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => eliminarPunto(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            
            // Botón guardar (solo si hay puntos)
            if (puntosMuestra.isNotEmpty) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: guardarMuestra,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.save, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        "Guardar muestra (${puntosMuestra.length} puntos)", 
                        style: const TextStyle(color: Colors.white, fontSize: 16)
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ========================================
// NOTAS PARA IMPLEMENTACIÓN DE API
// ========================================

/*
ENDPOINTS NECESARIOS:

1. POST /muestras-suelo
   Body: {
     idMuestra: string,
     codigoMuestra: string, 
     fechaMuestra: datetime,
     lote: string,
     puntos: [
       {
         numero: int,
         latitud: double,
         longitud: double,
         fecha: datetime
       }
     ]
   }

2. GET /lotes (para popup de selección)
   Response: [
     { id: string, nombre: string, activo: boolean }
   ]

CAMBIOS PENDIENTES:

1. Reemplazar obtenerCoordenadas() con GPS real usando Geolocator
2. Agregar validación de permisos de ubicación
3. Manejar casos de GPS desactivado o sin señal
4. Implementar guardado real en base de datos
5. Agregar loading states durante operaciones async
6. Implementar retry logic para fallos de red

FLUJO DE DATOS:

1. Usuario abre pantalla → se generan IDs automáticos
2. Usuario presiona "Agregar punto" → obtiene GPS → muestra popup
3. Usuario selecciona lote (solo en primer punto) → confirma
4. Punto se agrega a lista local → UI se actualiza
5. Repetir pasos 2-4 para más puntos (lote queda fijo)
6. Usuario presiona "Guardar" → envía a API → muestra confirmación → reset
*/