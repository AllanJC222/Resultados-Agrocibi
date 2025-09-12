import 'package:flutter/material.dart';

// ========================================
// POPUP DE CONFIRMACIÓN DE NUEVO PUNTO GPS
// ========================================
// Este popup se usa en CapturaSueloView para confirmar la adición de puntos GPS
// Características especiales:
// - Muestra información automática (GPS, código muestra, número punto)
// - Solo permite editar el LOTE
// - Bloquea el lote después del primer punto para mantener consistencia
// - Valida que se seleccione un lote antes de confirmar

/// Popup para confirmar la creación de un nuevo punto de muestra
/// Muestra información automática y permite seleccionar solo el lote
/// Clase estática (utility class) porque solo proporciona métodos helper
class NuevoPuntoPopup {

  // ========================================
  // MÉTODO PRINCIPAL - MOSTRAR POPUP
  // ========================================
  
  /// Muestra el popup de confirmación de nuevo punto
  /// @param context - Contexto de la pantalla que llama al popup
  /// @param numeroPunto - Número secuencial del punto (1, 2, 3...)
  /// @param codigoMuestra - Código de la muestra padre (ej: "SL-12092025")
  /// @param latitud - Coordenada GPS de latitud
  /// @param longitud - Coordenada GPS de longitud  
  /// @param loteActual - Lote ya seleccionado (vacío si es primer punto)
  /// @param bloqueado - Si true, no permite cambiar lote (después del primer punto)
  /// @return Future<Map?> - Map con datos del punto si confirma, null si cancela
  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    required int numeroPunto,           // Parámetros obligatorios con required
    required String codigoMuestra,
    required double latitud,
    required double longitud,
    required String loteActual,
    required bool bloqueado,
  }) async {
    // showDialog<T> especifica el tipo de dato que devuelve el popup
    return showDialog<Map<String, dynamic>?>(
      context: context,
      barrierDismissible: false, // IMPORTANTE: No se puede cerrar tocando fuera
      builder: (BuildContext context) {
        // Devuelve el widget interno que maneja el estado
        return _NuevoPuntoDialog(
          numeroPunto: numeroPunto,
          codigoMuestra: codigoMuestra,
          latitud: latitud,
          longitud: longitud,
          loteActual: loteActual,
          bloqueado: bloqueado,
        );
      },
    );
  }
}

// ========================================
// WIDGET INTERNO DEL DIALOG (STATEFUL)
// ========================================
// Este widget maneja el estado interno del popup (lote seleccionado)
// Es privado (_NuevoPuntoDialog) porque solo se usa dentro de esta clase

/// Widget interno del dialog
/// StatefulWidget porque necesita manejar la selección del lote
class _NuevoPuntoDialog extends StatefulWidget {
  
  // ========================================
  // PROPIEDADES INMUTABLES (DESDE EL PADRE)
  // ========================================
  
  final int numeroPunto;        // Número del punto (1, 2, 3...)
  final String codigoMuestra;   // Código de muestra (ej: "SL-12092025")
  final double latitud;         // GPS - Coordenada Y
  final double longitud;        // GPS - Coordenada X
  final String loteActual;      // Lote ya seleccionado (vacío o con valor)
  final bool bloqueado;         // Si true = no permite cambiar lote

  /// Constructor interno con todos los parámetros requeridos
  const _NuevoPuntoDialog({
    required this.numeroPunto,
    required this.codigoMuestra,
    required this.latitud,
    required this.longitud,
    required this.loteActual,
    required this.bloqueado,
  });

  @override
  // createState() crea la instancia del estado mutable
  State<_NuevoPuntoDialog> createState() => _NuevoPuntoDialogState();
}

class _NuevoPuntoDialogState extends State<_NuevoPuntoDialog> {
  
  // ========================================
  // VARIABLES DE ESTADO MUTABLE
  // ========================================
  
  /// Lote seleccionado por el usuario
  /// Inicia vacío y se actualiza con el dropdown o se auto-asigna si está bloqueado
  String _loteSeleccionado = '';
  
  // Colores del tema (constantes locales para este popup)
  final Color _primaryColor = const Color(0xFFE85A2B); // Naranja
  final Color _accentColor = const Color(0xFF8BC34A);  // Verde

  @override
  void initState() {
    // initState() se ejecuta una vez al crear el widget
    super.initState();
    
    // ========================================
    // LÓGICA DE AUTO-ASIGNACIÓN DE LOTE
    // ========================================
    
    // Si el lote está bloqueado Y hay un lote actual, usarlo automáticamente
    // Esto pasa cuando es el 2do, 3er, 4to... punto de la misma muestra
    if (widget.bloqueado && widget.loteActual.isNotEmpty) {
      _loteSeleccionado = widget.loteActual;
    }
    // Si no está bloqueado, _loteSeleccionado queda vacío (usuario debe elegir)
  }

  @override
  Widget build(BuildContext context) {
    // build() construye toda la UI del popup
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        // Ancho: 90% de la pantalla (más ancho que otros popups)
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          // mainAxisSize.min = solo el tamaño necesario
          mainAxisSize: MainAxisSize.min,
          children: [
            
            // ========================================
            // SECCIÓN 1: HEADER NARANJA
            // ========================================
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _primaryColor, // Naranja del tema
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: const Text(
                "Nuevo punto de captura",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            
            // ========================================
            // SECCIÓN 2: CONTENIDO PRINCIPAL
            // ========================================
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  // ========================================
                  // SUBSECCIÓN 2.1: INFORMACIÓN DEL PUNTO
                  // ========================================
                  
                  // Container con toda la información automática
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,              // Fondo gris claro
                      borderRadius: BorderRadius.circular(15), // Esquinas redondeadas
                      border: Border.all(color: Colors.grey.shade300), // Borde sutil
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        // ========================================
                        // NÚMERO DE PUNTO
                        // ========================================
                        
                        Text(
                          "# de punto de la muestra (número de muestra)",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700, // Gris para etiquetas
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Punto ${widget.numeroPunto}", // "Punto 1", "Punto 2", etc.
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // ========================================
                        // CÓDIGO DE MUESTRA
                        // ========================================
                        
                        Text(
                          "Código de muestra:",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.codigoMuestra, // Ej: "SL-12092025"
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // ========================================
                        // COORDENADAS GPS (AUTOMÁTICAS)
                        // ========================================
                        
                        Text(
                          "Coordenadas GPS:",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // toStringAsFixed(6) = mostrar 6 decimales para precisión GPS
                        Text(
                          "Lat: ${widget.latitud.toStringAsFixed(6)}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "Lng: ${widget.longitud.toStringAsFixed(6)}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // ========================================
                        // SELECCIÓN DE LOTE (ÚNICA PARTE EDITABLE)
                        // ========================================
                        
                        Text(
                          "Lote:",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Dropdown dinámico (bloqueado o libre)
                        _buildLoteDropdown(),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // ========================================
                  // SUBSECCIÓN 2.2: BOTONES DE ACCIÓN
                  // ========================================
                  
                  Column(
                    children: [
                      // Botón principal: "Agregar nuevo punto"
                      _buildActionButton(
                        text: "Agregar nuevo punto",
                        backgroundColor: _accentColor, // Verde
                        textColor: Colors.white,
                        // onPressed condicional: solo funciona si hay lote seleccionado
                        onPressed: _loteSeleccionado.isNotEmpty ? _confirmarPunto : null,
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Botón secundario: "Cancelar"
                      _buildActionButton(
                        text: "Cancelar",
                        backgroundColor: Colors.grey.shade300, // Gris
                        textColor: Colors.black87,
                        onPressed: _cancelar, // Siempre habilitado
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========================================
  // MÉTODO HELPER: DROPDOWN DE LOTE
  // ========================================

  /// Construye el dropdown para selección de lote
  /// Comportamiento dinámico:
  /// - Si bloqueado = muestra lote fijo con candado
  /// - Si libre = muestra dropdown seleccionable
  Widget _buildLoteDropdown() {
    
    // ========================================
    // CASO 1: LOTE BLOQUEADO (2do+ punto)
    // ========================================
    
    if (widget.bloqueado) {
      // Mostrar container gris con candado (no editable)
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade400, // Gris para indicar bloqueado
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.loteActual, // Mostrar lote ya seleccionado
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            // Icono de candado para indicar que está bloqueado
            Icon(Icons.lock, color: Colors.white.withOpacity(0.7), size: 20),
          ],
        ),
      );
    }

    // ========================================
    // CASO 2: LOTE LIBRE (1er punto)
    // ========================================

    // Mostrar dropdown normal seleccionable
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _primaryColor, // Naranja del tema
        borderRadius: BorderRadius.circular(25),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          // value: valor actual seleccionado (null si no hay selección)
          value: _loteSeleccionado.isEmpty ? null : _loteSeleccionado,
          hint: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Seleccione lote",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          dropdownColor: _primaryColor,    // Color del menú desplegable
          icon: const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.keyboard_arrow_down, color: Colors.white),
          ),
          
          // ========================================
          // ITEMS DEL DROPDOWN (HARDCODEADOS)
          // ========================================
          
          // NOTA PARA API: Esta lista debe venir de un endpoint
          items: ['Lote A', 'Lote B', 'Lote C', 'Lote D', 'Lote E'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  value,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            );
          }).toList(),
          
          // ========================================
          // CALLBACK DE SELECCIÓN
          // ========================================
          
          onChanged: (String? newValue) {
            // setState() actualiza la UI cuando cambia la selección
            setState(() {
              _loteSeleccionado = newValue ?? ''; // ?? '' maneja el caso null
            });
          },
        ),
      ),
    );
  }

  // ========================================
  // MÉTODO HELPER: BOTONES DE ACCIÓN
  // ========================================

  /// Factory method para crear botones con estilo consistente
  /// @param text - Texto del botón
  /// @param backgroundColor - Color de fondo
  /// @param textColor - Color del texto
  /// @param onPressed - Función callback (null = deshabilitado)
  Widget _buildActionButton({
    required String text,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback? onPressed, // Puede ser null para deshabilitar
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        // Color condicional: si onPressed es null, usar gris (deshabilitado)
        color: onPressed != null ? backgroundColor : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(28),
      ),
      child: TextButton(
        onPressed: onPressed, // null = botón deshabilitado
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            // Color de texto condicional también
            color: onPressed != null ? textColor : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  // ========================================
  // LÓGICA DE NEGOCIO - ACCIONES DEL USUARIO
  // ========================================

  /// Confirma la creación del punto y retorna los datos al widget padre
  /// Se ejecuta cuando usuario presiona "Agregar nuevo punto"
  void _confirmarPunto() {
    
    // ========================================
    // CONSTRUCCIÓN DEL OBJETO DE RESPUESTA
    // ========================================
    
    // Crear Map con todos los datos del punto
    final puntoData = {
      'numeroPunto': widget.numeroPunto,        // Número secuencial
      'codigoMuestra': widget.codigoMuestra,    // Código de la muestra padre
      'lote': _loteSeleccionado,                // Lote seleccionado por usuario
      'latitud': widget.latitud,                // GPS latitud
      'longitud': widget.longitud,              // GPS longitud
      'fecha': DateTime.now().toIso8601String(), // Timestamp actual en formato ISO
    };
    
    // ========================================
    // CERRAR POPUP Y DEVOLVER DATOS
    // ========================================
    
    // Navigator.pop(context, data) hace dos cosas:
    // 1. Cierra el popup actual
    // 2. Devuelve 'puntoData' al widget que abrió este popup
    Navigator.of(context).pop(puntoData);
  }

  /// Cancela la creación del punto
  /// Se ejecuta cuando usuario presiona "Cancelar"
  void _cancelar() {
    // Navigator.pop(context, null) devuelve null
    // Esto indica al widget padre que el usuario canceló
    Navigator.of(context).pop(null);
  }
}

// ========================================
// NOTAS PARA IMPLEMENTACIÓN DE API
// ========================================

/*
ENDPOINT NECESARIO:

GET /lotes
Response: [
  {
    "id": "lote-a",
    "nombre": "Lote A", 
    "activo": true,
    "area": 2.5,
    "cultivo": "Tomate"
  },
  {
    "id": "lote-b", 
    "nombre": "Lote B",
    "activo": true,
    "area": 1.8,
    "cultivo": "Pepino"  
  }
]

CAMBIOS NECESARIOS:

1. REEMPLAZAR LISTA HARDCODEADA:
   Actual: ['Lote A', 'Lote B', 'Lote C', 'Lote D', 'Lote E']
   Futuro: await ApiService.getLotes() en initState()

2. AGREGAR LOADING STATE:
   - Mostrar loading spinner mientras carga lotes
   - Manejar error si falla la consulta
   - Mostrar mensaje si no hay lotes disponibles

3. VALIDACIÓN MEJORADA:
   - Verificar que lote seleccionado existe y está activo
   - Validar coordenadas GPS (rango válido)
   - Validar que numeroPunto sea positivo

FLUJO DE DATOS ACTUAL:

1. CapturaSueloView llama NuevoPuntoPopup.show()
2. Popup muestra información y permite seleccionar lote
3. Usuario elige lote y presiona "Agregar"
4. Popup devuelve Map con datos completos
5. CapturaSueloView agrega punto a lista local
6. Lista se actualiza y muestra nuevo punto

ESTRUCTURA DE RESPUESTA:

{
  'numeroPunto': int,        // 1, 2, 3...
  'codigoMuestra': string,   // "SL-12092025"  
  'lote': string,            // "Lote A"
  'latitud': double,         // 14.584512
  'longitud': double,        // -90.497832
  'fecha': string           // "2025-09-12T10:30:00.000Z"
}

LÓGICA DE BLOQUEO DE LOTE:

- Primer punto: bloqueado = false → usuario puede elegir cualquier lote
- Puntos 2+: bloqueado = true → automáticamente usa el mismo lote
- Razón: Mantener consistencia, todos los puntos de una muestra = mismo lote
- Beneficio: Evita errores humanos y simplifica la experiencia

CONSIDERACIONES ESPECIALES:

1. GPS PRECISION: 
   - Coordenadas con 6 decimales (~1 metro precisión)
   - Validar que coordenadas estén en rango válido (Guatemala)

2. MANEJO DE ERRORES:
   - GPS no disponible → mostrar error y permitir reintentar
   - Sin permisos de ubicación → solicitar permisos
   - Lotes no cargan → mostrar mensaje y botón retry

3. UX MEJORAS:
   - Previsualizar ubicación en mapa pequeño
   - Mostrar distancia del punto anterior
   - Confirmar si coordenadas parecen incorrectas

4. VALIDACIONES:
   - Código muestra no vacío
   - Coordenadas en rango válido
   - Lote seleccionado existe en sistema
   - Número punto > 0
*/