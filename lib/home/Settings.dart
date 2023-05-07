import 'package:final_project_art_direct/home/component_widgets.dart';
import 'package:final_project_art_direct/miscellaneous/buttons.dart';
import 'package:final_project_art_direct/miscellaneous/helper_widgets.dart';
import 'package:final_project_art_direct/miscellaneous/themes.dart';
import 'package:flutter/material.dart';

const TextStyle listBigSingle = TextStyle(
  color: Colors.white,
  fontSize: 20.0,
  fontWeight: FontWeight.w900
);

const TextStyle listTitle = TextStyle(
  color: Colors.white,
  fontSize: 12.0,
  fontWeight: FontWeight.w900
);

const TextStyle listSubtitle = TextStyle(
  color: Colors.white,
  fontSize: 12.0,
  fontWeight: FontWeight.normal
);

const TextStyle listTitleMedium = TextStyle(
  color: Colors.white,
  fontSize: 16.0,
);

const TextStyle listSubtitleMedium = TextStyle(
  color: Color.fromARGB(255, 160, 160, 160),
  fontSize: 16.0,
  fontWeight: FontWeight.normal
);

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: settingsTheme,
      home: Scaffold(
        appBar: topBar(title: 'Settings', context: context),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('Account', style: listBigSingle),
              contentPadding: const EdgeInsets.symmetric(horizontal: 50),
              onTap: () {
                _navigateTo(context, const AccountScreen());
              },
            ),
            ListTile(
              title: const Text('Privacy and Safety', style: listBigSingle),
              contentPadding: const EdgeInsets.symmetric(horizontal: 50),
              onTap: () {
                _navigateTo(context, const PrivacyScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: settingsTheme,
      home: Scaffold(
        appBar: topBar(title: 'Account', context: context),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('Account', style: listTitle,),
              subtitle: const Text('Change your password at anytime', style: listSubtitle,),
              leading: const SizedBox(height: double.infinity, child: Icon(Icons.person, color: Colors.white,)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 50),
              onTap: () {
                _navigateTo(context, AccountInformationScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AccountInformationScreen extends StatelessWidget {
  const AccountInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: settingsTheme,
      home: Scaffold(
        appBar: topBar(title: 'Account', context: context),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('Account', style: listTitleMedium,),
              subtitle: const Text('Display Name', style: listSubtitleMedium,),
              contentPadding: const EdgeInsets.symmetric(horizontal: 50),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Phone', style: listTitleMedium,),
              subtitle: const Text('+63 xxx xxx xxxx', style: listSubtitleMedium,),
              contentPadding: const EdgeInsets.symmetric(horizontal: 50),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Country', style: listTitleMedium,),
              subtitle: const Text('Philippines', style: listSubtitleMedium,),
              contentPadding: const EdgeInsets.symmetric(horizontal: 50),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: settingsTheme,
      home: Scaffold(
        appBar: topBar(title: 'Privacy and Security', context: context),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('Change your password', style: listTitle,),
              subtitle: const Text('Change your password at anytime', style: listSubtitle,),
              leading: const SizedBox(height: double.infinity, child: Icon(Icons.visibility, color: Colors.white,)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 50),
              onTap: () {
                _navigateTo(context, const AccountInformationScreen());
              },
            ),
            ListTile(
              title: const Text('Deactivate Account', style: listTitle,),
              subtitle: const Text('Find out how you can deactivate your account', style: listSubtitle,),
              leading: const SizedBox(height: double.infinity, child: Icon(Icons.account_box, color: Colors.white,)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 50),
              onTap: () {
                _navigateTo(context, const DeactivateAccountPopup());
              },
            ),
            ListTile(
              title: const Text('Security', style: listTitle,),
              subtitle: const Text('Manage your account\'s security', style: listSubtitle,),
              leading: const SizedBox(height: double.infinity, child: Icon(Icons.lock, color: Colors.white,)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 50),
              onTap: () {
                _navigateTo(context, const SecurityScreen());
              },
            ),
            ListTile(
              title: const Text('Connected Accounts', style: listTitle,),
              subtitle: const Text('Manage google or apple accounts connected to ArtDirect log in.', style: listSubtitle,),
              leading: const SizedBox(height: double.infinity, child: Icon(Icons.share, color: Colors.white,)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 50),
              onTap: () {
                _navigateTo(context, const ConnectedAccountsScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ConnectedAccountsScreen extends StatelessWidget {
  const ConnectedAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: settingsTheme,
      home: Scaffold(
        appBar: topBar(title: 'Connected Accounts', context: context),
        body: Column(
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 35.0, top: 20.0),
              child: Text(
                'These are the social accounts you connected to your Twitter account to log in. You can disable access here.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.0,
                  fontFamily: 'Asap',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: settingsTheme,
      home: Scaffold(
        appBar: topBar(title: 'Account', context: context),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('No security set on account.')
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DeactivateAccountPopup extends StatelessWidget {
  const DeactivateAccountPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E2537),
      appBar: AppBar(
        title: const Text('Security'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(
                left: 0.0,
                top: 20.0,
                right: 60.0,
              ),
              child: Text(
                'This will deactivate your account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Asap Condensed',
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 35.0, top: 20.0, right: 35.0),
              child: Text(
                'Your about to start the process of deactivating your ArtDirect account. Your display name, @username and public profile will no longer be viewable on ArtDirect.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.0,
                  fontFamily: 'Asap',
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 0.0,
                top: 20.0,
                right: 100.0,
              ),
              child: Text(
                'What else you should know',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Asap Condensed',
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 35.0, top: 20.0, right: 35.0),
              child: Text(
                'You can restore your Art Direct account if it was accidentally or wrongfully deactivated for up to 30 days after deactivation',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.0,
                  fontFamily: 'Asap',
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 35.0, top: 20.0, right: 35.0),
              child: Text(
                'Some account Information may still be available in search engines such as Google or Bing.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.0,
                  fontFamily: 'Asap',
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 35.0, top: 20.0, right: 35.0),
              child: Text(
                'If you just want to change your @username, you dont have to deactivate your account - edit it in your settings.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.0,
                  fontFamily: 'Asap',
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 35.0, top: 20.0, right: 35.0),
              child: Text(
                'To use your current @username or email address with a different ArtDirect account, change them before you deactivate this account',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.0,
                  fontFamily: 'Asap',
                ),
              ),
            ),
            addVerticalSpace(60),
            BiggerNavigationButton(text: 'Deactivate Account', onTap: () {}, color: Color.fromARGB(255, 109, 27, 27), textColor: Colors.white,)
          ],
        ),
      ),
    );
  }
}

void _navigateTo(BuildContext context, Widget widget) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => widget),
  );
}