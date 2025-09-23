import 'package:flutter/material.dart';
import 'sistema_datos.dart';
import 'app_bar.dart';

/// Widget para captura de resultados de variantes según método de análisis
/// Maneja formularios dinámicos basados en tipo de análisis y muestra
class Variantes extends StatefulWidget {
  final Metodo metodo;

  const Variantes({
    super.key,
    required this.metodo,
  });

  @override
  State<Variantes> createState() => _VariantesState();
}
class AppStrings {
  
}

class _VariantesState extends State<Variantes> {
  // VARIABLES DE ESTADO PRINCIPALES
  /// Lista de variantes disponibles para el método seleccionado
  List<Map<String, dynamic>> _resultados = [];

  
  
  /// Índice de la variante seleccionada (null = ninguna seleccionada)
  int? _selectedIndex;

  // VARIABLES DE FORMULARIO
  /// Estado del checkbox de presencia/ausencia
  bool _presenciaValue = false;
  
  /// Valor seleccionado en dropdown de dilución
  String? _dilucionValue;

  // CONTROLADORES DE TEXTO - Manejan entrada de datos numéricos
  /// Para valores de absorbancia o ciclos CT
  final TextEditingController _absorbanciaCtController = TextEditingController();
  
  /// Para conteo de organismos/colonias
  final TextEditingController _conteoController = TextEditingController();
  
  /// Para conteo de juveniles en análisis de nematodos
  final TextEditingController _juvenilesController = TextEditingController();
  
  /// Para observaciones generales del análisis
  final TextEditingController _observacionesController = TextEditingController();
  // VARIABLES DE COLOR - Inicializadas una sola vez
  late final Color _colorAnalisis;
  late final Analisis? _analisis;
  late final String _title;
  @override
  void initState() {
    super.initState();
    // Inicializa las variantes al crear el widget
    _analisis = SistemaDatos.getAnalisisPorId(widget.metodo.idAnalisis);
    _colorAnalisis = _analisis?.color ?? Colors.grey;
    _title = (_analisis?.nombre.length ?? 0) > 20 
  ? "Resultados:\n${_analisis!.nombre.substring(0, 20)}..."
  : "Resultados de la muestra:\n${_analisis?.nombre ?? 'Análisis'}";
    _initializeVariantes();
  }

  @override
  void dispose() {
    // IMPORTANTE: Liberar recursos de los controladores para evitar memory leaks
    _absorbanciaCtController.dispose();
    _conteoController.dispose();
    _juvenilesController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  /// Inicializa las variantes disponibles para el método seleccionado
  /// Obtiene datos del sistema centralizado y los mapea a estructura local
  void _initializeVariantes() {
    final variantes = SistemaDatos.getVariantesPorMetodo(widget.metodo.idMetodo);
    _resultados = variantes.map((variante) => {
      'id': variante.idVariante,
      'nombre': variante.nombre,
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Obtiene datos del análisis para colorear la UI dinámicamente

    return Scaffold(
      appBar: CustomAppBar.buildAppBar(
        context, 
        _title,
        appBarColor: _colorAnalisis, // Opcional
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSampleInfo(),              // Información de muestra y método
              const SizedBox(height: 10),
              _buildActionButtons(), // Botones de acción
              const SizedBox(height: 20),
              _buildVariantsSection(), // Selección de variante
              const SizedBox(height: 20),
              _buildDynamicInputSection(),     // Formulario dinámico
              const SizedBox(height: 20),
              _buildObservacionesSection(),    // Campo de observaciones
              const SizedBox(height: 30),
              _buildSaveButton(), // Botón guardar
            ],
          ),
        ),
      ),
    );
  }

  // --- MÉTODOS DE CONSTRUCCIÓN DE WIDGETS ---

  /// Construye AppBar con color dinámico basado en el análisis
  /// Muestra nombre del análisis en el título
  

  /// Construye card con información completa de muestra y método
  Widget _buildSampleInfo() {
    final muestra = SistemaDatos.muestra;
    final analisis = SistemaDatos.getAnalisisPorId(widget.metodo.idAnalisis);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Text(
              "Información de la muestra",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Información básica de la muestra
            _buildInfoRow("Código de muestra:", muestra['codigo'] ?? 'N/A'),
            _buildInfoRow("Tipo de muestra:", muestra['tipo'] ?? 'N/A'),
            _buildInfoRow("Análisis solicitado:", analisis?.nombre ?? 'N/A'),
            _buildInfoRow("Método:", widget.metodo.nombre),
          ],
        ),
      ),
    );
  }

  /// Helper para crear filas de información consistentes
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye botones de acción con color dinámico
  /// TODO: Implementar funcionalidad de los botones
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _colorAnalisis,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            elevation: 4,
          ),
          onPressed: () {}, // TODO: Implementar más detalles
          child: const Text("Más detalles", style: TextStyle(fontSize: 16)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _colorAnalisis,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            elevation: 4,
          ),
          onPressed: () {}, // TODO: Implementar otra muestra
          child: const Text("Otra muestra", style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  /// Construye sección de selección de variantes usando ChoiceChips
  /// Permite seleccionar una variante de la lista disponible
  Widget _buildVariantsSection() {
    return Column(
      children: [
        const Text(
          "Variante",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        // Chips seleccionables para cada variante
        Wrap(
          spacing: 12.0,
          runSpacing: 10.0,
          children: _resultados.asMap().entries.map((entry) {
            final int index = entry.key;
            final Map<String, dynamic> variante = entry.value;
            return ChoiceChip(
              label: Text(variante['nombre']),
              selected: _selectedIndex == index,
              // Callback cuando se selecciona/deselecciona un chip
              onSelected: (bool selected) {
                setState(() {
                  _selectedIndex = selected ? index : null;
                });
              },
              backgroundColor: Colors.grey.shade200,
              selectedColor: _colorAnalisis, // Color dinámico cuando está seleccionado
              labelStyle: TextStyle(
                color: _selectedIndex == index ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: _selectedIndex == index ? Colors.transparent : Colors.grey,
                  width: 1,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDynamicInputSection() {
  final int idAnalisis = widget.metodo.idAnalisis;
  final int idMetodo = widget.metodo.idMetodo;
  final int tipoMuestraId = 2; // 1: Tejido, 2: Suelo, 3: Semilla
  
  final List<Widget> inputWidgets = [];

  // VIRUS
  if (idAnalisis == 1) {
    if (idMetodo == 1 || idMetodo == 2) { // ELISA o PCR
      inputWidgets.add(_buildPresenciaSection());
      inputWidgets.add(const SizedBox(height: 20));
      inputWidgets.add(Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        "Absorbancia / CT",  // <-- El único cambio, ahora es dinámico
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      TextFormField(
        controller: _absorbanciaCtController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.all(16),
          hintText: 'Ingresar valor numérico',
        ),
        keyboardType: TextInputType.number,
      ),
    ],
  ));
    } else if (idMetodo == 3) { // Prueba Rápida
      inputWidgets.add(_buildPresenciaSection());
    }
  }
  
  // NEMATODOS
  else if (idAnalisis == 2 && idMetodo == 4) { // Centrifugación
    if (tipoMuestraId == 1 || tipoMuestraId == 2) { // Tejido o Suelo
      inputWidgets.add(Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        "Juveniles por gramos de suelo",  // <-- El único cambio, ahora es dinámico
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      TextFormField(
        controller: _juvenilesController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.all(16),
          hintText: 'Ingresar valor numérico',
        ),
        keyboardType: TextInputType.number,
      ),
    ],
  ));
    } else if (tipoMuestraId == 3) { // Semilla
      inputWidgets.add(_buildNoAplicaMessage('Nematodos no se analizan en semillas'));
    }
  }
  
  // HONGOS  
  else if (idAnalisis == 3 && idMetodo == 5) { // Convencional
    if (tipoMuestraId == 1 || tipoMuestraId == 3) { // Tejido o Semilla
      inputWidgets.add(_buildPresenciaSection());
    } else if (tipoMuestraId == 2) { // Suelo
      inputWidgets.add(Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        "Conteo",  // <-- El único cambio, ahora es dinámico
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      TextFormField(
        controller: _conteoController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.all(16),
          hintText: 'Ingresar valor numérico',
        ),
        keyboardType: TextInputType.number,
      ),
    ],
  ));
    }
  }
  
  // BACTERIOLOGÍA
  else if (idAnalisis == 4) {
    if (idMetodo == 6) { // Convencional
      if (tipoMuestraId == 1) { // Tejido
        inputWidgets.add(_buildPresenciaSection());
      } else if (tipoMuestraId == 2) { // Suelo
        inputWidgets.add(_buildNoAplicaMessage('Bacteriología convencional no aplica para suelo'));
      } else if (tipoMuestraId == 3) { // Semilla
        inputWidgets.add(_buildPresenciaSection());
        inputWidgets.add(const SizedBox(height: 20));
        inputWidgets.add(Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        "Conteo",  // <-- El único cambio, ahora es dinámico
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      TextFormField(
        controller: _conteoController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.all(16),
          hintText: 'Ingresar valor numérico',
        ),
        keyboardType: TextInputType.number,
      ),
    ],
  ));
        inputWidgets.add(const SizedBox(height: 20));
        inputWidgets.add(_buildDilucionSection());
      }
    } 
    else if (idMetodo == 7) { // PCR
      if (tipoMuestraId == 1) { // Tejido
        inputWidgets.add(_buildPresenciaSection());
      } else if (tipoMuestraId == 2) { // Suelo  
        inputWidgets.add(_buildNoAplicaMessage('PCR no aplica para suelo'));
      } else if (tipoMuestraId == 3) { // Semilla
        inputWidgets.add(_buildPresenciaSection());
        inputWidgets.add(const SizedBox(height: 20));
        inputWidgets.add(Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        "Valor Numérico",  // <-- El único cambio, ahora es dinámico
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      TextFormField(
        controller: _conteoController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.all(16),
          hintText: 'Ingresar valor numérico',
        ),
        keyboardType: TextInputType.number,
      ),
    ],
  ));
      }
    } 
    else if (idMetodo == 8) { // Prueba Rápida
      if (tipoMuestraId == 1 || tipoMuestraId == 3) { // Tejido o Semilla
        inputWidgets.add(_buildPresenciaSection());
      } else if (tipoMuestraId == 2) { // Suelo
        inputWidgets.add(_buildNoAplicaMessage('Prueba rápida no aplica para suelo'));
      }
    }
  }

  // Si no hay campos configurados
  if (inputWidgets.isEmpty) {
    return _buildNoAplicaMessage('No hay configuración para esta combinación');
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: inputWidgets,
  );
}
  // 🔥 WIDGETS NUEVOS - Agregar antes de _resetForm()
  
  /// Widget para cuando el análisis no aplica
  Widget _buildNoAplicaMessage(String razon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        border: Border.all(color: Colors.orange.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(Icons.not_interested, color: Colors.orange.shade600, size: 32),
          const SizedBox(height: 8),
          Text(
            'No Aplica',
            style: TextStyle(
              color: Colors.orange.shade800,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            razon,
            style: TextStyle(
              color: Colors.orange.shade700,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // --- WIDGETS DE CAMPOS DE FORMULARIO ---

  /// Widget checkbox para indicar presencia/ausencia
  Widget _buildPresenciaSection() {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Presencia",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          // Checkbox con callback para actualizar estado
          Checkbox(
            value: _presenciaValue,
            onChanged: (bool? newValue) {
              setState(() {
                _presenciaValue = newValue ?? false;
              });
            },
            activeColor: _colorAnalisis,
          ),
        ],
      ),
    ),
  );
}
 

  /// Widget dropdown para selección de dilución
  Widget _buildDilucionSection() {
    final List<String> diluciones = ['10', '100']; // Opciones predefinidas
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Dilución",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _dilucionValue,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.all(16),
          ),
          hint: const Text("Seleccionar dilución"),
          // Mapea opciones a DropdownMenuItems
          items: diluciones.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _dilucionValue = newValue;
            });
          },
        ),
      ],
    );
  }

  /// Widget para campo de observaciones (texto multilínea)
  Widget _buildObservacionesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Observaciones de los resultados de la muestra",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _observacionesController,
          decoration: InputDecoration(
            hintText: "Observaciones",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            contentPadding: const EdgeInsets.all(16),
          ),
          maxLines: 3, // Permite múltiples líneas
        ),
      ],
    );
  }

  /// Construye botón de guardar con color dinámico
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _colorAnalisis,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 4,
        ),
        onPressed: _guardarResultados, // Callback para guardar
        child: const Text(
          "Guardar resultados",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // --- LÓGICA DE NEGOCIO ---

  /// Lógica principal para guardar resultados
  /// Valida selección de variante y recopila datos del formulario
  void _guardarResultados() {
    // Validación: debe haber una variante seleccionada
    if (_selectedIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, selecciona una variante.")),
      );
      return;
    }

    // Recopila datos del formulario
    final varianteSeleccionada = _resultados[_selectedIndex!];
    final valorAbsorbancia = _absorbanciaCtController.text;
    final valorConteo = _conteoController.text;
    final valorJuveniles = _juvenilesController.text;
    final observaciones = _observacionesController.text;

    // Log para debugging (eliminar en producción)
    debugPrint('=== GUARDANDO RESULTADOS ===');
    debugPrint('Variante: ${varianteSeleccionada['nombre']}');
    debugPrint('Absorbancia/CT: $valorAbsorbancia');
    debugPrint('Conteo: $valorConteo');
    debugPrint('Juveniles: $valorJuveniles');
    debugPrint('Presencia: $_presenciaValue');
    debugPrint('Dilución: $_dilucionValue');
    debugPrint('Observaciones: $observaciones');
    debugPrint('============================');

    // TODO: Implementar guardado real en base de datos o sistema de persistencia

    // Feedback visual al usuario
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Resultados guardados correctamente"),
        backgroundColor: Colors.green,
      ),
    );

    // Resetea el formulario después de guardar
    _resetForm();
  }

  /// Limpia todos los campos del formulario y resetea el estado
  void _resetForm() {
    _absorbanciaCtController.clear();
    _conteoController.clear();
    _juvenilesController.clear();
    _observacionesController.clear();
    setState(() {
      _selectedIndex = null;
      _presenciaValue = false;
      _dilucionValue = null;
    });
  }
}
