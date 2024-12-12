import 'package:get_it/get_it.dart';

import '../../services/one_signal_services.dart';
import '../../services/socket_services.dart';
import '../local/app_notification.dart';
import '../local/cache_manager.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<SocketServices>(SocketServices());
  getIt.registerSingleton<CacheManager>(CacheManager());
  getIt.registerSingleton<OneSignalServices>(OneSignalServices());

}