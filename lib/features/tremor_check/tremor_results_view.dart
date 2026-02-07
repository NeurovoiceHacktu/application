import 'package:application/core/constants/colors.dart';
import 'package:application/core/constants/text_styles.dart';
import 'package:flutter/material.dart';

class TremorResultsView extends StatelessWidget {
  const TremorResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String riskLevel = args['riskLevel'] as String;
    final double confidence = args['confidence'] as double;
    final double tremorFrequency = args['tremorFrequency'] as double;
    final int severityScore = args['severityScore'] as int;
    final List<String> recommendations = args['recommendations'] as List<String>? ?? [];
    final String? modelUsed = args['modelUsed'] as String?;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryTremor,
        title: const Text('Tremor Test Results'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Risk Level Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _getRiskColor(riskLevel).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: _getRiskColor(riskLevel), width: 2),
                ),
                child: Column(
                  children: [
                    Icon(
                      _getRiskIcon(riskLevel),
                      size: 60,
                      color: _getRiskColor(riskLevel),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Risk Level: $riskLevel',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _getRiskColor(riskLevel),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Confidence: ${confidence.toStringAsFixed(1)}%',
                      style: AppTextStyles.subtitle,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Metrics Cards
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      'Tremor Frequency',
                      '${tremorFrequency.toStringAsFixed(1)} Hz',
                      Icons.graphic_eq,
                      AppColors.primaryTremor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      'Severity Score',
                      '$severityScore/100',
                      Icons.speed,
                      AppColors.primaryTremor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Recommendations
              const Text(
                'Recommendations',
                style: AppTextStyles.cardTitle,
              ),
              const SizedBox(height: 12),
              ...recommendations.map((rec) => _buildRecommendationItem(rec)).toList(),

              const SizedBox(height: 24),

              // Model Info Badge
              if (modelUsed != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: modelUsed.contains('Real ML') 
                        ? AppColors.green.withOpacity(0.1)
                        : AppColors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: modelUsed.contains('Real ML') 
                          ? AppColors.green 
                          : AppColors.orange,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        modelUsed.contains('Real ML') 
                            ? Icons.verified 
                            : Icons.info_outline,
                        size: 16,
                        color: modelUsed.contains('Real ML') 
                            ? AppColors.green 
                            : AppColors.orange,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          modelUsed,
                          style: TextStyle(
                            fontSize: 12,
                            color: modelUsed.contains('Real ML') 
                                ? AppColors.green 
                                : AppColors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              if (modelUsed != null) const SizedBox(height: 16),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/doctor_dashboard',
                      (route) => route.isFirst,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTremor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'View Doctor Dashboard',
                    style: TextStyle(fontSize: 16, color: AppColors.white),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: AppColors.primaryTremor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(fontSize: 16, color: AppColors.primaryTremor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(blurRadius: 10, color: AppColors.lightBlack)],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, style: AppTextStyles.subtitleSmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: AppColors.primaryTremor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: AppTextStyles.subtitle),
          ),
        ],
      ),
    );
  }

  Color _getRiskColor(String level) {
    switch (level) {
      case 'High':
        return AppColors.riskHigh;
      case 'Medium':
        return AppColors.riskMedium;
      case 'Low':
        return AppColors.riskLow;
      default:
        return AppColors.riskMedium;
    }
  }

  IconData _getRiskIcon(String level) {
    switch (level) {
      case 'High':
        return Icons.warning_amber_rounded;
      case 'Medium':
        return Icons.info_outline;
      case 'Low':
        return Icons.check_circle_outline;
      default:
        return Icons.info_outline;
    }
  }
}
