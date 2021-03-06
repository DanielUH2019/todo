import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/pages/login_page.dart';
import 'package:todo/components/ussd_widget.dart';
import 'package:todo/components/disclaim.dart';
import 'package:connectivity/connectivity.dart';
import 'package:todo/pages/settings_page.dart';
import 'package:provider/provider.dart';
import 'package:todo/services/AppStateNotifier.dart';
import 'package:todo/pages/account_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  IconData networkIcon;
  var suscription;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then(
      (prefs) {
        final dm = prefs.getBool('darkmode');
        if (dm != null)
          Provider.of<AppStateNotifier>(context, listen: false).updateTheme(dm);
      },
    );

    suscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile) {
        setState(() {
          networkIcon = Icons.network_cell;
        });
      } else if (result == ConnectivityResult.wifi) {
        setState(() {
          networkIcon = Icons.network_wifi;
        });
      } else {
        setState(() {
          networkIcon = Icons.network_locked;
        });
      }
    });
  }

  @override
  void dispose() {
    suscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SharedPreferences.getInstance().then((prefs) {
      final dok = prefs.getBool('dok1.1');

      if (dok == null || !dok)
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DisclaimerWidget(),
          ),
        );
    });

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).focusColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(
                title: 'NAUTA',
              ),
            ),
          );
        },
        child: Icon(
          Icons.wifi,
          color: Colors.white,
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(networkIcon),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(
                        title: 'NAUTA',
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AccountPage(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(
                        title: 'Ajustes',
                      ),
                    ),
                  );
                },
              ),
            ],
            expandedHeight: MediaQuery.of(context).size.height / 3,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              background: Center(
                child: ImageIcon(
                  AssetImage("logo.png"),
                  color: Colors.white,
                  size: 96,
                ),
              ),
            ),
          ),
          UssdRootWidget(),
        ],
      ),
    );
  }
}
