import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/common/common_widget.dart';
import 'package:flutter_base/riverpod/mvi/state/home_state.dart';
import 'package:flutter_base/riverpod/mvi/viewmodel/home_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uiState = ref.watch(homeViewModel.select((state) => state.uiState));

    ref.listen(homeTimer, (_, next) {
      if (next.uiState == HomeTimerUiState.reLoad) {
        ref.read(homeViewModel.notifier).onRefresh(1);
      }
    });

    return LayoutBuilder(
      builder: (buildContext, constraints) {
        return SafeArea(
          top: false,
          child: LoadingContainer(
            isLoading: uiState == HomeUiState.loading,
            child: RefreshIndicator(
              onRefresh: () async {
                await ref.read(homeViewModel.notifier).onRefresh(1);
              },
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const _HomeTopWidget(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),

                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: _HomeBottomWidget(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HomeTopWidget extends ConsumerWidget {
  const _HomeTopWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeVo = ref.watch(homeViewModel.select((state) => state.homeVo));
    return switch (homeVo?.applyState) {
      1 => Container(
        color: Colors.yellow,
        height: 240,
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Text("授信中UI"), _HomeTimerWidget()],
          ),
        ),
      ),
      2 => Container(
        color: Colors.yellow,
        height: 320,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("授信成功UI"),
              Text("xxxxxxxxxxxxxxxxxxxxx:${homeVo?.applyState}"),
            ],
          ),
        ),
      ),
      3 => Container(
        color: Colors.yellow,
        height: 280,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("放款中UI"),
              Text("ooooooooooooo:${homeVo?.applyState}"),
            ],
          ),
        ),
      ),
      _ => Container(
        color: Colors.yellow,
        height: 260,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("初始态UI"),
              Text("ppppppppppp:${homeVo?.applyState}"),
            ],
          ),
        ),
      ),
    };
  }
}

class _HomeBottomWidget extends ConsumerWidget {
  const _HomeBottomWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeVo = ref.watch(homeViewModel.select((state) => state.homeVo));
    return switch (homeVo?.applyState) {
      1 => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.blue,
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            topLeft: Radius.circular(24),
          ),
        ),
        child: Column(
          spacing: 16,
          children: [
            SingleTapDetector(
              onTap: () {
                ref.read(homeViewModel.notifier).onRefresh(1);
              },
              child: Container(
                width: double.infinity,
                height: 56,
                color: Colors.red,
                child: Center(child: Text("applyState = 1")),
              ),
            ),

            SingleTapDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                height: 56,
                color: Colors.red,
                child: Center(child: Text("applyState = 2")),
              ),
            ),

            SingleTapDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                height: 56,
                color: Colors.red,
                child: Center(child: Text("applyState = 3")),
              ),
            ),
          ],
        ),
      ),
      2 => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.blue,
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            topLeft: Radius.circular(24),
          ),
        ),
        child: Column(
          spacing: 16,
          children: [
            SingleTapDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                height: 56,
                color: Colors.red,
                child: Center(child: Text("applyState = 2")),
              ),
            ),

            SingleTapDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                height: 56,
                color: Colors.red,
                child: Center(child: Text("applyState = 3")),
              ),
            ),
          ],
        ),
      ),
      3 => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.blue,
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            topLeft: Radius.circular(24),
          ),
        ),
        child: Column(
          spacing: 16,
          children: [
            SingleTapDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                height: 56,
                color: Colors.red,
                child: Center(child: Text("applyState = 3")),
              ),
            ),
          ],
        ),
      ),
      _ => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.blue,
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            topLeft: Radius.circular(24),
          ),
        ),
        child: Column(
          spacing: 16,
          children: [
            SingleTapDetector(
              onTap: () {
                ref.read(homeViewModel.notifier).onRefresh(1);
              },
              child: Container(
                width: double.infinity,
                height: 56,
                color: Colors.red,
                child: Center(child: Text("applyState = 1")),
              ),
            ),
          ],
        ),
      ),
    };
  }
}

class _HomeTimerWidget extends ConsumerWidget {
  const _HomeTimerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeTimerState = ref.watch(homeTimer);
    return RepaintBoundary(
      child: Text(
        homeTimerState.uiState == HomeTimerUiState.firstStep
            ? "授信第一阶段倒计时:${homeTimerState.downTime}"
            : (homeTimerState.uiState == HomeTimerUiState.secondStep
                  ? "授信第二阶段倒计时:${homeTimerState.downTime}"
                  : "授信第三阶段"),
      ),
    );
  }
}
