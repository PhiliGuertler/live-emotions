import 'package:flutter/material.dart';

import 'emotion_button.dart';

class ButtonContainer extends StatelessWidget {
  final Widget child;
  final Alignment alignment;

  const ButtonContainer(
      {super.key, required this.child, required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: SizedBox(
        width: 150,
        height: 150,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }
}

class EmotionScreen extends StatelessWidget {
  final Map<Emotion, double> emotionRankings;

  const EmotionScreen({super.key, required this.emotionRankings});

  Color mixColors() {
    Color result = Colors.white;
    emotionRankings.forEach((emotion, value) {
      result = Color.lerp(result, emotion.color, 1 - value)!;
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    Color mixedColor = mixColors();

    return Container(
      color: mixedColor,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ButtonContainer(
            alignment: Alignment.topLeft,
            child: EmotionButton(
              emotion: Emotion.anger,
              onPressed: () {
                debugPrint(Emotion.anger.emoji);
              },
            ),
          ),
          ButtonContainer(
            alignment: Alignment.topRight,
            child: EmotionButton(
              emotion: Emotion.grief,
              onPressed: () {
                debugPrint(Emotion.grief.emoji);
              },
            ),
          ),
          ButtonContainer(
            alignment: Alignment.center,
            child: EmotionButton(
              emotion: Emotion.calmness,
              onPressed: () {
                debugPrint(Emotion.calmness.emoji);
              },
            ),
          ),
          ButtonContainer(
            alignment: Alignment.bottomLeft,
            child: EmotionButton(
              emotion: Emotion.fear,
              onPressed: () {
                debugPrint(Emotion.fear.emoji);
              },
            ),
          ),
          ButtonContainer(
            alignment: Alignment.bottomRight,
            child: EmotionButton(
              emotion: Emotion.joy,
              onPressed: () {
                debugPrint(Emotion.joy.emoji);
              },
            ),
          ),
        ],
      ),
    );
  }
}
