import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Screen'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Update Service Price',
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            ServicePriceForm(),
            SizedBox(height: 16),
            Text(
              'Add New Service',
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            NewServiceForm(),
          ],
        ),
      ),
    );
  }
}

class ServicePriceForm extends StatefulWidget {
  @override
  _ServicePriceFormState createState() => _ServicePriceFormState();
}

class _ServicePriceFormState extends State<ServicePriceForm> {
  TextEditingController _serviceNameController = TextEditingController();
  TextEditingController _newPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _serviceNameController,
          decoration: InputDecoration(labelText: 'Service Name'),
        ),
        SizedBox(height: 8),
        TextField(
          controller: _newPriceController,
          decoration: InputDecoration(labelText: 'New Price'),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            _updateServicePrice(context);
          },
          child: Text('Update Service Price'),
        ),
      ],
    );
  }

  void _updateServicePrice(BuildContext context) async {
    String serviceName = _serviceNameController.text.trim();
    double newPrice = double.tryParse(_newPriceController.text) ?? 0.0;

    if (serviceName.isNotEmpty) {
      CollectionReference servicesCollection =
      FirebaseFirestore.instance.collection('services');

      await servicesCollection.doc(serviceName).update({
        'price': newPrice,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Service price updated successfully'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid service name'),
        ),
      );
    }
  }
}

class NewServiceForm extends StatefulWidget {
  @override
  _NewServiceFormState createState() => _NewServiceFormState();
}

class _NewServiceFormState extends State<NewServiceForm> {
  TextEditingController _newServiceNameController = TextEditingController();
  TextEditingController _newServicePriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _newServiceNameController,
          decoration: InputDecoration(labelText: 'New Service Name'),
        ),
        SizedBox(height: 8),
        TextField(
          controller: _newServicePriceController,
          decoration: InputDecoration(labelText: 'Price'),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            _addNewService(context);
          },
          child: Text('Add New Service'),
        ),
      ],
    );
  }

  void _addNewService(BuildContext context) async {
    String newServiceName = _newServiceNameController.text.trim();
    double newServicePrice =
        double.tryParse(_newServicePriceController.text) ?? 0.0;

    if (newServiceName.isNotEmpty) {
      CollectionReference servicesCollection =
      FirebaseFirestore.instance.collection('services');

      await servicesCollection.doc(newServiceName).set({
        'name': newServiceName,
        'price': newServicePrice,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('New service added successfully'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid service name'),
        ),
      );
    }
  }
}
