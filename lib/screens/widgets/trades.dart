import 'package:flutter/material.dart';

class Trades extends StatefulWidget {
  const Trades({super.key});

  @override
  State<Trades> createState() => _TradesState();
}

class _TradesState extends State<Trades> {
  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        children: [
          CustomTabBar(
            selectedIndex: selectedTabIndex,
            onTabChanged: (index) {
              setState(() {
                selectedTabIndex = index;
              });
            },
          ),
          // Content based on selected tab
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildSelectedView(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedView() {
    switch (selectedTabIndex) {
      case 0:
        return const OpenOrders();
      case 1:
        return const Positions();
      default:
        return const SizedBox.shrink();
    }
  }
}

// Custom Tab Bar Widget
class CustomTabBar extends StatelessWidget {
  final Function(int) onTabChanged;
  final int selectedIndex;

  const CustomTabBar({
    super.key,
    required this.onTabChanged,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              _buildTab(context, 'Open Orders', 0),
              _buildTab(context, 'Positions', 1),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTab(BuildContext context, String title, int index) {
    final isSelected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChanged(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.secondary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

// View Widgets for each tab
class OpenOrders extends StatelessWidget {
  const OpenOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          height: 250,
          child: Center(child: Text('No Open Orders')),
        ),
      ],
    );
  }
}

class Positions extends StatelessWidget {
  const Positions({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          height: 250,
          child: Center(child: Text('No Open Positions')),
        ),
      ],
    );
  }
}
