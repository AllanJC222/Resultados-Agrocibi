import 'package:flutter/material.dart';
import '../widgets.dart';
import '../sistema_datos.dart';
import '../app_bar.dart';

abstract class ResultadosBase extends StatefulWidget {
  final Metodo metodo;
  
  const ResultadosBase({
    Key? key,
    required this.metodo,
  }) : super(key: key);
}

abstract class ResultadosBaseState<T extends ResultadosBase> extends State<T> {
  // Controladores comunes
  late TextEditingController observacionesController;
  late TextEditingController valorNumericoController;
  
  // Estado común
  List<Map<String, dynamic>> variantes = [];
  int? varianteSeleccionada;
  bool presenciaValue = false;
  String? dilucionValue;
  bool isLoading = false;
  
  // Color del análisis
  Color get colorAnalisis {
    final analisis = SistemaDatos.getAnalisisPorId(widget.metodo.idAnalisis);
    return analisis?.color ?? Colors.grey;
  }
  
  // Título del análisis
  String get tituloAnalisis {
    final analisis = SistemaDatos.getAnalisisPorId(widget.metodo.idAnalisis);
    return analisis?.nombre ?? 'Análisis';
  }
  
  // Tipo de muestra (TODO: Obtener de donde corresponda)
  
  @override
  void initState() {
    super.initState();
    observacionesController = TextEditingController();
    valorNumericoController = TextEditingController();
    inicializarVariantes();
  }
  
  @override
  void dispose() {
    observacionesController.dispose();
    valorNumericoController.dispose();
    super.dispose();
  }
  
  // Inicializar variantes según el método
  void inicializarVariantes() {
    final variantesData = SistemaDatos.getVariantesPorMetodo(widget.metodo.idMetodo);
    variantes = variantesData.map((v) => {
      'id': v.idVariante,
      'nombre': v.nombre,
    }).toList();
  }
  
  // Método abstracto para campos específicos
  Widget buildCamposEspecificos();
  
  // Guardar resultados
  Future<void> guardarResultados() async {
    if (!validarCampos()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor seleccione una variante'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() => isLoading = true);
    
    try {
      // TODO: Implementar guardado real
      await Future.delayed(const Duration(seconds: 1));
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Resultados guardados correctamente'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Reset form
      setState(() {
        varianteSeleccionada = null;
        presenciaValue = false;
        valorNumericoController.clear();
        observacionesController.clear();
      });
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
  
  bool validarCampos() {
    return varianteSeleccionada != null;
  }
  
  // Widgets comunes
  Widget buildInfoSection() {
    return SampleInfoCard(
      metodo: widget.metodo,
      colorAnalisis: colorAnalisis,
    );
  }
  
  Widget buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorAnalisis,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            elevation: 4,
          ),
          onPressed: () {
            // TODO: Implementar más detalles
          },
          child: const Text("Más detalles", style: TextStyle(fontSize: 16)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorAnalisis,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            elevation: 4,
          ),
          onPressed: () {
            // TODO: Implementar otra muestra
          },
          child: const Text("Otra muestra", style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
  
  Widget buildVariantesSection() {
    return Column(
      children: [
        const Text(
          "Variante",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12.0,
          runSpacing: 10.0,
          children: variantes.asMap().entries.map((entry) {
            final int index = entry.key;
            final Map<String, dynamic> variante = entry.value;
            
            return ChoiceChip(
              label: Text(variante['nombre']),
              selected: varianteSeleccionada == index,
              onSelected: (bool selected) {
                setState(() {
                  varianteSeleccionada = selected ? index : null;
                });
              },
              backgroundColor: Colors.grey.shade200,
              selectedColor: colorAnalisis,
              labelStyle: TextStyle(
                color: varianteSeleccionada == index ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: varianteSeleccionada == index ? Colors.transparent : Colors.grey,
                  width: 1,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
  
  // Build principal
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar.buildAppBar(
        context,
        'Resultados de la muestra:\n$tituloAnalisis',
        appBarColor: colorAnalisis,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildInfoSection(),
            const SizedBox(height: 10),
            buildActionButtons(),
            const SizedBox(height: 20),
            buildVariantesSection(),
            const SizedBox(height: 20),
            buildCamposEspecificos(), // Cada clase hija implementa sus campos
            const SizedBox(height: 20),
            ObservacionesField(controller: observacionesController),
            const SizedBox(height: 30),
            SaveButton(
              onPressed: isLoading ? () {} : guardarResultados,
              color: colorAnalisis,
            ),
          ],
        ),
      ),
    );
  }
}