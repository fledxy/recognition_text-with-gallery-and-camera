import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  XFile? imageFile;

  _pickImage() async {
    final pickImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickImage != null) {
      setState(() {
        imageFile = XFile(pickImage.path);
      });
    }
    _processImage();
  }

  _scanImage() async {
    final scanImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (scanImage != null) {
      setState(() {
        imageFile = XFile(scanImage.path);
      });
    }
  }

  _processImage() async {
    final inputImage = InputImage.fromFilePath(imageFile!.path);
    final textRecognize = GoogleMlKit.vision.textRecognizer();
    final RecognizedText recognizedText =
        await textRecognize.processImage(inputImage);
    final extractedText = recognizedText.text;
    print(extractedText);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Scaffold(
          appBar: AppBar(title: Text('Text Recognition')),
          body: Center(
              child: SingleChildScrollView(
            child: Column(children: [
              imageFile == null
                  ? Text('Select Image')
                  : Image.file(File(imageFile!.path)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonCustom(
                    text: 'Pick image',
                    ontap: () => _pickImage(),
                  ),
                  SizedBox(width: 10),
                  ButtonCustom(
                    text: 'Scan image',
                    ontap: () => _scanImage(),
                  )
                ],
              )
            ]),
          )),
        ));
  }
}

class ButtonCustom extends StatelessWidget {
  final String text;
  final VoidCallback ontap;
  const ButtonCustom({super.key, required this.text, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: ontap,
        child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.purple[600]),
            child: Text(text, style: TextStyle(color: Colors.white))));
  }
}
