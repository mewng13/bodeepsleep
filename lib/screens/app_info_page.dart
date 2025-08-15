import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/widgets/text_tile.dart';
import 'package:url_launcher/link.dart';
//import 'package:url_launcher/url_launcher.dart';

class AppInfoPage extends StatelessWidget {
  const AppInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          iconSize: 20,
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text('Information'),
        backgroundColor: Colors.black,
      ),

      body: SizedBox(
        height: MediaQuery.of(context).size.height,

        child: Column(
          children: [
            Image.asset('assets/img_info.png'),
            const SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  textTile(
                    '수면 전문 브랜드 바딥슬립은\n깊게 자고,\n깊게 사랑하고,\n깊게 사는 것을 추구합니다.',
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: Get.width * 0.05),
                      Text(
                        '과거를 그리워하거나 미래를 걱정하는 대신\n현실을 충실하게 살기를 바랍니다.\n\n수면을 취하는 1/3시간을 충실히 해야\n깨어나 사람들과 관계 맺고, 일하는 2/3의 시간을\n온전히 집중할 수 있기에.\n\n당신의 감각들이 현재를 충분히 경험하고\n즐길 수 있도록 바딥슬립은 고민하겠습니다.',
                        style: TextStyle(fontSize: 13, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: Get.width * 0.35,
                          child: Link(
                            target: LinkTarget.self,
                            uri: Uri.parse(
                              'https://bodeepsleep.com/index.html',
                            ),
                            builder:
                                (context, followLink) => ElevatedButton(
                                  onPressed: () {
                                    followLink!();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    overlayColor: Colors.grey,
                                  ),
                                  child: const Text(
                                    '웹사이트',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        SizedBox(
                          width: Get.width * 0.35,
                          child: Link(
                            target: LinkTarget.self,
                            uri: Uri.parse(
                              'https://www.instagram.com/bodeepsleep/?hl=en',
                            ),
                            builder:
                                (context, followLink) => ElevatedButton(
                                  onPressed: () {
                                    followLink!();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    overlayColor: Colors.grey,
                                  ),
                                  child: const Text(
                                    '인스타그램',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
