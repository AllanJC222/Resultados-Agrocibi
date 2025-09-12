import 'package:flutter/material.dart';
// Importa tu archivo de datos con el nombre correcto
import 'sistema_datos.dart'; // Asegúrate que este sea el nombre correcto de tu archivo

/// Popup de selección de análisis con estructura estática
/// Excluye análisis de nutrición y usa iconos personalizados
class MenuAnalisis extends StatelessWidget {
  const MenuAnalisis({super.key});

  /// Definición estática de análisis disponibles con iconos personalizados
  /// Se mantiene independiente del sistema de datos para mayor control
  static const List<Map<String, dynamic>> _analisisEstaticos = [
    {
      'id': 1,
      'nombre': 'Virus',
      'color': Color(0xFF8BC34A), // Púrpura
      'icon': Icons.coronavirus,
    },
    {
      'id': 2,
      'nombre': 'Nematodos',
      'color': Color(0xFF00BCD4), // Púrpura oscuro
      'icon': Icons.bug_report,
    },
    {
      'id': 3,
      'nombre': 'Hongos',
      'color': Color(0xFFFF5722), // Naranja (del main.dart)
      'icon': Icons.grass,
    },
    {
      'id': 4,
      'nombre': 'Bacteriología',
      'color': Color(0xFFFFC107), // Amarillo (del main.dart) 
      'icon': Icons.biotech,
    },
    // Nutrición removido según solicitud
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        constraints: const BoxConstraints(maxHeight: 550), // Reducido sin nutrición
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            _buildContent(context),
          ],
        ),
      ),
    );
  }

  /// Construye el header del popup con botón de cerrar y título
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          // Botón de cerrar con diseño circular
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 20, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 16),
          // Título centrado
          const Expanded(
            child: Text(
              "¿Qué análisis realizará?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 36), // Compensar espacio del botón cerrar
        ],
      ),
    );
  }

  /// Construye el contenido principal con la lista de análisis
  Widget _buildContent(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.separated(
          itemCount: _analisisEstaticos.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final analisisData = _analisisEstaticos[index];
            return _buildAnalisisCard(context, analisisData);
          },
        ),
      ),
    );
  }

  /// Construye cada card de análisis con diseño personalizado
  /// Utiliza datos estáticos en lugar del sistema dinámico
  Widget _buildAnalisisCard(BuildContext context, Map<String, dynamic> analisisData) {
    return GestureDetector(
      onTap: () {
        final int analisisId = analisisData['id'] as int;
        
        // Obtener tipo de muestra del sistema
        int tipoMuestraId = 2;
          
          // LÓGICA ESPECIAL: Si es Tejido (1) + Hongos (3) o Bacterias (4)
          // → Redireccionar directamente al main en lugar de mostrar métodos
          if (tipoMuestraId == 1 && (analisisId == 3 || analisisId == 4) || 
              tipoMuestraId == 4 && analisisId == 3 ) {
            // Cierra el popup actual y navega al main
          Navigator.of(context).popUntil((route) => route.isFirst);
          return;
        }
        
        // COMPORTAMIENTO NORMAL: Para otros casos, buscar análisis y continuar flujo
        final analisisFromSystem = SistemaDatos.analisis.firstWhere(
          (a) => a.idAnalisis == analisisId,
          orElse: () => throw Exception('Análisis no encontrado: $analisisId'),
        );
        // Retorna el objeto del sistema para continuar al popup de métodos
        Navigator.pop(context, analisisFromSystem);
      },
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: analisisData['color'] as Color,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Sección del texto (lado izquierdo)
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(
                  analisisData['nombre'] as String,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // Sección del icono (lado derecho)
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Icon(
                    analisisData['icon'] as IconData, // Icono personalizado
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// LÓGICA DE NAVEGACIÓN ESPECIAL:
// - Tejido (1) + Hongos (3)      → Redirección directa al main (análisis convencional)
// - Tejido (1) + Bacterias (4)   → Redirección directa al main (análisis convencional)  
// - Otros casos                  → Flujo normal hacia popup de métodos
//
// RAZÓN: Para tejidos, hongos y bacterias solo tienen método convencional,
// por lo que se omite la selección de método y se va directo a captura de resultados

// MAPEO DE ICONOS POR ANÁLISIS:
// 🦠 VIRUS (1)        → Icons.coronavirus      (Relacionado con virus)
// 🪱 NEMATODOS (2)    → Icons.bug_report       (Insectos/organismos)
// 🍄 HONGOS (3)       → Icons.grass            (Vegetación/hongos)
// 🧬 BACTERIOLOGÍA (4) → Icons.biotech          (Biotecnología/laboratorio)

// COLORES UTILIZADOS:
// - Púrpura para Virus (#8E24AA)
// - Púrpura oscuro para Nematodos (#7B1FA2)  
// - Naranja para Hongos (#E95D2B) - del AppColors.primary
// - Amarillo para Bacteriología (#F3CA0B) - del AppColors.secondary

// MEJORAS IMPLEMENTADAS:
// 1. ✅ Estructura estática en lugar de dinámica
// 2. ✅ Iconos personalizados para cada análisis  
// 3. ✅ Eliminado botón de nutrición
// 4. ✅ Mantenida compatibilidad con sistema existente
// 5. ✅ Colores coordinados con el tema de la app
// 6. ✅ Comentarios explicativos para cada sección