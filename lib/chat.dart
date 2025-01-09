import 'package:flutter/material.dart';
import 'package:front_end/widgets/navbar.dart' as navbar;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatState();
}

class _ChatState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return navbar.BottomNavBar(
      currentIndex: 3, 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chat',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8), // Jarak antara teks dan garis
                const Divider(
                  thickness: 1, // Ketebalan garis
                  color: Colors.black38, // Warna garis
                ),
              ],
            ),
          ),
          // Konten Empty State
          Expanded(
            child: Center(
              child: _buildEmptyState(
                context,
                'No chat yet!',
                'Start your order now',
                'assets/images/empty-chat.png', 
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
    return Column(
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
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
