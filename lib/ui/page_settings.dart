import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  final User? user;

  const SettingsPage({Key? key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {

  Future<void> sharePage() async {
    await Share.share(
        "Organize your tasks better with #actify available on Android and iOS");
  }

  Future<void> rateApp() async {
    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    } else {
      // Fallback to opening store listing
      inAppReview.openStoreListing(
        appStoreId: '1435481664', // Your iOS App ID
      );
    }
  }

  Future<void> _launchURL() async {
    final Uri url = Uri.parse('https://twitter.com/HugoExtrat');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              _getToolbar(context),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Text(
                            'Task',
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: 28.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: 50.0)),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Card(
                color: Colors.white,
                elevation: 2.0,
                child: Column(
                  children: <Widget>[
                    const ListTile(
                      leading: Icon(
                        FontAwesomeIcons.cogs,
                        color: Colors.grey,
                      ),
                      title: Text("Version"),
                      trailing: Text("1.0.0"),
                    ),
                    ListTile(
                      onTap: _launchURL,
                      leading: const Icon(
                        FontAwesomeIcons.twitter,
                        color: Colors.blue,
                      ),
                      title: const Text("Twitter"),
                      trailing: const Icon(Icons.arrow_right),
                    ),
                    ListTile(
                      onTap: rateApp,
                      leading: const Icon(
                        FontAwesomeIcons.star,
                        color: Colors.blue,
                      ),
                      title: const Text("Rate actify"),
                      trailing: const Icon(Icons.arrow_right),
                    ),
                    ListTile(
                      onTap: sharePage,
                      leading: const Icon(
                        FontAwesomeIcons.shareAlt,
                        color: Colors.blue,
                      ),
                      title: const Text("Share actify"),
                      trailing: const Icon(Icons.arrow_right),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Padding _getToolbar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Image(
            width: 40.0,
            height: 40.0,
            fit: BoxFit.cover,
            image: AssetImage('assets/list.png'),
          ),
        ],
      ),
    );
  }
}