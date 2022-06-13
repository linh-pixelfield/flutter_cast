import 'package:cast/cast.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';

class DevicesBottomSheetController extends GetxController {
  bool connectToDevice = false;
  Future<List<CastDevice>> getDevices() async {
    return CastDiscoveryService().search();
  }

  void startSession(CastDevice device) async {
    connectToDevice = true;
    update();
    final session = await CastSessionManager().startSession(device);
    session.sendReceiverCommand(
      CastLaunchCommand(appId: 'CC1AD845'),
    );
    connectToDevice = false;
    update();
    Get.back(result: session);
  }
}
