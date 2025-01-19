import 'package:flutter/material.dart';

class ServiceOptions extends StatelessWidget {
  final String selectedService;
  final Function(String) onServiceSelected;

  const ServiceOptions({
    super.key,
    required this.selectedService,
    required this.onServiceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _serviceOption(
          context,
          imagePath: 'assets/icons/recharge_freon.png',
          label: "Recharge Freon",
          isSelected: selectedService == "Recharge Freon",
          onTap: () => onServiceSelected("Recharge Freon"),
        ),
        _serviceOption(
          context,
          imagePath: 'assets/icons/cleaning_up.png',
          label: "Cleaning Up",
          isSelected: selectedService == "Cleaning Up",
          onTap: () => onServiceSelected("Cleaning Up"),
        ),
      ],
    );
  }

  Widget _serviceOption(
    BuildContext context, {
    required String imagePath,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border:
              Border.all(color: isSelected ? theme.primaryColor : Colors.grey),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                imagePath,
                width: 31,
                height: 40,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}