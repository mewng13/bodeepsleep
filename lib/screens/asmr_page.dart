import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/models/asmr_data.dart';
import 'package:testapp/models/asmr_player_controller.dart';
import 'package:testapp/models/mood_status_controller.dart';
import 'package:testapp/screens/app_info_page.dart';
import 'package:testapp/screens/asmr_play_page.dart';
import 'package:testapp/util/mood_ble_connect.dart';
import 'package:testapp/widgets/bottom_bar.dart';

class AsmrPage extends StatefulWidget {
  const AsmrPage({super.key});

  @override
  State<AsmrPage> createState() => _AsmrPageState();
}

class _AsmrPageState extends State<AsmrPage> {
  late final AsmrPlayerController asmrPlayerController = Get.put(
    AsmrPlayerController(),
  );

  String selectedCtg2 = '전체';
  @override
  void initState() {
    Get.put(AsmrPlayerController());

    if (asmrCtg1Datas.isEmpty) {
      setState(() async {
        await loadAsmrData();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text('사운드 테라피'),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AppInfoPage();
                },
              ),
            );
          },
          icon: const Icon(Icons.info_outline, color: Colors.grey),
        ),
        actions: [
          IconButton(
            onPressed: ()
            // => showDialog<String>(
            //   context: context,
            //   builder:
            //       (BuildContext context) => AlertDialog(
            //         backgroundColor: const Color.fromARGB(255, 18, 18, 18),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadiusGeometry.all(
            //             Radius.circular(5),
            //           ),
            //         ),
            //         title: const Text(
            //           'Nearby Devices',
            //           style: TextStyle(color: Colors.white),
            //         ),
            //         content: Column(children: [],),
            //         actions: <Widget>[
            //           TextButton(
            //             onPressed: () => Navigator.pop(context, 'Cancel'),
            //             style: OutlinedButton.styleFrom(
            //               overlayColor: Colors.transparent,
            //               shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.all(
            //                   Radius.circular(10),
            //                 ),
            //               ),
            //             ),
            //             child: Expanded(
            //               child: Center(
            //                 child: const Text(
            //                   '취소',
            //                   style: TextStyle(color: Colors.red),
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            // ),
            {
              if (moodStatusController.connected.value) {
                moodBleConnect.disconnectToMood();
              } else {
                moodBleConnect.connectToMood();
              }
            },
            icon: const Icon(Icons.bluetooth, color: Colors.grey),
          ),
        ],
        scrolledUnderElevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            selectedCtg2 = asmrCtg1Datas.keys.toList()[index];
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          textStyle: TextStyle(fontSize: 12),
                          side: BorderSide(
                            color:
                                selectedCtg2 ==
                                        asmrCtg1Datas.keys.toList()[index]
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey,
                          ),
                        ),
                        child: SizedBox(
                          width: 50,
                          child: Center(
                            child: Text(
                              asmrCtg1Datas.keys.toList()[index],
                              style: TextStyle(
                                color:
                                    selectedCtg2 ==
                                            asmrCtg1Datas.keys.toList()[index]
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: asmrCtg1Datas.length,
                ),
              ),
              SizedBox(height: 10),

              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 230),
                  itemBuilder: (context, index) {
                    String selectedCtg1 =
                        asmrCtg1Datas[selectedCtg2]!.keys.toList()[index];
                    List<AsmrData> asmrDataList =
                        asmrCtg1Datas[selectedCtg2]![selectedCtg1]!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(selectedCtg1),
                        ),
                        SizedBox(
                          height: 212,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index2) {
                                AsmrData asmrData = asmrDataList[index2];
                                return SizedBox(
                                  width: 196,
                                  child: thumbnail(asmrData, selectedCtg2),
                                  // ListTile(
                                  //   title: Text(asmrData.title),
                                  //   onTap: () {
                                  //     print(asmrData.title);
                                  //   },
                                  // ),
                                );
                              },
                              itemCount: asmrDataList.length,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  itemCount: asmrCtg1Datas[selectedCtg2]!.keys.toList().length,
                ),
              ),
            ],
          ),
          MediaQuery.of(context).size.height > 800
              ? BottomBar(bottom: MediaQuery.of(context).size.height / 12)
              : BottomBar(),

          //썸네일을 눌렀을 때 백그라운드 재생 오디오 보여주기
          Positioned(
            bottom: Get.height * 0.18,
            left: 0,
            right: 0,
            child: Obx(() {
              final controller = Get.find<AsmrPlayerController>();
              final data = controller.currentData.value;

              //오디오가 없다면 그냥 리턴
              if (data == null) return const SizedBox();

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/asmr/image/thumbnail/${data.code}.jpg',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.ctg1,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            data.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: controller.togglePlayPause,
                      icon: Obx(
                        () => Icon(
                          controller.isPlaying.value
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: controller.stop,
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

Widget thumbnail(AsmrData asmrData, String selectedCtg2Data) {
  final asmrPlayerController = Get.find<AsmrPlayerController>();

  String title = asmrData.title;
  String imagePath = 'assets/asmr/image/thumbnail/${asmrData.code}.jpg';
  return Padding(
    padding: const EdgeInsets.all(6),
    child: GestureDetector(
      onTap: () {
        asmrPlayerController.play(asmrData);

        //UI만 표시
        Get.to(() => AsmrPlayPage(selectedCtg2: selectedCtg2Data));
      },
      child: SizedBox(
        height: 200,
        width: 180,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      const Color.fromARGB(
                        255,
                        33,
                        31,
                        31,
                      ).withValues(alpha: 0.8), // 아래쪽은 진한 회색
                      Colors.transparent, // 위쪽은 투명
                      Colors.transparent, // 위쪽은 투명
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 50,
                left: 10,
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              if (asmrData.narration)
                Positioned(
                  bottom: 75,
                  left: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(6, 1, 6, 1),
                      child: Text('NAR', style: TextStyle(fontSize: 11)),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
