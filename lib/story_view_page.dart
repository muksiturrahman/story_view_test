import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class Home extends StatelessWidget {
  final StoryController controller = StoryController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: MoreStories()),
    );
  }
}

class MoreStories extends StatefulWidget {
  @override
  _MoreStoriesState createState() => _MoreStoriesState();
}

class _MoreStoriesState extends State<MoreStories> {
  final storyController = StoryController();
  late VideoPlayerController videoController;
  int currentIndex = 0; // Track the current index
  bool isAudioMuted = false;

  final List<String> videoUrls = [
    'https://www.kalbela.com/assets/videos/1696872160.mp4',
    'https://www.kalbela.com/assets/videos/1696697593.mp4',
    'https://www.kalbela.com/assets/videos/1696696922.mp4',
    'https://www.kalbela.com/assets/videos/1696000247.mp4',
  ];

  @override
  void initState() {
    super.initState();

    // Initialize the video controller
    videoController = VideoPlayerController.network(videoUrls[currentIndex]);
    videoController.initialize().then((_) {
      videoController.setLooping(false); // Disable looping
      videoController.setVolume(isAudioMuted ? 0.0 : 1.0);
    });
  }

  @override
  void dispose() {
    storyController.dispose();
    videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<StoryItem> videoStories = videoUrls
        .map(
          (url) => StoryItem.pageVideo(
        url,
        controller: storyController,
      ),
    )
        .toList();

    Navigator.of(context).popUntil((route) {
      storyController.pause();
      return true;
    });

    return Scaffold(
      body: Stack(
        children: [
          StoryView(
            storyItems: videoStories,
            onStoryShow: (s) {
              print("Showing a story");
            },
            onComplete: () {
              // Navigator.pop(context);
              print("Journey Completed");
            },
            progressPosition: ProgressPosition.top,
            repeat: false,
            controller: storyController,
          ),
          Positioned(
            top: 15,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(16),
                child: Icon(
                  Icons.clear,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          ),
          Positioned(
            top: 15,
            right: 48,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isAudioMuted = !isAudioMuted;
                  videoController.setVolume(isAudioMuted ? 0.0 : 1.0);
                });
              },
              child: Container(
                padding: EdgeInsets.all(16),
                child: Icon(
                  isAudioMuted ? Icons.volume_off : Icons.volume_up,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          ),
          Positioned(
            top: 15,
            right: 10,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100),
                      child: Dialog(
                        child: SizedBox(
                          height: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Clipboard.setData(ClipboardData(text: videoUrls[currentIndex]));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.black,
                                      content: Text('Link Copied', style: TextStyle(color: Colors.white)),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.link, color: Colors.white),
                                  ),
                                ),
                              ),
                              Text('Get Link', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w300, color: Colors.black)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.all(16),
                child: Image.asset(
                  'assets/send.png',
                  color: Colors.white,
                  height: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
