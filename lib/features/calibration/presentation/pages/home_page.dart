import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/logo_widget.dart';
import '../viewmodels/calibration_viewmodel.dart';
import 'new_session/session_setup_page.dart';
import 'history/history_page.dart';
import 'calibration/coffee_session_setup_page.dart';
import '../../domain/entities/calibration_method.dart';
import '../../../../features/brew_gpt/presentation/pages/brew_gpt_chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Cargar datos en background por si acaso
    WidgetsBinding.instance.addPostFrameCallback((_) =>
      context.read<CalibrationViewModel>().loadSessions()
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // Ajustar tamaño de texto según ancho de pantalla para evitar desbordamiento
    final isMobile = MediaQuery.of(context).size.width < 600;
    final heroFontSize = isMobile ? 56.0 : 96.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Sticky Header "VARIETY"
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.background,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "VARIETY",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 4.0,
                color: AppColors.textPrimary,
              ),
            ),
            centerTitle: true,
          ),

          // Hero Section
          SliverToBoxAdapter(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenHeight),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Main Typography
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 80.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FadeInLeft(
                          duration: const Duration(milliseconds: 800),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "VARIETY",
                                style: _heroTextStyle(context, heroFontSize),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(width: 24),
                              LogoWidget(
                                size: 60,
                                circleBorderWidth: 2,
                              ),
                            ],
                          ),
                        ),
                        FadeInRight(
                          duration: const Duration(milliseconds: 800),
                          child: Text(
                            "COFFEE",
                            style: _heroTextStyle(context, heroFontSize),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        FadeInUp(
                          duration: const Duration(milliseconds: 800),
                          child: Text(
                            "DEVELOPERS",
                            style: _heroTextStyle(context, heroFontSize),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FadeInUp(
                          delay: const Duration(milliseconds: 1000),
                          child: Center(
                            child: Text(
                              "SINCE 2022",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                letterSpacing: 2.0,
                                color: AppColors.textPrimary.withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        FadeInUp(
                          delay: const Duration(milliseconds: 1200),
                          child: Text(
                            "Tools for the modern barista.\nCalibrate, taste, and perfect your brew.",
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontFamily: 'Courier New', // Monospace feel like image
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Animated Arrow
                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: FadeInDown(
                        delay: const Duration(milliseconds: 1400),
                        child: Pulse(
                          infinite: true,
                          duration: const Duration(seconds: 2),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.secondary, width: 1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(
                              Icons.arrow_downward,
                              color: AppColors.secondary,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content Section Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
              child: Text(
                "NEW SESSION",
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: -1.0,
                ),
              ),
            ),
          ),

          // Horizontal Scroll Cards
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              clipBehavior: Clip.none,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MenuCard(
                    title: "ESPRESSO",
                    subtitle: "Start a new espresso brew session",
                    color: AppColors.cardEspresso,
                    onTap: () => _navigateToSetup(context, CalibrationMethod.espresso),
                  ),
                  const SizedBox(width: 20),
                  _MenuCard(
                    title: "FILTER", // or FILTERED? sticking to English titles
                    subtitle: "Start a new brew session",
                    color: AppColors.cardFilter,
                    onTap: () => _navigateToSetup(context, CalibrationMethod.filter),
                  ),
                  const SizedBox(width: 20),
                  _MenuCard(
                    title: "HISTORY",
                    subtitle: "Brew history",
                    color: AppColors.cardHistory,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HistoryPage()),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
          ),

          // Tools Section Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
              child: Text(
                "TOOLS",
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: -1.0,
                ),
              ),
            ),
          ),

          // Tools Cards
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              clipBehavior: Clip.none,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MenuCard(
                    title: "SENSORY\nEVALUATION",
                    subtitle: "Start a new sensory evaluation",
                    color: AppColors.cardEspresso,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CoffeeSessionSetupPage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  _MenuCard(
                    title: "COMING\nSOON",
                    subtitle: "New tool coming soon",
                    color: AppColors.cardFilter,
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Esta herramienta estará disponible pronto'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  _MenuCard(
                    title: "EVALUATIONS\nHISTORY",
                    subtitle: "Download detailed sensory reports",
                    color: AppColors.cardHistory,
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Historial de evaluaciones - próximamente'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
          ),
          
          // Footer
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 20),
              child: Center(
                child: Text(
                  "Develop by Varietal Desarrolladores de café",
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showBrewGPT,
        backgroundColor: AppColors.secondary,
        elevation: 6,
        label: const Text(
          'BrewGPT',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        icon: const Icon(
          Icons.smart_toy,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showBrewGPT() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BrewGPTChatPage(),
      ),
    );
  }

  TextStyle _heroTextStyle(BuildContext context, double fontSize) {
    return GoogleFonts.montserrat(
      fontSize: fontSize,
      height: 0.9,
      fontWeight: FontWeight.w900,
      color: AppColors.textPrimary,
    );
  }

  void _navigateToSetup(BuildContext context, CalibrationMethod method) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SessionSetupPage(method: method),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 200,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary.withValues(alpha: 0.9),
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary.withValues(alpha: 0.8),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




