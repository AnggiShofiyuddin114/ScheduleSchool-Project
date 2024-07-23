import 'package:quickalert/models/quickalert_type.dart';

class ItemQuickAlert {
  final String title;
  final String msg;
  final QuickAlertType type;

  ItemQuickAlert({required this.title, required this.msg, required this.type});
}
