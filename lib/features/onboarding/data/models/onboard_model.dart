import '../../domain/entities/onboard_entity.dart';

class OnboardModel extends OnboardEntity {
  const OnboardModel({
    required super.title,
    required super.description,
    required super.imagePath,
  });

  // Ready for local localized JSON assets or remote configurations
  factory OnboardModel.fromJson(Map<String, dynamic> json) {
    return OnboardModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imagePath: json['imagePath'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imagePath': imagePath,
    };
  }

  // Hardcoded initial platform onboarding list mapping your localized app mission
  static List<OnboardModel> get defaultEthiopianOnboarding => [
        const OnboardModel(
          title: "OPUTR PLATFORM",
          description: "Your unified solution for managing digital bills and active service renewals across Ethiopia.",
          imagePath: "assets/images/onboarding_billing.png", 
        ),
        const OnboardModel(
          title: "BILLING UPDATES",
          description: "Never miss a payment deadline. Get timely, local reminders for utility, telecom, and merchant bills.",
          imagePath: "assets/images/onboarding_subs.png",
        ),
        const OnboardModel(
          title: "SUBSCRIPTION NOTIFIER",
          description: "Keep track of all your active local and international subscriptions effortlessly in one clear dashboard.",
          imagePath: "assets/images/onboarding_notify.png",
        ),
      ];
}