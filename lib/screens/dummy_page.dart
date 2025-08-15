import 'package:flutter/material.dart';

class DummyPage extends StatefulWidget {
  const DummyPage({super.key});

  @override
  State<DummyPage> createState() => _DummyPageState();
}

class _DummyPageState extends State<DummyPage> {

  @override
  Widget build(BuildContext contrext) {

    return Scaffold(
      appBar: AppBar(
        title: Text('DummyPage'),
      ),
      body: Center(
        child: Text(
          'This a DummyPage.',
          style: TextStyle(fontSize: 24),
        ),
      )
    );
  }
}