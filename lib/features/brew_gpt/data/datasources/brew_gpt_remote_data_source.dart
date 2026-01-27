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

/// BrewGPT: Asistente experto en preparación de café
/// Guía a usuarios principiantes e intermedios con claridad y praticidad
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
    // Simular latencia de respuesta
    await Future.delayed(const Duration(milliseconds: 1500));

    String advice = "";
    List<String> actions = [];

    // Normalizar entrada
    final problemLower = problem.toLowerCase().trim();
    final methodLower = method.toLowerCase().trim();

    // Saludos personalizados según nivel
    final intro = _getIntroBySkillLevel(userProfile?.skillLevel);

    // === DIAGNÓSTICO DE PROBLEMAS ===

    // 1. PROBLEMAS DE ACIDEZ/VERDE (Sub-extracción)
    if (_containsAny(problemLower,
        ['ácido', 'acido', 'agrio', 'vinagre', 'verde', 'sharpness'])) {
      advice = "$intro Tu café está pidiendo **más tiempo de contacto**. "
          "El agua no ha extraído suficientemente los sólidos solubles. "
          "Esto da sabores verdes y acídicos.\n\n"
          "**¿Qué pasó?** Molienda muy gruesa, temperatura muy baja, "
          "o el flujo fue demasiado rápido.";
      actions = _getActionsForAcidity(userProfile?.skillLevel, methodLower);
    }

    // 2. PROBLEMAS DE AMARGOR/ASTRINGENCIA (Sobre-extracción)
    else if (_containsAny(problemLower,
        ['amargo', 'amargado', 'astringente', 'seco', 'áspero', 'burnt', 'quemado'])) {
      advice = "$intro Tu café se **sobre-extrajo** - sacaste demasiado "
          "de lo bueno y ahora tiene ese toque amargo y duro. "
          "El agua estuvo demasiado tiempo en contacto con el café.\n\n"
          "**¿Qué pasó?** Molienda muy fina, temperatura muy alta, "
          "o el flujo fue demasiado lento.";
      actions = _getActionsForBitterness(userProfile?.skillLevel, methodLower);
    }

    // 3. PROBLEMAS DE DEBILIDAD (Sub-extracción por cantidad)
    else if (_containsAny(problemLower,
        ['débil', 'debil', 'insípido', 'insipido', 'plano', 'aguado', 'sin sabor', 'sin carácter', 'watery'])) {
      advice = "$intro Tu café está **tímido** - no está sacando todo su potencial. "
          "Faltan sólidos disueltos en la taza (bajo TDS). "
          "Probablemente usaste muy poco café o el agua pasó muy rápido.\n\n"
          "**¿Qué pasó?** Bajo ratio agua/café, molienda muy gruesa, "
          "o tiempo de contacto muy corto.";
      actions = _getActionsForWeakness(userProfile?.skillLevel, methodLower);
    }

    // 4. BALANCE Y COMPLEJIDAD
    else if (_containsAny(problemLower,
        ['balance', 'equilibrio', 'complejo', 'redondo', 'limpio', 'balanced', 'complexity'])) {
      advice = "$intro Tu café está en **buen camino**. Ahora toca pulir "
          "esos detalles para que sea una sinfonía de sabores. "
          "Busca pequeños ajustes para descubrir notas nuevas.\n\n"
          "**Siguiente nivel:** Micro-ajustes en molienda y temperatura.";
      actions = _getActionsForBalance(userProfile?.skillLevel, userProfile?.favoriteMethod);
    }

    // 5. PROBLEMAS DE MÉTODO ESPECÍFICO
    else if (_containsAny(methodLower, ['v60', 'chemex', 'kalita']) ||
        _containsAny(userProfile?.favoriteMethod ?? '', ['v60', 'chemex', 'kalita'])) {
      advice = "$intro Con métodos de **vertido** como ${userProfile?.favoriteMethod ?? 'el tuyo'}, "
          "la consistencia del movimiento es crucial. "
          "Cada gota cuenta en el flujo final.\n\n"
          "**Lo básico:** Temperatura 90-95°C, molienda media, "
          "vertido lento y controlado.";
      actions = _getActionsForPourOver(userProfile?.skillLevel);
    }

    else if (_containsAny(methodLower, ['prensa francesa', 'french press', 'immersion']) ||
        _containsAny(userProfile?.favoriteMethod ?? '', ['prensa', 'french press'])) {
      advice = "$intro Con **prensa francesa**, todo depende del contacto prolongado. "
          "Los sabores se desarrollan lentamente, así que paciencia es clave.\n\n"
          "**Lo básico:** Agua entre 90-94°C, molienda gruesa, "
          "reposo de 4 minutos completos.";
      actions = _getActionsForFrenchPress(userProfile?.skillLevel);
    }

    else if (_containsAny(methodLower, ['espresso', 'aeropress', 'moka']) ||
        _containsAny(userProfile?.favoriteMethod ?? '', ['espresso', 'aeropress', 'moka'])) {
      advice = "$intro Con métodos de **presión**, el tamping y la distribución "
          "son críticos. Uniformidad = taza consistente.\n\n"
          "**Lo básico:** Presión firme, distribuidor uniforme, "
          "temperatura precisa (88-92°C para AeroPress).";
      actions = _getActionsForPressure(userProfile?.skillLevel);
    }

    // === ADAPTACIÓN POR TIPO DE AGUA ===
    if (userProfile?.waterType != null) {
      advice += _getWaterAdaptation(userProfile!.waterType, problemLower);
    }

    // === RESPUESTA POR DEFECTO INTELIGENTE ===
    if (advice.isEmpty) {
      advice = "$intro Veo que quieres mejorar tu café. "
          "Aquí van **tips generales** para un extracto más equilibrado:\n\n"
          "📊 **Medidas clave:** 1:16 ratio (ej: 20g café → 320ml agua)";
      actions = _getGeneralAdvice(userProfile?.skillLevel);
    }

    return BrewAdvice(content: advice, actionItems: actions);
  }

  /// Introducción personalizada por nivel de experiencia
  String _getIntroBySkillLevel(SkillLevel? level) {
    switch (level) {
      case SkillLevel.beginner:
        return "¡Hola, amig@ del café! ☕";
      case SkillLevel.intermediate:
        return "¡Muy bien, barista en formación! 🎯";
      case SkillLevel.advanced:
        return "¡Veamos qué ajustes micro necesita tu extracción! 🔬";
      default:
        return "¡Hola! ☕ Aquí va mi diagnóstico:";
    }
  }

  /// Acciones para acidez (sub-extracción)
  List<String> _getActionsForAcidity(SkillLevel? level, String method) {
    final base = [
      "📏 Afina la molienda: 1-2 clics **más fino**",
      "🌡️ Aumenta temperatura: +2-3°C (intenta 92-95°C)",
      "⏱️ Aumenta tiempo de contacto: +30-60 segundos",
      "💧 Aumenta ratio: Prueba 1:15 en lugar de 1:16"
    ];

    if (level == SkillLevel.beginner) {
      return [
        ...base,
        "📝 Nota el cambio: ¿Desapareció lo ácido? ¡Perfecto!"
      ];
    } else if (level == SkillLevel.intermediate) {
      return [
        ...base,
        "🔬 Si tienes refractómetro: Busca TDS 18-20%",
        "🌡️ Prueba rampas de temperatura (aumenta gradualmente)"
      ];
    } else {
      return [
        "📐 Ajusta granulometría en pasos de 0.1mm",
        "🌡️ Implementa rampa controlada de +2°C cada 30 segundos",
        "⏱️ Alarga el pre-infusionado 10-15 segundos más",
        "📊 Calcula % extracción: Busca llegar a 18-20%",
        "🔬 Usa refractómetro para validar cambios"
      ];
    }
  }

  /// Acciones para amargor (sobre-extracción)
  List<String> _getActionsForBitterness(SkillLevel? level, String method) {
    final base = [
      "📏 Engruesa la molienda: 1-2 clics **más grueso**",
      "🌡️ Baja temperatura: -2-3°C (intenta 88-92°C)",
      "⏱️ Reduce tiempo de contacto: -30-60 segundos",
      "💧 Reduce ratio: Prueba 1:17 en lugar de 1:16"
    ];

    if (level == SkillLevel.beginner) {
      return [
        ...base,
        "📝 Nota: ¿Menos seco y astringente? ¡Lo lograste!"
      ];
    } else if (level == SkillLevel.intermediate) {
      return [
        ...base,
        "🔬 Si tienes refractómetro: Busca TDS 16-18%",
        "⚡ Verifica que el flujo sea rápido (no lento)"
      ];
    } else {
      return [
        "📐 Afina granulometría en pasos de 0.05mm",
        "🌡️ Baja temperatura de forma controlada",
        "⏱️ Acorta pre-infusionado o flujo total",
        "📊 Busca % extracción máximo 20-22%",
        "💧 Experimenta con ratios 1:17 a 1:18"
      ];
    }
  }

  /// Acciones para café débil
  List<String> _getActionsForWeakness(SkillLevel? level, String method) {
    return [
      "📏 Engruesa la molienda para contacto más lento",
      "💧 **Aumenta la cantidad de café:** Ratio 1:15 o 1:14",
      "⏱️ Aumenta tiempo de contacto: +1-2 minutos",
      "🌡️ Considera subir temperatura (+1-2°C)",
      "🔬 Objetivo: Taza con más cuerpo y presencia"
    ];
  }

  /// Acciones para balance y complejidad
  List<String> _getActionsForBalance(SkillLevel? level, String? method) {
    return [
      "🎯 Micro-ajustes en molienda: 0.5 clics a la vez",
      "🌡️ Mantén temperatura **consistente** (±0.5°C)",
      "⏱️ Controla flujo con precisión",
      "📊 Prueba variaciones mínimas para descubrir sweet spot",
      "📝 Documenta: qué cambió y qué mejoró"
    ];
  }

  /// Acciones para métodos de vertido (V60, Chemex, Kalita)
  List<String> _getActionsForPourOver(SkillLevel? level) {
    return [
      "💨 **Consistencia de vertido:** Movimientos suaves y controlados",
      "💧 Agua 90-95°C (más caliente que prensa francesa)",
      "📏 Molienda media (como azúcar de caña)",
      "⏱️ Tiempo total: 2:30-3:30 minutos",
      "🌪️ Mantén el lecho de café mojado sin atascos"
    ];
  }

  /// Acciones para prensa francesa
  List<String> _getActionsForFrenchPress(SkillLevel? level) {
    return [
      "🌡️ Agua 90-94°C (no hirviendo)",
      "📏 Molienda **gruesa** (como sal marina)",
      "⏱️ Reposo exacto: 4 minutos",
      "🔄 Revuelve suavemente después de 1 minuto",
      "💧 Prensa lenta y controlada (10-15 segundos)"
    ];
  }

  /// Acciones para métodos de presión (Espresso, AeroPress, Moka)
  List<String> _getActionsForPressure(SkillLevel? level) {
    return [
      "🔨 **Tamping:** Firme, uniforme y nivelado",
      "📏 Molienda fina (pero no polvo)",
      "🌡️ AeroPress: 88-92°C | Moka: agua caliente, no fría",
      "⏱️ AeroPress: 1:30-2:00 | Moka: hasta primer borboteo",
      "🎯 Presión consistente = extracción uniforme"
    ];
  }

  /// Adaptaciones según tipo de agua
  String _getWaterAdaptation(WaterType waterType, String problem) {
    switch (waterType) {
      case WaterType.tap:
        return "\n\n💧 **Tu agua (Grifo):** Puede variar en dureza. "
            "Si notas cambios inconsistentes, considera un **filtro básico**. "
            "Agua dura → baja temperatura un poco. "
            "Agua blanda → sube temperatura.";

      case WaterType.filtered:
        return "\n\n💧 **Tu agua (Filtrada):** Buena opción. Consistente y neutra. "
            "Ideal para experimentar sin variables de agua.";

      case WaterType.distilled:
        return "\n\n💧 **Tu agua (Destilada):** Muy blanda. "
            "**Intenta subir temperatura 2-3°C** y aumentar ratio ligeramente. "
            "Sin minerales = extracción más rápida.";

      case WaterType.bottled:
        return "\n\n💧 **Tu agua (Embotellada):** Depende de la marca. "
            "Si es muy mineral (dura), **baja temperatura 1-2°C**. "
            "Si es muy blanda, sube un poco.";

      case WaterType.mineral:
        return "\n\n💧 **Tu agua (Mineral):** Alta en minerales. "
            "Esto intensifica sabores. Si notas **amargor extra**, "
            "baja temperatura 2°C o reduce ratio.";
    }
  }

  /// Consejo general para nivel de usuario
  List<String> _getGeneralAdvice(SkillLevel? level) {
    if (level == SkillLevel.beginner) {
      return [
        "🔬 Empieza con molienda **media**",
        "🌡️ Agua 90-94°C (no hirviendo, espera 30 seg después)",
        "📏 Ratio **1:16** (20g café → 320ml agua)",
        "⏱️ Tiempo total: 3-4 minutos según método",
        "📝 **Toma notas** de cada cambio - eso es tu aprendizaje",
        "🎯 Un ajuste a la vez: cambia molienda O temperatura, no ambos"
      ];
    } else if (level == SkillLevel.intermediate) {
      return [
        "📊 Usa **báscula de precisión** (0.1g)",
        "🌡️ Termómetro: Varía ±1°C máximo",
        "📏 Experimenta ratios 1:14 a 1:18",
        "⏱️ Registra tiempos de **pre-infusionado, bloom y flujo total**",
        "🔬 Prueba métodos alternativos para comparar",
        "📈 Objetivo: **3-4 extracciones iguales** en fila"
      ];
    } else {
      return [
        "📐 Calibra molinillo: Usa **precisión micrométrica**",
        "🌡️ Control digital: Mantén 89.5°C ±0.5°C",
        "⏱️ Analiza **cada fase:** Pre-infusionado, bloom, cuerpo, decaimiento",
        "📊 Refractómetro: Calcula % extracción preciso",
        "🎯 Optimiza **por origen:** Africanos vs Sudamericanos",
        "🔬 Experimenta con **perfiles de temperatura** y presión"
      ];
    }
  }

  /// Helper: Buscar múltiples palabras clave
  bool _containsAny(String text, List<String> keywords) {
    final lowerText = text.toLowerCase();
    return keywords.any((keyword) => lowerText.contains(keyword.toLowerCase()));
  }
}

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
