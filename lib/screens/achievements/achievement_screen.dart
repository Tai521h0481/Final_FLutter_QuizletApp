import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shop_app/components/achivement_card.dart';
import 'package:shop_app/models/Achievement.dart';
import 'package:shop_app/screens/achievements/components/achievement.dart';


class AchievementScreen extends StatelessWidget {
  static String routeName = "/achievement";
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LineAwesomeIcons.angle_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Text(
            "Achievements",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                itemCount: demoProducts.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 0.7,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 16,
                ),
                itemBuilder: (context, index) => AchievementCard(
                  achievement: demoProducts[index],
                  onPress: () => Navigator.pushNamed(
                    context,
                    AchievementComponent.routeName,
                    arguments:
                        AchievementDetailsArguments(achievement: demoProducts[index]),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
