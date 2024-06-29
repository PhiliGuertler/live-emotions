import 'package:cloud_firestore/cloud_firestore.dart';
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
  const EmotionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DocumentReference emotionCounterRef =
        FirebaseFirestore.instance.collection("emotions").doc("emotions");

    return StreamBuilder<DocumentSnapshot>(
        stream: emotionCounterRef.snapshots(),
        builder: (context, snapshot) {
          return Stack(
            alignment: Alignment.center,
            children: [
              for (final emotion in Emotion.values)
                Builder(builder: (context) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Text("Error: Data not found");
                  }

                  final int votes = snapshot.data![emotion.id] ?? 0;

                  int mostVotes = 0;
                  for (final emotion in Emotion.values) {
                    int emotionVotes = snapshot.data![emotion.id];
                    if (emotionVotes > mostVotes) {
                      mostVotes = emotionVotes;
                    }
                  }

                  final bool hasMostVotes = votes == mostVotes;

                  const Duration cooldown = Duration(seconds: 30);

                  return ButtonContainer(
                    alignment: emotion.alignment,
                    child: EmotionButton(
                      emotion: emotion,
                      onPressed: () async {
                        try {
                          await emotionCounterRef
                              .update({emotion.id: FieldValue.increment(1)});
                        } catch (e) {
                          debugPrint(
                              "Failed to increment counter for emotion $e");
                        }

                        await Future.delayed(cooldown, () {
                          try {
                            emotionCounterRef
                                .update({emotion.id: FieldValue.increment(-1)});
                          } catch (e) {
                            debugPrint(
                                "Failed to decrement counter for emotion $e");
                          }
                        });
                      },
                      votes: votes,
                      hasMostVotes: hasMostVotes,
                      cooldown: cooldown,
                    ),
                  );
                }),
            ],
          );
        });
  }
}
