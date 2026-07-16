import 'package:flutter/material.dart';
import 'package:flutter_base/common/common_widget.dart';
import 'package:flutter_base/widget/float_manager.dart';

import 'card_formatter.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: '组件集合',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: '组件集合'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("针对自定义组件的使用 和一些常用方法的使用"),
            ..._buildCard(),
            SubmitButton.general(
              text: "显示Loading",
              onClick: () async {
                FloatManager.instance.showLoading();
                await Future.delayed(Duration(seconds: 5));
                FloatManager.instance.hideLoading();
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCard() {
    return [
      const Text("EditText实现输入格式化"),
      const SizedBox(height: 8),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: TextField(
          keyboardType: TextInputType.number,
          inputFormatters: [CardFormatter(formatText: (text, divider) {
            final formattedBuffer = StringBuffer();
            for (int i = 0; i < text.length; i++) {
              formattedBuffer.write(text[i]);
              final nonZeroIndex = i + 1;
              if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
                formattedBuffer.write(divider);
              }
            }
            final formattedText = formattedBuffer.toString();
            return formattedText;
          })],
        ),
      ),
    ];
  }

  List<Widget> _buildImageHandle() {
    return [
      const Text("图片裁剪处理"),
      const SizedBox(height: 8),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: TextField(
          keyboardType: TextInputType.number,
          inputFormatters: [CardFormatter()],
        ),
      ),
    ];
  }
}
