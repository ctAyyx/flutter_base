import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/common/common_widget.dart';
import 'package:flutter_base/riverpod/router/app_router.gr.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<MainPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,

      child: AutoTabsScaffold(
        routes: [HomeRoute(), BillRoute(), SettingRoute()],
        bottomNavigationBuilder: (_, tabsRouter) {
          return _HomeBottomTab(
            selectedIndex: tabsRouter.activeIndex,
            onTabClick: (index, _) {
              tabsRouter.setActiveIndex(index);
            },
          );
        },
      ),
    );
  }
}

class _HomeBottomTab extends StatelessWidget {
  final int selectedIndex;
  final Function(int index, int preIndex)? onTabClick;

  const _HomeBottomTab({
    super.key,
    required this.selectedIndex,
    this.onTabClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 64,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ItemHomeBottomTab(
            icon: "",
            title: "首页",
            textColor: selectedIndex == 0 ? Colors.blue : Colors.black,
            onClick: () {
              onTabClick?.call(0, selectedIndex);
            },
          ),
          _ItemHomeBottomTab(
            icon: "",
            title: "账单",
            textColor: selectedIndex == 1 ? Colors.blue : Colors.black,
            onClick: () {
              onTabClick?.call(1, selectedIndex);
            },
          ),
          _ItemHomeBottomTab(
            icon: "",
            title: "设置",
            textColor: selectedIndex == 2 ? Colors.blue : Colors.black,
            onClick: () {
              onTabClick?.call(2, selectedIndex);
            },
          ),
        ],
      ),
    );
  }
}

class _ItemHomeBottomTab extends StatelessWidget {
  final String icon;
  final String title;
  final Color textColor;
  final VoidCallback? onClick;

  const _ItemHomeBottomTab({
    super.key,
    required this.icon,
    required this.title,
    required this.textColor,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return SingleTapDetector(
      onTap: onClick,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(color: textColor, width: 24, height: 24),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
