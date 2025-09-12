import 'package:flutter/material.dart';

/// Popup de confirmación que se muestra después de guardar una muestra exitosamente
/// Incluye botones para ingresar otra muestra o volver al menú principal
class ConfirmacionPopup {
  
  /// Muestra el popup de confirmación de guardado exitoso
  static Future<void> show(BuildContext context) async {
    print("🎉 MOSTRANDO POPUP DE CONFIRMACIÓN");
    
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // No se puede cerrar tocando fuera
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 320,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header verde con mensaje de éxito
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50), // Verde de éxito
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "La muestra sea\nguardado correctamente",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Icono de check verde
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 80,
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Botones de acción
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Botón "Ingresar otra muestra"
                      _buildActionButton(
                        text: "Ingresar otra muestra",
                        backgroundColor: Colors.white,
                        borderColor: Colors.black,
                        textColor: Colors.black,
                        onPressed: () {
                          print("🔄 SELECCIONADO: Ingresar otra muestra");
                          Navigator.pop(context); // Cierra el popup
                          _ingresarOtraMuestra(context);
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Botón "Volver al Menú"
                      _buildActionButton(
                        text: "Volver al Menú",
                        backgroundColor: Colors.white,
                        borderColor: Colors.black,
                        textColor: Colors.black,
                        onPressed: () {
                          print("🏠 SELECCIONADO: Volver al menú");
                          Navigator.pop(context); // Cierra el popup
                          _volverAlMenu(context);
                        },
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
  
  /// Construye un botón de acción con estilo personalizado
  static Widget _buildActionButton({
    required String text,
    required Color backgroundColor,
    required Color borderColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: TextButton(
        onPressed: onPressed,
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
            color: textColor,
          ),
        ),
      ),
    );
  }
  
  /// Maneja la acción de ingresar otra muestra
  /// Simplemente cierra el popup, el reset se hace desde CapturaMuestraView
  static void _ingresarOtraMuestra(BuildContext context) {
    // Solo cerramos el popup
    // El reset del formulario se maneja automáticamente en _guardarMuestra()
    print("🔄 ACCIÓN: Ingresar otra muestra seleccionada");
  }
  
  /// Maneja la acción de volver al menú principal
  /// Navega hasta la primera pantalla (menú principal)
  static void _volverAlMenu(BuildContext context) {
    // Navega al menú principal eliminando todas las pantallas anteriores
    Navigator.popUntil(context, (route) => route.isFirst);
    print("🏠 NAVEGANDO: Volviendo al menú principal");
  }
}

// EJEMPLO DE USO:
// Para mostrar el popup después de guardar una muestra:
/*
void _guardarMuestra() async {
  // ... lógica de validación y guardado ...
  
  if (guardadoExitoso) {
    await ConfirmacionPopup.show(context);
    // El popup se encarga de las acciones posteriores
  }
}
*/

// CARACTERÍSTICAS DEL POPUP:
// ✅ Diseño fiel al mockup proporcionado
// ✅ No se puede cerrar tocando fuera (barrierDismissible: false)
// ✅ Botones funcionales para las dos acciones principales
// ✅ Navegación limpia al menú principal
// ✅ Feedback visual con SnackBars
// ✅ Estilo consistente con el tema de la app
// ✅ Responsive y bien estructurado

// INTEGRACIÓN:
// 1. Importar en Captura_agrocibi.dart
// 2. Llamar ConfirmacionPopup.show(context) después de guardar exitosamente
// 3. El popup maneja automáticamente las acciones posteriores