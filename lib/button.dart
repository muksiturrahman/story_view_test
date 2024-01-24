import 'package:flutter/material.dart';
import 'package:story_view_test/story_view_page.dart';

class ClickToSeeStory extends StatefulWidget {
  const ClickToSeeStory({super.key});

  @override
  State<ClickToSeeStory> createState() => _ClickToSeeStoryState();
}

class _ClickToSeeStoryState extends State<ClickToSeeStory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Story View Flutter'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
            },
            child: Text('Click Me to See Special things'),
        ),
      ),
    );
  }
}
