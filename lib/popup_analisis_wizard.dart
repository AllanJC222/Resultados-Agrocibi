import 'package:flutter/material.dart';
import 'sistema_datos.dart';
import 'route.dart';

class AnalisisWizardPopup extends StatefulWidget {
  const AnalisisWizardPopup({super.key});

  @override
  State<AnalisisWizardPopup> createState() => _AnalisisWizardPopupState();
}

class _AnalisisWizardPopupState extends State<AnalisisWizardPopup> 
    with SingleTickerProviderStateMixin {
  
  // ========== ESTADO DEL WIZARD ==========
  int pasoActual = 0; // 0 = scan, 1 = análisis, 2 = método
  bool muestraEscaneada = false;
  bool escaneando = false;
  String codigoMuestra = '';
  
  // Selecciones del usuario
  Analisis? analisisSeleccionado;
  Metodo? metodoSeleccionado;
  
  // Para animaciones suaves
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  // Datos de análisis (lo mismo que tienes en popup_analisi)
  final List<Map<String, dynamic>> _analisisOpciones = SistemaDatos.getAnalisisComoMapa();
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  // ========== LÓGICA DE NAVEGACIÓN ==========
  
  void _avanzarPaso() {
    setState(() {
      if (pasoActual < 2) {
        pasoActual++;
        // Reiniciar animación para el nuevo paso
        _animationController.forward(from: 0);
      }
    });
  }
  
  void _retrocederPaso() {
    setState(() {
      if (pasoActual > 0) {
        pasoActual--;
        _animationController.forward(from: 0);
        
        // Limpiar selección del paso anterior
        if (pasoActual == 0) {
          analisisSeleccionado = null;
        } else if (pasoActual == 1) {
          metodoSeleccionado = null;
        }
      }
    });
  }
  
  // ========== ESCANEO (igual que tu código actual) ==========
  
  Future<void> _escanearMuestra() async {
    setState(() {
      escaneando = true;
    });
    
    try {
      await Future.delayed(const Duration(seconds: 1));
      final muestra = SistemaDatos.muestra;
      
      setState(() {
        muestraEscaneada = true;
        escaneando = false;
        codigoMuestra = muestra['codigo'] ?? 'SIN-CÓDIGO';
        pasoActual = 1; // Avanzar automáticamente al siguiente paso
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("📋 Escaneado: $codigoMuestra"),
          backgroundColor: Colors.green.shade600,
        ),
      );
    } catch (e) {
      setState(() {
        escaneando = false;
      });
    }
  }
  
  // ========== BUILD PRINCIPAL ==========
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            if (pasoActual > 0) _buildProgressIndicator(), // Indicador de progreso
            Flexible(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildContenidoActual(),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // ========== HEADER DINÁMICO ==========
  
  Widget _buildHeader() {
    // Título cambia según el paso
    String titulo = '';
    switch (pasoActual) {
      case 0:
        titulo = 'Escanear Muestra';
        break;
      case 1:
        titulo = '¿Qué análisis realizará?';
        break;
      case 2:
        titulo = 'Seleccione el método';
        break;
    }
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          // Botón atrás (solo si no es el primer paso)
          if (pasoActual > 0)
            GestureDetector(
              onTap: _retrocederPaso,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, size: 20),
              ),
            )
          else
            const SizedBox(width: 36), // Espacio equivalente
            
          Expanded(
            child: Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          
          // Botón cerrar
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 20),
            ),
          ),
        ],
      ),
    );
  }
  
  // ========== INDICADOR DE PROGRESO ==========
  
  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Paso 1: Análisis
          _buildStepDot(1, pasoActual >= 1),
          _buildStepLine(pasoActual >= 2),
          // Paso 2: Método
          _buildStepDot(2, pasoActual >= 2),
        ],
      ),
    );
  }
  
  Widget _buildStepDot(int step, bool isActive) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.green : Colors.grey.shade300,
      ),
      child: Center(
        child: Text(
          '$step',
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  
  Widget _buildStepLine(bool isActive) {
    return Container(
      width: 40,
      height: 2,
      color: isActive ? Colors.green : Colors.grey.shade300,
    );
  }
  
  // ========== CONTENIDO DINÁMICO ==========
  
  Widget _buildContenidoActual() {
    switch (pasoActual) {
      case 0:
        return _buildPasoEscaneo();
      case 1:
        return _buildPasoAnalisis();
      case 2:
        return _buildPasoMetodo();
      default:
        return Container();
    }
  }
  
  // PASO 0: Escaneo
  Widget _buildPasoEscaneo() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.qr_code_scanner,
            size: 100,
            color: Colors.orange.shade600,
          ),
          const SizedBox(height: 24),
          const Text(
            'Escanee la muestra para continuar',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: escaneando ? null : _escanearMuestra,
            icon: escaneando
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.qr_code_scanner),
            label: Text(escaneando ? 'Escaneando...' : 'Escanear'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // PASO 1: Selección de análisis
  Widget _buildPasoAnalisis() {
    return Column(
      children: [
        // Info de muestra escaneada
        if (muestraEscaneada)
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green.shade600),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Muestra: $codigoMuestra',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        
        // Lista de análisis
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _analisisOpciones.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final opcion = _analisisOpciones[index];
              return _buildOpcionAnalisis(opcion);
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildOpcionAnalisis(Map<String, dynamic> opcion) {
    return GestureDetector(
      onTap: () {
        // Verificar lógica especial (la que tenías en popup_analisi)
        int tipoMuestraId = SistemaDatos().tipoMuestra;
        int analisisId = opcion['id'];
        
        // Tu lógica actual de restricciones
        if (tipoMuestraId == 1 && (analisisId == 3 || analisisId == 4) ||
            tipoMuestraId == 4 && analisisId == 3) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          return;
        }
        
        // Seleccionar análisis y avanzar
        setState(() {
          analisisSeleccionado = SistemaDatos.analisis.firstWhere(
            (a) => a.idAnalisis == analisisId,
          );
          _avanzarPaso();
        });
      },
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: opcion['color'],
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(
                  opcion['nombre'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                opcion['icon'],
                color: Colors.white,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // PASO 2: Selección de método
  Widget _buildPasoMetodo() {
    if (analisisSeleccionado == null) return Container();
    
    final metodos = SistemaDatos.getMetodosPorAnalisis(
      analisisSeleccionado!.idAnalisis,
    );
    
    if (metodos.isEmpty) {
      return const Center(
        child: Text('No hay métodos disponibles'),
      );
    }
    
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: metodos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final metodo = metodos[index];
        return _buildOpcionMetodo(metodo);
      },
    );
  }
  
  Widget _buildOpcionMetodo(Metodo metodo) {
    return GestureDetector(
    onTap: () {
      Navigator.pop(context); // Cierra el popup

      String? rutaDestino;
      switch (analisisSeleccionado?.idAnalisis) {
        case 1: // Virus
          rutaDestino = AppRoutes.resultadosVirus;
          break;
        case 2: // Nematodos
          rutaDestino = AppRoutes.resultadosNematodos;
          break;
        case 3: // Hongos
          rutaDestino = AppRoutes.resultadosHongos;
          break;
        case 4: // Bacteriología
          rutaDestino = AppRoutes.resultadosBacteriologia;
          break;
      }

      if (rutaDestino != null) {
        Navigator.pushNamed(
          context,
          rutaDestino,
          arguments: metodo, // Pasa el objeto Metodo como argumento
        );
      }
    },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: analisisSeleccionado!.color,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                metodo.nombre,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}