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

  /// LÓGICA CENTRAL: Construye formulario dinámico basado en análisis, método y tipo de muestra
  /// Implementa matriz completa según tabla de especificaciones:
  /// VIRUS: ELISA/PCR (presencia+absorbancia), Prueba Rápida (solo presencia)
  /// NEMATODOS: Centrifugación (juveniles) - solo tejido/suelo
  /// HONGOS: Convencional - tejido(presencia), suelo(conteo), agua(conteo+presencia)  
  /// BACTERIOLOGÍA: Convencional, PCR, Prueba Rápida con campos específicos
  Widget _buildDynamicInputSection() {
    final analisis = SistemaDatos.getAnalisisPorId(widget.metodo.idAnalisis);
    final int idAnalisis = analisis?.idAnalisis ?? 0;
    final int idMetodo = widget.metodo.idMetodo;
    
    // 🔥 CÓDIGO NUEVO: Obtener tipo de muestra como INT
    int tipoMuestraId = 3;
    
    // Función para obtener el tipo lógico basado en la matriz
    int _getTipoLogico(int tipoId, int idAnalisis, int idMetodo) {
      // 1=Tejido, 2=Suelo, 3=Agua, 4=Semilla
      
      if (tipoId == 4) { // Semilla
        // Reglas especiales para semilla según tu matriz:
        if (idAnalisis == 1) return 1; // Virus: se toma como tejido
        if (idAnalisis == 2) return 1; // Nematodos: se toma como tejido  
        if (idAnalisis == 3) return 1; // Hongos: se toma como tejido
        if (idAnalisis == 4) return 4; // Bacteriología: mantiene como semilla
      }
      
      return tipoId; // Para tejido, suelo, agua: sin cambios
    }
    
    int tipoLogicoId = _getTipoLogico(tipoMuestraId, idAnalisis, idMetodo);
    
    // Helper para nombres de tipos (solo para debug/display)
    String _getNombreTipo(int id) {
      switch (id) {
        case 1: return 'Tejido';
        case 2: return 'Suelo';
        case 3: return 'Agua';
        case 4: return 'Semilla';
        default: return 'Desconocido';
      }
    }
    
    // DEBUG
    print('=== MATRIZ CON INT ===');
    print('Tipo original: $tipoMuestraId (${_getNombreTipo(tipoMuestraId)})');
    print('Tipo lógico: $tipoLogicoId (${_getNombreTipo(tipoLogicoId)})');
    print('Análisis: $idAnalisis, Método: $idMetodo');
    print('=====================');
    
    final List<Widget> inputWidgets = [];

    // 🔥 SWITCH CON LÓGICA INT
    switch (idAnalisis) {
      case 1: // VIRUS
        print('🦠 VIRUS - Todos los tipos iguales');
        if (idMetodo == 1 || idMetodo == 2) { // ELISA o PCR
          inputWidgets.addAll([
            _buildPresenciaSection(),
            const SizedBox(height: 20),
            _buildAbsorbanciaCtSection(),
          ]);
        } else if (idMetodo == 3) { // Prueba Rápida
          inputWidgets.add(_buildPresenciaSection());
        }
        
        // Nota especial si es semilla
        if (tipoMuestraId == 4) {
          inputWidgets.insert(0, _buildInfoNote('Las semillas se procesan como tejido para virus'));
          inputWidgets.insert(1, const SizedBox(height: 12));
        }
        break;
        
      case 2: // NEMATODOS
        print('🪱 NEMATODOS');
        if (idMetodo == 4) { // Centrifugación
          if (tipoLogicoId == 1 || tipoLogicoId == 2) { // Tejido o Suelo (incluye semilla→tejido)
            inputWidgets.add(_buildJuvenilesSection());
            
            if (tipoMuestraId == 4) {
              inputWidgets.insert(0, _buildInfoNote('Las semillas se procesan como tejido para nematodos'));
              inputWidgets.insert(1, const SizedBox(height: 12));
            }
          } else if (tipoLogicoId == 3) { // Agua
            inputWidgets.add(_buildNoAplicaMessage('Nematodos no se analizan en muestras de agua'));
          }
        }
        break;
        
      case 3: // HONGOS
        print('🍄 HONGOS');
        if (idMetodo == 5) { // Convencional
          if (tipoLogicoId == 1) { // Tejido (incluye semilla→tejido)
            inputWidgets.add(_buildPresenciaSection());
            
            if (tipoMuestraId == 4) {
              inputWidgets.insert(0, _buildInfoNote('Las semillas se procesan como tejido para hongos'));
              inputWidgets.insert(1, const SizedBox(height: 12));
            }
          } else if (tipoLogicoId == 2) { // Suelo
            inputWidgets.add(_buildConteoSection());
          } else if (tipoLogicoId == 3) { // Agua
            inputWidgets.addAll([
              _buildConteoSection(),
              const SizedBox(height: 20),
              _buildPresenciaSection(),
            ]);
          }
        }
        break;
        
      case 4: // BACTERIOLOGÍA
        print('🧬 BACTERIOLOGÍA');
        if (idMetodo == 6) { // Convencional
          if (tipoLogicoId == 1) { // Tejido
            inputWidgets.add(_buildPresenciaSection());
          } else if (tipoLogicoId == 2) { // Suelo
            inputWidgets.add(_buildNoAplicaMessage('Bacteriología convencional no aplica para muestras de suelo'));
          } else if (tipoLogicoId == 3) { // Agua
            inputWidgets.addAll([
              _buildPresenciaSection(),
              const SizedBox(height: 20),
              _buildAbsorbanciaCtSection(),
              const SizedBox(height: 20),
              _buildDilucionSection(),
            ]);
          } else if (tipoLogicoId == 4) { // Semilla (caso especial)
            inputWidgets.addAll([
              _buildInfoNote('Análisis bacteriológico para semillas: presencia + CT + dilución'),
              const SizedBox(height: 12),
              _buildPresenciaSection(),
              const SizedBox(height: 20),
              _buildAbsorbanciaCtSection(),
              const SizedBox(height: 20),
              _buildDilucionSection(),
            ]);
          }
        } else if (idMetodo == 7) { // PCR
          if (tipoLogicoId == 1) { // Tejido
            inputWidgets.add(_buildPresenciaSection());
          } else if (tipoLogicoId == 2) { // Suelo
            inputWidgets.add(_buildNoAplicaMessage('PCR no aplica para muestras de suelo'));
          } else if (tipoLogicoId == 3) { // Agua
            inputWidgets.addAll([
              _buildPresenciaSection(),
              const SizedBox(height: 20),
              _buildAbsorbanciaCtSection(),
            ]);
          } else if (tipoLogicoId == 4) { // Semilla (caso especial)
            inputWidgets.addAll([
              _buildInfoNote('PCR para semillas: presencia + valor numérico'),
              const SizedBox(height: 12),
              _buildPresenciaSection(),
              const SizedBox(height: 20),
              _buildValorNumericoSection(),
            ]);
          }
        } else if (idMetodo == 8) { // Prueba Rápida
          if (tipoLogicoId == 1 || tipoLogicoId == 3 || tipoLogicoId == 4) { // Tejido, Agua, Semilla
            inputWidgets.add(_buildPresenciaSection());
            
            if (tipoMuestraId == 4) {
              inputWidgets.insert(0, _buildInfoNote('Prueba rápida para semillas: solo presencia'));
              inputWidgets.insert(1, const SizedBox(height: 12));
            }
          } else if (tipoLogicoId == 2) { // Suelo
            inputWidgets.add(_buildNoAplicaMessage('Prueba rápida no aplica para muestras de suelo'));
          }
        }
        break;
    }

    // Si no hay campos disponibles
    if (inputWidgets.isEmpty) {
      return Column(
        children: [
          const Icon(Icons.info, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Configuración no disponible:\n'
            '${analisis?.nombre} - ${widget.metodo.nombre}\n'
            'Tipo de muestra: ${_getNombreTipo(tipoMuestraId)}',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      );
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

  /// Widget para valor numérico (diferente de CT)
  Widget _buildValorNumericoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Valor Numérico",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _conteoController, // Reutiliza el controlador existente
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.all(16),
            hintText: 'Ingresar valor numérico',
            labelText: 'Valor',
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  /// Widget de nota informativa
  Widget _buildInfoNote(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        border: Border.all(color: Colors.blue.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue.shade600, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.blue.shade700,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
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

  /// Widget para entrada numérica de absorbancia o ciclos CT
  Widget _buildAbsorbanciaCtSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Absorbancia / CT",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _absorbanciaCtController,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.all(16),
            hintText: 'Ingresar valor numérico',
          ),
          keyboardType: TextInputType.number, // Teclado numérico
        ),
      ],
    );
  }

  /// Widget para entrada numérica de conteo de organismos
  Widget _buildConteoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Conteo",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _conteoController,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.all(16),
            hintText: 'Ingresar conteo',
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  /// Widget para entrada de juveniles por gramo (específico para nematodos)
  Widget _buildJuvenilesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Juveniles por gramos de suelo",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _juvenilesController,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.all(16),
            hintText: 'Ingresar valor',
          ),
          keyboardType: TextInputType.number,
        ),
      ],
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
