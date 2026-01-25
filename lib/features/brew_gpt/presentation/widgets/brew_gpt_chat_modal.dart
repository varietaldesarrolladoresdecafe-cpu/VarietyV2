import 'package:flutter/material.dart';

class BrewGPTChatModal extends StatelessWidget {
  final Map<String, dynamic> sessionInfo;

  const BrewGPTChatModal({super.key, required this.sessionInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Asistente BrewGPT',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          const Expanded(
            child: Center(
              child: Text(
                'Próximamente: Chat inteligente para resolver problemas de extracción.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}