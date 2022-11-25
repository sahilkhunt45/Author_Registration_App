// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../helper/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  ImagePicker imagePicker = ImagePicker();
  String imageUrl = '';
  String authorImageUrl = '';
  GlobalKey<FormState> insertFormKey = GlobalKey();
  GlobalKey<FormState> updatedFormKey = GlobalKey();

  TextEditingController nameController = TextEditingController();
  TextEditingController updatedNameController = TextEditingController();
  TextEditingController bookNameController = TextEditingController();
  TextEditingController updatedBookNameController = TextEditingController();

  String? name;
  String? bookName;
  String? updatedName;
  String? updatedBookName;

  Future imgFromGallery() async {
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    XFile? file = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceImages = referenceRoot.child('images');
    Reference referenceImagesUpload = referenceImages.child(uniqueFileName);

    try {
      await referenceImagesUpload.putFile(File(file!.path));
      imageUrl = await referenceImagesUpload.getDownloadURL();
    } catch (error) {
      print("$error");
    }
  }

  Future authorImgFromGallery() async {
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    XFile? file = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceImages = referenceRoot.child('Author_images');
    Reference referenceImagesUpload = referenceImages.child(uniqueFileName);

    try {
      await referenceImagesUpload.putFile(File(file!.path));
      authorImageUrl = await referenceImagesUpload.getDownloadURL();
    } catch (error) {
      print("$error");
    }
  }

  Future imgFromCamera() async {
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    XFile? file = await imagePicker.pickImage(
      source: ImageSource.camera,
    );
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceImages = referenceRoot.child('images');
    Reference referenceImagesUpload = referenceImages.child(uniqueFileName);

    try {
      await referenceImagesUpload.putFile(File(file!.path));
      imageUrl = await referenceImagesUpload.getDownloadURL();
    } catch (error) {
      print("$error");
    }
  }

  Future authorImgFromCamera() async {
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    XFile? file = await imagePicker.pickImage(
      source: ImageSource.camera,
    );
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceImages = referenceRoot.child('Author_images');
    Reference referenceImagesUpload = referenceImages.child(uniqueFileName);

    try {
      await referenceImagesUpload.putFile(File(file!.path));
      authorImageUrl = await referenceImagesUpload.getDownloadURL();
    } catch (error) {
      print("$error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Author Registration"),
        backgroundColor: Colors.deepPurple,
        leading: const Icon(
          Icons.book,
          color: Colors.white,
          size: 35,
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addRecords();
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: CloudFirestoreHelper.cloudFirestoreHelper.selectRecord(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: SelectableText("${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              QuerySnapshot? data = snapshot.data;
              List<QueryDocumentSnapshot> documents = data!.docs;

              return (documents.isNotEmpty)
                  ? ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      itemCount: documents.length,
                      itemBuilder: (BuildContext context, i) {
                        return Card(
                          elevation: 10,
                          shadowColor: Colors.deepPurple,
                          margin: const EdgeInsets.all(10),
                          child: Container(
                            height: 320,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        updatedRecord(
                                          id: documents[i].id,
                                          name: documents[i]['name'],
                                          bookName: documents[i]['bookName'],
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.deepPurple,
                                        size: 30,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        deleteMessage();
                                        await CloudFirestoreHelper
                                            .cloudFirestoreHelper
                                            .deleteRecord(
                                          id: documents[i].id,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          right: 10, left: 10),
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              "${documents[i]['authorImages']}"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "${documents[i]['name']}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          right: 10, left: 10),
                                      height: 140,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              "${documents[i]['images']}"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '''${documents[i]['bookName']}''',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.sentiment_dissatisfied,
                            size: 100,
                            color: Colors.deepPurple,
                          ),
                          Text(
                            "No Registration Yet !",
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                    );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.deepPurple,
                ),
              );
            }
          }),
    );
  }

  void addRecords() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter Detail"),
          content: Form(
            key: insertFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: const CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    radius: 40,
                    child: Icon(
                      Icons.person_add_alt_1_outlined,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                  onTap: () async {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SafeArea(
                            child: Wrap(
                              children: <Widget>[
                                ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text('Gallery'),
                                    onTap: () {
                                      authorImgFromGallery();
                                      Navigator.of(context).pop();
                                    }),
                                ListTile(
                                  leading: const Icon(Icons.photo_camera),
                                  title: const Text('Camera'),
                                  onTap: () {
                                    authorImgFromCamera();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  },
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  child: const CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    radius: 40,
                    child: Icon(
                      CupertinoIcons.book_fill,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                  onTap: () async {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SafeArea(
                            child: Wrap(
                              children: <Widget>[
                                ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text('Gallery'),
                                    onTap: () {
                                      imgFromGallery();
                                      Navigator.of(context).pop();
                                    }),
                                ListTile(
                                  leading: const Icon(Icons.photo_camera),
                                  title: const Text('Camera'),
                                  onTap: () {
                                    imgFromCamera();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Enter Author Name",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.deepPurple,
                      ),
                    ),
                    labelStyle: TextStyle(color: Colors.deepPurple),
                    labelText: "Author Name",
                    border: OutlineInputBorder(),
                  ),
                  controller: nameController,
                  onSaved: (val) {
                    setState(() {
                      name = val;
                    });
                  },
                  validator: (val) =>
                      (val!.isEmpty) ? "Enter your name first" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    hintText: "Enter Book Name",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.deepPurple,
                      ),
                    ),
                    labelStyle: TextStyle(color: Colors.deepPurple),
                    labelText: "Book Name",
                  ),
                  controller: bookNameController,
                  onSaved: (val) {
                    setState(() {
                      bookName = val;
                    });
                  },
                  validator: (val) =>
                      (val!.isEmpty) ? "Enter your Book name first" : null,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (insertFormKey.currentState!.validate()) {
                  insertFormKey.currentState!.save();

                  await CloudFirestoreHelper.cloudFirestoreHelper.insertRecord(
                      name: name!,
                      bookName: bookName!,
                      imageUrl: imageUrl,
                      authorImages: authorImageUrl);
                 
                  nameController.clear();
                  bookNameController.clear();

                  setState(() {
                    name = null;
                    bookName = null;
                  });

                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text("Add"),
            ),
            ElevatedButton(
              onPressed: () {
                nameController.clear();
                bookNameController.clear();
                setState(() {
                  name = null;
                  bookName = null;
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void updatedRecord({
    required String id,
    required String name,
    required String bookName,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        updatedNameController.text = name;
        updatedBookNameController.text = bookName;
        return AlertDialog(
          title: const Text("Update Detail"),
          content: Form(
            key: updatedFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: const CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    radius: 40,
                    child: Icon(
                      Icons.person_add_alt_1_outlined,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                  onTap: () async {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SafeArea(
                            child: Wrap(
                              children: <Widget>[
                                ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text('Gallery'),
                                    onTap: () {
                                      authorImgFromGallery();
                                      Navigator.of(context).pop();
                                    }),
                                ListTile(
                                  leading: const Icon(Icons.photo_camera),
                                  title: const Text('Camera'),
                                  onTap: () {
                                    authorImgFromCamera();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  },
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  child: const CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    radius: 40,
                    child: Icon(
                      CupertinoIcons.book_fill,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                  onTap: () async {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SafeArea(
                            child: Wrap(
                              children: <Widget>[
                                ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text('Gallery'),
                                    onTap: () {
                                      imgFromGallery();
                                      Navigator.of(context).pop();
                                    }),
                                ListTile(
                                  leading: const Icon(Icons.photo_camera),
                                  title: const Text('Camera'),
                                  onTap: () {
                                    imgFromCamera();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Enter Author Name",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.deepPurple,
                      ),
                    ),
                    labelStyle: TextStyle(color: Colors.deepPurple),
                    labelText: "Author Name",
                  ),
                  controller: updatedNameController,
                  onSaved: (val) {
                    setState(() {
                      updatedName = val;
                    });
                  },
                  validator: (val) =>
                      (val!.isEmpty) ? "Enter your Author Name first" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    hintText: "Enter Book Name",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.deepPurple,
                      ),
                    ),
                    labelStyle: TextStyle(color: Colors.deepPurple),
                    labelText: "Book Name",
                  ),
                  controller: updatedBookNameController,
                  onSaved: (val) {
                    setState(() {
                      updatedBookName = val!;
                    });
                  },
                  validator: (val) =>
                      (val!.isEmpty) ? "Enter your BookName first" : null,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (updatedFormKey.currentState!.validate()) {
                  updatedFormKey.currentState!.save();

                  Map<String, dynamic> updatedData = {
                    'name': updatedName,
                    'bookName': updatedBookName,
                  };
                  await CloudFirestoreHelper.cloudFirestoreHelper
                      .updateRecord(updatedData: updatedData, updatedId: id);

                  updatedNameController.clear();
                  updatedBookNameController.clear();

                  setState(() {
                    updatedName = null;
                    updatedBookName = null;
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Successfully Record Updated"),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.deepPurple,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text("Update"),
            ),
            ElevatedButton(
              onPressed: () {
                updatedNameController.clear();
                updatedBookNameController.clear();
                setState(() {
                  updatedName = null;
                  updatedBookName = null;
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  deleteMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Successfully Author's Record Deleted"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ),
    );
  }
}
