import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:variety_coffee_developers/core/theme/app_colors.dart';
import '../../viewmodels/new_session_viewmodel.dart';
import 'package:variety_coffee_developers/features/calibration/domain/entities/calibration_method.dart';
import '../../../../../../core/services/service_locator.dart';
import '../active_session/active_session_page.dart';

class SessionSetupPage extends StatelessWidget {
  final CalibrationMethod method;

  const SessionSetupPage({super.key, required this.method});

  @override
  Widget build(BuildContext context) {
    final isEspresso = method == CalibrationMethod.espresso;
    final accentColor = isEspresso ? AppColors.cardEspresso : AppColors.cardFilter;
    final title = isEspresso ? 'ESPRESSO' : 'FILTER';

    return ChangeNotifierProvider(
      create: (_) => sl<NewSessionViewModel>()..setMethod(method),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: AppColors.background,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: AppColors.textPrimary),
              title: Text(
                "NEW $title SESSION",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: 1.0,
                  fontSize: 16,
                ),
              ),
              centerTitle: true,
            ),
            SliverToBoxAdapter(
              child: _SessionSetupForm(accentColor: accentColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionSetupForm extends StatefulWidget {
  final Color accentColor;
  const _SessionSetupForm({required this.accentColor});

  @override
  State<_SessionSetupForm> createState() => _SessionSetupFormState();
}

class _SessionSetupFormState extends State<_SessionSetupForm> {
  final _formKey = GlobalKey<FormState>();
  final _varietyController = TextEditingController();
  final _daysController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NewSessionViewModel>();

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: widget.accentColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: widget.accentColor, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "EQUIPMENT",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (viewModel.selectedMethod == CalibrationMethod.espresso) ...[
                      _CustomTextField(
                        label: 'Espresso Machine',
                        icon: Icons.coffee_maker,
                        accentColor: widget.accentColor,
                      ),
                    ] else ...[
                      _CustomTextField(
                        label: 'Brew Method (V60, Chemex...)',
                        icon: Icons.filter_alt,
                        accentColor: widget.accentColor,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              duration: const Duration(milliseconds: 600),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "COFFEE INFO",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _CustomTextField(
                      controller: _varietyController,
                      label: 'Variety / Origin',
                      accentColor: widget.accentColor,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Roast Level',
                        labelStyle: TextStyle(color: AppColors.textPrimary.withValues(alpha: 0.6)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.textPrimary.withValues(alpha: 0.2)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.textPrimary.withValues(alpha: 0.2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: widget.accentColor, width: 2),
                        ),
                        filled: true,
                        fillColor: AppColors.background,
                      ),
                      dropdownColor: AppColors.background,
                      items: const [
                        DropdownMenuItem(value: 'Light', child: Text('Light')),
                        DropdownMenuItem(value: 'Medium-Light', child: Text('Medium-Light')),
                        DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                        DropdownMenuItem(value: 'Medium-Dark', child: Text('Medium-Dark')),
                        DropdownMenuItem(value: 'Dark', child: Text('Dark')),
                      ],
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 16),
                    _CustomTextField(
                      controller: _daysController,
                      label: 'Days off roast',
                      accentColor: widget.accentColor,
                      keyboardType: TextInputType.number,
                      suffixText: 'days',
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              duration: const Duration(milliseconds: 600),
              child: SizedBox(
                height: 60,
                child: FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final sessionInfo = {
                        'variety': _varietyController.text,
                        'days': _daysController.text,
                      };
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ActiveSessionPage(
                            method: viewModel.selectedMethod!,
                            sessionInfo: sessionInfo,
                          ),
                        ),
                      );
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: widget.accentColor,
                    foregroundColor: AppColors.textPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'START SESSION',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final TextEditingController? controller;
  final Color accentColor;
  final TextInputType? keyboardType;
  final String? suffixText;

  const _CustomTextField({
    required this.label,
    this.icon,
    this.controller,
    required this.accentColor,
    this.keyboardType,
    this.suffixText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.textPrimary.withValues(alpha: 0.6)),
        prefixIcon: icon != null ? Icon(icon, color: AppColors.textPrimary.withValues(alpha: 0.5)) : null,
        suffixText: suffixText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.textPrimary.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.textPrimary.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentColor, width: 2),
        ),
        filled: true,
        fillColor: AppColors.background,
      ),
    );
  }
}

