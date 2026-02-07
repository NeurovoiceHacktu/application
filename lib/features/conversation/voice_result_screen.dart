import 'package:flutter/material.dart';

class FakeVoiceResultView extends StatelessWidget {
  const FakeVoiceResultView({super.key});

  @override
  Widget build(BuildContext context) {
    // Deterministic demo values (feel computed, not random)
    const int confidenceScore = 78;
    const double stability = 0.82;
    const double speechRate = 118; // words per minute
    const double pauseRatio = 0.18;
    const String riskLevel = "Low";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Voice Analysis Result"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Confidence Circle (main hero)
            _ConfidenceCircle(score: confidenceScore),

            const SizedBox(height: 30),

            // AI Summary Card
            _SummaryCard(riskLevel: riskLevel),

            const SizedBox(height: 30),

            // Metrics
            _MetricTile(
              label: "Speech Rate",
              value: "${speechRate.toStringAsFixed(0)} words/min",
              subtitle: "Normal conversational range",
            ),
            _MetricTile(
              label: "Voice Stability",
              value: "${(stability * 100).toStringAsFixed(1)}%",
              subtitle: "Low tremor variation detected",
            ),
            _MetricTile(
              label: "Pause Ratio",
              value: "${(pauseRatio * 100).toStringAsFixed(1)}%",
              subtitle: "Consistent speech flow",
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text("Done"),
            ),
          ],
        ),
      ),
    );
  }
}

/* ===================== UI COMPONENTS ===================== */

class _ConfidenceCircle extends StatelessWidget {
  final int score;
  const _ConfidenceCircle({required this.score});

  @override
  Widget build(BuildContext context) {
    final Color color = score >= 70
        ? Colors.green
        : score >= 40
            ? Colors.orange
            : Colors.red;

    return Column(
      children: [
        CircleAvatar(
          radius: 70,
          backgroundColor: color.withOpacity(0.15),
          child: CircleAvatar(
            radius: 55,
            backgroundColor: color,
            child: Text(
              "$score%",
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Voice Confidence Score",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String riskLevel;
  const _SummaryCard({required this.riskLevel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.psychology, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Based on conversational voice patterns, "
              "your overall neurological voice risk is assessed as "
              "$riskLevel.",
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}