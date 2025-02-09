import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Dashboard', style: Theme.of(context).textTheme.displaySmall),
                  Row(
                    children: [
                      IconButton(onPressed: () {}, icon: const Icon(Icons.upload_file_outlined)),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.download)),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
      ),
    );
  }
}
