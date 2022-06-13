import 'package:cast/cast.dart';
import 'package:example/views/devices_bottom_sheet/devices_bottom_sheet_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';

class CastDevicesBottomSheet extends StatelessWidget {
  const CastDevicesBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DevicesBottomSheetController>(
        init: DevicesBottomSheetController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: Get.back,
                  icon: const Icon(CupertinoIcons.chevron_down)),
              title: const Text('Dispositivos'),
            ),
            body: Stack(
              children: [
                FutureBuilder<List<CastDevice>>(
                  future: controller.getDevices(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Buscando dispositivos...'),
                            SizedBox(height: 10),
                            CircularProgressIndicator(),
                          ],
                        ),
                      );
                    }

                    final devices = snapshot.data ?? [];
                    if (devices.isEmpty) {
                      return Center(
                        child: Text('No devices found'),
                      );
                    }

                    return ListView.builder(
                      itemCount: devices.length,
                      itemBuilder: (context, index) {
                        final device = devices[index];

                        return ListTile(
                          title: Text(device.name),
                          subtitle: Text(device.name),
                          onTap: () {
                            controller.startSession(device);
                          },
                        );
                      },
                    );
                  },
                ),
                AnimatedPositioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  top: controller.connectToDevice
                      ? 0
                      : MediaQuery.of(context).size.height,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Conectando...',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  static Future<CastSession?> show() async {
    return await Get.bottomSheet(const CastDevicesBottomSheet());
  }
}
