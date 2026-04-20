import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forui/forui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_stock/app/config/assets.dart';
import 'package:smart_stock/app/config/constants.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/_core/theme/custom_forui.dart';

//TODO: Responsiveness. In any screen resolution less than 412px the app breaks. And also on horizontal orientation
@RoutePage()
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const slogan = 'Seu inventário inteligente.';
    const presentationText =
        'Grave os produtos do seu banco de dados nas etiquetas RFID e depois as use para fazer os inventários.';

    final typography = context.theme.typography;

    final logoDecoration = GoogleFonts.kodchasan(
      fontSize: typography.xl4.fontSize,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      shadows: [const Shadow(color: Colors.black, offset: Offset(2, 2))],

      height: 0,
    );

    final Widget logo = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            if (AppConfig.useNewlandTheme)
              SvgPicture.asset(Assets.newlandLogo, height: MediaQuery.of(context).size.height / 32)
            else
              Icon(
                FIcons.origami,
                size: MediaQuery.of(context).size.height / 32,
                color: Colors.white,
              ),
            Text('SmartStock', style: logoDecoration, textAlign: TextAlign.center),
          ],
        ),
        Text(
          'RFID',
          style: typography.xl3.copyWith(
            color: AppConfig.useNewlandTheme ? Colors.red : Colors.lightBlueAccent,
            height: 0,
            shadows: [const Shadow(color: Colors.black, offset: Offset(2, 2))],
            letterSpacing: 8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );

    final Widget main = Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 12),
      child: Column(
        spacing: 12,
        children: [
          // logo,
          // const SizedBox(height: 200),
          Text(
            slogan,
            style: typography.xl2.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              height: 1.5,
              shadows: [const Shadow(color: Colors.black, offset: Offset(2, 2))],
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            presentationText,
            style: typography.lg.copyWith(
              color: Colors.white,
              height: 1.5,
              shadows: [const Shadow(color: Colors.black, offset: Offset(2, 2))],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    final Widget footer = FButton(
      onPress: () {
        context.router.replaceAll([const HomeRoute()]);
      },
      style: primaryLargeButton(context),
      child: Text(
        'Vamos começar',
        style: typography.xl2.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(Assets.stockPhoto), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [logo, main, footer],
            ),
          ),
        ),
      ),
    );
  }
}
