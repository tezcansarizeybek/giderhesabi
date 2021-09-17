import 'package:get/get.dart';
import 'package:giderhesabi/view/expense_form_page.dart';
import 'package:giderhesabi/viewmodel/expense_vm.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationVM extends GetxController {
  var markers = (<Marker>[]).obs;
  markerAdd() {
    markers.assignAll([]);
    for (var i = 0; i < Get.find<ExpenseVM>().expenseList.length; i++) {
      var element = Get.find<ExpenseVM>().expenseList.elementAt(i);
      if (element.gpsx != null && element.gpsy != null) {
        markers.add(Marker(
            markerId: MarkerId(element.description),
            position: LatLng(element.gpsx!, element.gpsy!),
            onTap: () {
              Get.find<ExpenseVM>().controllerSet(expenseVal: element);
              Get.to(() => ExpenseFormPage(index: i));
            }));
      }
    }
  }

  var latLng = (const LatLng(0, 0)).obs;
  getLocation() async {
    Location loc = Location();
    var location = await loc.getLocation();
    var locLl = LatLng(location.altitude ?? 0, location.latitude ?? 0);
    latLng.value = locLl;
  }
}
