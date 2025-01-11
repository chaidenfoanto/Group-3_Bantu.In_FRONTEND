import 'package:flutter/material.dart';
import 'package:front_end/widgets/navbar.dart' as navbar;

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersState();
}

class _OrdersState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return navbar.BottomNavBar(
      currentIndex: 1, 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Orders',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          // Tab Bar untuk History, In Progress, Scheduled
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                     TabBar(
                      labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.black,
                      indicatorColor: const Color(0xFFFECE2E), // Warna kuning
                      indicatorWeight: 3.0,
                      // unselectedLabelStyle: TextStyle( // Gaya teks untuk tab yang tidak aktif
                      //   fontWeight: FontWeight.normal,
                      // ),
                      tabs: const [
                        Tab(text: 'History'),
                        Tab(text: 'In Progress'),
                        Tab(text: 'Scheduled'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Tab History
                          _buildEmptyState(
                            context,
                            'No orders yet!',
                            'Start your order now',
                            'assets/images/empty-order.png',
                          ),
                          // Tab In Progress
                          _buildEmptyState(
                            context,
                            'No orders in progress!',
                            'Place an order now',
                            'assets/images/empty-order.png',
                          ),
                          // Tab Scheduled
                          _buildEmptyState(
                            context,
                            'No scheduled orders!',
                            'Plan your order now',
                            'assets/images/empty-order.png',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    String title,
    String subtitle,
    String imagePath,
  ) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            height: 200,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign:
                TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
