import 'package:flutter/material.dart';
import 'sistema_datos.dart';

// ========================================
// POPUP DE SELECCIÓN DE MÉTODOS DE ANÁLISIS
// ========================================
// Este es el SEGUNDO popup en el flujo de navegación:
// 1. MenuAnalisis (popup_analisi.dart) → Usuario elige "Virus", "Hongos", etc.
// 2. MetodosAnalisisPopup (ESTE ARCHIVO) → Usuario elige "ELISA", "PCR", etc.
// 3. Variantes (varinates.dart) → Usuario captura resultados específicos

/// Popup que muestra los métodos disponibles para un análisis específico
/// Ejemplo: Si eligió "Virus" → muestra "ELISA", "PCR", "Prueba Rápida AGDIA"
/// StatelessWidget porque solo presenta opciones, no maneja estado complejo
class MetodosAnalisisPopup extends StatelessWidget {
  
  // ========================================
  // PROPIEDADES Y CONSTRUCTOR
  // ========================================
  
  /// Objeto Analisis que contiene:
  /// - idAnalisis: ID único en base de datos
  /// - nombre: "Virus", "Hongos", "Bacterias", etc.
  /// - color: Color del tema para UI consistente
  final Analisis analisis;
  
  /// Constructor que requiere el análisis seleccionado del paso anterior
  /// Este análisis viene desde MenuAnalisis (popup_analisi.dart)
  const MetodosAnalisisPopup({
    super.key,
    required this.analisis, // Parámetro obligatorio
  });

  @override
  Widget build(BuildContext context) {
    
    // ========================================
    // OBTENER MÉTODOS DEL SISTEMA DE DATOS
    // ========================================
    
    /// Consulta al sistema centralizado los métodos específicos para este análisis
    /// Ejemplo: Si analisis.idAnalisis = 1 (Virus) → devuelve [ELISA, PCR, Prueba Rápida]
    /// Esta consulta se hace cada vez que se construye el widget (es ligera)
    final List<Metodo> metodosDelAnalisis = 
        SistemaDatos.getMetodosPorAnalisis(analisis.idAnalisis);
    
    // ========================================
    // ESTRUCTURA PRINCIPAL DEL POPUP
    // ========================================
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        // Ancho: 85% de la pantalla (más estrecho que el popup de detalles)
        width: MediaQuery.of(context).size.width * 0.85,
        // Altura máxima: 500px (evita que sea demasiado alto)
        constraints: const BoxConstraints(maxHeight: 500),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          // mainAxisSize.min = solo el tamaño necesario (no expandir innecesariamente)
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),              // Header con título y botón back
            _buildContent(metodosDelAnalisis),  // Lista de métodos disponibles
          ],
        ),
      ),
    );
  }

  // ========================================
  // SECCIÓN 1: HEADER DEL POPUP
  // ========================================

  /// Construye el header con título dinámico y color del análisis
  /// El color viene del objeto analisis para mantener coherencia visual
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // COLOR DINÁMICO: cada análisis tiene su color
        // Virus = verde, Hongos = naranja, Bacterias = amarillo, etc.
        color: analisis.color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          
          // ========================================
          // BOTÓN BACK (LADO IZQUIERDO)
          // ========================================
          
          GestureDetector(
            onTap: () => Navigator.pop(context), // Regresar al popup anterior
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
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
          const SizedBox(width: 16),
          
          // ========================================
          // TÍTULO DINÁMICO (CENTRO)
          // ========================================
          
          Expanded(
            child: Text(
              // TÍTULO DINÁMICO: "Métodos Virus", "Métodos Hongos", etc.
              "Métodos ${analisis.nombre}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          // SizedBox(width: 36) compensa el espacio del botón back para centrar título
          const SizedBox(width: 36),
        ],
      ),
    );
  }

  // ========================================
  // SECCIÓN 2: CONTENIDO PRINCIPAL
  // ========================================

  /// Construye el contenido principal con la lista de métodos
  /// Maneja tanto el caso de métodos disponibles como el caso vacío
  Widget _buildContent(List<Metodo> metodos) {
    
    // ========================================
    // CASO 1: NO HAY MÉTODOS DISPONIBLES
    // ========================================
    
    if (metodos.isEmpty) {
      // Mostrar mensaje informativo si no hay métodos
      // Esto podría pasar si hay problemas con los datos o configuración incompleta
      return const Expanded(
        child: Center(
          child: Text(
            "No hay métodos disponibles",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    // ========================================
    // CASO 2: HAY MÉTODOS - MOSTRAR LISTA
    // ========================================

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.separated(
          itemCount: metodos.length,
          
          // separatorBuilder crea espacios entre elementos
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          
          // itemBuilder crea cada tarjeta de método
          itemBuilder: (context, index) {
            final Metodo metodo = metodos[index]; // Método actual
            return _buildMetodoCard(context, metodo);
          },
        ),
      ),
    );
  }

  // ========================================
  // MÉTODO HELPER: TARJETA DE MÉTODO
  // ========================================

  /// Construye cada tarjeta individual de método
  /// @param context - Contexto para navegación
  /// @param metodo - Objeto con datos del método (id, nombre, idAnalisis)
  Widget _buildMetodoCard(BuildContext context, Metodo metodo) {
    return GestureDetector(
      // ========================================
      // LÓGICA DE NAVEGACIÓN
      // ========================================
      
      onTap: () {
        // Navigator.pop(context, metodo) hace DOS cosas:
        // 1. Cierra este popup
        // 2. Devuelve el objeto 'metodo' al widget que abrió este popup
        // 
        // El widget padre (NavigationHelper) recibirá este objeto y
        // navegará a la pantalla de Variantes con este método
        Navigator.pop(context, metodo);
      },
      
      // ========================================
      // DISEÑO VISUAL DE LA TARJETA
      // ========================================
      
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // MISMO COLOR que el header para consistencia visual
          color: analisis.color,
          borderRadius: BorderRadius.circular(25), // Muy redondeado
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Sombra sutil
              blurRadius: 4,
              offset: const Offset(0, 2), // Sombra hacia abajo
            ),
          ],
        ),
        child: Row(
          children: [
            
            // ========================================
            // NOMBRE DEL MÉTODO (LADO IZQUIERDO)
            // ========================================
            
            Expanded(
              child: Text(
                metodo.nombre, // "ELISA", "PCR", "Convencional", etc.
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Texto blanco sobre fondo de color
                ),
              ),
            ),
            
            // ========================================
            // ICONO FLECHA (LADO DERECHO)
            // ========================================
            
            Icon(
              Icons.arrow_forward_ios, // Flecha hacia adelante
              color: Colors.white.withOpacity(0.8), // Blanco semi-transparente
              size: 16,
            ),
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
ENDPOINT NECESARIO:

GET /analisis/{idAnalisis}/metodos
Response: [
  {
    "idMetodo": 1,
    "nombre": "ELISA", 
    "idAnalisis": 1,
    "activo": true
  },
  {
    "idMetodo": 2,
    "nombre": "PCR",
    "idAnalisis": 1, 
    "activo": true
  }
]

EJEMPLO DE FLUJO DE DATOS:

1. Usuario en MenuAnalisis elige "Virus" (idAnalisis: 1)
2. Se crea MetodosAnalisisPopup con analisis = {id: 1, nombre: "Virus", color: verde}
3. Widget consulta: SistemaDatos.getMetodosPorAnalisis(1) 
4. API devuelve: [ELISA, PCR, Prueba Rápida AGDIA]
5. Usuario toca "PCR"
6. Se cierra popup y devuelve objeto metodo = {id: 2, nombre: "PCR", idAnalisis: 1}
7. NavigationHelper navega a Variantes con este método

CONSIDERACIONES PARA IMPLEMENTACIÓN:

1. COLORES DINÁMICOS:
   - Cada análisis debe tener un color asociado en la BD
   - O definir mapeo en el cliente: 
     * Virus = verde (#8BC34A)
     * Hongos = naranja (#FF5722) 
     * Bacterias = amarillo (#FFC107)

2. MÉTODOS INACTIVOS:
   - La API puede devolver campo "activo": false
   - El widget puede filtrar o mostrar deshabilitados
   - Actualmente no maneja este caso

3. ORDEN DE MÉTODOS:
   - Considerar campo "orden" en BD para controlar secuencia
   - O ordenar alfabéticamente en cliente

4. CACHE DE DATOS:
   - Los métodos cambian raramente, considerar cache local
   - Refrescar solo cuando sea necesario

PATRONES DE DISEÑO UTILIZADOS:

1. FACTORY METHOD: _buildMetodoCard() crea widgets consistentes
2. COMPOSITION: Separar header y content en métodos diferentes  
3. DEPENDENCY INJECTION: Recibe analisis como parámetro
4. CALLBACK PATTERN: Navigator.pop(context, metodo) devuelve resultado

MANEJO DE ERRORES:

Actualmente el widget maneja:
- ✅ Lista vacía de métodos
- ❌ Error de red (crashea)
- ❌ Datos malformados (crashea)

Para producción agregar:
- try/catch alrededor de consulta de datos
- Loading state mientras carga métodos
- Retry button si falla la consulta
- Validation de estructura de datos

TESTING:

Para testear este widget:
1. Mock SistemaDatos.getMetodosPorAnalisis()
2. Verificar que muestra métodos correctos
3. Verificar que devuelve método seleccionado
4. Verificar colores dinámicos por análisis
5. Verificar caso de lista vacía

NAVEGACIÓN:

Este popup es parte de un flujo de 3 pasos:
1. MenuAnalisis → selecciona tipo de análisis
2. MetodosAnalisisPopup → selecciona método (ESTE ARCHIVO)
3. Variantes → captura resultados

El patrón usado es:
- Navigator.pop(context, resultado) para devolver selección
- El widget padre maneja la navegación al siguiente paso
*/