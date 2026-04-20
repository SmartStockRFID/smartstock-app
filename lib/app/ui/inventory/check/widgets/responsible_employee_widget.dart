import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/config/assets.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/_core/widgets/custom_card.dart';
import 'package:smart_stock/app/ui/inventory/check/logic/future_providers.dart';

class ResponsibleEmployee extends ConsumerWidget {
  const ResponsibleEmployee();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typography = context.theme.typography;
    final currentUser = ref.watch(currentUserProvider);
    return CustomCard(
      sizedBoxHeight: 1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FAvatar(image: const AssetImage(Assets.avatarPlaceholder)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  currentUser.when(
                        data: (data) => data,
                        error: (err, trace) => 'Desconhecido',
                        loading: () => 'Carregando...',
                      ) ??
                      'admin',
                  style: typography.xl.copyWith(fontWeight: FontWeight.bold, height: 1.2),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Text('Funcionário conectado'),
              ],
            ),
          ),
          FButton(
            style: FButtonStyle.outline(),
            onPress: () async {
              await context.router.push(LoginRoute());
              ref.invalidate(currentUserProvider, asReload: true);
            },
            child: const Icon(FIcons.arrowRightLeft),
          ),
        ],
      ),
    );
  }
}
