import 'package:dio/dio.dart';
import '../../domain/entities/brew_advice.dart';

abstract class BrewGPTRemoteDataSource {
  Future<BrewAdvice> getAdvice({
    required String method,
    required String coffeeInfo,
    required Map<String, dynamic> lastRecipe,
    required String problem,
    required String sensoryAnalysis,
  });
}

class BrewGPTRemoteDataSourceImpl implements BrewGPTRemoteDataSource {
  final Dio client;

  BrewGPTRemoteDataSourceImpl({required this.client});

  @override
  Future<BrewAdvice> getAdvice({
    required String method,
    required String coffeeInfo,
    required Map<String, dynamic> lastRecipe,
    required String problem,
    required String sensoryAnalysis,
  }) async {
    // AQUÍ IRÍA LA LLAMADA REAL A OPENAI
    // Por ahora simulamos una respuesta inteligente basada en reglas simples
    // para demostrar la funcionalidad sin API Key.
    
    await Future.delayed(const Duration(seconds: 2)); // Simular red

    // Lógica Mock básica (se reemplazaría con llamada a GPT-4o-mini)
    String advice = "";
    List<String> actions = [];

    if (problem.toLowerCase().contains("ácido") || problem.toLowerCase().contains("agrio")) {
      advice = "Si el café está ácido o agrio, generalmente indica sub-extracción. Necesitamos aumentar el contacto o la superficie.";
      actions = [
        "Afinar la molienda (1-2 clics más fino)",
        "Aumentar la temperatura del agua (+2°C)",
        "Aumentar el ratio (más agua o menos café)"
      ];
    } else if (problem.toLowerCase().contains("amargo") || problem.toLowerCase().contains("seco")) {
      advice = "El amargor excesivo y la astringencia sugieren sobre-extracción. Debemos reducir la extracción.";
      actions = [
        "Engrosar la molienda",
        "Bajar la temperatura del agua (-2°C)",
        "Acortar el tiempo total de extracción"
      ];
    } else {
      advice = "Para ajustar el perfil, enfócate en el equilibrio.";
      actions = ["Verifica la consistencia de tu vertido", "Mantén la temperatura estable"];
    }

    return BrewAdvice(content: advice, actionItems: actions);
  }
}