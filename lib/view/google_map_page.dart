import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giderhesabi/viewmodel/location_vm.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapPage extends StatelessWidget {
  const GoogleMapPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harita Görünümü'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: GoogleMap(
        markers: Get.find<LocationVM>().markers.toSet(),
        initialCameraPosition: CameraPosition(
          target: Get.find<LocationVM>().latLng.value,
          zoom: 10.0,
        ),
      ),
    );
  }
}
