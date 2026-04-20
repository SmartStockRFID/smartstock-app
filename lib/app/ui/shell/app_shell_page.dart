import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:forui/forui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_stock/app/config/assets.dart';
import 'package:smart_stock/app/config/constants.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/_core/widgets/app_bar.dart';
import 'package:smart_stock/app/ui/shell/logic/quick_read_provider.dart';
import 'package:smart_stock/app/ui/shell/widgets/app_drawer.dart';
import 'package:smart_stock/app/ui/shell/widgets/first_session_toast_widget.dart';
import 'package:smart_stock/app/ui/shell/widgets/quick_read_sheet_widget.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';

@RoutePage()
class AppShellPage extends HookConsumerWidget {
  const AppShellPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isModalOpen = useState(false);

    ref.listen(quickReadProvider, (_, state) async {
      if ((ModalRoute.of(context)?.isCurrent ?? false) && state.hasValue && !isModalOpen.value) {
        isModalOpen.value = true;
        Vibration.vibrate(preset: VibrationPreset.quickSuccessAlert);

        await showQuickReadSheet(context, state.value!);
        isModalOpen.value = false;
      }
    });

    return AutoTabsRouter(
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        final String routeName = tabsRouter.topMatch.name;
        final bool isAtHome = routeName == HomeRoute.name;

        return Scaffold(
          appBar: _getAppBar(context, routeName, isAtHome),
          backgroundColor: Colors.white,
          body: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (isAtHome) {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              } else {
                context.router.replaceAll(const [HomeRoute()]);
              }
            },
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: FToaster(child: FirstSessionToastRunner(child: child)),
              ),
            ),
          ),
          drawer: isAtHome ? const MainDrawer() : null,
        );
      },
    );
  }

  AppBar? _getAppBar(BuildContext context, String routeName, bool isAtHome) {
    if (isAtHome) {
      return baseAppBar(
        widgetTitle: AppConfig.useNewlandTheme
            ? SvgPicture.asset(Assets.newlandLogo, height: MediaQuery.of(context).size.height / 20)
            : Icon(FIcons.origami, size: MediaQuery.of(context).size.height / 20),
      );
    }

    final backButton = BackButton(
      onPressed: () {
        context.router.replaceAll([const HomeRoute()]);
      },
    );

    return baseAppBar(
      title: routesTitles[routeName],
      leadingButton: backButton,
      actions: routeName == EncodingSetupRoute.name
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: const Icon(FIcons.history, size: 24, color: Colors.white),
                  onPressed: () {
                    context.router.push(const EncodingHistoryRoute());
                  },
                ),
              ),
            ]
          : [],
    );
  }
}
