import 'package:flutter/material.dart';
import 'Captura_agrocibi.dart';
import 'Captura_suelo.dart';

class TipoCapturaPopup {
  
  // Método para mostrar el popup
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 300,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
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
                const SizedBox(height: 24),
                
                // Título
                const Text(
                  "Que tipo de captura",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Opción 1: Análisis de suelo
                _buildCapturaOption(
                  context,
                  title: "Captura de Analisis de suelo",
                  color: Colors.green.shade600,
                  icon: Icons.eco,
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const CapturaSueloView())
                    );
                  },
                ),
                const SizedBox(height: 16),
                
                // Opción 2: Muestras para Agrocibi
                _buildCapturaOption(
                  context,
                  title: "Captura de muestras para Agrocibi",
                  color: Colors.teal.shade600,
                  icon: Icons.science,
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const CapturaMuestraView())
                    );
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Botón cerrar
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancelar",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
  
  // Widget para cada opción de captura
  static Widget _buildCapturaOption(
    BuildContext context, {
    required String title,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Título
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Área de iconos/ilustración
                Container(
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Mano con guante
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade700,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Icon(
                          Icons.back_hand,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      
                      // Planta/elemento central
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.green.shade800,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          icon,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      
                      // Lupa
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.brown.shade600,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}