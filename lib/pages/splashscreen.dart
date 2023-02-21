import 'package:flutter/material.dart';
import 'package:stsl/services/get_permission.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

bool flag = false;

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    GetPermission.goToHome(context);
    // checkstate();

    // Future.delayed(
    //   const Duration(seconds: 5),
    //   (() {
    //     log('flagggg ====   $flag');

    //     Navigator.of(context).popUntil((route) => route.isFirst);
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => (flag == true)
    //             ? Homepage(
    //                 bedtime: bedTime,
    //                 gender: gender,
    //                 waketime: wakeTime,
    //               )
    //             : const WeightPage(
    //                 title: 'title',
    //               ),
    //       ),
    //     );
    //   }),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 247, 249),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            "Pakistan Sign Express",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      )),
    );
  }

//   Future<void> checkstate() async {
//     await FirebaseFirestore.instance
//         .collection('Default-User')
//         .doc('user1')
//         .get()
//         .then(
//       (DocumentSnapshot documentSnapshot) {
//         if (documentSnapshot.exists) {
//           flag = true;
//         } else {
//           flag = false;
//         }
//       },
//     );
//   }
// }

// CollectionReference collectionReference =
//     FirebaseFirestore.instance.collection('Default-User');
// Future<int?> getData(
//     [int? intake,
//     String? gender,
//     DateTime? bedTime,
//     Timestamp? stamp1,
//     Timestamp? stamp2,
//     DateTime? wakeTime,
//     Function? callbackfunction]) async {
//   await collectionReference.doc('user1').get().then((value) {
//     intake = (intake != null) ? (value)['waterIntake'] : null;

//     if (intake != null && intake! > 0) {
//       flag = true;
//     }
//     gender = (gender != null) ? (value)['gender'] : null;

//     stamp1 = (stamp1 != null) ? (value)['bedTime'] : null;

//     bedTime = (bedTime != null) ? stamp1!.toDate() : null;

//     stamp2 = (stamp2 != null) ? (value)['wakeTime'] : null;

//     wakeTime = (wakeTime != null) ? stamp2!.toDate() : null;

//     if (intake == null && callbackfunction != null) {
//       callbackfunction(gender);
//     } else if (callbackfunction != null) {
//       callbackfunction(intake, bedTime, wakeTime);
//     }
//   });
  // return intake;
}
