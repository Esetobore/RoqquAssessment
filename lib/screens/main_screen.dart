import 'package:flutter/material.dart';
import 'package:roqquassessment/constants/image_path.dart';
import 'package:roqquassessment/screens/widgets/bottom_buttons.dart';
import 'package:roqquassessment/screens/widgets/chart_order.dart';
import 'package:roqquassessment/screens/widgets/mini_menu.dart';
import 'package:roqquassessment/screens/widgets/price_header.dart';
import 'package:roqquassessment/screens/widgets/trades.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Builder(
            builder: (context) {
              final platformBrightness =
                  MediaQuery.platformBrightnessOf(context);
              return Image(
                image: AssetImage(
                  platformBrightness == Brightness.light
                      ? ImagePaths.lLogo // Light mode logo
                      : ImagePaths.dLogo, // Dark mode logo
                ),
                height: 40, // Adjust height as needed
                fit: BoxFit.contain,
              );
            },
          ),
          centerTitle: false,
          actions: [
            IconButton(
                onPressed: () {},
                icon: Image.asset(ImagePaths.avatar, height: 32, width: 32)),
            IconButton(
                onPressed: () {},
                icon: Image.asset(ImagePaths.icGlobe, height: 24, width: 24)),
            IconButton(
                onPressed: () => showDialog(
                    context: context,
                    builder: (context) => Dialog(
                        alignment: Alignment.topRight,
                        insetPadding: const EdgeInsets.only(
                            left: 100.0, top: 24.0, right: 24.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.secondary),
                        ), //this right here
                        child: const Menu())),
                icon: Image.asset(ImagePaths.icMenu, height: 32, width: 32)),
            const SizedBox(width: 15.0)
          ],
        ),
        body: ListView(
          children: const [
            PrinceHeader(),
            ChartOrder(),
            Trades(),
            BottomButtons(),
          ],
        ));
  }
}
