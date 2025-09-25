// Modelos basados en tu estructura real de base de datos
import 'package:flutter/material.dart';

// ...resto del código...
class Analisis {
  final int idAnalisis;
  final String nombre;
  final Color color;
  final IconData icon;

  Analisis({
    required this.idAnalisis,
    required this.nombre,
    required this.color,
    required this.icon,
  });
}

class Metodo {
  final int idMetodo;
  final String nombre;
  final int idAnalisis; // FK a Analisis

  Metodo({
    required this.idMetodo,
    required this.nombre,
    required this.idAnalisis,
  });
}

class Variante {
  final int idVariante;
  final String nombre;
  final int idMetodo; // FK a Metodo

  Variante({
    required this.idVariante,
    required this.nombre,
    required this.idMetodo,
  });
}

// Clase para manejar todos los datos del sistema
class SistemaDatos {
  // Datos reales extraídos de tu tabla
  static final List<Analisis> analisis = [
    Analisis(
      idAnalisis: 1,
      nombre: "Virus",
      color: const Color(0xFF8BC34A), // Verde
      icon: Icons.coronavirus,
    ),
    Analisis(
      idAnalisis: 2,
      nombre: "Nematodo",
      color: const Color(0xFF00BCD4), // Cyan
      icon: Icons.bug_report,
    ),
    Analisis(
      idAnalisis: 3,
      nombre: "Hongos",
      color: const Color(0xFFFF5722), // Naranja
      icon: Icons.grass,
    ),
    Analisis(
      idAnalisis: 4,
      nombre: "Bacteriología",
      color: const Color(0xFFFFC107), // Amarillo
      icon: Icons.biotech,
    ),
  ];

  static final List<Metodo> metodos = [
    // Métodos de Virus (id_analisis = 1)
    Metodo(idMetodo: 1, nombre: "ELISA", idAnalisis: 1),
    Metodo(idMetodo: 2, nombre: "PCR", idAnalisis: 1),
    Metodo(idMetodo: 3, nombre: "Prueba Rápida AGDIA", idAnalisis: 1),

    // Métodos de Nematodo (id_analisis = 2)
    Metodo(idMetodo: 4, nombre: "Centrifugación", idAnalisis: 2),

    // Métodos de Hongos (id_analisis = 3)
    Metodo(idMetodo: 5, nombre: "Convencional", idAnalisis: 3),

    // Métodos de Bacteriología (id_analisis = 4)
    Metodo(idMetodo: 6, nombre: "Convencional", idAnalisis: 4),
    Metodo(idMetodo: 7, nombre: "PCR", idAnalisis: 4),
    Metodo(idMetodo: 8, nombre: "Prueba Rápida AGDIA", idAnalisis: 4),

    // Métodos de Nutrición (id_analisis = 5)
    Metodo(idMetodo: 9, nombre: "Multi-Ion", idAnalisis: 5),
  ];

  static final List<Variante> variantes = [
    // Variantes ELISA - Virus (id_metodo = 1)
    Variante(idVariante: 1, nombre: "MNSV", idMetodo: 1),
    Variante(idVariante: 2, nombre: "SqMV", idMetodo: 1),
    Variante(idVariante: 3, nombre: "CGMMV", idMetodo: 1),

    // Variantes PCR - Virus (id_metodo = 2)
    Variante(idVariante: 4, nombre: "CGMMV", idMetodo: 2),
    Variante(idVariante: 5, nombre: "TYLCV", idMetodo: 2),
    Variante(idVariante: 6, nombre: "SqYVV", idMetodo: 2),
    Variante(idVariante: 7, nombre: "CYSDV", idMetodo: 2),

    // Variantes Prueba Rápida AGDIA - Virus (id_metodo = 3)
    Variante(idVariante: 8, nombre: "MNSV", idMetodo: 3),
    Variante(idVariante: 9, nombre: "SqMV", idMetodo: 3),
    Variante(idVariante: 10, nombre: "Potyvirus", idMetodo: 3),
    Variante(idVariante: 11, nombre: "MeSMV", idMetodo: 3),
    Variante(idVariante: 12, nombre: "ToLCNDV", idMetodo: 3),

    // Variantes Centrifugación - Nematodo (id_metodo = 4)
    Variante(idVariante: 13, nombre: "Meloidogyne sp", idMetodo: 4),
    Variante(idVariante: 14, nombre: "Pratylenchus", idMetodo: 4),
    Variante(idVariante: 15, nombre: "Helicotylenchus", idMetodo: 4),
    Variante(idVariante: 16, nombre: "Tylenchidae", idMetodo: 4),
    Variante(idVariante: 17, nombre: "Fitoparásitos no descritos", idMetodo: 4),

    // Variantes Convencional - Hongos (id_metodo = 5)
    Variante(idVariante: 18, nombre: "Trichoderma sp", idMetodo: 5),
    Variante(idVariante: 19, nombre: "Fusarium sp", idMetodo: 5),
    Variante(idVariante: 20, nombre: "Monosporascus sp", idMetodo: 5),
    Variante(idVariante: 21, nombre: "Didymella sp", idMetodo: 5),
    Variante(idVariante: 22, nombre: "Olpidium sp", idMetodo: 5),
    Variante(idVariante: 23, nombre: "Macrophomina sp", idMetodo: 5),
    Variante(idVariante: 24, nombre: "Rhizoctonia sp", idMetodo: 5),
    Variante(idVariante: 25, nombre: "Phytophthora sp", idMetodo: 5),
    Variante(idVariante: 26, nombre: "Pythium sp", idMetodo: 5),
    Variante(idVariante: 27, nombre: "Geotrichum sp", idMetodo: 5),
    Variante(idVariante: 28, nombre: "Phomopsis sp", idMetodo: 5),
    Variante(idVariante: 29, nombre: "Colletotrichum sp", idMetodo: 5),
    Variante(idVariante: 30, nombre: "Acremonium sp", idMetodo: 5),
    Variante(idVariante: 31, nombre: "Otros hongos", idMetodo: 5),

    // Variantes Convencional - Bacteriología (id_metodo = 6)
    Variante(idVariante: 32, nombre: "Erwinia sp", idMetodo: 6),
    Variante(idVariante: 33, nombre: "Acidovorax sp", idMetodo: 6),
    Variante(idVariante: 34, nombre: "Pseudomonas sp", idMetodo: 6),
    Variante(idVariante: 35, nombre: "Xanthomonas sp", idMetodo: 6),

    // Variantes PCR (hongos) - Bacteriología (id_metodo = 7)
    Variante(idVariante: 36, nombre: "A. citrulli", idMetodo: 7),

    // Variantes Prueba Rápida AGDIA - Bacteriología (id_metodo = 8)
    Variante(idVariante: 37, nombre: "A. citrulli", idMetodo: 8),
    Variante(idVariante: 38, nombre: "Erwinia amylovora", idMetodo: 8),
    Variante(idVariante: 39, nombre: "Ralstonia", idMetodo: 8),
    Variante(idVariante: 40, nombre: "Xanthomonas", idMetodo: 8),
    Variante(idVariante: 41, nombre: "Phytophthora", idMetodo: 8),

    // Variantes Multi-Ion - Nutrición (id_metodo = 9)
    Variante(idVariante: 42, nombre: "Iones/Cationes", idMetodo: 9),
  ];

  final int tipoMuestra = 1; // 1: Tejido , 2: Suelo, 3: Agua
  static final Map<String, dynamic> muestra = {
    "id": 2,
    "codigo": "M-2025-001",
    "tipo": "Tejido",
    "tipoMuestraId": 2,
    "analisis": "Hongos / Bacterias",
    "finca": "Finca El Progreso",
    "ubicacionTecnica": "Lote 12, Sector Norte",
    "temporada": "2025",
    "turno": "Mañana",
    "valvula": "Válvula #7",
    "longitud": "-87.175",
    "latitud": "14.084",
    "fechaMuestreo": "01/09/2025",
    "fechaEnvio": "02/09/2025",
    "fechaResultados": "04/09/2025",
    "identificacion": "Hoja afectada con manchas amarillas",
    "observaciones":
        "La muestra fue recolectada en condiciones secas, sin rocío.",
  };

  // ========================================
  // RESULTADOS SIMULADOS - VIRUS
  // ========================================
  static final List<Map<String, dynamic>> resultadosVirus = [
    {
      'id': 1,
      'codigoMuestra': 'V-2025-001',
      'tipoMuestra': 'Tejido',
      'metodo': 'ELISA',
      'variante': 'MNSV',
      'presencia': true,
      'ctAbsorbancia': '0.485',
      'fecha': '2025-09-15',
      'observaciones': 'Muestra con alta concentración viral',
    },
    {
      'id': 2,
      'codigoMuestra': 'V-2025-002',
      'tipoMuestra': 'Tejido',
      'metodo': 'PCR',
      'variante': 'CGMMV',
      'presencia': false,
      'ctAbsorbancia': '35.2',
      'fecha': '2025-09-16',
      'observaciones': '',
    },
    {
      'id': 3,
      'codigoMuestra': 'V-2025-003',
      'tipoMuestra': 'Semilla',
      'metodo': 'Prueba Rápida AGDIA',
      'variante': 'Potyvirus',
      'presencia': true,
      'ctAbsorbancia': '',
      'fecha': '2025-09-17',
      'observaciones': 'Detección positiva en lote de semillas',
    },
    {
      'id': 4,
      'codigoMuestra': 'V-2025-004',
      'tipoMuestra': 'Tejido',
      'metodo': 'ELISA',
      'variante': 'SqMV',
      'presencia': false,
      'ctAbsorbancia': '0.089',
      'fecha': '2025-09-18',
      'observaciones': '',
    },
  ];

  // ========================================
  // RESULTADOS SIMULADOS - HONGOS
  // ========================================
  static final List<Map<String, dynamic>> resultadosHongos = [
    {
      'id': 1,
      'codigoMuestra': 'H-2025-001',
      'tipoMuestra': 'Suelo',
      'metodo': 'Convencional',
      'variante': 'Trichoderma sp',
      'presencia': true,
      'conteo': 250,
      'fecha': '2025-09-15',
      'observaciones': 'Alto conteo de esporas',
    },
    {
      'id': 2,
      'codigoMuestra': 'H-2025-002',
      'tipoMuestra': 'Tejido',
      'metodo': 'Convencional',
      'variante': 'Fusarium sp',
      'presencia': true,
      'conteo': null,
      'fecha': '2025-09-16',
      'observaciones': 'Presencia confirmada en tejido',
    },
    {
      'id': 3,
      'codigoMuestra': 'H-2025-003',
      'tipoMuestra': 'Suelo',
      'metodo': 'Convencional',
      'variante': 'Rhizoctonia sp',
      'presencia': false,
      'conteo': 0,
      'fecha': '2025-09-17',
      'observaciones': '',
    },
  ];

  // ========================================
  // RESULTADOS SIMULADOS - NEMATODOS
  // ========================================
  static final List<Map<String, dynamic>> resultadosNematodos = [
    {
      'id': 1,
      'codigoMuestra': 'N-2025-001',
      'tipoMuestra': 'Suelo',
      'metodo': 'Centrifugación',
      'variante': 'Meloidogyne sp',
      'presencia': null, // No aplica presencia en nematodos
      'juveniles': 45,
      'fecha': '2025-09-15',
      'observaciones': 'Moderada infestación de juveniles',
    },
    {
      'id': 2,
      'codigoMuestra': 'N-2025-002',
      'tipoMuestra': 'Tejido',
      'metodo': 'Centrifugación',
      'variante': 'Pratylenchus',
      'presencia': null,
      'juveniles': 12,
      'fecha': '2025-09-16',
      'observaciones': 'Baja población detectada',
    },
    {
      'id': 3,
      'codigoMuestra': 'N-2025-003',
      'tipoMuestra': 'Suelo',
      'metodo': 'Centrifugación',
      'variante': 'Helicotylenchus',
      'presencia': null,
      'juveniles': 0,
      'fecha': '2025-09-17',
      'observaciones': 'No se detectaron nematodos',
    },
  ];

  // ========================================
  // RESULTADOS SIMULADOS - BACTERIOLOGÍA
  // ========================================
  static final List<Map<String, dynamic>> resultadosBacteriologia = [
    {
      'id': 1,
      'codigoMuestra': 'B-2025-001',
      'tipoMuestra': 'Tejido',
      'metodo': 'Convencional',
      'variante': 'Erwinia sp',
      'presencia': true,
      'conteo': null,
      'dilucion': null,
      'fecha': '2025-09-15',
      'observaciones': 'Infección bacteriana confirmada',
    },
    {
      'id': 2,
      'codigoMuestra': 'B-2025-002',
      'tipoMuestra': 'Semilla',
      'metodo': 'Convencional',
      'variante': 'Pseudomonas sp',
      'presencia': true,
      'conteo': 1200,
      'dilucion': '100',
      'fecha': '2025-09-16',
      'observaciones': 'Contaminación en lote de semillas',
    },
    {
      'id': 3,
      'codigoMuestra': 'B-2025-003',
      'tipoMuestra': 'Tejido',
      'metodo': 'PCR',
      'variante': 'A. citrulli',
      'presencia': false,
      'conteo': null,
      'dilucion': null,
      'fecha': '2025-09-17',
      'observaciones': '',
    },
  ];

  // MÉTODOS UTILITARIOS PARA CONSULTAR LOS DATOS

  // Obtener métodos por análisis
  static List<Metodo> getMetodosPorAnalisis(int idAnalisis) {
    return metodos.where((m) => m.idAnalisis == idAnalisis).toList();
  }

  // Obtener variantes por método
  static List<Variante> getVariantesPorMetodo(int idMetodo) {
    return variantes.where((v) => v.idMetodo == idMetodo).toList();
  }

  // Obtener análisis por ID
  static Analisis? getAnalisisPorId(int idAnalisis) {
    try {
      return analisis.firstWhere((a) => a.idAnalisis == idAnalisis);
    } catch (e) {
      return null;
    }
  }

  // Obtener método por ID
  static Metodo? getMetodoPorId(int idMetodo) {
    try {
      return metodos.firstWhere((m) => m.idMetodo == idMetodo);
    } catch (e) {
      return null;
    }
  }

  // Obtener variante por ID
  static Variante? getVariantePorId(int idVariante) {
    try {
      return variantes.firstWhere((v) => v.idVariante == idVariante);
    } catch (e) {
      return null;
    }
  }

  // Obtener color de análisis por método
  static Color getColorPorMetodo(int idMetodo) {
    final metodo = getMetodoPorId(idMetodo);
    if (metodo != null) {
      final analisisObj = getAnalisisPorId(metodo.idAnalisis);
      return analisisObj?.color ?? Colors.grey;
    }
    return Colors.grey;
  }

  // Obtener nombre completo: Análisis > Método > Variante
  static String getNombreCompleto(int idVariante) {
    final variante = getVariantePorId(idVariante);
    if (variante == null) return "Desconocido";

    final metodo = getMetodoPorId(variante.idMetodo);
    if (metodo == null) return variante.nombre;

    final analisisObj = getAnalisisPorId(metodo.idAnalisis);
    if (analisisObj == null) return "${metodo.nombre} > ${variante.nombre}";

    return "${analisisObj.nombre} > ${metodo.nombre} > ${variante.nombre}";
  }

  static List<Map<String, dynamic>> getAnalisisComoMapa() {
    return analisis.map((analisis) {
      return {
        'id': analisis.idAnalisis,
        'nombre': analisis.nombre,
        'color': analisis.color,
        'icon': analisis.icon,
      };
    }).toList();
  }

  // ========================================
  // MÉTODOS HELPER PARA RESULTADOS
  // ========================================

  // Obtener resultados por análisis
  static List<Map<String, dynamic>> getResultadosPorAnalisis(int idAnalisis) {
    switch (idAnalisis) {
      case 1:
        return resultadosVirus;
      case 2:
        return resultadosNematodos;
      case 3:
        return resultadosHongos;
      case 4:
        return resultadosBacteriologia;
      default:
        return [];
    }
  }

  // Filtrar por tipo de muestra
  static List<Map<String, dynamic>> filtrarPorTipoMuestra(
    int idAnalisis,
    String tipoMuestra,
  ) {
    final resultados = getResultadosPorAnalisis(idAnalisis);
    if (tipoMuestra.isEmpty) return resultados;

    return resultados
        .where(
          (r) => r['tipoMuestra'].toString().toLowerCase().contains(
            tipoMuestra.toLowerCase(),
          ),
        )
        .toList();
  }

  // Filtrar por código de muestra
  static List<Map<String, dynamic>> filtrarPorCodigo(
    int idAnalisis,
    String codigo,
  ) {
    final resultados = getResultadosPorAnalisis(idAnalisis);
    if (codigo.isEmpty) return resultados;

    return resultados
        .where(
          (r) => r['codigoMuestra'].toString().toLowerCase().contains(
            codigo.toLowerCase(),
          ),
        )
        .toList();
  }

  // Obtener tipos de muestra únicos por análisis
  static List<String> getTiposMuestraPorAnalisis(int idAnalisis) {
    final resultados = getResultadosPorAnalisis(idAnalisis);
    final tipos = resultados.map((r) => r['tipoMuestra'].toString()).toSet();
    return tipos.toList()..sort();
  }
}
