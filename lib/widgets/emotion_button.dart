import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:badges/badges.dart' as badges;

enum Emotion {
  grief(
    emoji: "😢",
    name: "Trauer",
    color: Color.fromARGB(255, 130, 195, 248),
    alignment: Alignment.topLeft,
    id: "grief",
  ),
  joy(
    emoji: "😊",
    name: "Freude",
    color: Color.fromARGB(255, 169, 233, 172),
    alignment: Alignment.topRight,
    id: "joy",
  ),
  calmness(
    emoji: "😌",
    name: "Ruhe",
    color: Color.fromARGB(255, 216, 216, 216),
    alignment: Alignment.center,
    id: "calmness",
  ),
  anger(
    emoji: "😡",
    name: "Wut",
    color: Color.fromARGB(255, 243, 169, 164),
    alignment: Alignment.bottomLeft,
    id: "anger",
  ),
  fear(
    emoji: "😱",
    name: "Angst",
    color: Color.fromARGB(255, 212, 129, 226),
    alignment: Alignment.bottomRight,
    id: "fear",
  );

  final String emoji;
  final String name;
  final Color color;
  final Alignment alignment;
  final String id;

  const Emotion({
    required this.emoji,
    required this.name,
    required this.color,
    required this.alignment,
    required this.id,
  });
}

class EmotionButton extends StatefulWidget {
  final Emotion emotion;
  final VoidCallback onPressed;
  final Duration cooldown;
  final int votes;
  final bool hasMostVotes;

  const EmotionButton({
    super.key,
    required this.emotion,
    required this.onPressed,
    this.cooldown = const Duration(seconds: 30),
    required this.votes,
    required this.hasMostVotes,
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
    Widget result = LayoutBuilder(builder: (context, constraints) {
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

    if (widget.hasMostVotes) {
      result = Stack(
        children: [
          ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Material(
                    color: widget.emotion.color.withOpacity(0.5),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: widget.emotion.color,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ))
              .animate(
                onPlay: (controller) => controller.repeat(),
              )
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(2, 2),
                duration: 250.milliseconds,
                delay: 1.seconds,
              )
              .fadeOut(
                duration: 250.milliseconds,
                delay: 1.seconds,
              ),
          result,
        ],
      );
    }
    result = result
        .animate(target: widget.hasMostVotes ? 1 : 0)
        .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2));
    return badges.Badge(
      position: badges.BadgePosition.topEnd(top: -8, end: -8),
      badgeStyle: badges.BadgeStyle(
        shape: badges.BadgeShape.square,
        badgeColor: widget.emotion.color,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        borderRadius: BorderRadius.circular(8),
        elevation: 3,
      ),
      badgeContent: Text(widget.votes.toString()),
      child: result,
    );
  }
}
