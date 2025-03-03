import 'package:azure_chat_bot/features/home/presentation/widgets/home_feature_item.dart';
import 'package:flutter/material.dart';

class HomeFeaturesView extends StatelessWidget {
  const HomeFeaturesView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              HomeFeatureItem(
                icon: Icons.smart_toy_outlined,
                title: 'AI-Powered Conversations',
                description: 'Chat naturally with our advanced AI assistant',
              ),
              SizedBox(height: 16),
              HomeFeatureItem(
                icon: Icons.bolt_outlined,
                title: 'Fast Responses',
                description: 'Get quick and accurate answers to your questions',
              ),
              SizedBox(height: 16),
              HomeFeatureItem(
                icon: Icons.security_outlined,
                title: 'Secure & Private',
                description: 'Your conversations are protected and private',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
