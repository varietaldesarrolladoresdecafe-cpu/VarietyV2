import 'package:equatable/equatable.dart';

class BrewAdvice extends Equatable {
  final String content;
  final List<String> actionItems;

  const BrewAdvice({
    required this.content,
    required this.actionItems,
  });

  @override
  List<Object?> get props => [content, actionItems];
}