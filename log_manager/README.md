<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

## Features

A tool for viewing logs in the app

## Getting started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  log_sys:^1.0.1
```

## Usage


```
  // main.dart 
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  ...
  LogManager.init(
    isDebug: true,
    // option feishu webhook 
    fsApi:"",
        
  );
  runApp(MyApp());
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // Use the floating button
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LogManager.showFloatButton(navigatorKey.currentState?.overlay);
    });
  }

  @override
  Widget build(BuildContext context) {
    ...
     //Or Use LogScreen
  Navigator.push(context, MaterialPageRoute(builder: (_)=>LogScreen()));
    ...
  }
}
  
 
  
  //Option  Dio Interceptor
  dio.interceptors.add(LogDioInterceptor());
```


## Additional information

