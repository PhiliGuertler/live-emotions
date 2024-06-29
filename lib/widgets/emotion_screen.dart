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
  final Map<Emotion, int> emotionVotes;

  const EmotionScreen({super.key, required this.emotionVotes});

  @override
  Widget build(BuildContext context) {
    int maxVotes = emotionVotes.values
        .fold(0, (max, current) => max > current ? max : current);

    return Stack(
      alignment: Alignment.center,
      children: [
        for (final emotion in Emotion.values)
          ButtonContainer(
            alignment: emotion.alignment,
            child: EmotionButton(
              emotion: emotion,
              onPressed: () {
                debugPrint(emotion.emoji);
              },
              votes: emotionVotes.containsKey(emotion)
                  ? emotionVotes[emotion]!
                  : 0,
              hasMostVotes: maxVotes ==
                  (emotionVotes.containsKey(emotion)
                      ? emotionVotes[emotion]!
                      : 0),
            ),
          ),
      ],
    );
  }
}
