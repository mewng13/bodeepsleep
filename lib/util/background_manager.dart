// import 'package:testapp/models/noti_service.dart';
// import 'package:workmanager/workmanager.dart';

// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     switch (task) {
//       case "weekly_alarm":
//         String? title = inputData?["title"];
//         String? body = inputData?["body"];

//         await NotiService().showNotification(
//           title: title ?? "알람",
//           body: body ?? "설정된 시간이 되었습니다.",
//         );
//         break;
//       default:
//         // Handle unknown task types
//         break;
//     }

//     return Future.value(true);
//   });
// }
