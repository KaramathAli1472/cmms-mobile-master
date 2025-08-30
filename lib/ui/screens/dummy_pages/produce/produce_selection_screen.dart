import 'package:flutter/material.dart';

class ProduceSelectionScreen extends StatefulWidget {
  const ProduceSelectionScreen({super.key});

  @override
  State<ProduceSelectionScreen> createState() => _ProduceSelectionScreenState();
}

class _ProduceSelectionScreenState extends State<ProduceSelectionScreen> {
  List<String> produceItems = ['Apples', 'Oranges', 'Bananas', 'Tomatoes'];
  int? selectedIndex;

  void _onDone() {
    if (selectedIndex != null) {
      Navigator.pop(context, produceItems[selectedIndex!]);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Produce'),
        actions: [
          TextButton(
            onPressed: _onDone,
            child: const Text(
              'DONE',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: produceItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(produceItems[index]),
            trailing: selectedIndex == index ? const Icon(Icons.check, color: Colors.blue) : null,
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
          );
        },
      ),
    );
  }
}
