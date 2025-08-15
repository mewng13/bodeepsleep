import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/models/asmr_player_controller.dart';

class AsmrInfoPage extends StatelessWidget {
  final String imagePath, code;
  AsmrInfoPage({super.key, required this.imagePath, required this.code});

  final AsmrPlayerController asmrPlayerController = Get.find();

  @override
  Widget build(BuildContext context) {
    final currentData = asmrPlayerController.currentData.value;

    bool whiteFont = false;
    if (currentData?.ctg1 == "음악" || currentData?.title == "미라클 나잇") {
      whiteFont = true;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          iconSize: 20,
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text('About'),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              width: Get.size.width,
              height: Get.size.height,
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                code.contains("b")
                    ? "assets/asmr/image/b.jpg"
                    : "assets/asmr/image/$code.jpg",
                fit: BoxFit.fitWidth,
                height: Get.size.height * 0.45,
              ),
            ),
            Positioned(
              top: Get.size.height * 0.31,
              child: Row(
                children: [
                  SizedBox(width: Get.size.width * 0.1),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color.fromARGB(255, 107, 107, 107),
                        ),

                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Text(
                          currentData!.ctg1Sub,
                          style: TextStyle(fontSize: 11, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        currentData.infoTitle,
                        style: TextStyle(
                          fontSize: 22,
                          color: whiteFont ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        currentData.infoSubTitle,
                        style: TextStyle(
                          fontSize: 20,
                          color: whiteFont ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: Get.size.height * 0.5,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  alignment: Alignment.topLeft,
                  width: Get.size.width * 0.66,
                  height: Get.size.height * 0.45,
                  child: Text(
                    currentData.info,
                    style: TextStyle(
                      fontSize: 13,
                      //color: whiteFont ? Colors.white : Colors.black,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
