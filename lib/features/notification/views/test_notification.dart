import 'package:flutter/material.dart';

class TestNotification extends StatelessWidget {
  final VoidCallback goBack;
  const TestNotification({super.key, required this.goBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: goBack,
          icon: const Icon(Icons.close),
        ),
        title: const Text('Test Notification'),
      ),
      body: const SafeArea(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
