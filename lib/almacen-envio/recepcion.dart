import 'package:flutter/material.dart';
import 'datos_almacen.dart';
import 'base_envio&recepcion.dart';

/// Vista de recepción - SOLO configura parámetros específicos
/// TODO heredado del mixin almacen_envio&recepcion
class AlmacenRecepcionView extends StatefulWidget {
  const AlmacenRecepcionView({super.key});

  @override
  State<AlmacenRecepcionView> createState() => _AlmacenRecepcionViewState();
}

class _AlmacenRecepcionViewState extends State<AlmacenRecepcionView> 
    with AlmacenBaseLogic {
  
  @override
  void initState() {
    super.initState();
    cargarMuestras(); // ← Heredado
  }

  // ========================================
  // CONFIGURACIÓN ESPECÍFICA DE RECEPCIÓN
  // ========================================
  
  @override
  List<Map<String, dynamic>> cargarMuestrasEspecificas() =>
      AlmacenDatos.getMuestrasEnviadas(); // ← Solo muestras enviadas
  
  @override
  String get campoFechaFiltro => 'fechaEnvio';
  
  @override
  Future<bool> actualizarFechasEspecificas(List<int> ids, String fecha) async =>
      AlmacenDatos.actualizarFechasRecepcion(ids, fecha);
  
  @override
  String get mensajeExito => 'recibidas';

  // CONFIGURACIÓN DE UI
  @override
  String get tituloAppBar => 'Registro de recepción\n de muestras';
  
  @override
  String get labelFiltroFecha => 'Filtrar por fecha de envío';
  
  @override
  String get labelAccion => 'Asignar fecha de recepción a las muestras seleccionadas';
  
  @override
  String get textoBotonAccion => 'Marcar como recibidas';
  
  @override
  String get columnaFechaTabla => 'Fecha Envío';
  
  @override
  String get mensajeVacio => 'No hay muestras enviadas disponibles';

  @override
  String get tipoAccion => 'recepción';

  // ========================================
  // BUILD - UNA SOLA LÍNEA
  // ========================================
  
  @override
  Widget build(BuildContext context) => buildScaffold(context); // ← Heredado completo
}