import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:giderhesabi/view/expense_form_page.dart';
import 'package:giderhesabi/viewmodel/expense_vm.dart';
import 'package:intl/intl.dart';

class ExpenseListWidget extends StatelessWidget {
  ExpenseListWidget({Key? key}) : super(key: key);

  final c = Get.find<ExpenseVM>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemBuilder: (context, index) {
          var exp = c.expenseList.elementAt(index);
          return Card(
            elevation: 10,
            color: c.selectedExpenses.contains(index) ? Colors.blue : null,
            child: Slidable(
              child: ListTile(
                // tileColor: index % 2 != 0 ? Colors.grey : null,
                onTap: () {
                  if (!c.selectedExpenses.contains(index)) {
                    c.selectedExpenses.add(index);
                  } else {
                    c.selectedExpenses.remove(index);
                  }
                  c.update();
                },
                title: Text(exp.description),
                subtitle: Text(DateFormat("dd-MM-yyyy").format(DateFormat("yyyy-MM-dd").parse(exp.date))),
                trailing: Text(exp.total.toStringAsFixed(2)),
              ),
              actionPane: const SlidableDrawerActionPane(),
              secondaryActions: [
                IconSlideAction(
                  caption: "Düzenle",
                  color: Colors.orange,
                  icon: CupertinoIcons.create,
                  onTap: () {
                    c.controllerSet(expenseVal: c.expenseList.elementAt(index));
                    Get.to(() => ExpenseFormPage(
                          index: index,
                        ));
                  },
                ),
                IconSlideAction(
                  caption: "Sil",
                  color: Colors.red,
                  icon: CupertinoIcons.delete,
                  onTap: () {
                    c.expenseDelete(index);
                  },
                )
              ],
            ),
          );
        },
        itemCount: c.expenseList.length,
      ),
    );
  }
}
