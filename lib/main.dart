import 'package:flutter/material.dart';
// Importaciones de widgets personalizados para popups y navegación
import 'popip_muestra.dart'; 
// Sistema centralizado de datos de la aplicación
import 'sistema_datos.dart';
import 'app_bar.dart';
import 'navigation_helper.dart';


/// Constantes de colores para mantener consistencia visual
/// Centraliza la paleta de colores evitando magic numbers
class AppColors {
  static const Color primary = Color.fromRGBO(233, 99, 43, 1);
  static const Color secondary = Color.fromRGBO(243, 202, 11, 1);
  static const Color background = Colors.white;
  static const Color text = Colors.black87;
  static const Color shadow = Colors.black26;
}

/// Constantes de strings para evitar hardcoding y facilitar internacionalización
class AppStrings {
  static const String appTitle = 'Hongos/Bacterias\nresultados para tejidos';
  static const String sampleInfo = 'Información de la muestra';
  static const String moreDetails = 'Más detalles';
  static const String otherSample = 'Otra Muestra';
  static const String fungi = 'Hongos';
  static const String bacteria = 'Bacterias';
  static const String variants = 'Variantes';
  static const String absence = 'Ausencia';
  static const String presence = 'Presencia';
}

/// Punto de entrada de la aplicación
void main() {
  runApp(const MyApp());
}

/// Widget raíz de la aplicación
/// Configura el tema global y la página inicial
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      title: 'Login de usuario', // TODO: Revisar si este título es correcto
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Roboto',
      ),
      home: const MyHomePage(title: AppStrings.appTitle),
    );
    
  }
}

/// Página principal que muestra los resultados de análisis de hongos y bacterias
/// Maneja el estado de las variantes analizadas y su presencia/ausencia
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // VARIABLES DE ESTADO
  /// Lista de resultados para hongos con estructura: {id, nombre, presencia}
  /// presencia: null = no evaluado, true = presente, false = ausente
  List<Map<String, dynamic>> _hongosResults = [];
  
  /// Lista de resultados para bacterias con la misma estructura
  List<Map<String, dynamic>> _bacteriasResults = [];

  @override
  void initState() {
    super.initState();
    // Inicialización de datos al crear el widget
    _initializeResults();
  }

  /// Inicializa los resultados obteniendo las variantes del sistema de datos
  /// Se ejecuta una sola vez al iniciar la pantalla
  void _initializeResults() {
    // Obtiene variantes de hongos (método convencional, id = 5)
    final variantesHongos = SistemaDatos.getVariantesPorMetodo(5);
    _hongosResults = variantesHongos.map((variante) => {
      'id': variante.idVariante,
      'nombre': variante.nombre,
      'presencia': null, // Estado inicial: no evaluado
    }).toList();

    // Obtiene variantes de bacterias (método convencional, id = 6)
    final variantesBacterias = SistemaDatos.getVariantesPorMetodo(6);
    _bacteriasResults = variantesBacterias.map((variante) => {
      'id': variante.idVariante,
      'nombre': variante.nombre,
      'presencia': null,
    }).toList();
  }

  // CONSTRUCCIÓN DE LA UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.buildAppBar(
        context, 
        AppStrings.appTitle,
        appBarColor: AppColors.primary, // Opcional
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSampleInfo(),           // Información de la muestra
              const SizedBox(height: 10),
              _buildActionButtons(),        // Botones de acción
              const SizedBox(height: 10),
              // Tabla de variantes de hongos
              _buildVariantTable(
                title: AppStrings.fungi,
                variants: _hongosResults,
                color: AppColors.primary,
              ),
              const SizedBox(height: 15),
              // Tabla de variantes de bacterias
              _buildVariantTable(
                title: AppStrings.bacteria,
                variants: _bacteriasResults,
                color: AppColors.secondary,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye el AppBar con botón de retroceso y menú
  

  /// Construye la card con información básica de la muestra
  /// Obtiene los datos del sistema centralizado
  Widget _buildSampleInfo() {
    final muestra = SistemaDatos.muestra; // Acceso a datos de muestra
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Text(
              AppStrings.sampleInfo,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            // Muestra código y tipo de muestra
            _buildInfoRow("Código:", muestra['codigo'] ?? 'N/A'),
            _buildInfoRow("Tipo:", muestra['tipo'] ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  /// Widget helper para crear filas de información consistentes
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  /// Construye los botones de acción principales
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Botón para mostrar detalles adicionales de la muestra
        _buildActionButton(
          text: AppStrings.moreDetails,
          onPressed: _showSampleDetails, // Callback para mostrar popup
        ),
        // Botón para navegar a análisis de otra muestra
        _buildActionButton(
          text: AppStrings.otherSample,
          onPressed: _showAnalisisMenu, // Callback para menú de análisis
        ),
      ],
    );
  }

  /// Factory method para crear botones con estilo consistente
  Widget _buildActionButton({
    required String text, 
    required VoidCallback onPressed
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        elevation: 4,
      ),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }

  /// Construye una tabla de variantes con checkboxes para presencia/ausencia
  /// Parámetros: título, lista de variantes, color de tema
  Widget _buildVariantTable({
    required String title,
    required List<Map<String, dynamic>> variants,
    required Color color,
  }) {
    return Column(
      children: [
        // Título de la sección (Hongos/Bacterias)
        Text(
          title,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        // Container con tabla de variantes
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 2),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildTableHeader(), // Header con títulos de columnas
              // Mapea cada variante a una fila de tabla
              ...variants.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> variant = entry.value;
                // isLast para manejar borde inferior
                return _buildTableRow(variant, color, index == variants.length - 1);
              }),
            ],
          ),
        ),
      ],
    );
  }

  /// Construye el header de la tabla con títulos de columnas
  Widget _buildTableHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            flex: 2, // Doble espacio para columna de variantes
            child: _buildHeaderText(AppStrings.variants),
          ),
          Expanded(
            child: _buildHeaderText(AppStrings.absence),
          ),
          Expanded(
            child: _buildHeaderText(AppStrings.presence),
          ),
        ],
      ),
    );
  }

  /// Helper para crear texto de header consistente
  Widget _buildHeaderText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.text,
      ),
    );
  }

  /// Construye una fila de datos en la tabla de variantes
  /// Incluye nombre de variante y checkboxes para ausencia/presencia
  Widget _buildTableRow(Map<String, dynamic> variant, Color color, bool isLast) {
    // Determina el estado actual de los checkboxes
    final bool presenceIsTrue = variant['presencia'] == true;
    final bool presenceIsFalse = variant['presencia'] == false;

    return Container(
      decoration: BoxDecoration(
        // Solo agrega borde inferior si no es la última fila
        border: isLast 
          ? null 
          : const Border(bottom: BorderSide(color: Colors.grey)),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Columna del nombre de la variante
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: color, // Color dinámico según tipo (hongos/bacterias)
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                variant['nombre'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Checkbox para ausencia
          Expanded(
            child: _buildCustomCheckbox(
              value: presenceIsFalse,
              onChanged: (newVal) => _updateVariantPresence(variant, newVal, false),
            ),
          ),
          // Checkbox para presencia
          Expanded(
            child: _buildCustomCheckbox(
              value: presenceIsTrue,
              onChanged: (newVal) => _updateVariantPresence(variant, newVal, true),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye checkbox personalizado con estilo consistente
  Widget _buildCustomCheckbox({
    required bool value, 
    required Function(bool?) onChanged
  }) {
    return Center(
      child: Transform.scale(
        scale: 1.2, // Agranda ligeramente el checkbox
        child: Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: const Color.fromARGB(255, 0, 0, 0), // Color cuando está marcado
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
    );
  }

  // LÓGICA DE NEGOCIO

  /// Actualiza el estado de presencia de una variante
  /// Implementa lógica mutuamente excluyente (solo una opción activa)
  void _updateVariantPresence(
    Map<String, dynamic> variant, 
    bool? newVal, 
    bool isPresence
  ) {
    setState(() {
      if (newVal == true) {
        // Si se marca un checkbox, establece el estado correspondiente
        variant['presencia'] = isPresence;
      } else {
        // Si se desmarca, vuelve al estado no evaluado
        variant['presencia'] = null;
      }
    });
  }

  /// Muestra popup con detalles completos de la muestra
  void _showSampleDetails() {
    showDialog(
      context: context,
      builder: (context) => MuestraPopup(muestra: SistemaDatos.muestra),
    );
  }

  /// Maneja el flujo de selección de nuevo análisis
  /// 1. Muestra menú de tipos de análisis
  /// 2. Muestra métodos disponibles para el análisis seleccionado  
  /// 3. Navega a pantalla de variantes del método elegido
  void _showAnalisisMenu() async {
  // En lugar de toda la lógica que tenías antes, ahora solo:
  await NavigationHelper.showAnalisisFlow(
    context,
    onMainRefresh: () {
      // Esta función se ejecuta si necesita refrescar el main
      setState(() {
        _initializeResults(); // Tu función existente
      });
    },
  );
}

  

}
// NOTAS DE MEJORAS IDENTIFICADAS:
// 1. El título 'Login de usuario' no coincide con la funcionalidad
// 2. Falta implementar navegación del botón back
// 3. Falta implementar menú lateral
// 4. El método _getAnalyzedCount no se usa actualmente
// 5. Considerar extraer constantes para IDs de métodos (5, 6)
// 6. Añadir validación de datos nulos del SistemaDato