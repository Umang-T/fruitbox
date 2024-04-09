import 'package:flutter/material.dart';

import '../../../constants/geocoding_service.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final GeocodingService _geocodingService = GeocodingService();
  String? _currentAddress;

  @override
  void initState() {
    super.initState();
    _fetchCurrentAddress();
  }

  Future<void> _fetchCurrentAddress() async {
    // final address = await _geocodingService.getCurrentAddress();
    setState(() {
      // _currentAddress = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Address'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey,
              child: const Center(
                child: Text('Dynamic Map'),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.blueGrey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Address',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  _currentAddress != null
                      ? Text(_currentAddress!)
                      : const Text('Fetching address...'),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.blue,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/new_address');
              },
              child: const Text(
                'Add New Address',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
