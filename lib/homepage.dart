import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload File"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(pickedFile != null)
              Expanded(child: Container(
                color: Colors.blue[100],
                child: Center(
                  child: Text(pickedFile!.name),
                ),
              )),
            ElevatedButton(onPressed: selectFile, child: const Text("Select File")),
            const SizedBox(height: 32,),
            ElevatedButton(onPressed: uploadFile, child: const Text("Upload File"))
          ],
        ),
      ),
    );
  }

  Future selectFile() async{
    final result = await FilePicker.platform.pickFiles();
    if(result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadFile() async {
    final file = File(pickedFile!.path!);
    final path = 'files/${pickedFile!.name}';

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() => {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print("Download Link ${urlDownload}");
  }
}
