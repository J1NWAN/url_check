import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SystemListDetailScreen extends ConsumerWidget {
  const SystemListDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('시스템 상세 정보'),
      ),
      body: const Text('SystemListDetailScreen'),
    );
  }
}
