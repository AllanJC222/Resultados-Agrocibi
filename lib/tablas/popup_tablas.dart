// popup_selector_analisis.dart
import 'package:flutter/material.dart';
import '../sistema_datos.dart';
import '../route.dart';

String _getRutaPorId(int id) {
  switch (id) {
    case 1: return AppRoutes.tablaVirus;
    case 2: return AppRoutes.tablaNematodos;
    case 3: return AppRoutes.tablaHongos;
    case 4: return AppRoutes.tablaBacteriologia;
    default: return AppRoutes.tablaVirus; // fallback
  }
}

class SelectorAnalisisPopup extends StatefulWidget {
  const SelectorAnalisisPopup({super.key});

  @override
  State<SelectorAnalisisPopup> createState() => _SelectorAnalisisPopupState();
}


class _SelectorAnalisisPopupState extends State<SelectorAnalisisPopup>
    with SingleTickerProviderStateMixin {
  // 🎯 MISMA ANIMACIÓN DEL WIZARD
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // 🔄 EXACTAMENTE IGUAL que el wizard
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🎯 EXACTAMENTE EL MISMO DIALOG que el wizard
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(), // 📱 Mismo header del wizard
            Flexible(
              child: FadeTransition(
                opacity: _fadeAnimation, // ✨ Misma animación del wizard
                child: _buildListaAnalisis(), // 📋 Misma lista del wizard
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🎯 HEADER COPIADO DEL WIZARD - Solo cambiar título
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5), // 🎨 Mismo color del wizard
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 36), // 📏 Mismo espaciado del wizard

          const Expanded(
            child: Text(
              '¿Qué análisis ver?', // 📝 ÚNICO CAMBIO: título específico para ver
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),

          // 🎯 MISMO BOTÓN CERRAR del wizard
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  // 🎯 LISTA COPIADA DEL WIZARD - Solo cambiar fuente de datos
  Widget _buildListaAnalisis() {
    return ListView.separated(
      padding: const EdgeInsets.all(16), // 📏 Mismo padding del wizard
      shrinkWrap: true,
      itemCount:
          SistemaDatos.getAnalisisComoMapa().length, // 📊 Usar sistema_datos
      separatorBuilder: (_, __) =>
          const SizedBox(height: 8), // 📏 Mismo separador
      itemBuilder: (context, index) {
        final opcion =
            SistemaDatos.getAnalisisComoMapa()[index]; // 📊 Usar sistema_datos
        return _buildOpcionAnalisis(opcion); // 🎯 Mismo widget del wizard
      },
    );
  }

  // 🎯 WIDGET OPCIÓN COPIADO DEL WIZARD - Solo cambiar onTap
  Widget _buildOpcionAnalisis(Map<String, dynamic> opcion) {
    return GestureDetector(
      onTap: () {
        // 🎯 ÚNICA DIFERENCIA: navegar a tabla en lugar de continuar wizard
        Navigator.pop(context); // Cierra el popup
        String ruta = _getRutaPorId(opcion['id']);
        Navigator.pushNamed(context, ruta);
      },
      child: Container(
        height: 70, // 📏 Misma altura del wizard
        decoration: BoxDecoration(
          color: opcion['color'], // 🎨 Mismo color del wizard
          borderRadius: BorderRadius.circular(35), // 📐 Mismo radio del wizard
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                0.1,
              ), // 🌫️ Misma sombra del wizard
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2, // 📏 Misma proporción del wizard
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                ), // 📏 Mismo padding del wizard
                child: Text(
                  opcion['nombre'], // 📝 Mismo texto del wizard
                  style: const TextStyle(
                    fontSize: 20, // 📝 Mismo tamaño del wizard
                    fontWeight: FontWeight.bold, // 📝 Mismo peso del wizard
                    color: Colors.white, // 🎨 Mismo color del wizard
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8), // 📏 Mismo margen del wizard
              width: 54, // 📏 Mismo tamaño del wizard
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(
                  0.3,
                ), // 🎨 Misma transparencia del wizard
                shape: BoxShape.circle, // 📐 Misma forma del wizard
              ),
              child: Icon(
                opcion['icon'], // 🎯 Mismo ícono del wizard
                color: Colors.white, // 🎨 Mismo color del wizard
                size: 32, // 📏 Mismo tamaño del wizard
              ),
            ),
          ],
        ),
      ),
    );
    
  }
  
}
