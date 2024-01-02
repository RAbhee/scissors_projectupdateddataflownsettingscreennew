import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scissors_project/Screens/homescreen/service_list.dart';
import '../bookingslots/bookingslot_screen.dart';
import '../dashboard/add_profile.dart';

CollectionReference servicesCollection = FirebaseFirestore.instance.collection('services');

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<Services> selectedServices = [];
  double totalAmount = 0.0;

  late Stream<QuerySnapshot<Map<String, dynamic>>> servicesStream;

  @override
  void initState() {
    super.initState();
    servicesStream = FirebaseFirestore.instance.
    collection('services')
        .snapshots() as Stream<QuerySnapshot<Map<String, dynamic>>>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: servicesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // Handle case when the document does not exist
             return Text("Document does not exist");
          }

          //Map<String, dynamic> data = snapshot.data!.data()!;
          //double updatedPrice = data['price'] ?? 0.0;
          List<Services> servicesList = snapshot.data!.docs.map((document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return Services(
              id: document.id,
              name: data['name'],
              description: data['description'],
              price: data['price'],
              images: data['images'],
            );
          }).toList();


          return Scaffold(
            body: Stack(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    itemCount: servicesList.length,
                    itemBuilder: (context, index) {
                      Services service = servicesList[index];
                      return Card(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: ListTile(
                            title: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    service.images,
                                    height: 55,
                                    width: 85,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        service.name,
                                        style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        service.price,
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                service.description,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 12,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            trailing: ElevatedButton(
                              onPressed: () {
                                _toggleService(service);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: selectedServices.contains(service)
                                    ? Colors.brown[400]
                                    : Colors.brown[800],
                              ),
                              child: Text(
                                selectedServices.contains(service) ? 'Remove' : 'Add',
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _toggleService(Services service) {
    setState(() {
      if (selectedServices.contains(service)) {
        selectedServices.remove(service);
        totalAmount -= double.tryParse(service.price.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0;
      } else {
        selectedServices.add(service);
        totalAmount += double.tryParse(service.price.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0;
        _showPriceUpdateForm(service.id);

        addService(
          service.name,
          service.description,
          service.price,
          service.images,
        );
      }
    });

    _showSelectedServices(context);
    _updateFirebaseData();
  }

  void _showPriceUpdateForm(String serviceId) {
    TextEditingController servicenameController = TextEditingController();
    TextEditingController oldPriceController = TextEditingController();
    TextEditingController newPriceController1 = TextEditingController();
    TextEditingController confirmPriceController2 = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return PriceUpdateForm(
          serviceId: serviceId,
          servicenameController: servicenameController,
          oldPriceController: oldPriceController,
          newPriceController1: newPriceController1,
          confirmPriceController2: confirmPriceController2,
        );
      },
    );
  }

  void _updateFirebaseData() async {
    CollectionReference bookingCollection = FirebaseFirestore.instance.collection('bookings');

    String documentId = DateTime.now().millisecondsSinceEpoch.toString();
    await bookingCollection.doc(documentId).set({
      'services': selectedServices.map((service) => {
        'id': service.id,
        'name': service.name,
        'description': service.description,
        'price': service.price,
        'images': service.images,
      }).toList(),
      'totalAmount': totalAmount,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void _showSelectedServices(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.brown.withOpacity(0.5),
                        Colors.brown.withOpacity(0.7),
                        Colors.brown.withOpacity(0.9),
                        Colors.brown.withOpacity(0.7),
                        Colors.brown.withOpacity(0.5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Selected Services',
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            color: Colors.white,
                            letterSpacing: .5,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 2,
                        endIndent: 15,
                        indent: 15,
                        color: Colors.white,
                      ),
                      for (Services service in selectedServices) ...[
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                service.name,
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: .5,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 1),
                            Text(
                              service.price,
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: .5,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      SizedBox(height: 16),
                      Text(
                        'Total Amount : Rs. $totalAmount/-',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.white,
                            letterSpacing: .5,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Conditionally render RawMaterialButton
                      if (totalAmount > 0)
                        RawMaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingSlotScreen(),
                              ),
                            );
                          },
                          fillColor: Colors.brown[900],
                          constraints: BoxConstraints(maxHeight: 100),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Book',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.white,
                                letterSpacing: .6,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void addService(String name, String description, String price, String images) {}
}
