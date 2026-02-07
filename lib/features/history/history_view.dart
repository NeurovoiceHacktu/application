import 'dart:convert';
import 'package:application/core/constants/colors.dart';
import 'package:application/core/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  // 🔗 Unified history endpoint
  static const String backendBaseUrl =
      'https://neurovoice-db.onrender.com/api/history';

  // Temporary user id (replace with auth later)
  static const String userId = 'demo-user';

  // ---------------- FETCH HISTORY ----------------
  Future<List<Map<String, dynamic>>> _fetchHistory() async {
    final response = await http.get(Uri.parse('$backendBaseUrl/$userId'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load history');
    }

    final List data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>();
  }

  // ---------------- UI HELPERS ----------------
  Color _riskColor(String level) {
    switch (level) {
      case "High":
        return AppColors.red;
      case "Medium":
        return AppColors.orange;
      default:
        return AppColors.green;
    }
  }

  IconData _riskIcon(String level) {
    switch (level) {
      case "High":
        return Icons.warning;
      case "Medium":
        return Icons.info_outline;
      default:
        return Icons.check_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History", style: AppTextStyles.title),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchHistory(),
        builder: (context, snapshot) {
          // -------- LOADING --------
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // -------- ERROR --------
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Failed to load history",
                style: TextStyle(color: AppColors.red),
              ),
            );
          }

          final results = snapshot.data ?? [];

          // -------- EMPTY --------
          if (results.isEmpty) {
            return const Center(
              child: Text(
                "No history yet",
                style: TextStyle(color: AppColors.gray),
              ),
            );
          }

          // -------- SORT (Newest first) --------
          results.sort(
            (a, b) => DateTime.parse(
              b['createdAt'],
            ).compareTo(DateTime.parse(a['createdAt'])),
          );

          // -------- LIST --------
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: results.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (_, index) {
              final item = results[index];

              final String testType = item['type']; // face | voice | tremor
              final String riskLevel = item['level'];
              final double riskScore = (item['score'] as num).toDouble();

              final DateTime time = DateTime.parse(item['createdAt']).toLocal();

              final Color accent = _riskColor(riskLevel);

              // ✅ SAFE FEATURE EXTRACTION
              final Map<String, dynamic>? features =
                  item['features'] as Map<String, dynamic>?;

              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_riskIcon(riskLevel), color: accent),
                ),
                title: Text(
                  "Risk Level: $riskLevel",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Score: ${riskScore.toStringAsFixed(1)}%"),
                    const SizedBox(height: 4),
                    Text(
                      "Test: ${testType.toUpperCase()}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    // -------- FACE METRICS --------
                    if (testType == 'face') ...[
                      const SizedBox(height: 4),
                      Text(
                        "Blink: ${item['blinkRate'].toStringAsFixed(1)}/min • "
                        "Motion: ${item['motion'].toStringAsFixed(2)} • "
                        "Asym: ${item['asymmetry'].toStringAsFixed(3)}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],

                    // -------- VOICE METRICS --------
                    if (testType == 'voice' && features != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        "Jitter: ${(features['jitter'] as num?)?.toStringAsFixed(3) ?? '--'} • "
                        "Shimmer: ${(features['shimmer'] as num?)?.toStringAsFixed(3) ?? '--'} • "
                        "Pitch: ${(features['pitch'] as num?)?.toStringAsFixed(1) ?? '--'}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],

                    // -------- TREMOR METRICS --------
                    if (testType == 'tremor') ...[
                      const SizedBox(height: 4),
                      Text(
                        "Frequency: ${(item['tremorFrequency'] ?? item['tremor_frequency'] ?? 0).toStringAsFixed(1)} Hz • "
                        "Severity: ${item['severityScore'] ?? item['severity_score'] ?? 0}/100",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ],
                ),
                trailing: Text(
                  "${time.day}/${time.month}/${time.year}\n"
                  "${time.hour}:${time.minute.toString().padLeft(2, '0')}",
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 12),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
