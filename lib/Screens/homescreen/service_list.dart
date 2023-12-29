
import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference servicesCollection = FirebaseFirestore.instance.collection('services');

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class Services {
  final String id;
  late String name;
  late String price;
  late String description;
  late String images;


  Services({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.images,});
}

List<Services>ServicesList=[
  Services(name: 'Mens Haircut', price: 'Rs 200/-', description: '(Haircut that suits your face.)', images:  'assets/haircuttingsalon.jpg', id: '',),
  Services(name:'Mens shaving', price: 'Rs 200/-', description: '(Beard grooming that suits your face.)', images:  'assets/shaving.jpeg', id: '',),
  Services(name: 'Hair colour',price: 'Rs 300/-', description: '(Even & mess-free color application.)', images: 'assets/haircolor.jpeg', id: '',),
  Services(name: 'Face care', price: 'Rs 500/-', description: '(Cleaning of face along with scrubbing.)', images:  'assets/facecare.jpeg', id: '',),
  Services(name:'Massage', price: 'Rs 400/-', description: '(Relaxing Oil massage to relieve stress.)', images:  'assets/massage.jpeg', id: '',),
];

