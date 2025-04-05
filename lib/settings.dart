import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'data.dart';

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
  late String conversationTopic;
  late String foreignLanguage;
  late String nativeLanguage;
  late double speechPitch;
  late double speechRate;
  late double speechVolume;

  @override
  void initState() {
    super.initState();

    conversationTopic = widget.settings.getString( "conversationTopic" ) ?? defaultData.conversationTopic;
    foreignLanguage = widget.settings.getString( "foreignLanguage" ) ?? defaultData.foreignLanguage;
    nativeLanguage = widget.settings.getString( "nativeLanguage" ) ?? defaultData.nativeLanguage;
    speechPitch = widget.settings.getDouble( "speechPitch" ) ?? defaultData.speechPitch;
    speechRate = widget.settings.getDouble( "speechRate" ) ?? defaultData.speechRate;
    speechVolume = widget.settings.getDouble( "speechVolume" ) ?? defaultData.speechVolume;
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
                    value: "english"
                  ),
                  DropdownMenuEntry(
                    label: "French",
                    value: "french"
                  ),
                  DropdownMenuEntry(
                    label: "Spanish",
                    value: "spanish"
                  )
                ],
                initialSelection: foreignLanguage,
                label: Text( "Foreign language" ),
                onSelected: (value) {
                  setState( () => foreignLanguage = value! );
                  widget.settings.setString( "foreignLanguage", foreignLanguage );
                }
              ),
              DropdownMenu(
                dropdownMenuEntries: [
                  DropdownMenuEntry(
                    label: "English",
                    value: "english"
                  ),
                  DropdownMenuEntry(
                    label: "French",
                    value: "french"
                  ),
                  DropdownMenuEntry(
                    label: "Spanish",
                    value: "spanish"
                  )
                ],
                initialSelection: nativeLanguage,
                label: Text( "Native language" ),
                onSelected: (value) {
                  setState( () => nativeLanguage = value! );
                  widget.settings.setString( "nativeLanguage", nativeLanguage );
                }
              )
            ]
          )
        ),
        ListTile(
          title: Center(
            child: DropdownMenu(
              dropdownMenuEntries: [
                DropdownMenuEntry(
                  label: "Dinner plans",
                  value: "dinner plans"
                ),
                DropdownMenuEntry(
                  label: "New Year's resolutions",
                  value: "New Year's resolutions"
                ),
                DropdownMenuEntry(
                  label: "Vacation ideas",
                  value: "vacation ideas"
                )
              ],
              initialSelection: conversationTopic,
              label: Text( "Conversation topic" ),
              onSelected: (value) {
                setState( () => conversationTopic = value! );
                widget.settings.setString( "conversationTopic", conversationTopic );
              }
            )
          )
        ),
        ListTile( title: Center( child: Text( "Speech pitch: $speechPitch" ) ) ),
        ListTile(
          title: Slider(
            divisions: 20,
            max: 2.0,
            onChanged: (value) => setState( () => speechPitch = value ),
            onChangeEnd: (value) => widget.settings.setDouble( "speechPitch", value ),
            value: speechPitch
          )
        ),
        ListTile( title: Center( child: Text( "Speech rate: $speechRate" ) ) ),
        ListTile(
          title: Slider(
            divisions: 20,
            max: 2.0,
            onChanged: (value) => setState( () => speechRate = value ),
            onChangeEnd: (value) => widget.settings.setDouble( "speechRate", value ),
            value: speechRate
          )
        ),
        ListTile( title: Center( child: Text( "Speech volume: $speechVolume" ) ) ),
        ListTile(
          title: Slider(
            divisions: 20,
            max: 2.0,
            onChanged: (value) => setState( () => speechVolume = value ),
            onChangeEnd: (value) => widget.settings.setDouble( "speechVolume", value ),
            value: speechVolume
          )
        )
      ]
    );
  }
}