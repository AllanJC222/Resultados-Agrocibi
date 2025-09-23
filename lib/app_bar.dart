import 'package:flutter/material.dart';
import 'popup_tipoCapptura.dart';
import 'popup_analisis_wizard.dart';

class CustomAppBar {
  // Método estático para crear el AppBar con popup
  static PreferredSizeWidget buildAppBar(
    BuildContext context,
    String title, {
    Color? appBarColor,
    VoidCallback? onReset, // ← AGREGAMOS CALLBACK PARA RESET
  }) {
    return AppBar(
      backgroundColor: appBarColor ?? Colors.blue,
      elevation: 4,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.menu_sharp, color: Colors.white),
          onPressed: () {
            _showMenuPopup(
              context,
              appBarColor ?? Colors.blue,
              onReset,
            ); // ← PASAMOS EL CALLBACK
          },
        ),
      ],
    );
  }

  // Método privado para mostrar el popup
  static void _showMenuPopup(
    BuildContext context,
    Color color,
    VoidCallback? onReset,
  ) {
    // ← RECIBIMOS EL CALLBACK
    // GUARDAMOS EL CONTEXTO PADRE para usarlo después
    final BuildContext parentContext = context;

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) {
        return Stack(
          children: [
            Positioned(
              top: 90,
              right: 16,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 250,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.person, color: Colors.blue),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                "Menú Principal",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 18,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),
                      // Línea separadora
                      Container(
                        height: 1,
                        color: Colors.white.withOpacity(0.3),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      const SizedBox(height: 8),
                      // Opciones del menú
                      _buildMenuItem(
                        context,
                        Icons.home,
                        "Volver al menú principal",
                        () {
                          Navigator.pop(context);
                          Navigator.popUntil(
                            parentContext,
                            (route) => route.isFirst,
                          );
                        },
                      ),
                      _buildMenuItem(
                        context,
                        Icons.camera_alt,
                        "Tipo de captura",
                        () {
                          Navigator.pop(context);
                          TipoCapturaPopup.show(parentContext);
                        },
                      ),

                      _buildMenuItem(
                        context,
                        Icons.add_circle,
                        "Ingresar resultados",
                        () async {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (_) => AnalisisWizardPopup(),
                          );
                        },
                      ),

                      _buildMenuItem(
                        context,
                        Icons.visibility,
                        "Ver resultados",
                        () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(parentContext).showSnackBar(
                            const SnackBar(
                              content: Text("Navegando a resultados..."),
                            ),
                          );
                        },
                      ),
                      // Separador
                      Container(
                        height: 1,
                        color: Colors.white.withOpacity(0.2),
                        margin: const EdgeInsets.all(8),
                      ),
                      _buildMenuItem(
                        context,
                        Icons.logout,
                        "Cerrar Sesión",
                        () {
                          Navigator.pop(context);
                          _showLogoutDialog(parentContext);
                        },
                        isRed: true,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Widget para cada opción del menú
  static Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isRed = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Diálogo para logout
  static void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cerrar Sesión"),
        content: const Text("¿Cerrar la sesión actual?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: const Text("Cerrar Sesión"),
          ),
        ],
      ),
    );
  }
}
