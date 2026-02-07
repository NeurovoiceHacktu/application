import 'package:application/core/constants/colors.dart';
import 'package:application/core/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'caregiver_viewmodel.dart';
import 'caregiver_model.dart';

class CaregiverDashboardView extends StatefulWidget {
  const CaregiverDashboardView({super.key});

  @override
  State<CaregiverDashboardView> createState() => _CaregiverDashboardViewState();
}

class _CaregiverDashboardViewState extends State<CaregiverDashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CaregiverViewModel>(context, listen: false).loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CaregiverViewModel()..loadDashboardData(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primaryVoice,
          title: const Text('Caregiver Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                Provider.of<CaregiverViewModel>(context, listen: false).refresh();
              },
            ),
          ],
        ),
        body: Consumer<CaregiverViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading && viewModel.dashboardData == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.dashboardData == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: AppColors.grey),
                    const SizedBox(height: 16),
                    Text('Failed to load dashboard', style: AppTextStyles.subtitle),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => viewModel.refresh(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final data = viewModel.dashboardData!;

            return RefreshIndicator(
              onRefresh: () => viewModel.loadDashboardData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPatientHeader(data),
                    const SizedBox(height: 20),
                    _buildEmotionalHealthCard(data.emotionalHealth),
                    const SizedBox(height: 16),
                    _buildMedicationCard(data.medication),
                    const SizedBox(height: 16),
                    _buildSpeechStabilityCard(data.speechStability),
                    const SizedBox(height: 16),
                    _buildEmergencyAlertsCard(data.emergencyAlerts),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPatientHeader(CaregiverDashboardModel data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryVoice, AppColors.primaryFace],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.white,
            child: Icon(Icons.person, size: 36, color: AppColors.primaryVoice),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.patientName,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'ID: ${data.patientId}',
                  style: const TextStyle(color: AppColors.whiteText, fontSize: 14),
                ),
              ],
            ),
          ),
          const Icon(Icons.verified_user, color: AppColors.white, size: 32),
        ],
      ),
    );
  }

  Widget _buildEmotionalHealthCard(EmotionalHealth health) {
    return _buildCard(
      title: 'Emotional Health',
      icon: Icons.favorite,
      color: Colors.pink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Mood Score', style: AppTextStyles.subtitleSmall),
                  Text(
                    '${health.moodScore}/100',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _getStressColor(health.stressLevel),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  health.stressLevel,
                  style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Recent Mood Entries', style: AppTextStyles.cardTitle),
          const SizedBox(height: 8),
          ...health.recentEntries.take(3).map((entry) => _buildMoodEntry(entry)).toList(),
        ],
      ),
    );
  }

  Widget _buildMoodEntry(MoodEntry entry) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(entry.date.substring(5), style: AppTextStyles.subtitleSmall),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(entry.mood, style: const TextStyle(fontSize: 12)),
          ),
          const Spacer(),
          Text('${entry.score}', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildMedicationCard(Medication medication) {
    return _buildCard(
      title: 'Medication Reminders',
      icon: Icons.medication,
      color: Colors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryVoice.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.alarm, color: AppColors.primaryVoice, size: 32),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Next Reminder', style: AppTextStyles.subtitleSmall),
                    Text(
                      medication.nextReminder,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Compliance Rate: ', style: AppTextStyles.subtitle),
              Text(
                '${medication.complianceRate}%',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('✓ Taken Today', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          ...medication.todayTaken.map((med) => Padding(
                padding: const EdgeInsets.only(left: 20, top: 4),
                child: Text(med, style: AppTextStyles.subtitle),
              )).toList(),
          const SizedBox(height: 8),
          const Text('○ Pending Today', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
          ...medication.todayPending.map((med) => Padding(
                padding: const EdgeInsets.only(left: 20, top: 4),
                child: Text(med, style: AppTextStyles.subtitle),
              )).toList(),
        ],
      ),
    );
  }

  Widget _buildSpeechStabilityCard(SpeechStability speech) {
    return _buildCard(
      title: 'Daily Speech Stability',
      icon: Icons.record_voice_over,
      color: Colors.purple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Today\'s Score', style: AppTextStyles.subtitleSmall),
                  Text(
                    '${speech.dailyScore}/100',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _getTrendColor(speech.trend),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(_getTrendIcon(speech.trend), color: AppColors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      speech.trend,
                      style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Last 7 Days Trend', style: AppTextStyles.cardTitle),
          const SizedBox(height: 8),
          _buildSimpleChart(speech.last7Days),
        ],
      ),
    );
  }

  Widget _buildSimpleChart(List<int> data) {
    final maxValue = data.reduce((a, b) => a > b ? a : b);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: data.map((value) {
        return Container(
          width: 30,
          height: (value / maxValue) * 80,
          decoration: BoxDecoration(
            color: AppColors.primaryVoice,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmergencyAlertsCard(List<EmergencyAlert> alerts) {
    return _buildCard(
      title: 'Emergency Alerts',
      icon: Icons.warning_amber_rounded,
      color: Colors.red,
      child: alerts.isEmpty
          ? const Text('No active alerts', style: AppTextStyles.subtitle)
          : Column(
              children: alerts.map((alert) => _buildAlertItem(alert)).toList(),
            ),
    );
  }

  Widget _buildAlertItem(EmergencyAlert alert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getSeverityColor(alert.severity).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getSeverityColor(alert.severity)),
      ),
      child: Row(
        children: [
          Icon(_getAlertIcon(alert.type), color: _getSeverityColor(alert.severity)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(alert.type, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(alert.time, style: AppTextStyles.subtitleSmall),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: alert.status == 'Resolved' ? Colors.green : Colors.orange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              alert.status,
              style: const TextStyle(color: AppColors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(blurRadius: 10, color: AppColors.lightBlack)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 12),
              Text(title, style: AppTextStyles.cardTitle),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Color _getStressColor(String level) {
    switch (level) {
      case 'Low':
        return Colors.green;
      case 'Moderate':
        return Colors.orange;
      case 'High':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Color _getTrendColor(String trend) {
    switch (trend) {
      case 'Improving':
        return Colors.green;
      case 'Stable':
        return Colors.blue;
      case 'Declining':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  IconData _getTrendIcon(String trend) {
    switch (trend) {
      case 'Improving':
        return Icons.trending_up;
      case 'Stable':
        return Icons.trending_flat;
      case 'Declining':
        return Icons.trending_down;
      default:
        return Icons.trending_flat;
    }
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'Low':
        return Colors.blue;
      case 'Medium':
        return Colors.orange;
      case 'High':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  IconData _getAlertIcon(String type) {
    if (type.contains('Fall')) return Icons.fall_sharp;
    if (type.contains('Medication')) return Icons.medication;
    return Icons.warning;
  }
}
