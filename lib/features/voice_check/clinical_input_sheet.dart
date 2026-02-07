import 'package:neurovoice_app/core/constants/colors.dart';
import 'package:flutter/material.dart';

class ClinicalInputSheet extends StatefulWidget {
  const ClinicalInputSheet({super.key});

  @override
  State<ClinicalInputSheet> createState() => _ClinicalInputSheetState();
}

class _ClinicalInputSheetState extends State<ClinicalInputSheet> {
  bool ageAbove60 = false;
  bool neuroHistory = false;
  bool hypertension = false;
  bool updrs = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Before we begin',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          _switchTile(
            'Age above 60',
            ageAbove60,
            (v) => setState(() => ageAbove60 = v),
          ),
          _switchTile(
            'Neurological test history',
            neuroHistory,
            (v) => setState(() => neuroHistory = v),
          ),
          _switchTile(
            'High blood pressure (Hypertension)',
            hypertension,
            (v) => setState(() => hypertension = v),
          ),
          _switchTile(
            "UPDRS — Unified Parkinson’s Disease Rating Scale",
            updrs,
            (v) => setState(() => updrs = v),
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, {
                'ac': ageAbove60 ? 1 : 0,
                'nth': neuroHistory ? 1 : 0,
                'htn': hypertension ? 1 : 0,
                'updrs': updrs ? 1 : 0,
              });
            },
            child: const Text(
              'Continue',
              style: TextStyle(color: AppColors.accentBlue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _switchTile(String label, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.accentBlue,
    );
  }
}
