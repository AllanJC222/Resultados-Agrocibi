import 'package:flutter/material.dart';

// ============================================
// WIDGETS ESPECÍFICOS PARA ALMACÉN DE MUESTRAS
// ============================================

/// DatePicker personalizado para filtros de fecha
class SandiaDatePicker extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onChanged;
  final String? hintText;
  final Color? accentColor;
  final bool isRequired;

  const SandiaDatePicker({
    super.key,
    required this.label,
    required this.onChanged,
    this.selectedDate,
    this.hintText,
    this.accentColor,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? const Color(0xFF8BC34A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label con asterisco si es requerido
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            children: [
              if (isRequired)
                const TextSpan(
                  text: " *",
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Container del DatePicker
        GestureDetector(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: color,
                      onPrimary: Colors.white,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            onChanged(picked);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12),
              color: selectedDate != null
                  ?  Color(0xFF8BC34A) // Azul cálido cuando hay fecha
                  : Colors.grey.shade400, // Gris cuando no hay fecha
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate != null
                      ? _formatDate(selectedDate!)
                      : hintText ?? 'Seleccionar fecha',
                  style: TextStyle(
                    fontSize: 16,
                    color: selectedDate != null
                        ? Colors.black87
                        : Colors.grey.shade600,
                  ),
                ),
                Icon(Icons.calendar_today, color:  Colors.black, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Formatea fecha para mostrar DD/MM/YYYY
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

/// Checkbox para seleccionar todas las filas de una tabla
class SelectAllCheckbox extends StatelessWidget {
  final bool? value; // null = indeterminado, true = todos, false = ninguno
  final ValueChanged<bool?> onChanged;
  final String label;
  final int totalItems;
  final int selectedItems;

  const SelectAllCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = 'Seleccionar todas',
    required this.totalItems,
    required this.selectedItems,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          tristate: true, // Permite estado indeterminado
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF8BC34A),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$label ($selectedItems de $totalItems)',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

/// Panel para acciones masivas (fecha + botón actualizar)
class MassiveActionPanel extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateChanged;
  final VoidCallback? onUpdatePressed;
  final String dateLabel;
  final String buttonText;
  final int selectedCount;
  final bool isLoading;
  final Color? accentColor;

  const MassiveActionPanel({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
    required this.onUpdatePressed,
    this.dateLabel = 'Nueva fecha de envío',
    this.buttonText = 'Actualizar fechas seleccionadas',
    required this.selectedCount,
    this.isLoading = false,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? const Color(0xFF8BC34A);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: SandiaDatePicker(
              label: dateLabel,
              selectedDate: selectedDate,
              onChanged: onDateChanged,
              hintText: 'Seleccionar fecha',
              accentColor: color,
            ),
          ),

          const SizedBox(width: 16),

          // Botón actualizar
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed:
                        selectedCount > 0 && selectedDate != null && !isLoading
                        ? onUpdatePressed
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            buttonText,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget para mostrar estadísticas de filtros
class AlmacenStatsCard extends StatelessWidget {
  final int totalMuestras;
  final int muestrasFiltradas;
  final int muestrasSeleccionadas;
  final String? filtroActual;
  final Color? accentColor;

  const AlmacenStatsCard({
    super.key,
    required this.totalMuestras,
    required this.muestrasFiltradas,
    required this.muestrasSeleccionadas,
    this.filtroActual,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? const Color(0xFF8BC34A);

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Stats izquierda
          Row(
            children: [
              Icon(Icons.info_outline, color: color, size: 16),
              const SizedBox(width: 8),
              Text(
                'Mostrando $muestrasFiltradas de $totalMuestras muestras',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),

          // Stats derecha
          Row(
            children: [
              if (filtroActual != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    filtroActual!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Text(
                '$muestrasSeleccionadas seleccionadas',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================
// HELPERS PARA CONSTRUIR FILAS DE TABLA
// ============================================

/// Helper para crear DataRow con checkbox (NO es Widget)
class AlmacenTableRowHelper {
  /// Construye un DataRow con checkbox para tabla de almacén
  static DataRow buildRow({
    required bool isSelected,
    required ValueChanged<bool?> onChanged,
    required List<Widget> cells,
    required int index,
  }) {
    return DataRow(
      selected: isSelected,
      color: MaterialStateProperty.resolveWith<Color?>((
        Set<MaterialState> states,
      ) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF8BC34A).withOpacity(0.1);
        }
        return index.isEven ? Colors.grey.shade50 : Colors.white;
      }),
      cells: [
        // Primera celda siempre es el checkbox
        DataCell(
          Checkbox(
            value: isSelected,
            onChanged: onChanged,
            activeColor: const Color(0xFF8BC34A),
          ),
        ),
        // Resto de celdas
        ...cells.map((cell) => DataCell(cell)),
      ],
    );
  }

  /// Helper para construir celdas de texto
  static Widget buildTextCell(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    );
  }
  
  /// Helper para construir header de columna
  static Widget buildColumnHeader(String text, {Color? color}) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: color ?? const Color(0xFF8BC34A),
        fontSize: 14,
      ),
    );
  }
}
