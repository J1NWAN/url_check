import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final int index;
  const DashboardScreen({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('대시보드 ${index + 1}', style: Theme.of(context).textTheme.displaySmall),
            Row(
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.upload_file_outlined)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.download)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
              ],
            )
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(onPressed: () {}, child: const Text('오늘')),
                    TextButton(onPressed: () {}, child: const Text('주')),
                    TextButton(onPressed: () {}, child: const Text('월')),
                    TextButton(onPressed: () {}, child: const Text('년')),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          constraints: const BoxConstraints(
            minHeight: 300,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
