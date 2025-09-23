import 'package:flutter/material.dart';
import 'sistema_datos.dart';

// ============================================
// WIDGETS BÁSICOS MEJORADOS
// ============================================

/// Widget para mostrar información de la muestra - MEJORADO
class SampleInfoCard extends StatelessWidget {
  final Metodo metodo;
  final Color colorAnalisis;
  final bool showExtended; // Para mostrar más o menos info

  const SampleInfoCard({
    super.key,
    required this.metodo,
    required this.colorAnalisis,
    this.showExtended = false,
  });

  @override
  Widget build(BuildContext context) {
    final muestra = SistemaDatos.muestra;
    final analisis = SistemaDatos.getAnalisisPorId(metodo.idAnalisis);
    final tipoMuestra = _getTipoMuestraTexto(SistemaDatos().tipoMuestra);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [colorAnalisis.withOpacity(0.1), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con icono
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorAnalisis,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getAnalysisIcon(metodo.idAnalisis),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Información de la muestra",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorAnalisis,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Info básica
              _buildInfoRow("Código:", muestra['codigo'] ?? 'N/A'),
              _buildInfoRow("Tipo de muestra:", tipoMuestra),
              _buildInfoRow("Análisis:", analisis?.nombre ?? 'N/A'),
              _buildInfoRow("Método:", metodo.nombre),
              
              // Info extendida si se solicita
              if (showExtended) ...[
                const SizedBox(height: 8),
                _buildInfoRow("Finca:", muestra['finca'] ?? 'N/A'),
                _buildInfoRow("Turno:", muestra['turno'] ?? 'N/A'),
                if (muestra['lote'] != null)
                  _buildInfoRow("Lote:", muestra['lote']),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  String _getTipoMuestraTexto(int? tipoId) {
    switch (tipoId) {
      case 1: return "Tejido";
      case 2: return "Suelo";
      case 3: return "Semilla";
      default: return "Desconocido";
    }
  }

  IconData _getAnalysisIcon(int analisisId) {
    switch (analisisId) {
      case 1: return Icons.coronavirus; // Virus
      case 2: return Icons.bug_report;  // Nematodos
      case 3: return Icons.grass;       // Hongos
      case 4: return Icons.biotech;     // Bacteriología
      case 5: return Icons.science;     // Nutrición
      default: return Icons.science;
    }
  }
}

// ============================================
// WIDGETS PARA CAMPOS ESPECÍFICOS
// ============================================

/// Campo de texto validado y mejorado
class SandiaValidatedField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool isRequired;
  final String? helperText;
  final IconData? prefixIcon;
  final String? suffixText;
  final int maxLines;

  const SandiaValidatedField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.isRequired = false,
    this.helperText,
    this.prefixIcon,
    this.suffixText,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
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
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator ?? (isRequired ? _defaultValidator : null),
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF8BC34A), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            suffixText: suffixText,
            helperText: helperText,
            hintText: 'Ingrese $label',
          ),
        ),
      ],
    );
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '$label es obligatorio';
    }
    return null;
  }
}

/// Dropdown mejorado con más opciones
class SandiaDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String? placeholder;
  final bool isRequired;
  final String? Function(T?)? validator;
  final IconData? prefixIcon;

  const SandiaDropdown({
    Key? key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    this.placeholder,
    this.isRequired = false,
    this.validator,
    this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
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
        DropdownButtonFormField<T>(
          value: value,
          validator: validator ?? (isRequired ? _defaultValidator : null),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF8BC34A), width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          ),
          hint: Text(placeholder ?? 'Seleccione $label'),
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(item.toString()),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  String? _defaultValidator(T? value) {
    if (value == null) {
      return 'Debe seleccionar $label';
    }
    return null;
  }
}

/// Checkbox con diseño mejorado
class SandiaCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final Color color;
  final String? subtitle;

  const SandiaCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            ),
            Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: color,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// WIDGETS PARA SELECCIÓN MÚLTIPLE
// ============================================

/// Widget para seleccionar múltiples variantes
class VariantSelectionWidget extends StatelessWidget {
  final String title;
  final List<Variante> variantes;
  final List<int> selectedIds;
  final Function(List<int>) onSelectionChanged;
  final Color accentColor;

  const VariantSelectionWidget({
    super.key,
    required this.title,
    required this.variantes,
    required this.selectedIds,
    required this.onSelectionChanged,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: variantes.map((variante) {
            final isSelected = selectedIds.contains(variante.idVariante);
            return SandiaChoiceChip(
              label: variante.nombre,
              isSelected: isSelected,
              color: accentColor,
              onSelected: (selected) {
                List<int> newSelection = List.from(selectedIds);
                if (selected) {
                  newSelection.add(variante.idVariante);
                } else {
                  newSelection.remove(variante.idVariante);
                }
                onSelectionChanged(newSelection);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Chip de selección mejorado
class SandiaChoiceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final ValueChanged<bool> onSelected;

  const SandiaChoiceChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelected(!isSelected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade400,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.add_circle_outline,
              color: isSelected ? Colors.white : Colors.grey.shade600,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// WIDGETS ESPECIALIZADOS
// ============================================

/// Widget para mostrar coordenadas GPS
class GPSCoordinatesCard extends StatelessWidget {
  final double? latitud;
  final double? longitud;
  final VoidCallback? onRefresh;
  final bool isLoading;
  final Color accentColor;

  const GPSCoordinatesCard({
    super.key,
    this.latitud,
    this.longitud,
    this.onRefresh,
    this.isLoading = false,
    this.accentColor = const Color(0xFF8BC34A),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Coordenadas GPS",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
                if (onRefresh != null)
                  IconButton(
                    onPressed: isLoading ? null : onRefresh,
                    icon: isLoading 
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: accentColor,
                            ),
                          )
                        : Icon(Icons.refresh, color: accentColor),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (latitud != null && longitud != null) ...[
              Text(
                "Lat: ${latitud!.toStringAsFixed(6)}",
                style: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
              ),
              Text(
                "Lng: ${longitud!.toStringAsFixed(6)}",
                style: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
              ),
            ] else ...[
              const Text(
                "Coordenadas no disponibles",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================
// BOTONES MEJORADOS
// ============================================

/// Botón de guardar con loading state
class SaveButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color color;
  final String text;
  final bool isLoading;
  final IconData? icon;

  const SaveButton({
    super.key,
    this.onPressed,
    required this.color,
    this.text = "Guardar resultados",
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade400,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          elevation: isLoading ? 0 : 4,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Guardando...",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Botón de acción genérico
class SandiaActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final IconData? icon;
  final bool isOutlined;

  const SandiaActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
    this.icon,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isOutlined ? Colors.white : color,
        foregroundColor: isOutlined ? color : Colors.white,
        side: isOutlined ? BorderSide(color: color, width: 2) : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        elevation: isOutlined ? 0 : 4,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ============================================
// CAMPO DE OBSERVACIONES MEJORADO
// ============================================

/// Campo de observaciones con contador de caracteres
class ObservacionesField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final int maxLength;

  const ObservacionesField({
    super.key,
    required this.controller,
    this.title = "Observaciones de los resultados",
    this.maxLength = 500,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLength: maxLength,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Escriba sus observaciones aquí...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF8BC34A), width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}

// ============================================
// WIDGETS DE VALIDACIÓN
// ============================================

/// Widget que muestra errores de validación
class ValidationErrorWidget extends StatelessWidget {
  final List<String> errors;

  const ValidationErrorWidget({
    super.key,
    required this.errors,
  });

  @override
  Widget build(BuildContext context) {
    if (errors.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
              const SizedBox(width: 8),
              Text(
                "Errores de validación:",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...errors.map((error) => Padding(
            padding: const EdgeInsets.only(left: 28, bottom: 4),
            child: Text(
              "• $error",
              style: TextStyle(fontSize: 13, color: Colors.red.shade700),
            ),
          )),
        ],
      ),
    );
  }
}

class PresenciaSelector extends StatelessWidget {
  final bool? value; // null = no seleccionado, true = presencia, false = ausencia
  final Function(bool?) onChanged;
  final Color? activeColor;
  
  const PresenciaSelector({
    Key? key,
    required this.value,
    required this.onChanged,
    this.activeColor,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final color = activeColor ?? const Color(0xFFE85A2B);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Resultado',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildOption(
                label: 'Ausencia',
                isSelected: value == false,
                color: Colors.grey,
                onTap: () => onChanged(false),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildOption(
                label: 'Presencia',
                isSelected: value == true,
                color: color,
                onTap: () => onChanged(true),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildOption({
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? Colors.white : Colors.grey.shade600,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SandiaInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool isRequired;

  const SandiaInputField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.all(16),
            hintText: 'Ingresar valor',
          ),
          keyboardType: keyboardType,
          validator: (value) {
            if (isRequired && (value == null || value.isEmpty)) {
              return 'Este campo es requerido';
            }
            return null;
          },
        ),
      ],
    );
  }
}