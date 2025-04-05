import 'package:duocast/data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({
    super.key,
    required this.settings
  });

  final SharedPreferences settings;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late int foreignLanguage;
  late int nativeLanguage;

  @override
  void initState() {
    super.initState();

    foreignLanguage = widget.settings.getInt( "foreignLanguage" ) ?? defaultData.foreignLanguage;
    nativeLanguage = widget.settings.getInt( "nativeLanguage" ) ?? defaultData.nativeLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownMenu(
                dropdownMenuEntries: [
                  DropdownMenuEntry(
                    label: "English",
                    value: 0
                  ),
                  DropdownMenuEntry(
                    label: "French",
                    value: 1
                  ),
                  DropdownMenuEntry(
                    label: "Spanish",
                    value: 2
                  )
                ],
                initialSelection: foreignLanguage,
                label: Text( "Foreign language" ),
                onSelected: (value) {
                  setState( () => foreignLanguage = value! );
                  widget.settings.setInt( "foreignLanguage", foreignLanguage );
                }
              ),
              DropdownMenu(
                dropdownMenuEntries: [
                  DropdownMenuEntry(
                    label: "English",
                    value: 0
                  ),
                  DropdownMenuEntry(
                    label: "French",
                    value: 1
                  ),
                  DropdownMenuEntry(
                    label: "Spanish",
                    value: 2
                  )
                ],
                initialSelection: nativeLanguage,
                label: Text( "Native language" ),
                onSelected: (value) {
                  setState( () => nativeLanguage = value! );
                  widget.settings.setInt( "nativeLanguage", nativeLanguage );
                }
              )
            ]
          )
        )
      ]
    );
  }
}