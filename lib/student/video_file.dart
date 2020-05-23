import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:learning360/student/student_materials.dart';
import 'package:video_player/video_player.dart';

class VideoFile extends StatefulWidget {
  @override
  _VideoFileState createState() => _VideoFileState();
}

class _VideoFileState extends State<VideoFile> {
  String appendedText;
  String _downloadUrl;

  VideoPlayerController controller;
  Future<void> futureController;

  @override
  void initState() {
    //  StudentMaterials.cFileName;
    String filepath =
        '${StudentMaterials.cName}${StudentMaterials.cLevel}${StudentMaterials.cSemester}${StudentMaterials.cMonth}${StudentMaterials.cYear}';
    String type = 'VideoFile/';
    String filename = StudentMaterials.cFileName;
    appendedText = '$filepath$type$filename';
    downloadVideo();
    print('Apeennnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn$appendedText');
    controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');
    futureController = controller.initialize();
    controller.setLooping(true);
    controller.setVolume(25.0);
    super.initState();
  }

  Future downloadVideo() async {
    try {
      String combine = "$appendedText";
      StorageReference storageReference =
          FirebaseStorage.instance.ref().child(combine);
      String downloadAddress = await storageReference.getDownloadURL();
      print("DownloadED ADDDRESS::: $downloadAddress");
      setState(() {
        _downloadUrl = downloadAddress;
      });
    } catch (e) {
      print("ERRRRRRRRRRRROR::::: $e");
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      backgroundColor: Colors.orangeAccent,
      appBar: AppBar(
        title: Text('Materials'),
        backgroundColor: Colors.black87,
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: FutureBuilder(
              future: futureController,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return VideoPlayer(controller);
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Center(
            child: ButtonTheme(
              height: 100.0,
              minWidth: 200.0,
              child: RaisedButton(
                padding: EdgeInsets.all(60.0),
                color: Colors.transparent,
                textColor: Colors.white,
                onPressed: () {
                  setState(() {
                    if (controller.value.isPlaying) {
                      controller.pause();
                    } else {
                      controller.play();
                    }
                  });
                },
                child: Icon(
                  controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 120.0,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
