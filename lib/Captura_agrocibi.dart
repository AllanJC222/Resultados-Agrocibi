import 'package:flutter/material.dart';
import 'app_bar.dart';
import 'popup_confirmacion.dart';


/*
 * FORMULARIO DE CAPTURA DE MUESTRAS PARA AGROCIBI
 * 
 * Esta es una pantalla completa de formulario para capturar datos de muestras
 * que van a ser enviadas a Agrocibi para análisis.
 * 
 * CARACTERÍSTICAS PRINCIPALES:
 * - Formulario con validaciones
 * - Campos obligatorios y opcionales claramente marcados
 * - Animación de entrada suave
 * - Chips seleccionables para análisis múltiples
 * - Popup de confirmación al guardar
 * - Reset automático después de guardar
 */

class CapturaMuestraView extends StatefulWidget {
  const CapturaMuestraView({super.key});

  @override
  State<CapturaMuestraView> createState() => _CapturaMuestraViewState();
}

class _CapturaMuestraViewState extends State<CapturaMuestraView>
    with SingleTickerProviderStateMixin {
  
  // CONTROLADORES Y VARIABLES DE ESTADO
  
  // Controladores para los campos de texto
  final TextEditingController _observacionesController = TextEditingController();
  final TextEditingController _detallesMuestraController = TextEditingController();

  // Set para análisis múltiples seleccionados
  Set<String> _analisisSeleccionados = <String>{};
  
  // Lista de análisis disponibles
  final List<String> _tiposAnalisis = ['Virus', 'Nematodos', 'Hongos', 'Bacterias'];
  
  // Variables de estado para los campos del formulario
  String _cicloSeleccionado = '';
  String _temporadaSeleccionada = 'Temporada 1'; // Valor automático
  String _loteSeleccionado = '';
  String _turnoSeleccionado = '';
  String _valvulaSeleccionada = '';
  DateTime? _fechaSiembra;
  String _tipoMuestraSeleccionado = '';

  // Colores del tema
  final Color _primaryColor = const Color(0xFFE85A2B); // Naranja principal
  final Color _accentColor = const Color(0xFF8BC34A); // Verde
  final Color _backgroundColor = const Color(0xFFF5F5F5);

  // Animación para entrada suave
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // MÉTODOS DE CICLO DE VIDA
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _observacionesController.dispose();
    _detallesMuestraController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // LÓGICA DE VALIDACIÓN Y GUARDADO

  /// MÉTODO PRINCIPAL DE VALIDACIÓN Y GUARDADO
  /// Valida todos los campos obligatorios y muestra el popup de confirmación
  void _guardarMuestra() async {
    print("\n=== INICIANDO VALIDACIÓN DE MUESTRA ===");
    
    // VALIDACIONES DE CAMPOS OBLIGATORIOS
    List<String> errores = [];
    
    if (_cicloSeleccionado.isEmpty) errores.add("El ciclo es obligatorio");
    if (_turnoSeleccionado.isEmpty) errores.add("El turno es obligatorio");
    if (_tipoMuestraSeleccionado.isEmpty) errores.add("El tipo de muestra es obligatorio");
    if (_loteSeleccionado.isEmpty) errores.add("El lote es obligatorio");
    if (_valvulaSeleccionada.isEmpty) errores.add("La válvula es obligatoria");

    // Si hay errores, mostrar el primero y salir
    if (errores.isNotEmpty) {
      print("❌ ERROR DE VALIDACIÓN: ${errores.first}");
      _showErrorSnackBar(errores.first);
      return;
    }

    print("✅ VALIDACIONES PASADAS - Preparando datos para guardar");

    // PREPARAR DATOS PARA ENVÍO
    Map<String, dynamic> datosmuestra = _prepararDatosParaGuardar();
    
    // MOSTRAR DEBUG DE DATOS
    _mostrarDebugDatos(datosmuestra);
    
    // SIMULAR GUARDADO (aquí iría tu lógica real de API/BD)
    await _simularGuardado();
    
    // MOSTRAR POPUP DE CONFIRMACIÓN
    await ConfirmacionPopup.show(context);
    
    // RESETEAR FORMULARIO DESPUÉS DEL POPUP
    _resetForm();
  }

  /// Simula el proceso de guardado con un delay
  Future<void> _simularGuardado() async {
    await Future.delayed(const Duration(milliseconds: 800));
    // TODO: Aquí implementarás la lógica real de guardado
    // - Llamada a API
    // - Guardado en base de datos local
    // - Manejo de errores de red, etc.
  }

  /// Prepara los datos del formulario en un Map para envío
  Map<String, dynamic> _prepararDatosParaGuardar() {
    return {
      // DATOS OBLIGATORIOS
      'ciclo': _cicloSeleccionado,
      'turno': _turnoSeleccionado,
      'tipoMuestra': _tipoMuestraSeleccionado,
      'lote': _loteSeleccionado,
      'valvula': _valvulaSeleccionada,
      'analisisRequeridos': _analisisSeleccionados.toList(),
      
      // DATOS AUTOMÁTICOS
      'temporada': _temporadaSeleccionada,
      
      // DATOS OPCIONALES
      'fechaSiembra': _fechaSiembra?.toIso8601String(),
      'detallesMuestra': _detallesMuestraController.text.trim(),
      'observaciones': _observacionesController.text.trim(),
      
      // METADATOS
      'fechaCreacion': DateTime.now().toIso8601String(),
      'version': '1.0',
    };
  }

  /// Resetea todos los campos del formulario a su estado inicial
  void _resetForm() {
    setState(() {
      _cicloSeleccionado = '';
      _loteSeleccionado = '';
      _turnoSeleccionado = '';
      _valvulaSeleccionada = '';
      _fechaSiembra = null;
      _tipoMuestraSeleccionado = '';
      _analisisSeleccionados.clear();
      // La temporada se mantiene automática
    });
    
    _observacionesController.clear();
    _detallesMuestraController.clear();
    
    print("🔄 FORMULARIO RESETEADO");
  }

  /// Muestra mensaje de error
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // BUILD METHOD - CONSTRUCCIÓN DE LA UI

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: CustomAppBar.buildAppBar(
        context,
        "Captura de muestra\nAgrocibi",
        appBarColor: _primaryColor,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Primera fila: Ciclo y Turno (OBLIGATORIOS)
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildSection(
                          title: "Seleccione el ciclo *", // * indica obligatorio
                          child: _buildCycleButtons(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSection(
                          title: "Seleccione su turno *",
                          child: _buildTurnoButtons(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Segunda fila: Temporada (automática) y Lote (obligatorio)
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildSection(
                          title: "Temporada (automática)",
                          child: _buildSeasonButton(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSection(
                          title: "Seleccione el lote de la muestra *",
                          child: _buildLoteDropdown(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Tercera fila: Tipo de muestra y Válvula (OBLIGATORIOS)
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildSection(
                          title: "Seleccione el tipo de muestra *",
                          child: _buildTipoMuestraDropdown(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSection(
                          title: "Seleccione la válvula *",
                          child: _buildValvulaDropdown(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Fecha de siembra (OPCIONAL)
                _buildSection(
                  title: "Ingrese la fecha en la que se va a sembrar la muestra",
                  child: _buildDatePicker(),
                ),
                const SizedBox(height: 24),

                // Detalles de muestra (OPCIONAL)
                _buildSection(
                  title: "Detalles de la muestra (Opcional)",
                  child: _buildSampleDetailsTextField(),
                ),
                const SizedBox(height: 24),

                // Análisis requeridos (OBLIGATORIO)
                _buildSection(
                  title: "Agregue los análisis requeridos para esta muestra *",
                  child: _buildAnalysisField(),
                ),
                const SizedBox(height: 24),

                // Observaciones (OPCIONAL)
                _buildSection(
                  title: "Observaciones de la muestra (Opcional)",
                  child: _buildObservationsField(),
                ),
                const SizedBox(height: 40),

                // Botón Guardar
                _buildSaveButton(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // WIDGETS BUILDERS - CONSTRUCCIÓN DE COMPONENTES
  /// Método para construir secciones con título
  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _accentColor,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  /// Botones para ciclo (Ciclo 1 y Ciclo 2)
  Widget _buildCycleButtons() {
    return Column(
      children: [
        _buildSelectableButton(
          text: "Ciclo 1",
          isSelected: _cicloSeleccionado == "Ciclo 1",
          onPressed: () {
            setState(() {
              _cicloSeleccionado = "Ciclo 1";
            });
          },
        ),
        const SizedBox(height: 8),
        _buildSelectableButton(
          text: "Ciclo 2",
          isSelected: _cicloSeleccionado == "Ciclo 2",
          onPressed: () {
            setState(() {
              _cicloSeleccionado = "Ciclo 2";
            });
          },
        ),
      ],
    );
  }

  /// Botones para turno (Turno 1 y Turno 2)
  Widget _buildTurnoButtons() {
    return Column(
      children: [
        _buildSelectableButton(
          text: "Turno 1",
          isSelected: _turnoSeleccionado == "Turno 1",
          onPressed: () {
            setState(() {
              _turnoSeleccionado = "Turno 1";
            });
          },
        ),
        const SizedBox(height: 8),
        _buildSelectableButton(
          text: "Turno 2",
          isSelected: _turnoSeleccionado == "Turno 2",
          onPressed: () {
            setState(() {
              _turnoSeleccionado = "Turno 2";
            });
          },
        ),
      ],
    );
  }

  /// Botón para temporada (valor automático, no editable)
  Widget _buildSeasonButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade300, // Color diferente para mostrar que es automático
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        _temporadaSeleccionada,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black54,
        ),
      ),
    );
  }

  /// Dropdown para selección de lote
  Widget _buildLoteDropdown() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _primaryColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _loteSeleccionado.isEmpty ? null : _loteSeleccionado,
          hint: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Lote",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          dropdownColor: _primaryColor,
          icon: const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.keyboard_arrow_down, color: Colors.white),
          ),
          items: ['Lote A', 'Lote B', 'Lote C'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  value,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _loteSeleccionado = newValue ?? '';
            });
          },
        ),
      ),
    );
  }

  /// Dropdown para selección de tipo de muestra
  Widget _buildTipoMuestraDropdown() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _primaryColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _tipoMuestraSeleccionado.isEmpty ? null : _tipoMuestraSeleccionado,
          hint: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Muestra",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          dropdownColor: _primaryColor,
          icon: const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.keyboard_arrow_down, color: Colors.white),
          ),
          items: ['Tejido', 'Suelo', 'Agua','Semilla'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  value,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _tipoMuestraSeleccionado = newValue ?? '';
            });
          },
        ),
      ),
    );
  }

  /// Dropdown para selección de válvula
  Widget _buildValvulaDropdown() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _primaryColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _valvulaSeleccionada.isEmpty ? null : _valvulaSeleccionada,
          hint: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Válvula",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          dropdownColor: _primaryColor,
          icon: const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.keyboard_arrow_down, color: Colors.white),
          ),
          items: ['Válvula 1', 'Válvula 2', 'Válvula 3'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  value,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _valvulaSeleccionada = newValue ?? '';
            });
          },
        ),
      ),
    );
  }

  /// Selector de fecha con DatePicker
  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: _primaryColor,
                  onPrimary: Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          setState(() {
            _fechaSiembra = picked;
          });
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: _primaryColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _fechaSiembra == null
                  ? "Fecha de siembra"
                  : "${_fechaSiembra!.day}/${_fechaSiembra!.month}/${_fechaSiembra!.year}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const Icon(
              Icons.calendar_today,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  /// Campo de texto para detalles de la muestra
  Widget _buildSampleDetailsTextField() {
    return TextFormField(
      controller: _detallesMuestraController,
      decoration: InputDecoration(
        hintText: "Escriba los detalles de la muestra...",
        hintStyle: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(25),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _accentColor, width: 2),
          borderRadius: BorderRadius.circular(25),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      style: TextStyle(
        color: Colors.grey.shade800,
        fontSize: 16,
      ),
      maxLines: 2,
    );
  }

  /// Campo de análisis con chips seleccionables
  Widget _buildAnalysisField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Campo de texto no editable que muestra los análisis seleccionados
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _analisisSeleccionados.isEmpty
                  ? "Seleccione los análisis requeridos"
                  : _analisisSeleccionados.join(", "),
              style: TextStyle(
                color: _analisisSeleccionados.isEmpty 
                    ? Colors.grey.shade500 
                    : Colors.grey.shade800,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Botones para agregar análisis
        Text(
          "Tipos de análisis disponibles:",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 12),
        
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _tiposAnalisis.map((analisis) {
            bool isSelected = _analisisSeleccionados.contains(analisis);
            return _buildAnalysisChip(
              text: analisis,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _analisisSeleccionados.remove(analisis);
                  } else {
                    _analisisSeleccionados.add(analisis);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Campo de observaciones multilínea
  Widget _buildObservationsField() {
    return TextFormField(
      controller: _observacionesController,
      maxLines: 2,
      decoration: InputDecoration(
        hintText: "Observaciones",
        hintStyle: TextStyle(color: Colors.grey.shade500),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: _accentColor, width: 2),
        ),
        contentPadding: const EdgeInsets.all(16),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  /// Botón guardar con gradiente
  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [_accentColor, _accentColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: _accentColor.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _guardarMuestra,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: const Text(
          "Guardar muestra",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// MÉTODO DE PRUEBA - Para verificar que el popup funciona
  /// Puedes usar este método temporalmente para testear el popup

  /// Widget para botón seleccionable personalizado
  Widget _buildSelectableButton({
    required String text,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? _primaryColor : Colors.grey.shade200,
          foregroundColor: isSelected ? Colors.white : Colors.grey.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          elevation: isSelected ? 4 : 1,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  /// Widget para chip de análisis seleccionable
  Widget _buildAnalysisChip({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? _primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _primaryColor : Colors.grey.shade400,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.3),
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
              text,
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

  // MÉTODOS DE DEBUG
  /// Muestra debug detallado de los datos a guardar
  void _mostrarDebugDatos(Map<String, dynamic> datos) {
    print("\n📊 === DEBUG DE DATOS A GUARDAR ===");
    print("🔹 CAMPOS OBLIGATORIOS:");
    print("   • Ciclo: ${datos['ciclo']}");
    print("   • Turno: ${datos['turno']}");
    print("   • Tipo Muestra: ${datos['tipoMuestra']}");
    print("   • Lote: ${datos['lote']}");
    print("   • Válvula: ${datos['valvula']}");
    print("   • Análisis: ${datos['analisisRequeridos']}");
    
    print("\n🔹 CAMPOS AUTOMÁTICOS:");
    print("   • Temporada: ${datos['temporada']}");
    
    print("\n🔹 CAMPOS OPCIONALES:");
    print("   • Fecha Siembra: ${datos['fechaSiembra'] ?? 'No especificada'}");
    print("   • Detalles: ${datos['detallesMuestra'].isEmpty ? 'Sin detalles' : datos['detallesMuestra']}");
    print("   • Observaciones: ${datos['observaciones'].isEmpty ? 'Sin observaciones' : datos['observaciones']}");
    
    print("\n🔹 METADATOS:");
    print("   • Fecha Creación: ${datos['fechaCreacion']}");
    print("   • Versión: ${datos['version']}");
    print("=== FIN DEBUG ===\n");
  }
}