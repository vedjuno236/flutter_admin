import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseFirestoreService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  //addd data to firestore collection
  Future<bool> addDocument(String collectionPath, Map<String, dynamic> data) async {
    try{
      await _firestore.collection(collectionPath).add(data);
      return true;
    }catch(e){
      print("Failed to add");
      return false;
    }
  }
  //addd data to firestore collection
  Future<bool> addDocumentCustomId(String collectionPath,String docId, Map<String, dynamic> data) async {
    try{
      await _firestore.collection(collectionPath).doc(docId).set(data);
      return true;
    }catch(e){
      print("Failed to add");
      return false;
    }
  }
  //get all data from firestore collection
  Stream<QuerySnapshot> getCollectionStream(String collectionPath) {
    return _firestore.collection(collectionPath).snapshots();
  }
  //get all data from firestore collection
  Stream<QuerySnapshot> getCollectionWithRelationshipStream(String collectionPath,String docIdField,String docId) {
    return _firestore.collection(collectionPath).where(docIdField,isEqualTo: docId).snapshots();
  }
  //get single data from firestore collection
  Stream<DocumentSnapshot> getSingleCollectionStream(String collectionPath,String documentId) {
    var document =  _firestore.collection(collectionPath).doc(documentId).snapshots();
    return document;
  }

  //get single data from firestore collection Not Use in Widget But Use in Function or Method
  Future<DocumentSnapshot> getSingleDataUseInFunction(String collectionPath,String documentId) async{
    return await _firestore.collection(collectionPath).doc(documentId).get();
  }


  Future<bool> updateDocument(String collectionPath, String documentId, Map<String, dynamic> newData) async {
    try{
      await _firestore.collection(collectionPath).doc(documentId).update(newData);
      return true;
    }catch(e){
      print("Failed to update");
      return false;
    }

  }

  Future<bool> deleteDocument(String collectionPath, String documentId) async {
    try{
      await _firestore.collection(collectionPath).doc(documentId).delete();
      return true;
    }catch(e){
      print("Failed to delete");
      return false;
    }
  }

  Future<String> uploadImage(String imagePath, String imageName) async {
    try {
      print("imagePath: " + imagePath);
      print("imageName: " + imageName);
      final Reference storageReference = _storage.ref().child('images/$imageName');
      final UploadTask uploadTask = storageReference.putFile(File(imagePath));
      final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      final String imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return "";
    }
  }

}