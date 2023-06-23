

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getCollectionData(String collectionName) async {
    final QuerySnapshot querySnapshot =
    await _firestore.collection(collectionName).get();
    final List<Map<String, dynamic>> data = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    return data;
  }
}