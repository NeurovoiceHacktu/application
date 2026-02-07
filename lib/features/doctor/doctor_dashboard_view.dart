import 'package:application/core/constants/colors.dart';
import 'package:application/core/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'doctor_viewmodel.dart';
import 'doctor_model.dart';

class DoctorDashboardView extends StatefulWidget {
  const DoctorDashboardView({super.key});

  @override
  State<DoctorDashboardView> createState() => _DoctorDashboardViewState();
}

class _DoctorDashboardViewState extends State<DoctorDashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DoctorViewModel>(context, listen: false).loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DoctorViewModel()..loadDashboardData(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primaryTremor,
          title: const Text('Doctor Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                Provider.of<DoctorViewModel>(context, listen: false).refresh();
              },
            ),
          ],
        ),
        body: Consumer<DoctorViewModel>(
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
                    _buildRiskSeverityCard(data.riskSeverity),
                    const SizedBox(height: 16),
                    _buildTremorLevelsCard(data.riskSeverity.tremorLevels),
                    const SizedBox(height: 16),
                    _buildAISummaryCard(data.aiClinicalSummary),
                    const SizedBox(height: 16),
                    _buildDiseaseProgressionCard(data.diseaseProgression),
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

  Widget _buildPatientHeader(DoctorDashboardModel data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryTremor, Color(0xFF6A4C93)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.white,
            child: Icon(Icons.person, size: 36, color: AppColors.primaryTremor),
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
                  'Age: ${data.age} • ID: ${data.patientId}',
                  style: const TextStyle(color: AppColors.whiteText, fontSize: 14),
                ),
              ],
            ),
          ),
          const Icon(Icons.medical_services, color: AppColors.white, size: 32),
        ],
      ),
    );
  }

  Widget _buildRiskSeverityCard(RiskSeverity risk) {
    final color = _getRiskLevelColor(risk.currentLevel);
    
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
              Icon(Icons.assessment, color: color, size: 28),
              const SizedBox(width: 12),
              const Text('Risk Severity Index', style: AppTextStyles.cardTitle),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 8),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${risk.score}',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        Text(
                          'out of 100',
                          style: AppTextStyles.subtitleSmall,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color, width: 2),
                  ),
                  child: Text(
                    risk.currentLevel,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Assessed on ${risk.date}',
                  style: AppTextStyles.subtitleSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTremorLevelsCard(TremorLevels levels) {
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
              const Icon(Icons.timeline, color: AppColors.primaryTremor, size: 28),
              const SizedBox(width: 12),
              const Text('All Level Assessments', style: AppTextStyles.cardTitle),
            ],
          ),
          const SizedBox(height: 20),
          _buildLevelBar('Voice (Level 1)', levels.voice, AppColors.primaryVoice),
          const SizedBox(height: 16),
          _buildLevelBar('Facial (Level 2)', levels.facial, AppColors.primaryFace),
          const SizedBox(height: 16),
          _buildLevelBar('Tremor (Level 3)', levels.tremor, AppColors.primaryTremor),
        ],
      ),
    );
  }

  Widget _buildLevelBar(String label, int value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text('$value/100', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: value / 100,
            backgroundColor: AppColors.lightGrey,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildAISummaryCard(AIClinicalSummary summary) {
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.psychology, color: Colors.purple, size: 24),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('AI-Generated Clinical Summary', style: AppTextStyles.cardTitle),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Generated: ${summary.generatedAt}',
            style: AppTextStyles.subtitleSmall,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purple.withOpacity(0.2)),
            ),
            child: Text(
              summary.summary,
              style: const TextStyle(height: 1.5),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Key Findings:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...summary.keyFindings.map((finding) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.fiber_manual_record, size: 8, color: Colors.purple),
                    const SizedBox(width: 8),
                    Expanded(child: Text(finding)),
                  ],
                ),
              )).toList(),
        ],
      ),
    );
  }

  Widget _buildDiseaseProgressionCard(DiseaseProgression progression) {
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
              const Icon(Icons.show_chart, color: AppColors.primaryTremor, size: 28),
              const SizedBox(width: 12),
              const Text('Disease Progression Graph', style: AppTextStyles.cardTitle),
            ],
          ),
          const SizedBox(height: 20),
          _buildProgressionChart(progression),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegend('Tremor', AppColors.primaryTremor),
              _buildLegend('Voice', AppColors.primaryVoice),
              _buildLegend('Motor', Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressionChart(DiseaseProgression progression) {
    final maxValue = [
      ...progression.tremorScores,
      ...progression.voiceScores,
      ...progression.motorScores
    ].reduce((a, b) => a > b ? a : b).toDouble();

    return SizedBox(
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(progression.months.length, (index) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        // Tremor bar
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            width: double.infinity,
                            height: (progression.tremorScores[index] / maxValue) * 160,
                            decoration: BoxDecoration(
                              color: AppColors.primaryTremor.withOpacity(0.7),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                            ),
                          ),
                        ),
                        // Voice bar
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: double.infinity,
                            height: (progression.voiceScores[index] / maxValue) * 160,
                            decoration: BoxDecoration(
                              color: AppColors.primaryVoice.withOpacity(0.7),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                            ),
                          ),
                        ),
                        // Motor bar
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            width: double.infinity,
                            height: (progression.motorScores[index] / maxValue) * 160,
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.7),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    progression.months[index],
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Color _getRiskLevelColor(String level) {
    if (level.contains('High')) return AppColors.riskHigh;
    if (level.contains('Medium')) return AppColors.riskMedium;
    if (level.contains('Low')) return AppColors.riskLow;
    return AppColors.riskMedium;
  }
}
