import 'package:flutter/material.dart';
import 'package:shop_max/localization/localization_constants.dart';
import 'package:shop_max/models/language.dart';
import 'package:shop_max/widgets/app_drawer.dart';

import '../main.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings-screen';
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var valueLanguage = '';

  void _changeLanguage(Language language) async {
    Locale _temp = await setLocale(language.languageCode);
    MyApp.setLocale(context, _temp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, 'settings')),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: DropdownButton(
          onChanged: (Language language) {
            _changeLanguage(language);
            valueLanguage = language.name;
          },
          icon: Icon(
            Icons.language,
            color: Colors.black,
          ),
          //value: _value,
          hint: Text(valueLanguage == ''
              ? getTranslated(context, 'select_language')
              : valueLanguage),
          items: Language.languageList()
              .map<DropdownMenuItem<Language>>((lang) => DropdownMenuItem(
                    value: lang,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(lang.flag),
                        Text(
                          lang.name,
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
