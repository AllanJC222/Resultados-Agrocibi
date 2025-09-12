import 'package:flutter/material.dart';

// POPUP DE DETALLES COMPLETOS DE MUESTRA
// Este widget muestra un diálogo modal con toda la información detallada
// de una muestra específica. Se llama desde el botón "Más detalles" en main.dart

/// Popup que muestra información completa de una muestra
/// StatelessWidget porque solo muestra datos, no maneja estado interno
class MuestraPopup extends StatelessWidget {
  
  // PROPIEDADES Y CONSTRUCTOR
  
  /// Map que contiene todos los datos de la muestra
  /// Estructura: { 'codigo': string, 'tipo': string, 'finca': string, ... }
  /// ¿Por qué Map? Flexibilidad para agregar/quitar campos sin cambiar código
  final Map<String, dynamic> muestra;

  /// Constructor que requiere los datos de la muestra
  /// super.key ayuda a Flutter a identificar uniquamente este widget
  const MuestraPopup({super.key, required this.muestra});

  @override
  Widget build(BuildContext context) {
    
    // ESTRUCTURA PRINCIPAL DEL POPUP
    
    // Dialog() crea un overlay modal sobre la pantalla actual
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Esquinas redondeadas
      ),
      child: Container(
        // Tamaño responsivo: 90% del ancho y alto de la pantalla
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white, // Fondo blanco
        ),
        child: Column(
          children: [
            
            // SECCIÓN 1: HEADER DEL POPUP
            
            // Header con color naranja como en tu diseño
            Container(
              width: double.infinity, // Toma todo el ancho
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                // Color naranja principal del tema (hardcodeado por consistencia)
                color: Color.fromRGBO(233, 99, 43, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),  // Solo esquinas superiores
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  
                  // BOTÓN DE REGRESAR (LADO IZQUIERDO)
                  
                  // GestureDetector detecta toques en cualquier widget
                  GestureDetector(
                    onTap: () => Navigator.pop(context), // Cerrar popup
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        // Borde blanco para destacar sobre fondo naranja
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // ========================================
                  // TÍTULO DEL POPUP (CENTRO)
                  // ========================================
                  
                  // Expanded hace que tome todo el espacio disponible
                  const Expanded(
                    child: Text(
                      "Detalles de la muestra",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // ========================================
            // SECCIÓN 2: CONTENIDO SCROLLEABLE
            // ========================================
            
            // Expanded toma todo el espacio vertical restante
            Expanded(
              child: SingleChildScrollView( // Permite scroll vertical
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Alinear a la izquierda
                  children: [
                    
                    // Título principal del contenido
                    const Text(
                      "Información de la muestra",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // ========================================
                    // SUBSECCIÓN 2.1: INFORMACIÓN GENERAL
                    // ========================================
                    
                    _buildInfoSection("Información General", [
                      _buildInfoItem("Código de muestra:", muestra['codigo']),
                      _buildInfoItem("Tipo de muestra:", muestra['tipo']),
                      _buildInfoItem("Análisis solicitados:", muestra['analisis']),
                      _buildInfoItem("Finca:", muestra['finca']),
                      _buildInfoItem("Ubicación Técnica:", muestra['ubicacionTecnica']),
                      _buildInfoItem("Temporada:", muestra['temporada']),
                      _buildInfoItem("Turno:", muestra['turno']),
                    ]),
                    
                    const SizedBox(height: 20),
                    
                    // ========================================
                    // SUBSECCIÓN 2.2: INFORMACIÓN DE UBICACIÓN
                    // ========================================
                    
                    _buildInfoSection("Ubicación", [
                      _buildInfoItem("Válvula:", muestra['valvula']),
                      _buildInfoItem("Longitud:", muestra['longitud']),
                      _buildInfoItem("Latitud:", muestra['latitud']),
                    ]),
                    
                    const SizedBox(height: 20),
                    
                    // ========================================
                    // SUBSECCIÓN 2.3: FECHAS IMPORTANTES
                    // ========================================
                    
                    _buildInfoSection("Fechas", [
                      _buildInfoItem("Fecha de Muestreo:", muestra['fechaMuestreo']),
                      _buildInfoItem("Fecha de envío:", muestra['fechaEnvio']),
                      _buildInfoItem("Fecha de resultados:", muestra['fechaResultados']),
                    ]),
                    
                    const SizedBox(height: 20),
                    
                    // ========================================
                    // SUBSECCIÓN 2.4: IDENTIFICACIÓN
                    // ========================================
                    
                    _buildInfoSection("Identificación", [
                      _buildInfoItem("Identificación de la muestra:", muestra['identificacion']),
                    ]),
                    
                    const SizedBox(height: 20),
                    
                    // ========================================
                    // SUBSECCIÓN 2.5: OBSERVACIONES (DISEÑO ESPECIAL)
                    // ========================================
                    
                    _buildObservationsSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // MÉTODO HELPER: SECCIÓN DE INFORMACIÓN
  
  /// Widget helper para crear secciones de información consistentes
  /// @param title - Título de la sección (ej: "Información General")
  /// @param items - Lista de widgets _buildInfoItem() 
  /// ¿Por qué usar este helper? Mantiene diseño consistente y reduce duplicación
  Widget _buildInfoSection(String title, List<Widget> items) {
    return Container(
      width: double.infinity, // Toma todo el ancho disponible
      decoration: BoxDecoration(
        color: Colors.grey.shade50,              // Fondo gris muy claro
        borderRadius: BorderRadius.circular(12), // Esquinas redondeadas
        border: Border.all(color: Colors.grey.shade200), // Borde sutil
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alinear contenido a la izquierda
        children: [
          
          // TÍTULO DE LA SECCIÓN
          
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF6B35), // Color naranja para títulos
            ),
          ),
          const SizedBox(height: 12),
          
          // ELEMENTOS DE LA SECCIÓN
          
          // Operador spread (...) "desempaca" la lista y agrega cada elemento
          // Es equivalente a hacer items[0], items[1], items[2]... uno por uno
          ...items,
        ],
      ),
    );
  }
  
  // MÉTODO HELPER: ELEMENTO DE INFORMACIÓN
  
  /// Widget helper para cada elemento individual de información
  /// @param label - Etiqueta (ej: "Código de muestra:")
  /// @param value - Valor (ej: "M-2025-001") - puede ser null
  /// Estructura: [Etiqueta fija 120px] [Valor expandible]
  Widget _buildInfoItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8), // Espacio entre elementos
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Alinear arriba (para textos largos)
        children: [
          
          // ETIQUETA (LADO IZQUIERDO - ANCHO FIJO)
          
          SizedBox(
            width: 120, // Ancho fijo para alinear todas las etiquetas
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600, // Más bold que normal
                color: Colors.black87,
              ),
            ),
          ),
          
          // VALOR (LADO DERECHO - EXPANDIBLE)
          
          // Expanded toma todo el espacio restante
          Expanded(
            child: Text(
              // Operador null-coalescing: si value es null, mostrar "No disponible"
              value ?? "No disponible",
              style: TextStyle(
                fontSize: 14,
                // Color condicional: negro si hay valor, gris si es null
                color: value != null ? Colors.black54 : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // MÉTODO ESPECIAL: SECCIÓN DE OBSERVACIONES
  
  /// Widget especial para las observaciones con diseño diferente
  /// ¿Por qué especial? Las observaciones pueden ser texto largo y necesitan más espacio
  Widget _buildObservationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        // TÍTULO DE OBSERVACIONES
        
        const Text(
          "Observaciones de muestreo",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        
        // CONTENEDOR DE TEXTO DE OBSERVACIONES
        
        Container(
          width: double.infinity, // Toma todo el ancho
          constraints: const BoxConstraints(
            minHeight: 100, // Altura mínima de 100px (incluso si está vacío)
          ),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            // Borde más grueso que las otras secciones para destacar
            border: Border.all(color: Colors.grey.shade400, width: 2),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white, // Fondo blanco para contrastar
          ),
          child: Text(
            // Mostrar observaciones o mensaje por defecto
            muestra['observaciones'] ?? "Sin observaciones",
            style: TextStyle(
              fontSize: 14,
              // Color condicional basado en si hay observaciones
              color: muestra['observaciones'] != null 
                  ? Colors.black87  // Negro si hay texto
                  : Colors.grey,    // Gris si no hay observaciones
              height: 1.4, // Espaciado entre líneas (más legible)
            ),
          ),
        ),
      ],
    );
  }
}

// NOTAS PARA IMPLEMENTACIÓN DE API

/*
ENDPOINT NECESARIO:

GET /muestras/{id}/detalles
Response: {
  "codigo": "M-2025-001",
  "tipo": "Tejido foliar", 
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
  "observaciones": "La muestra fue recolectada en condiciones secas..."
}

CONSIDERACIONES PARA API:

1. MANEJO DE CAMPOS NULOS:
   - El widget maneja campos null automáticamente
   - Muestra "No disponible" para datos faltantes
   - API puede enviar null o omitir campos opcionales

2. FORMATO DE FECHAS:
   - Actualmente espera strings formateados (DD/MM/AAAA)
   - Considerar usar formato ISO 8601 y formatear en cliente
   - Ejemplo: "2025-09-01T00:00:00Z" → "01/09/2025"

3. OBSERVACIONES LARGAS:
   - El widget soporta texto multi-línea automáticamente
   - Sin límite de caracteres en el diseño
   - API puede enviar texto completo sin truncar

4. COORDENADAS GPS:
   - Actualmente son strings, considerar usar números
   - Ejemplo: "latitud": -87.175 en lugar de "-87.175"
   - Facilita cálculos geográficos si se necesitan

MEJORAS FUTURAS:

2. LINKS INTERACTIVOS:
   - Hacer coordenadas GPS clickeables (abrir Maps)
   - Links a sistemas externos por código de muestra

4. HISTORIAL:
   - Mostrar cambios/actualizaciones de la muestra
   - Timeline de estados de la muestra

ESTRUCTURA DE DATOS:

El widget es completamente flexible con la estructura de datos:
- Acepta cualquier Map<String, dynamic>
- Maneja valores null automáticamente  
- Fácil agregar nuevos campos sin cambiar código
- Compatible con JSON de APIs REST

PERFORMANCE:

- Widget ligero, solo muestra datos
- SingleChildScrollView maneja listas largas eficientemente
- No hay operaciones costosas o llamadas a API
- Se puede mostrar inmediatamente con datos cached

ACCESIBILIDAD:

- Textos legibles con contraste adecuado
- Tamaños de fuente apropiados
- Estructura semántica clara
- Compatible con lectores de pantalla
*/