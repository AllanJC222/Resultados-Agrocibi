// ============================================
// DATOS Y LÓGICA ESPECÍFICA PARA ALMACÉN DE MUESTRAS
// ============================================

/// Clase para manejar todos los datos del almacén de muestras
/// Separada para mantener modularidad y no tocar sistema_datos.dart
class AlmacenDatos {
  
  // ========================================
  // DATOS SIMULADOS DE MUESTRAS
  // ========================================
  
  /// Lista de muestras para gestión de almacén (envío y recepción)
  /// Simula muestras reales con diferentes estados de fechas
  static List<Map<String, dynamic>> _muestrasAlmacen = [
    {
      'id': 1,
      'codigo': 'M-2025-001',
      'tipo': 'Tejido',
      'fechaMuestreo': '2025-09-15',
      'fechaEnvio': null, // Sin enviar
      'fechaRecepcion': null,
      'finca': 'Finca El Progreso',
      'lote': 'Lote A',
      'analisis': ['Virus', 'Hongos'],
    },
    {
      'id': 2,
      'codigo': 'M-2025-002', 
      'tipo': 'Suelo',
      'fechaMuestreo': '2025-09-15',
      'fechaEnvio': '2025-09-16', // Ya enviado
      'fechaRecepcion': null,
      'finca': 'Finca San José',
      'lote': 'Lote B',
      'analisis': ['Nematodos'],
    },
    {
      'id': 3,
      'codigo': 'M-2025-003',
      'tipo': 'Tejido',
      'fechaMuestreo': '2025-09-15',
      'fechaEnvio': '2025-09-16', // Ya enviado
      'fechaRecepcion': '2025-09-18', // Ya recibido
      'finca': 'Finca El Progreso',
      'lote': 'Lote A',
      'analisis': ['Bacterias'],
    },
    {
      'id': 4,
      'codigo': 'M-2025-004',
      'tipo': 'Semilla',
      'fechaMuestreo': '2025-09-16',
      'fechaEnvio': null, // Sin enviar
      'fechaRecepcion': null,
      'finca': 'Finca Los Robles',
      'lote': 'Lote C',
      'analisis': ['Virus', 'Bacterias'],
    },
    {
      'id': 5,
      'codigo': 'M-2025-005',
      'tipo': 'Tejido',
      'fechaMuestreo': '2025-09-16',
      'fechaEnvio': null, // Sin enviar
      'fechaRecepcion': null,
      'finca': 'Finca San José',
      'lote': 'Lote D',
      'analisis': ['Hongos'],
    },
    {
      'id': 6,
      'codigo': 'M-2025-006',
      'tipo': 'Suelo',
      'fechaMuestreo': '2025-09-17',
      'fechaEnvio': '2025-09-18', // Ya enviado
      'fechaRecepcion': null,
      'finca': 'Finca El Progreso', 
      'lote': 'Lote A',
      'analisis': ['Nematodos', 'Hongos'],
    },
    {
      'id': 7,
      'codigo': 'M-2025-007',
      'tipo': 'Tejido',
      'fechaMuestreo': '2025-09-17',
      'fechaEnvio': null, // Sin enviar
      'fechaRecepcion': null,
      'finca': 'Finca Los Robles',
      'lote': 'Lote B',
      'analisis': ['Virus'],
    },
    {
      'id': 8,
      'codigo': 'M-2025-008',
      'tipo': 'Semilla',
      'fechaMuestreo': '2025-09-18',
      'fechaEnvio': null, // Sin enviar
      'fechaRecepcion': null,
      'finca': 'Finca San José',
      'lote': 'Lote C',
      'analisis': ['Bacterias', 'Virus'],
    },
    {
      'id': 9,
      'codigo': 'M-2025-009',
      'tipo': 'Tejido',
      'fechaMuestreo': '2025-09-18',
      'fechaEnvio': '2025-09-19', // Ya enviado
      'fechaRecepcion': null,
      'finca': 'Finca El Progreso',
      'lote': 'Lote A',
      'analisis': ['Hongos', 'Virus'],
    },
    {
      'id': 10,
      'codigo': 'M-2025-010',
      'tipo': 'Suelo',
      'fechaMuestreo': '2025-09-19',
      'fechaEnvio': null, // Sin enviar
      'fechaRecepcion': null,
      'finca': 'Finca Los Robles',
      'lote': 'Lote D',
      'analisis': ['Nematodos'],
    },
  ];

  // ========================================
  // MÉTODOS DE CONSULTA GENERAL
  // ========================================

  /// Obtiene todas las muestras de almacén (copia para evitar modificación directa)
  static List<Map<String, dynamic>> getMuestrasAlmacen() {
    return List.from(_muestrasAlmacen);
  }


  /// Obtiene el total de muestras en el sistema
  static int getTotalMuestras() {
    return _muestrasAlmacen.length;
  }

  // ========================================
  // MÉTODOS ESPECÍFICOS PARA ENVÍO
  // ========================================

  /// Obtiene muestras SIN fecha de envío (pendientes de envío)
  static List<Map<String, dynamic>> getMuestrasPendientesEnvio() {
  var muestras = _muestrasAlmacen.where((muestra) {
    return muestra['fechaEnvio'] == null;
  }).toList();
  
  // Ordenar por fecha de muestreo descendente (más reciente primero)
  muestras.sort((a, b) {
    String fechaA = a['fechaMuestreo'] ?? '';
    String fechaB = b['fechaMuestreo'] ?? '';
    return fechaB.compareTo(fechaA); // ← invertido = descendente
  });
  
  return muestras;
}

  /// Obtiene muestras QUE YA fueron enviadas
  static List<Map<String, dynamic>> getMuestrasEnviadas() {
  var muestras = _muestrasAlmacen.where((muestra) {
    return muestra['fechaEnvio'] != null;
  }).toList();
  
  // Ordenar por fecha de envío descendente (más reciente primero)
  muestras.sort((a, b) {
    String fechaA = a['fechaEnvio'] ?? '';
    String fechaB = b['fechaEnvio'] ?? '';
    return fechaB.compareTo(fechaA); // ← invertido = descendente
  });
  
  return muestras;
}

  /// Obtiene muestras completamente procesadas (enviadas Y recibidas)
  static List<Map<String, dynamic>> getMuestrasCompletas() {
    return _muestrasAlmacen.where((muestra) {
      return muestra['fechaEnvio'] != null && muestra['fechaRecepcion'] != null;
    }).toList();
  }


  // ========================================
  // MÉTODOS DE ACTUALIZACIÓN
  // ========================================

  /// Actualiza fecha de envío de muestras específicas
  /// @param ids - Lista de IDs de muestras a actualizar
  /// @param fechaEnvio - Nueva fecha en formato 'YYYY-MM-DD'
  /// @return true si se actualizó correctamente, false si hubo error
  static bool actualizarFechasEnvio(List<int> ids, String fechaEnvio) {
    try {
      int actualizados = 0;
      
      for (int id in ids) {
        // Buscar índice de la muestra por ID
        int index = _muestrasAlmacen.indexWhere((m) => m['id'] == id);
        
        if (index != -1) {
          _muestrasAlmacen[index]['fechaEnvio'] = fechaEnvio;
          actualizados++;
        }
      }
      
      // Considerar éxito si se actualizó al menos una muestra
      return actualizados > 0;
      
    } catch (e) {
      return false;
    }
  }

  /// Actualiza fecha de recepción de muestras específicas
  /// @param ids - Lista de IDs de muestras a actualizar  
  /// @param fechaRecepcion - Nueva fecha en formato 'YYYY-MM-DD'
  /// @return true si se actualizó correctamente, false si hubo error
  static bool actualizarFechasRecepcion(List<int> ids, String fechaRecepcion) {
    try {
      int actualizados = 0;
      
      for (int id in ids) {
        // Buscar índice de la muestra por ID
        int index = _muestrasAlmacen.indexWhere((m) => m['id'] == id);
        
        if (index != -1) {
          // Solo actualizar si ya tiene fecha de envío
          if (_muestrasAlmacen[index]['fechaEnvio'] != null) {
            _muestrasAlmacen[index]['fechaRecepcion'] = fechaRecepcion;
            actualizados++;
          }
        }
      }
      
      return actualizados > 0;
      
    } catch (e) {
      return false;
    }
  }

  // ========================================
  // MÉTODOS DE FORMATEO DE FECHAS
  // ========================================

  /// Convierte DateTime a formato de BD (YYYY-MM-DD)
  /// @param fecha - DateTime a convertir
  /// @return String en formato ISO date
  static String formatearFechaParaBD(DateTime fecha) {
    return fecha.toIso8601String().substring(0, 10);
  }

  /// Convierte fecha de BD a formato de mostrar (DD/MM/YYYY)
  /// @param fecha - String en formato YYYY-MM-DD (puede ser null)
  /// @return String formateado para mostrar o '-' si es null
  static String formatearFechaParaMostrar(String? fecha) {
    if (fecha == null || fecha.isEmpty) return '-';
    
    try {
      DateTime dt = DateTime.parse(fecha);
      return '${dt.day.toString().padLeft(2, '0')}/'
             '${dt.month.toString().padLeft(2, '0')}/'
             '${dt.year}';
    } catch (e) {
      return fecha; // Si no se puede parsear, devolver original
    }
  }

  /// Convierte String DD/MM/YYYY a DateTime
  /// @param fechaTexto - Fecha en formato DD/MM/YYYY
  /// @return DateTime o null si no se puede parsear
  static DateTime? parsearFechaDeTexto(String fechaTexto) {
    try {
      List<String> partes = fechaTexto.split('/');
      if (partes.length == 3) {
        int dia = int.parse(partes[0]);
        int mes = int.parse(partes[1]);
        int anio = int.parse(partes[2]);
        return DateTime(anio, mes, dia);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}