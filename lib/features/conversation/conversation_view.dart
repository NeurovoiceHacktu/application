import 'package:application/features/conversation/conversation_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConversationDemoView extends StatefulWidget {
  const ConversationDemoView({super.key});

  @override
  State<ConversationDemoView> createState() => _ConversationDemoViewState();
}

class _ConversationDemoViewState extends State<ConversationDemoView> {
  bool _started = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ConversationDemoViewModel(),
      child: Consumer<ConversationDemoViewModel>(
        builder: (context, vm, _) {
          if (!_started && vm.state == ConversationState.idle) {
            _started = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              vm.start();
            });
          }

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text("Voice Conversation Check"),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  await vm.finish();
                  if (mounted) Navigator.pop(context);
                },
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  /// Progress
                  // ProgressBar(step: vm.step),

                  // const SizedBox(height: 24),

                  /// Instruction card
                  InstructionCard(text: vm.currentText),

                  const SizedBox(height: 40),

                  /// Voice waves
                  const WaveBars(),

                  const SizedBox(height: 24),

                  /// Status chip
                  StatusChip(status: _mapStatus(vm.state)),

                  const Spacer(),

                  if (vm.state == ConversationState.listening)
                    ElevatedButton(
                      onPressed: vm.next,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text("Continue"),
                    ),

                  if (vm.state == ConversationState.finished)
                    const Text(
                      "Conversation complete",
                      style: TextStyle(fontSize: 16),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  ConversationDemoStatus _mapStatus(ConversationState state) {
    switch (state) {
      case ConversationState.speaking:
        return ConversationDemoStatus.speaking;
      case ConversationState.listening:
        return ConversationDemoStatus.listening;
      case ConversationState.finished:
        return ConversationDemoStatus.finished;
      default:
        return ConversationDemoStatus.idle;
    }
  }
}

/* ===================== ENUM ===================== */

enum ConversationDemoStatus {
  idle,
  speaking,
  listening,
  finished,
}

/* ===================== PROGRESS BAR ===================== */

class ProgressBar extends StatelessWidget {
  final int step; // 0–4
  const ProgressBar({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          height: 6,
          width: index == step ? 32 : 8,
          decoration: BoxDecoration(
            color: index <= step
                ? Colors.blue
                : Colors.blue.withOpacity(0.25),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

/* ===================== INSTRUCTION CARD ===================== */

class InstructionCard extends StatelessWidget {
  final String text;
  const InstructionCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "AI ASSISTANT",
            style: TextStyle(
              letterSpacing: 2,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            text.isEmpty ? "Preparing conversation…" : text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/* ===================== WAVE BARS ===================== */

class WaveBars extends StatelessWidget {
  const WaveBars({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          7,
          (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 10,
            height: 40 + (index % 2) * 30,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.7),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ),
    );
  }
}

/* ===================== STATUS CHIP ===================== */

class StatusChip extends StatelessWidget {
  final ConversationDemoStatus status;
  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    late IconData icon;
    late String label;
    late Color color;

    switch (status) {
      case ConversationDemoStatus.speaking:
        icon = Icons.volume_up;
        label = "Assistant speaking";
        color = Colors.blue;
        break;

      case ConversationDemoStatus.listening:
        icon = Icons.mic;
        label = "Listening to you";
        color = Colors.green;
        break;

      case ConversationDemoStatus.finished:
        icon = Icons.check_circle;
        label = "Completed";
        color = Colors.green;
        break;

      default:
        icon = Icons.hourglass_top;
        label = "Starting";
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}