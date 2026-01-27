import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:variety_coffee_developers/features/calibration/presentation/viewmodels/active_session_viewmodel.dart';
import 'package:variety_coffee_developers/features/calibration/domain/entities/calibration_method.dart';
import 'package:variety_coffee_developers/features/brew_gpt/presentation/widgets/brew_gpt_chat_modal.dart';

class ActiveSessionPage extends StatelessWidget {
  final CalibrationMethod method;
  final Map<String, dynamic> sessionInfo; // Datos del setup anterior

  const ActiveSessionPage({
    super.key,
    required this.method,
    required this.sessionInfo,
  });

  void _saveSession(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sesión guardada correctamente'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ActiveSessionViewModel(method: method),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Calibrando...'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () => _saveSession(context),
            )
          ],
        ),
        body: const _RecipeForm(),
        floatingActionButton: _BrewGPTButton(sessionInfo: sessionInfo),
      ),
    );
  }
}

class _RecipeForm extends StatelessWidget {
  const _RecipeForm();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ActiveSessionViewModel>();
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Historial de recetas previas (mini cards)
        if (viewModel.recipes.isNotEmpty) ...[
          Text('Iteraciones previas: ${viewModel.recipes.length}', 
            style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: viewModel.recipes.length,
              itemBuilder: (context, index) {
                final recipe = viewModel.recipes[index];
                return Card(
                  child: Container(
                    width: 120,
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Receta #${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Dosis: ${recipe['dose']}g'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 32),
        ],

        Text('Nueva Receta', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        
        // Campos de Receta
        Row(
          children: [
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Dosis (g)', border: OutlineInputBorder()),
                onChanged: (val) => viewModel.updateField('dose', double.tryParse(val)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Rendimiento (g/ml)', border: OutlineInputBorder()),
                onChanged: (val) => viewModel.updateField('yield', double.tryParse(val)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          decoration: const InputDecoration(labelText: 'Molienda (Clicks/Ajuste)', border: OutlineInputBorder()),
          onChanged: (val) => viewModel.updateField('grind', val),
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Tiempo Total (s)', border: OutlineInputBorder()),
          onChanged: (val) => viewModel.updateField('time', val),
        ),
        const SizedBox(height: 16),

        const Text('Análisis Sensorial', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Notas de cata',
            hintText: 'Ácido, Amargo, Dulce, Cuerpo...',
            border: OutlineInputBorder()
          ),
          onChanged: (val) => viewModel.updateField('sensory', val),
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Problema Principal',
            hintText: 'Ej: Muy ácido, final seco...',
            border: OutlineInputBorder()
          ),
          onChanged: (val) => viewModel.updateField('problem', val),
        ),

        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => viewModel.saveRecipe(),
          child: const Text('Registrar Iteración'),
        ),
        const SizedBox(height: 80), // Espacio para FAB
      ],
    );
  }
}

class _BrewGPTButton extends StatelessWidget {
  final Map<String, dynamic> sessionInfo;
  
  const _BrewGPTButton({required this.sessionInfo});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        // Mostrar Modal de BrewGPT
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => BrewGPTChatModal(sessionInfo: sessionInfo),
        );
      },
      backgroundColor: Colors.teal,
      icon: const Icon(Icons.smart_toy, color: Colors.white),
      label: const Text('Preguntar a BrewGPT', style: TextStyle(color: Colors.white)),
    );
  }
}