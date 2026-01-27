import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/models/coffee_session_data.dart';
import '../sensory_evaluation/sensory_evaluation_page.dart';

class CoffeeSessionSetupPage extends StatefulWidget {
  const CoffeeSessionSetupPage({super.key});

  @override
  State<CoffeeSessionSetupPage> createState() => _CoffeeSessionSetupPageState();
}

class _CoffeeSessionSetupPageState extends State<CoffeeSessionSetupPage> {
  late TextEditingController _brandController;
  late TextEditingController _varietyController;
  late TextEditingController _originController;
  late TextEditingController _processController;
  late TextEditingController _roastTypeController;
  late TextEditingController _sampleCountController;
  late TextEditingController _extraNotesController;
  
  DateTime _selectedRoastDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _brandController = TextEditingController();
    _varietyController = TextEditingController();
    _originController = TextEditingController();
    _processController = TextEditingController();
    _roastTypeController = TextEditingController();
    _sampleCountController = TextEditingController(text: '1');
    _extraNotesController = TextEditingController();
  }

  @override
  void dispose() {
    _brandController.dispose();
    _varietyController.dispose();
    _originController.dispose();
    _processController.dispose();
    _roastTypeController.dispose();
    _sampleCountController.dispose();
    _extraNotesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedRoastDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedRoastDate) {
      setState(() {
        _selectedRoastDate = picked;
      });
    }
  }

  void _proceedToEvaluation() {
    final sampleCount = int.tryParse(_sampleCountController.text) ?? 1;
    
    if (_brandController.text.isEmpty ||
        _varietyController.text.isEmpty ||
        _originController.text.isEmpty ||
        _processController.text.isEmpty ||
        _roastTypeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos requeridos')),
      );
      return;
    }

    final sessionData = CoffeeSessionData(
      brandName: _brandController.text,
      variety: _varietyController.text,
      origin: _originController.text,
      process: _processController.text,
      roastType: _roastTypeController.text,
      roastDate: _selectedRoastDate,
      restDays: _selectedRoastDate.difference(DateTime.now()).inDays.abs(),
      sampleCount: sampleCount,
      extraNotes: _extraNotesController.text,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SensoryEvaluationPage(sessionData: sessionData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'NUEVA SESIÓN',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: FadeInUp(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand Name
                _buildTextField(
                  controller: _brandController,
                  label: 'Nombre de la Marca',
                  hint: 'Ej: Café Colombiano Premium',
                  icon: Icons.business,
                ),
                const SizedBox(height: 20),

                // Variety
                _buildTextField(
                  controller: _varietyController,
                  label: 'Variedad de Café',
                  hint: 'Ej: Geisha, Bourbon, Typica',
                  icon: Icons.restaurant,
                ),
                const SizedBox(height: 20),

                // Origin
                _buildTextField(
                  controller: _originController,
                  label: 'Origen',
                  hint: 'Ej: Colombia, Etiopía, Perú',
                  icon: Icons.location_on,
                ),
                const SizedBox(height: 20),

                // Process
                _buildTextField(
                  controller: _processController,
                  label: 'Proceso',
                  hint: 'Ej: Lavado, Natural, Honey',
                  icon: Icons.settings,
                ),
                const SizedBox(height: 20),

                // Roast Type
                _buildTextField(
                  controller: _roastTypeController,
                  label: 'Tipo de Tueste',
                  hint: 'Ej: Light, Medium, Dark',
                  icon: Icons.local_fire_department,
                ),
                const SizedBox(height: 20),

                // Roast Date
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.secondary, width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.background,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: AppColors.secondary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fecha de Tostado',
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary.withValues(alpha: 0.6),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('dd/MM/yyyy').format(_selectedRoastDate),
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${_selectedRoastDate.difference(DateTime.now()).inDays.abs()} días',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Sample Count
                _buildTextField(
                  controller: _sampleCountController,
                  label: 'Cantidad de Muestras',
                  hint: '1',
                  icon: Icons.filter_alt,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),

                // Extra Notes
                _buildTextField(
                  controller: _extraNotesController,
                  label: 'Anotaciones Extra',
                  hint: 'Escribe observaciones adicionales sobre el café...',
                  icon: Icons.note,
                  maxLines: 4,
                ),
                const SizedBox(height: 40),

                // Proceed Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _proceedToEvaluation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'PROCEDER A EVALUACIÓN',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary.withValues(alpha: 0.6),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.montserrat(
              fontSize: 14,
              color: AppColors.textPrimary.withValues(alpha: 0.4),
            ),
            prefixIcon: Icon(icon, color: AppColors.secondary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.secondary, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.secondary, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.secondary, width: 2),
            ),
            filled: true,
            fillColor: AppColors.background,
          ),
        ),
      ],
    );
  }
}


