import 'package:flutter/material.dart';

class ConfirmacionAlmacenPopup {
  
  /// Muestra el popup de confirmación
  /// 
  /// @param context - Contexto de Flutter
  /// @param tipoAccion - "envío" o "recepción" (para mensajes dinámicos)
  /// @param cantidadMuestras - Número de muestras seleccionadas
  /// @param fechaSeleccionada - Fecha que se va a asignar
  /// @param accentColor - Color opcional para el botón confirmar
  /// 
  /// @return Future<bool?> - true si confirma, false/null si cancela
  static Future<bool?> show(
    BuildContext context, {
    required String tipoAccion,
    required int cantidadMuestras,
    required DateTime fechaSeleccionada,
    Color? accentColor,
  }) {
    return showDialog<bool>(
      context: context,
      // No se puede cerrar tocando fuera
      // El usuario DEBE elegir una opción
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _ConfirmacionDialog(
          tipoAccion: tipoAccion,
          cantidadMuestras: cantidadMuestras,
          fechaSeleccionada: fechaSeleccionada,
          accentColor: accentColor ?? const Color(0xFF8BC34A),
        );
      },
    );
  }
}

/// Widget interno del diálogo
/// Privado porque solo se usa dentro de ConfirmacionAlmacenPopup
class _ConfirmacionDialog extends StatelessWidget {
  final String tipoAccion;
  final int cantidadMuestras;
  final DateTime fechaSeleccionada;
  final Color accentColor;

  const _ConfirmacionDialog({
    required this.tipoAccion,
    required this.cantidadMuestras,
    required this.fechaSeleccionada,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 380,
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
            // Header con color y título
            _buildHeader(),
            
            // Contenido principal
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Ícono grande
                  _buildIcono(),
                  
                  const SizedBox(height: 20),
                  
                  // Mensaje principal
                  _buildMensajePrincipal(),
                  
                  const SizedBox(height: 24),
                  
                  // Detalles de la operación
                  _buildDetalles(),
                  
                  const SizedBox(height: 32),
                  
                  // Botones de acción
                  _buildBotones(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Header del popup con color
  /// El color depende del tipo de acción (naranja para envío, verde para recepción)
  Widget _buildHeader() {
    // Color dinámico según la acción
    final Color headerColor = tipoAccion.toLowerCase() == 'envío'
        ? const Color(0xFFE85A2B) // Naranja para envío
        : accentColor; // Verde para recepción

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        color: headerColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          // Ícono según el tipo
          Icon(
            _getIconoPorTipo(),
            color: Colors.white,
            size: 28,
          ),
          const SizedBox(width: 12),
          // Título dinámico
          Expanded(
            child: Text(
              'Confirmar $tipoAccion',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Ícono principal del popup (grande, centrado)
  Widget _buildIcono() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: accentColor.withOpacity(0.3),
          width: 3,
        ),
      ),
      child: Icon(
        _getIconoPorTipo(),
        color: accentColor,
        size: 50,
      ),
    );
  }

  /// Mensaje principal con texto dinámico
  Widget _buildMensajePrincipal() {
    // Texto dinámico según acción
    final String accion = tipoAccion.toLowerCase() == 'envío'
        ? 'enviadas'
        : 'recibidas';
    
    // Singular vs plural
    final String muestrasTexto = cantidadMuestras == 1
        ? 'muestra'
        : 'muestras';

    return Text(
      '¿Desea marcar $cantidadMuestras $muestrasTexto como $accion?',
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
        height: 1.3,
      ),
    );
  }

  /// Contenedor con detalles de la operación
  Widget _buildDetalles() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Detalle 1: Cantidad
          _buildDetalleRow(
            icono: Icons.inventory_2_outlined,
            label: 'Cantidad de muestras:',
            valor: '$cantidadMuestras',
            valorColor: accentColor,
          ),
          
          const SizedBox(height: 12),
          
          // Detalle 2: Fecha
          _buildDetalleRow(
            icono: Icons.calendar_today,
            label: 'Fecha de $tipoAccion:',
            valor: _formatearFecha(fechaSeleccionada),
            valorColor: accentColor,
          ),
        ],
      ),
    );
  }

  /// Fila individual de detalle (ícono + label + valor)
  Widget _buildDetalleRow({
    required IconData icono,
    required String label,
    required String valor,
    required Color valorColor,
  }) {
    return Row(
      children: [
        // Ícono
        Icon(icono, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        
        // Label
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        
        // Valor destacado
        Text(
          valor,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: valorColor,
          ),
        ),
      ],
    );
  }

  /// Botones de Cancelar y Confirmar
  Widget _buildBotones(BuildContext context) {
    return Row(
      children: [
        // Botón Cancelar (expandido)
        Expanded(
          child: _buildBotonCancelar(context),
        ),
        
        const SizedBox(width: 12),
        
        // Botón Confirmar (expandido)
        Expanded(
          child: _buildBotonConfirmar(context),
        ),
      ],
    );
  }

  /// Botón Cancelar (gris, outlined)
  Widget _buildBotonCancelar(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.shade400, width: 2),
      ),
      child: TextButton(
        onPressed: () => Navigator.of(context).pop(false), // Retorna false
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          'Cancelar',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  /// Botón Confirmar (verde/naranja, filled)
  Widget _buildBotonConfirmar(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextButton(
        onPressed: () => Navigator.of(context).pop(true), // Retorna true
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const Text(
          'Confirmar',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ========================================
  // MÉTODOS HELPER
  // ========================================

  /// Devuelve el ícono apropiado según el tipo de acción
  IconData _getIconoPorTipo() {
    return tipoAccion.toLowerCase() == 'envío'
        ? Icons.send_rounded // Envío = avión/flecha
        : Icons.inbox_rounded; // Recepción = bandeja
  }

  /// Formatea fecha a DD/MM/YYYY
  String _formatearFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/'
           '${fecha.month.toString().padLeft(2, '0')}/'
           '${fecha.year}';
  }
}