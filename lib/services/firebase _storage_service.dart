// ignore_for_file: file_names

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseStorageService {
  static File? file;
  static PlatformFile? pickedFile;
  static Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      pickedFile = result.files.first;
      log(pickedFile.toString());
      file = File(pickedFile!.path!);
      log(file.toString());
    }
  }

  static uploadimage(String address, String id, bool check) async {
    if (FirebaseStorageService.file == null) return;
    final path = '/$address/$id/${FirebaseStorageService.pickedFile!.name}';
    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(FirebaseStorageService.file!);
    final upload = ref.putFile(FirebaseStorageService.file!);
    final snapshot = await upload.whenComplete(() {});
    String urlDownload = await snapshot.ref.getDownloadURL();
    log('url is = $urlDownload');
    if (check) {
      final docUser = FirebaseFirestore.instance.collection("Parties").doc(id);

      await docUser.update(
        {
          "imgurl": urlDownload,
        },
      );
    }
    if (!check) {
      final docUser = FirebaseFirestore.instance
          .collection(
            FirebaseAuth.instance.currentUser!.email!,
          )
          .doc(id);

      await docUser.update(
        {
          "dpURL": urlDownload,
        },
      );
    }
    FirebaseStorageService.file = null;
  }

  static Future<void> deleteParty(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection("Parties")
          .doc(id)
          .delete()
          .then(
        (value) {
          Fluttertoast.showToast(msg: "Delete");
        },
      );
    } catch (e) {
      log(
        e.toString(),
      );
    }
  }
}
