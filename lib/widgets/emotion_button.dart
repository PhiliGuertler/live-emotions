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
  final Duration cooldown;

  const EmotionButton({
    super.key,
    required this.emotion,
    required this.onPressed,
    this.cooldown = const Duration(seconds: 5),
  });

  @override
  State<EmotionButton> createState() => _EmotionButtonState();
}

class _EmotionButtonState extends State<EmotionButton>
    with SingleTickerProviderStateMixin {
  bool triggerGrowAnimation = false;

  late AnimationController animationController_;

  @override
  void initState() {
    super.initState();

    animationController_ = AnimationController(
      vsync: this,
      duration: widget.cooldown,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: ColoredBox(
                color: widget.emotion.color.withOpacity(0.5),
                child: const FractionallySizedBox(
                  heightFactor: 1.0,
                  widthFactor: 1.0,
                ),
              )
                  .animate(
                    target: triggerGrowAnimation ? 1 : 0,
                    controller: animationController_,
                  )
                  .moveX(
                    begin: -constraints.maxWidth,
                    end: 0,
                    duration: widget.cooldown,
                  ),
            ),
            Material(
              color: !triggerGrowAnimation
                  ? widget.emotion.color
                  : Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: widget.emotion.color,
                    width: triggerGrowAnimation ? 2 : 0,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: InkWell(
                  onTap: (!triggerGrowAnimation)
                      ? () {
                          setState(() {
                            triggerGrowAnimation = true;
                            animationController_.value = 0;
                          });
                          Future.delayed(widget.cooldown, () {
                            setState(() {
                              triggerGrowAnimation = false;
                            });
                          });
                          widget.onPressed();
                        }
                      : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                              )
                              .scale(
                                end: const Offset(1.3, 1.3),
                                curve: Curves.easeInOut,
                                duration: 150.milliseconds,
                              )
                              .then(
                                  duration:
                                      (widget.cooldown - 150.milliseconds) *
                                          0.5),
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
            ),
          ],
        ),
      );
    });
  }
}
