import 'package:flutter/material.dart';
import 'resultados_base.dart';
import '../widgets.dart';
import 'sistema_datos.dart';

class ResultadosBacterias extends ResultadosBase {
  const ResultadosBacterias({Key? key, required super.metodo})
    : super(key: key);

  @override
  State<ResultadosBacterias> createState() => _ResultadosBacteriasState();
}


class _ResultadosBacteriasState
    extends ResultadosBaseState<ResultadosBacterias> {
  @override
  Widget buildCamposEspecificos() {
    final List<Widget> campos = [];

    if (SistemaDatos().tipoMuestra == 2) {
      // Suelo - no aplica para ningún método de bacteriología
      campos.add(
        _buildNoAplicaMessage('Bacteriología no aplica para muestras de suelo'),
      );
    } else {
      switch (widget.metodo.idMetodo) {
        case 6: // Convencional
          campos.add(
            SandiaCheckbox(
              label: "Presencia",
              value: presenciaValue,
              onChanged: (value) {
                setState(() => presenciaValue = value ?? false);
              },
              color: colorAnalisis,
            ),
          );
          campos.add(const SizedBox(height: 20));
          campos.add(
            SandiaInputField(
              label: "CT",
              controller: valorNumericoController,
              keyboardType: TextInputType.number,
              isRequired: true,
            ),
          );
          campos.add(const SizedBox(height: 20));
          campos.add(
            SandiaDropdown<String>(
              label: "Dilución",
              value: dilucionValue,
              items: const ['10', '100', '1000'],
              onChanged: (value) {
                setState(() => dilucionValue = value);
              },
              placeholder: 'Seleccionar dilución',
            ),
          );
          break;

        case 7: // PCR
          campos.add(
            SandiaCheckbox(
              label: "Presencia",
              value: presenciaValue,
              onChanged: (value) {
                setState(() => presenciaValue = value ?? false);
              },
              color: colorAnalisis,
            ),
          );
          campos.add(const SizedBox(height: 20));
          campos.add(
            SandiaInputField(
              label: "Valor Numérico",
              controller: valorNumericoController,
              keyboardType: TextInputType.number,
              isRequired: true,
            ),
          );
          break;

        case 8: // Prueba Rápida
          campos.add(
            SandiaCheckbox(
              label: "Presencia",
              value: presenciaValue,
              onChanged: (value) {
                setState(() => presenciaValue = value ?? false);
              },
              color: colorAnalisis,
            ),
          );
          break;
      }
    }
    return Column(children: campos);
  }

  // Override de validación específica para bacteriología
  @override
  bool validarCampos() {
    // Primero validar que haya variante seleccionada
    if (!super.validarCampos()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor seleccione una variante'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    // Si es suelo, no hay más que validar
    if (SistemaDatos().tipoMuestra == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Muestras de suelo no aplican para Bacteoroligia'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    // Validaciones específicas por método
    switch (widget.metodo.idMetodo) {
      case 6: // Convencional - requiere CT y dilución
        if (valorNumericoController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('El campo CT es obligatorio'),
              backgroundColor: Colors.red,
            ),
          );
          return false;
        }
        if (dilucionValue == null || dilucionValue!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Debe seleccionar una dilución'),
              backgroundColor: Colors.red,
            ),
          );
          return false;
        }
        break;

      case 7: // PCR - requiere valor numérico
        if (valorNumericoController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('El campo Valor Numérico es obligatorio'),
              backgroundColor: Colors.red,
            ),
          );
          return false;
        }
        break;

      case 8: // Prueba Rápida - no requiere campos adicionales
        // Solo necesita variante que ya se validó arriba
        break;
    }

    return true;
  }

  // Override del método guardar para manejar mensajes específicos
  @override
  Future<void> guardarResultados() async {
    if (!validarCampos()) {
      // Los mensajes de error ya se muestran en validarCampos
      return;
    }

    setState(() => isLoading = true);

    try {
      // Preparar datos según el método
      Map<String, dynamic> datosGuardar = {
        'codigo_muestra': SistemaDatos.muestra['codigo'],
        'fk_muetsra': widget.metodo.idMetodo,
        'fk_variante_detalle': variantes[varianteSeleccionada!]['id'],
        'presencia': presenciaValue,
        'observacion': observacionesController.text,
        'fecha_resultados': DateTime.now().toIso8601String(),
      };

      // Agregar campos específicos según método
      if (widget.metodo.idMetodo == 6) {
        // Convencional
        datosGuardar['CT'] = double.tryParse(valorNumericoController.text);
        datosGuardar['dilusion'] = double.tryParse(dilucionValue ?? '');
      } else if (widget.metodo.idMetodo == 7) {
        // PCR
        datosGuardar['CT'] = double.tryParse(valorNumericoController.text);
      }

      // TODO: Implementar guardado real en BD
      await Future.delayed(const Duration(seconds: 1));
      print('Datos a guardar: $datosGuardar');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Resultados de bacteriología guardados correctamente'),
          backgroundColor: Colors.green,
        ),
      );

      // Limpiar formulario
      setState(() {
        varianteSeleccionada = null;
        presenciaValue = false;
        valorNumericoController.clear();
        observacionesController.clear();
        dilucionValue = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _buildNoAplicaMessage(String mensaje) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        border: Border.all(color: Colors.orange.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          mensaje,
          style: TextStyle(color: Colors.orange.shade700, fontSize: 16),
        ),
      ),
    );
  }
}
