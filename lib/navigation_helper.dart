import 'package:flutter/material.dart';
import 'popup_analisi.dart';
import 'popup_metodo.dart';
import 'varinates.dart';
import 'sistema_datos.dart';

/*
 * CLASE UTILITARIA - NavigationHelper
 * 
 * Esta clase centraliza todos los flujos de navegación complejos
 * para que puedan ser reutilizados desde cualquier widget.
 * 
 * ¿Por qué hacer esto?
 * - Evita duplicar código
 * - Mantiene la lógica en un solo lugar
 * - Fácil de mantener y debuggear
 * - Se puede usar desde AppBar, main, o cualquier otro widget
 */
class NavigationHelper {
  
  /*
   * FLUJO PRINCIPAL - Análisis → Métodos → Variantes
   * 
   * Esta función maneja todo el flujo de selección de análisis.
   * Es exactamente la misma lógica que tienes en main.dart pero
   * hecha estática para poder usarla desde cualquier lado.
   * 
   * Parámetros:
   * - context: Para navegación y diálogos
   * - onMainRefresh: Función opcional que se ejecuta si hay que refrescar el main
   */
  static Future<void> showAnalisisFlow(
    BuildContext context, {
    VoidCallback? onMainRefresh, // Función opcional para refrescar el main
  }) async {
    try {
      print("🚀 Iniciando flujo de análisis...");
      
      // PASO 1: Mostrar popup de análisis
      final analisisSeleccionado = await showDialog<dynamic>(
        context: context,
        builder: (context) => const MenuAnalisis(),
      );

      print("🔍 Análisis seleccionado: $analisisSeleccionado");

      // CASO ESPECIAL: Redirección al main
      if (analisisSeleccionado == 'REDIRECT_TO_MAIN') {
        print("🏠 Señal de redirección al main detectada");
        
        if (onMainRefresh != null) {
          // Si estamos en el main, refrescar
          onMainRefresh();
        } else {
          // Si no estamos en el main, navegar hacia allá
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        }
        return;
      }

      // PASO 2: Flujo normal para otros análisis
      if (analisisSeleccionado != null && analisisSeleccionado is Analisis) {
        print("📋 Abriendo popup de métodos para: ${analisisSeleccionado.nombre}");
        
        // Mostrar popup de métodos
        final metodoSeleccionado = await showDialog<Metodo>(
          context: context,
          builder: (context) => MetodosAnalisisPopup(
            analisis: analisisSeleccionado,
          ),
        );

        print("🛠️ Método seleccionado: ${metodoSeleccionado?.nombre ?? 'ninguno'}");

        // PASO 3: Navegar a pantalla de variantes
        if (metodoSeleccionado != null) {
          print("🎯 Navegando a pantalla de variantes...");
          
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Variantes(metodo: metodoSeleccionado),
            ),
          );
        } else {
          print("❌ Usuario canceló selección de método");
        }
      } else if (analisisSeleccionado != null) {
        print("⚠️ Tipo de análisis no reconocido: ${analisisSeleccionado.runtimeType}");
      } else {
        print("❌ Usuario canceló selección de análisis");
      }

    } catch (e) {
      print("💥 Error en flujo de análisis: $e");
      
      // Mostrar error al usuario
      _showErrorDialog(context, e.toString());
    }
  }

  /*
   * MÉTODO HELPER - Muestra diálogo de error
   * 
   * Centraliza la manera de mostrar errores para mantener
   * consistencia en toda la app.
   */
  static void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade700),
            const SizedBox(width: 8),
            const Text("Error"),
          ],
        ),
        content: Text(
          "Hubo un problema al procesar el análisis:\n\n$error\n\n"
          "Verifica que todos los archivos necesarios estén importados correctamente.",
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Entendido"),
          ),
        ],
      ),
    );
  }

  /*
   * MÉTODO ADICIONAL - Navegar directamente a un análisis específico
   * 
   * Útil si quieres saltar directamente a un análisis sin mostrar
   * el popup de selección.
   */
  static Future<void> navigateToAnalisis(
    BuildContext context, 
    int analisisId,
  ) async {
    try {
      final analisis = SistemaDatos.getAnalisisPorId(analisisId);
      if (analisis == null) {
        throw Exception("Análisis con ID $analisisId no encontrado");
      }

      // Obtener métodos disponibles
      final metodos = SistemaDatos.getMetodosPorAnalisis(analisisId);
      
      if (metodos.isEmpty) {
        throw Exception("No hay métodos disponibles para ${analisis.nombre}");
      }

      // Si solo hay un método, ir directo a variantes
      if (metodos.length == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Variantes(metodo: metodos.first),
          ),
        );
      } else {
        // Si hay varios métodos, mostrar popup de selección
        final metodoSeleccionado = await showDialog<Metodo>(
          context: context,
          builder: (context) => MetodosAnalisisPopup(analisis: analisis),
        );

        if (metodoSeleccionado != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Variantes(metodo: metodoSeleccionado),
            ),
          );
        }
      }
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  /*
   * MÉTODO ADICIONAL - Atajos rápidos para análisis comunes
   * 
   * Estos métodos permiten navegar rápidamente a análisis específicos
   * sin pasar por todos los popups.
   */
  
  static Future<void> navigateToVirus(BuildContext context) async {
    await navigateToAnalisis(context, 1); // ID 1 = Virus
  }

  static Future<void> navigateToNematodos(BuildContext context) async {
    await navigateToAnalisis(context, 2); // ID 2 = Nematodos
  }

  static Future<void> navigateToHongos(BuildContext context) async {
    await navigateToAnalisis(context, 3); // ID 3 = Hongos
  }

  static Future<void> navigateToBacterias(BuildContext context) async {
    await navigateToAnalisis(context, 4); // ID 4 = Bacteriología
  }

  /*
   * MÉTODO HELPER - Reinicio de página/datos
   * 
   * Centraliza la lógica de reinicio para que sea consistente
   * en toda la aplicación.
   */
  static void reloadPage(BuildContext context, {VoidCallback? onReload}) {
    try {
      if (onReload != null) {
        // Si hay una función de reload personalizada, usarla
        onReload();
      } else {
        // Si no, hacer reload genérico navegando al inicio
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }

      // Mostrar confirmación
      Future.delayed(const Duration(milliseconds: 300), () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.refresh, color: Colors.white),
                SizedBox(width: 8),
                Text("Página reiniciada"),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            duration: const Duration(seconds: 2),
          ),
        );
      });
    } catch (e) {
      print("Error al recargar página: $e");
      
      // Fallback: navegar al inicio
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
  }
}

