import 'package:flutter/material.dart';
import 'datos_almacen.dart';
import 'base_envio&recepcion.dart';

/// Vista de envío - SOLO configura parámetros específicos
/// TODO heredado del mixin AlmacenBaseLogic
class AlmacenEnvioView extends StatefulWidget {
  const AlmacenEnvioView({super.key});

  @override
  State<AlmacenEnvioView> createState() => _AlmacenEnvioViewState();
}

class _AlmacenEnvioViewState extends State<AlmacenEnvioView> 
    with AlmacenBaseLogic {
  
  @override
  void initState() {
    super.initState();
    cargarMuestras(); // ← Heredado
  }

  // ========================================
  // CONFIGURACIÓN ESPECÍFICA DE ENVÍO
  // ========================================
  
  @override
  List<Map<String, dynamic>> cargarMuestrasEspecificas() =>
      AlmacenDatos.getMuestrasPendientesEnvio();
  
  @override
  String get campoFechaFiltro => 'fechaMuestreo';
  
  @override
  Future<bool> actualizarFechasEspecificas(List<int> ids, String fecha) async =>
      AlmacenDatos.actualizarFechasEnvio(ids, fecha);
  
  @override
  String get mensajeExito => 'enviadas';

  // CONFIGURACIÓN DE UI
  @override
  String get tituloAppBar => 'Registro de envio de muestras';
  
  @override
  String get labelFiltroFecha => 'Filtrar por fecha de muestreo';
  
  @override
  String get labelAccion => 'Asignar fecha de envio a las muestras seleccionadas';
  
  @override
  String get textoBotonAccion => 'Actualizar fechas';
  
  @override
  String get columnaFechaTabla => 'Fecha Muestreo';
  
  @override
  String get mensajeVacio => 'No hay muestras disponibles';

  @override
  String get tipoAccion => 'envío';


  // ========================================
  // BUILD - UNA SOLA LÍNEA
  // ========================================
  
  @override
  Widget build(BuildContext context) => buildScaffold(context); // ← Heredado completo
}