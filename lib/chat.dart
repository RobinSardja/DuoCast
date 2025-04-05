import 'package:flutter/material.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data.dart';
import 'gemini.dart';

class Chat extends StatefulWidget {
  const Chat({
    super.key,
    required this.settings
  });

  final SharedPreferences settings;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<String> convo = ["Click below to generate a conversation!"];
  int currSentence = -1;
  late String foreignLanguage;
  late String nativeLanguage;
  late String prompt;
  late double speechPitch;
  late double speechRate;
  late double speechVolume;
  FlutterTts tts = FlutterTts();

  void extractConvo( String output ) {
    final lines = output.split('\n');
    final re = RegExp( r'\[(.*?)\]\((.*?)\)' );

    convo.clear();
    for( String line in lines ) {
      if( line.startsWith( "Bea:" ) || line.startsWith( "Jay: " ) ) {
        final matches = re.allMatches(line);
        for( Match match in matches ) {
          convo.add( match.group(1)! );
          convo.add( match.group(2)! );
        }
      }
    }
  }

  void speakConvo() async {
    final voices = await tts.getVoices;
    bool firstVoice = true;
    currSentence = 0;

    await tts.setPitch( speechPitch );
    await tts.setSpeechRate( speechRate );
    await tts.setVolume( speechVolume );

    while( currSentence < convo.length ) {
      if( currSentence % 2 == 0 ) {
        await tts.setVoice( Map<String, String>.from( voices[ firstVoice ? 0 : 1 ] ) );
        firstVoice = !firstVoice;
      }
      await tts.awaitSpeakCompletion(true);
      await tts.speak( convo[currSentence] );
      setState( () => currSentence++ );
    }
  }

  @override
  void dispose() async {
    super.dispose();

    await tts.stop();
  }

  @override
  void initState() {
    super.initState();

    foreignLanguage = widget.settings.getString( "foreignLanguage" ) ?? defaultData.foreignLanguage;
    nativeLanguage = widget.settings.getString( "nativeLanguage" ) ?? defaultData.nativeLanguage;
    speechPitch = widget.settings.getDouble( "speechPitch" ) ?? defaultData.speechPitch;
    speechRate = widget.settings.getDouble( "speechRate" ) ?? defaultData.speechRate;
    speechVolume = widget.settings.getDouble( "speechVolume" ) ?? defaultData.speechVolume;
    prompt = """
Create a conversation between Bea and Jay about their vacation plans.
Start off with societally expected formalities.
Use basic conversational language.
Display each person's original response in $nativeLanguage in square brackets and translated in $foreignLanguage in parantheses like so:
Bea: [$nativeLanguage]($foreignLanguage)
Jay: [$nativeLanguage]($foreignLanguage)
""";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: convo.asMap().entries.map(
          (entry) => ListTile(
            selected: entry.key == currSentence,
            title: Text( entry.value, textAlign: TextAlign.center )
          )
        ).toList()
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState( () => convo = ["Generating"] );
          extractConvo( await pipe(prompt) );
          speakConvo();
          setState(() {});
        },
        child: Icon( Icons.chat )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }
}