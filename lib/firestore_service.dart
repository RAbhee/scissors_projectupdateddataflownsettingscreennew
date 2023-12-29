import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get pricesCollection => _firestore.collection('prices');

  Stream<QuerySnapshot> getPricesStream() {
    return pricesCollection.snapshots();
  }
}
