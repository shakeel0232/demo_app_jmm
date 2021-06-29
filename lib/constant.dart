import 'package:fluttertoast/fluttertoast.dart';

class appConstant {
  String userId =
      'W9lxAPG5ZmPKvhAX2YLz'; // userId used for to view the history of this user already created in firestore.
  showToast(msg) {
    return Fluttertoast.showToast(msg: msg);
  }
}
