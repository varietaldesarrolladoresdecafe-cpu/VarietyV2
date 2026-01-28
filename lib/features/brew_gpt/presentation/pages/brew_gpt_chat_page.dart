import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/theme/app_colors.dart';
import '../viewmodels/brew_gpt_viewmodel.dart';
import 'user_profile_setup_page.dart';
import '../../domain/entities/brew_advice.dart';

class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
  });
}

class BrewGPTChatPage extends StatefulWidget {
  final Map<String, dynamic>? recipeToAnalyze;

  const BrewGPTChatPage({super.key, this.recipeToAnalyze});

  @override
  State<BrewGPTChatPage> createState() => _BrewGPTChatPageState();
}

class _BrewGPTChatPageState extends State<BrewGPTChatPage> {
  late TextEditingController _messageController;
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _hasShownRecipeOffer = false;
  BrewAdvice? _lastProcessedAdvice;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    
    // Cargar perfil del usuario
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BrewGPTViewModel>().loadUserProfile();
      _addWelcomeMessage();
      
      // If there's a recipe to analyze, show the offer
      if (widget.recipeToAnalyze != null && !_hasShownRecipeOffer) {
        _showRecipeAnalysisOffer();
        _hasShownRecipeOffer = true;
      }
      
      // Listen to ViewModel changes
      _listenToViewModelChanges();
    });
  }

  void _listenToViewModelChanges() {
    context.read<BrewGPTViewModel>().addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    final viewModel = context.read<BrewGPTViewModel>();
    
    // Add advice message when it becomes available and hasn't been added yet
    if (viewModel.advice != null && _lastProcessedAdvice != viewModel.advice) {
      _lastProcessedAdvice = viewModel.advice;
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              content: viewModel.advice!.content,
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
        });
        _scrollToBottom();
      }
    }
    
    // Add error message if there's an error
    if (viewModel.error != null && mounted && 
        !_messages.any((msg) => msg.content.contains('Error:'))) {
      setState(() {
        _messages.add(
          ChatMessage(
            content: 'Error: ${viewModel.error}',
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });
      _scrollToBottom();
    }
  }

  void _addWelcomeMessage() {
    setState(() {
      _messages.add(
        ChatMessage(
          content: '¡Hola! Soy BrewGPT, tu asistente en café de especialidad. '
              'Cuéntame sobre tu método de extracción, el café que estás preparando, '
              'y si hay algo que no te esté saliendo bien. ¡Juntos mejoraremos tu taza! ☕',
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  void _showRecipeAnalysisOffer() {
    _scrollToBottom();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _showRecipeOfferDialog();
      }
    });
  }

  void _showRecipeOfferDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '🎯 Recipe Detected',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          content: Text(
            'I detected a recipe you just saved. Would you like me to analyze it and suggest calibration adjustments?',
            style: GoogleFonts.montserrat(
              color: AppColors.textPrimary.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Later',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary.withValues(alpha: 0.6),
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                _analyzeRecipe();
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.secondary,
              ),
              child: Text(
                'Analyze Recipe',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _analyzeRecipe() {
    final viewModel = context.read<BrewGPTViewModel>();
    
    setState(() {
      _messages.add(
        ChatMessage(
          content: 'I\'ll analyze your espresso recipe now...',
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
    });

    // The listener will handle adding the response message
    viewModel.analyzeRecipeForCalibration(widget.recipeToAnalyze!);
  }

  @override
  void dispose() {
    try {
      context.read<BrewGPTViewModel>().removeListener(_onViewModelChanged);
    } catch (e) {
      // Handle case where context is not available
    }
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) {
      return;
    }

    final userMessage = _messageController.text;
    
    // Agregar mensaje del usuario al chat
    setState(() {
      _messages.add(
        ChatMessage(
          content: userMessage,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
    });

    _messageController.clear();
    _scrollToBottom();

    // Enviar mensaje a BrewGPT
    final viewModel = context.read<BrewGPTViewModel>();
    viewModel.askBrewGPT(
      method: 'No especificado',
      coffeeInfo: 'No especificado',
      lastRecipe: {},
      problem: userMessage,
      sensoryAnalysis: '',
    );
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildTypingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              shape: BoxShape.circle,
            ),
          ),
        ),
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
        title: Column(
          children: [
            Text(
              'BREW GPT ☕',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontSize: 14,
                letterSpacing: 2.0,
              ),
            ),
            Text(
              'Tu asistente en café de especialidad',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary.withValues(alpha: 0.7),
                fontSize: 9,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Consumer<BrewGPTViewModel>(
            builder: (context, viewModel, _) {
              return IconButton(
                icon: const Icon(Icons.person, color: AppColors.textPrimary),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserProfileSetupPage(isEditing: true),
                    ),
                  ).then((_) {
                    viewModel.loadUserProfile();
                  });
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages area
          Expanded(
            child: Consumer<BrewGPTViewModel>(
              builder: (context, viewModel, _) {
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemCount: _messages.length + (viewModel.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Si es el índice del indicador de carga
                    if (index == _messages.length && viewModel.isLoading) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withValues(alpha: 0.15),
                                  border: Border.all(
                                    color: AppColors.secondary.withValues(alpha: 0.3),
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(4),
                                    topRight: const Radius.circular(18),
                                    bottomLeft: const Radius.circular(18),
                                    bottomRight: const Radius.circular(18),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildTypingIndicator(),
                                    const SizedBox(width: 8),
                                    Text(
                                      'BrewGPT está escribiendo...',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        color: AppColors.textPrimary.withValues(alpha: 0.6),
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    final message = _messages[index];
                    return _buildChatBubble(message, viewModel);
                  },
                );
              },
            ),
          ),
          // Removed the separate loading indicator below
          // Message input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border(
                top: BorderSide(
                  color: AppColors.textPrimary.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Cuéntame sobre tu café...',
                      hintStyle: GoogleFonts.montserrat(
                        fontSize: 13,
                        color: AppColors.textPrimary.withValues(alpha: 0.3),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                          color: AppColors.secondary,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: AppColors.secondary.withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                          color: AppColors.secondary,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 12),
                Consumer<BrewGPTViewModel>(
                  builder: (context, viewModel, _) {
                    return GestureDetector(
                      onTap: viewModel.isLoading ? null : _sendMessage,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: viewModel.isLoading 
                              ? AppColors.secondary.withValues(alpha: 0.5)
                              : AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message, BrewGPTViewModel viewModel) {
    final isUser = message.isUser;
    
    if (isUser) {
      // User message
      return FadeInRight(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: const Radius.circular(18),
                      bottomRight: const Radius.circular(4),
                    ),
                  ),
                  child: Text(
                    message.content,
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // BrewGPT message
      return FadeInLeft(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.15),
                    border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(4),
                      topRight: const Radius.circular(18),
                      bottomLeft: const Radius.circular(18),
                      bottomRight: const Radius.circular(18),
                    ),
                  ),
                  child: Text(
                    message.content,
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}


