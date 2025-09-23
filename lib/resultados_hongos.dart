import 'package:flutter/material.dart';
import 'app_bar.dart';
import 'sistema_datos.dart';
import 'widgets.dart';

class ResultadosHongos extends StatefulWidget {
  final Metodo metodo;

  const ResultadosHongos({
    super.key,
    required this.metodo,
  });

  @override
  State<ResultadosHongos> createState() => _ResultadosHongosState();
}

class _ResultadosHongosState extends State<ResultadosHongos> {
  final TextEditingController _conteoController = TextEditingController();
  final TextEditingController _observacionesController = TextEditingController();
  String? _dilucionValue;
  final List<String> _dilucionOpciones = ['10-1', '10-2', '10-3'];

  late final Color _colorAnalisis;
  late final String _title;

  @override
  void initState() {
    super.initState();
    final analisis = SistemaDatos.getAnalisisPorId(widget.metodo.idAnalisis);
    _colorAnalisis = analisis?.color ?? Colors.grey;
    _title = "Resultados: ${analisis?.nombre ?? 'Análisis'}";
  }

  @override
  void dispose() {
    _conteoController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  void _guardarResultados() {
    final conteo = _conteoController.text;
    final dilucion = _dilucionValue;
    final observaciones = _observacionesController.text;

    debugPrint('=== GUARDANDO RESULTADOS DE HONGOS ===');
    debugPrint('Conteo: $conteo CFU');
    debugPrint('Dilución: $dilucion');
    debugPrint('Observaciones: $observaciones');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Resultados de Hongos guardados correctamente"),
        backgroundColor: Colors.green,
      ),
    );
    _resetForm();
  }

  void _resetForm() {
    _conteoController.clear();
    _observacionesController.clear();
    setState(() {
      _dilucionValue = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.buildAppBar(
        context,
        _title,
        appBarColor: _colorAnalisis,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SampleInfoCard(
                metodo: widget.metodo,
                colorAnalisis: _colorAnalisis,
              ),
              const SizedBox(height: 20),
              SandiaInputField(
                label: "Conteo en CFU",
                controller: _conteoController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              SandiaDropdown<String>(
                label: "Dilución",
                items: _dilucionOpciones,
                value: _dilucionValue,
                onChanged: (newValue) {
                  setState(() {
                    _dilucionValue = newValue;
                  });
                },
                placeholder: "Seleccionar dilución",
              ),
              const SizedBox(height: 20),
              ObservacionesField(controller: _observacionesController),
              const SizedBox(height: 30),
              SaveButton(
                onPressed: _guardarResultados,
                color: _colorAnalisis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}