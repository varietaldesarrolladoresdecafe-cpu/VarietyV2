import 'package:dio/dio.dart';
import '../../domain/entities/brew_advice.dart';
import '../../domain/entities/user_profile.dart';

abstract class BrewGPTRemoteDataSource {
  Future<BrewAdvice> getAdvice({
    required String method,
    required String coffeeInfo,
    required Map<String, dynamic> lastRecipe,
    required String problem,
    required String sensoryAnalysis,
    UserProfile? userProfile,
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
    UserProfile? userProfile,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    String advice = "";
    List<String> actions = [];

    // Normalizar entrada para análisis
    final problemLower = problem.toLowerCase();

    // Personalizar intro según nivel de usuario
    String intro = _getIntroBySkillLevel(userProfile?.skillLevel);

    // === PROBLEMAS DE ACIDEZ ===
    if (_containsAny(problemLower, ['ácido', 'agrio', 'vinagre', 'verde'])) {
      advice =
          "$intro Tu café está pidiendo más tiempo de extracción. Parece que el agua no ha tenido suficiente contacto con el café.";
      actions = _getActionsForAcidity(userProfile?.skillLevel);
    }

    // === PROBLEMAS DE AMARGOR/ASTRINGENCIA ===
    else if (_containsAny(problemLower,
        ['amargo', 'amargado', 'astringente', 'seco', 'áspero'])) {
      advice =
          "$intro Tu café se sobre-extrajo - sacaste demasiado de lo bueno. Es hora de ser más delicado con la extracción.";
      actions = _getActionsForBitterness(userProfile?.skillLevel);
    }

    // === PROBLEMAS DE DEBILIDAD ===
    else if (_containsAny(problemLower,
        ['débil', 'insípido', 'plano', 'aguado', 'sin sabor', 'sin carácter'])) {
      advice =
          "$intro Tu café está tímido... No está sacando todo su potencial. ¡Hora de presionar más!";
      actions = _getActionsForWeakness(userProfile?.skillLevel);
    }

    // === PROBLEMAS DE BALANCE ===
    else if (_containsAny(problemLower,
        ['balance', 'equilibrio', 'complejo', 'redondo', 'limpio'])) {
      advice =
          "$intro Tu café está en un buen camino. Ahora toca pulir esos detalles para que sea una sinfonía completa de sabores.";
      actions =
          _getActionsForBalance(userProfile?.skillLevel, userProfile?.favoriteMethod);
    }

    // === RESPUESTA PERSONALIZADA POR MÉTODO Y UBICACIÓN ===
    if (_containsAny(method, ['v60', 'chemex', 'pour over', 'kalita'])) {
      if (!advice.contains('pourover') && !advice.contains('v60')) {
        advice +=
            "\n\nPara métodos de vertido como el ${userProfile?.favoriteMethod ?? 'V60'}, la consistencia del vertido es clave.";
      }
    } else if (_containsAny(method, ['espresso', 'aeropress', 'moka'])) {
      if (!advice.contains('presión')) {
        advice +=
            "\n\nCon métodos de presión, el tamping y la distribución son críticos. Asegúrate de que sean uniformes.";
      }
    }

    // === PERSONALIZACIÓN POR AGUA ===
    if (userProfile?.waterType == WaterType.tap) {
      advice +=
          "\n💧 Nota: Estás usando agua del grifo. Si es muy dura o blanda, considera un filtro para mejores resultados.";
    } else if (userProfile?.waterType == WaterType.mineral) {
      advice +=
          "\n💧 Nota: El agua mineral puede intensificar ciertos sabores. Monitorea si notas cambios extraños.";
    }

    // === RESPUESTA POR DEFECTO INTELIGENTE ===
    if (advice.isEmpty) {
      advice =
          "$intro Veo que buscas mejorar tu extracción. Aquí van mis tips generales para un café más equilibrado:";
      actions = _getGeneralAdvice(userProfile?.skillLevel);
    }

    return BrewAdvice(content: advice, actionItems: actions);
  }

  String _getIntroBySkillLevel(SkillLevel? level) {
    switch (level) {
      case SkillLevel.beginner:
        return "¡Hola, amig@ del café! ☕";
      case SkillLevel.intermediate:
        return "¡Muy bien, barista en formación! 🎯";
      case SkillLevel.advanced:
        return "¡Veamos qué ajustes micro necesita tu extracción! 🔬";
      default:
        return "¡Hola! ☕";
    }
  }

  List<String> _getActionsForAcidity(SkillLevel? level) {
    final base = [
      "📏 Afina la molienda (1-2 clics más fino)",
      "🌡️ Aumenta la temperatura del agua (+2-3°C)",
      "⏱️ Deja reposar más tiempo en contacto",
      "💧 Aumenta el ratio agua/café ligeramente"
    ];

    if (level == SkillLevel.beginner) {
      return base;
    } else if (level == SkillLevel.intermediate) {
      return [
        ...base,
        "🔬 Monitorea el TDS (sólidos disueltos totales) si tienes refractómetro"
      ];
    } else {
      return [
        "📐 Ajusta la granulometría en pasos de 0.1mm",
        "🌡️ Experimenta con rampas de temperatura",
        "⏱️ Controla el tiempo de contacto por fases",
        "📊 Calcula el porcentaje de extracción objetivo",
      ];
    }
  }

  List<String> _getActionsForBitterness(SkillLevel? level) {
    final base = [
      "📏 Engruesa la molienda (1-2 clics más grueso)",
      "🌡️ Baja la temperatura del agua (-2-3°C)",
      "⏱️ Acorta el tiempo total de extracción",
      "💧 Reduce el ratio de agua"
    ];

    if (level == SkillLevel.beginner) {
      return base;
    } else if (level == SkillLevel.intermediate) {
      return [
        ...base,
        "🔬 Prueba con agua más fría para reducir extracción rápida"
      ];
    } else {
      return [
        "📐 Ajusta en pasos de 0.05mm para sensibilidad máxima",
        "🌡️ Implementa descenso de temperatura gradual",
        "⏱️ Controla cada fase del flujo independientemente",
        "📊 Busca 18-20% de extracción (no más de 22%)",
      ];
    }
  }

  List<String> _getActionsForWeakness(SkillLevel? level) {
    return [
      "📏 Engruesa la molienda para extracción más completa",
      "💧 Aumenta la cantidad de café (lower ratio)",
      "⏱️ Aumenta el tiempo de extracción",
      "🌡️ Considera subir un poco la temperatura"
    ];
  }

  List<String> _getActionsForBalance(SkillLevel? level, String? method) {
    return [
      "🎯 Pequeños ajustes en la molienda (0.5 clics)",
      "🌡️ Mantén la temperatura consistente",
      "⏱️ Controla el flujo para perfeccionar el tiempo",
      "📊 Prueba variaciones mínimas para descubrir tu sweet spot"
    ];
  }

  List<String> _getGeneralAdvice(SkillLevel? level) {
    if (level == SkillLevel.beginner) {
      return [
        "🔬 Empieza con una molienda media",
        "🌡️ Agua entre 90-94°C",
        "⏱️ Experimenta con tiempos de 3-5 minutos",
        "📝 Toma notas de cada cambio pequeño",
        "🎯 Un ajuste a la vez para identificar qué funciona"
      ];
    } else if (level == SkillLevel.intermediate) {
      return [
        "📊 Usa una báscula para medidas precisas",
        "🌡️ Mantén variaciones de temp dentro de ±1°C",
        "⏱️ Registra tiempos de contacto y flujo",
        "🔬 Prueba métodos alternativos para comparar",
        "📈 Busca consistencia en tus extracciones"
      ];
    } else {
      return [
        "📐 Calibra tu molinillo con precisión micrométrica",
        "🌡️ Implementa control de temperatura digital",
        "⏱️ Analiza el flujo en diferentes fases",
        "📊 Calcula extracción con refractómetro",
        "🎯 Optimiza para perfiles específicos por origen"
      ];
    }
  }

  /// Helper para buscar múltiples palabras clave
  bool _containsAny(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword.toLowerCase()));
  }
}
