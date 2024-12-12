import 'package:chat_app/data/injection/dependency_injection.dart';
import 'package:chat_app/presentation/home/home.dart';
import 'package:chat_app/services/one_signal_services.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'presentation/calender_ui.dart';
import 'utils/colors.dart' as cs;
import 'bloc/auth/auth_bloc.dart';
import 'bloc/checkLogin/check_login_bloc.dart';
import 'bloc/pickimage/pickimage_bloc.dart';
import 'bloc/sendMessage/send_message_bloc.dart';
import 'bloc/uploadImage/upload_image_bloc.dart';
import 'bloc/users/users_bloc.dart';
import 'data/local/app_notification.dart';
import 'data/local/cache_manager.dart';
import 'presentation/auth/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey:
            "AIzaSyD-UJ-rU1RbSeA6axNcGi7Gpe-mZ9skVaw", // paste your api key here
        appId:
            "1:1091667117693:android:fbc2db045d0f7a7f2c5314", //paste your app id here
        messagingSenderId: "1091667117693", //paste your messagingSenderId here
        projectId: "chatapp-d0681",
        storageBucket: "chatapp-d0681.appspot.com" //paste your project id here
        ),
  );

  setup();
  await getIt<CacheManager>().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final CheckLoginBloc _checkLoginBloc;
  MyApp({super.key}) : _checkLoginBloc = CheckLoginBloc() {
    _checkLoginBloc.add(CheckAlreadyLogin());
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => PickimageBloc()),
        BlocProvider(create: (_) => UploadImageBloc()),
        BlocProvider(create: (_) => CheckLoginBloc()),
        BlocProvider(create: (_) => UsersBloc()),
        BlocProvider(create: (_) => SendMessageBloc()),
      ],
      child: NotificationListener<AppNotification>(
        onNotification: (notification) {
          print("object");
          print(notification.json);
          print(notification.json["user"]);

          return true;
        },
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            appBarTheme: AppBarTheme(color: cs.Colors().appBarColors),
            colorScheme: ColorScheme.fromSeed(
              seedColor: cs.Colors().sendBackgroundColor,
              background: cs.Colors().backGroundColor,
              onBackground: cs.Colors().backGroundColor,
            ),
            useMaterial3: true,
          ),
          home: BlocConsumer<CheckLoginBloc, CheckLoginState>(
            bloc: _checkLoginBloc,
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              getIt<OneSignalServices>().context = context;

              return state is CheckLoginSuccess
                  ? Home()
                  : state is CheckLoginFailed
                      ? Login()
                      : state is CheckLoginLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Center(
                              child: Text("Hi"),
                            );
            },
          ),
        ),
      ),
    );
  }
}
