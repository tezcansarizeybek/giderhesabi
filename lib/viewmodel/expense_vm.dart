import 'package:get/get.dart';
import 'package:giderhesabi/core/database_helper.dart';
import 'package:giderhesabi/model/controller_model.dart';
import 'package:giderhesabi/model/expense_model.dart';
import 'package:giderhesabi/viewmodel/location_vm.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

enum ExpenseStatus { loading, done, idle }

class ExpenseVM extends GetxController {
  var expenseList = (<Expense>[]).obs;
  var expense = Expense(uuid: '', description: '', category: '', date: '', total: 0).obs;
  var controller = ControllerModel();
  var currentCategory = "".obs;
  var categoryList = [].obs;
  var chosenCategory = "".obs;
  late Database db;
  var expenseStatus = (ExpenseStatus.idle).obs;
  var selectedExpenses = (<int>[]).obs;

  openDb() async {
    db = await openExpenseDb();
  }

  controllerSet({Expense? expenseVal}) {
    controller = ControllerModel();
    if (expenseVal != null) {
      expense.value = expenseVal;
      controller.total.text = expense.value.total.toStringAsFixed(2);
      controller.date.text = DateFormat("dd-MM-yyyy").format(DateFormat("yyyy-MM-dd").parse(expense.value.date));
      controller.description.text = expense.value.description;
      controller.category.text = expense.value.category;
      Get.find<LocationVM>().markers.assignAll([]);
      Get.find<LocationVM>().markers.add(Marker(markerId: MarkerId(expenseVal.description), position: LatLng(expenseVal.gpsx ?? 0, expenseVal.gpsy ?? 0)));
      controller.gpsY = expense.value.gpsy;
      controller.gpsX = expense.value.gpsx;
    } else {
      Get.find<LocationVM>().markers.assignAll([]);
      controller.category.text = currentCategory.value;
    }
  }

  ///Sets [expense] model value.
  ///Optional param [expenseVal] must be passed if you want to update the value
  ///Else it returns unique [uuid]
  model({Expense? expenseVal}) {
    var uuid = "";
    if (expenseVal != null) {
      uuid = expenseVal.uuid;
    } else {
      uuid = const Uuid().v1();
    }
    expense.value = Expense(
        description: controller.description.text,
        category: controller.category.text,
        date: DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(controller.date.text)),
        total: double.parse(controller.total.text),
        uuid: uuid,
        gpsx: controller.gpsX,
        gpsy: controller.gpsY);
  }

  ///Adds model to DB
  expenseAdd() async {
    model();
    await db.insert('EXPENSE', expense.value.toMap());
    await expenseGet();
  }

  ///Updates model
  ///You have to set [expense] before updating
  expenseUpdate(index) async {
    expense.value = expenseList.elementAt(index);
    model(expenseVal: expense.value);
    await db.update('EXPENSE', expense.value.toMap(), where: "UUID = ?", whereArgs: [expense.value.uuid]);
    expenseList[index] = expense.value;
  }

  ///Gets expenses from db and assign them to [expenseList]
  expenseGet() async {
    try {
      expenseStatus.value = ExpenseStatus.loading;
      var result = await db.query('EXPENSE', orderBy: "DATE DESC");
      expenseList.assignAll([]);
      for (var element in result) {
        expenseList.add(Expense.fromMap(element));
      }
      expenseStatus.value = ExpenseStatus.done;
    } catch (e, s) {
      expenseStatus.value = ExpenseStatus.done;
      throw Exception("$e $s");
    }
  }

  ///Gets expenses from db and assign them to [expenseList] where category is [chosenCategory]
  expenseGetByCategory() async {
    try {
      expenseStatus.value = ExpenseStatus.loading;
      var result = await db.query('EXPENSE', where: "CATEGORY = ?", whereArgs: [chosenCategory.value]);
      expenseList.assignAll([]);
      for (var element in result) {
        expenseList.add(Expense.fromMap(element));
      }
      expenseStatus.value = ExpenseStatus.done;
    } catch (e, s) {
      expenseStatus.value = ExpenseStatus.done;
      throw Exception("$e $s");
    }
  }

  ///Deletes expense
  expenseDelete(int index) async {
    var uuid = expenseList.elementAt(index).uuid;
    await db.delete('EXPENSE', where: "UUID = ?", whereArgs: [uuid]);
    expenseList.removeAt(index);
  }

  expenseDeleteSelected() async {
    for (var index in selectedExpenses) {
      var uuid = expenseList.elementAt(index).uuid;
      await db.delete('EXPENSE', where: "UUID = ?", whereArgs: [uuid]);
      expenseList.removeAt(index);
    }
    selectedExpenses.assignAll([]);
  }

  ///Gets category list from db and assigns them to [categoryList]
  categoryGet() async {
    var result = await db.query('CATEGORY');
    categoryList.assignAll([]);
    for (var element in result) {
      categoryList.add(element["NAME"]);
    }
    if (categoryList.isNotEmpty) {
      chosenCategory.value = categoryList.first;
    }
  }
}
