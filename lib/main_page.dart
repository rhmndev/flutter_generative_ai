import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

import 'global_variables.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController textEditingController = TextEditingController();
  String answer = '';
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade100,
          title: const Text('Gemini AI Demo'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              TextField(
                  controller: textEditingController,
                  decoration: const InputDecoration(
                    hintText: 'Masukan pertanyaanmu di sini....',
                    border: OutlineInputBorder(),
                  )),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                    color: image == null ? Colors.grey.shade200 : null,
                    image: image != null
                        ? DecorationImage(image: FileImage(File(image!.path)))
                        : null),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  ImagePicker().pickImage(source: ImageSource.gallery).then(
                    (value) {
                      setState(() {
                        image = value;
                      });
                    },
                  );
                },
                child: const Text('Pilih Gambar'),
              ),
              ElevatedButton(
                onPressed: () {
                  GenerativeModel model = GenerativeModel(
                      model: 'gemini-1.5-flash-latest', apiKey: apiKey);
                  //  Content Text Generate
                  // model.generateContent([
                  //   Content.text(textEditingController.text),
                  // ]).then(
                  //   (value) {
                  //     setState(() {
                  //       answer = value.text.toString();
                  //     });
                  //   },
                  // );
                  model.generateContent([
                    Content.multi([
                      TextPart(textEditingController.text),
                      if (image != null)
                        DataPart(
                            'image/jpeg', File(image!.path).readAsBytesSync()),
                    ])
                  ]).then((value) => setState(() {
                        answer = value.text.toString();
                      }));
                },
                child: const Text('Kirim'),
              ),
              const SizedBox(height: 20),
              Text(answer),
            ],
          ),
        ));
  }
}
