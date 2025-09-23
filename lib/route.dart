import 'package:flutter/material.dart';
import 'resultados_virus.dart';
import 'resultados_nematodos.dart';
import 'resultados_hongos.dart';
import 'resultados_bacteorologia.dart';
import 'sistema_datos.dart';
import 'main.dart'; // Importa la clase Metodo

// Definición de nombres de rutas para evitar errores de escritura
class AppRoutes {
  static const String resultadosVirus = '/resultados-virus';
  static const String resultadosNematodos = '/resultados-nematodos';
  static const String resultadosHongos = '/resultados-hongos';
  static const String resultadosBacteriologia = '/resultados-bacteriologia';
}

// Lógica de generación de rutas
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/': // Esta es tu ruta de inicio
        return MaterialPageRoute(builder: (_) => const MyHomePage());

      case AppRoutes.resultadosVirus:
        if (args is Metodo) {
          return MaterialPageRoute(
            builder: (_) => ResultadosVirus(metodo: args),
          );
        }
        return _errorRoute();

      case AppRoutes.resultadosNematodos:
        if (args is Metodo) {
          return MaterialPageRoute(
            builder: (_) => ResultadosNematodos(metodo: args),
          );
        }
        return _errorRoute();

      case AppRoutes.resultadosHongos:
        if (args is Metodo) {
          return MaterialPageRoute(
            builder: (_) => ResultadosHongos(metodo: args),
          );
        }
        return _errorRoute();

      case AppRoutes.resultadosBacteriologia:
        if (args is Metodo) {
          return MaterialPageRoute(
            builder: (_) => ResultadosBacterias(metodo: args),
          );
        }
        return _errorRoute();

      default:
        // Manejo de error para rutas no definidas
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('ERROR: Página no encontrada')),
        );
      },
    );
  }
}
