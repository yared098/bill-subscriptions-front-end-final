import 'package:equatable/equatable.dart';

class OnboardEntity extends Equatable {
  final String title;
  final String description;
  final String imagePath;

  const OnboardEntity({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  List<Object?> get props => [title, description, imagePath];
}