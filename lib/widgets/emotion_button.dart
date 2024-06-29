import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum Emotion {
  grief(emoji: "😢", name: "Trauer", color: Color.fromARGB(255, 130, 195, 248)),
  joy(emoji: "😊", name: "Freude", color: Color.fromARGB(255, 169, 233, 172)),
  anger(emoji: "😡", name: "Wut", color: Color.fromARGB(255, 243, 169, 164)),
  calmness(
      emoji: "😌", name: "Ruhe", color: Color.fromARGB(255, 216, 216, 216)),
  fear(emoji: "😱", name: "Angst", color: Color.fromARGB(255, 212, 129, 226));

  final String emoji;
  final String name;
  final Color color;

  const Emotion({required this.emoji, required this.name, required this.color});
}

class EmotionButton extends StatefulWidget {
  final Emotion emotion;
  final VoidCallback onPressed;

  const EmotionButton(
      {super.key, required this.emotion, required this.onPressed});

  @override
  State<EmotionButton> createState() => _EmotionButtonState();
}

class _EmotionButtonState extends State<EmotionButton> {
  bool triggerGrowAnimation = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Material(
        color: widget.emotion.color,
        child: InkWell(
          onTap: !triggerGrowAnimation
              ? () {
                  setState(() {
                    triggerGrowAnimation = true;
                  });
                  widget.onPressed();
                }
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    widget.emotion.emoji,
                    style: Theme.of(context).textTheme.headlineLarge,
                  )
                      .animate(
                        target: triggerGrowAnimation ? 1 : 0,
                        onComplete: (controller) {
                          setState(() {
                            triggerGrowAnimation = false;
                          });
                        },
                      )
                      .scale(
                        end: const Offset(1.3, 1.3),
                        curve: Curves.easeInOut,
                        duration: 150.milliseconds,
                      ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 16.0),
                  child: Text(widget.emotion.name),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
