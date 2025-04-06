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
  late String conversationTopic;
  List<String> convo = ["Click below to generate a conversation!"];
  int currSentence = -1;
  late String foreignLanguage;
  bool isGenerating = false;
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
      if( line.startsWith( "Bea: " ) || line.startsWith( "Jay: " ) ) {
        final matches = re.allMatches(line);
        for( Match match in matches ) {
          convo.add( match.group(1)! );
          convo.add( match.group(2)! );
        }
      }
    }
  }

  void speakConvo() async {
    currSentence = 0;
    bool firstVoice = true;
    final voices = await tts.getVoices;

    await tts.setPitch( speechPitch );
    await tts.setSpeechRate( speechRate );
    await tts.setVolume( speechVolume );

    while( currSentence < convo.length ) {
      if( currSentence % 2 == 0 ) {
        await tts.setVoice( Map<String, String>.from( voices[ firstVoice ? 2 : 3 ] ) );
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

    conversationTopic = widget.settings.getString( "conversationTopic" ) ?? defaultData.conversationTopic;
    foreignLanguage = widget.settings.getString( "foreignLanguage" ) ?? defaultData.foreignLanguage;
    nativeLanguage = widget.settings.getString( "nativeLanguage" ) ?? defaultData.nativeLanguage;
    speechPitch = widget.settings.getDouble( "speechPitch" ) ?? defaultData.speechPitch;
    speechRate = widget.settings.getDouble( "speechRate" ) ?? defaultData.speechRate;
    speechVolume = widget.settings.getDouble( "speechVolume" ) ?? defaultData.speechVolume;
    prompt = """
Create a conversation between Bea and Jay about $conversationTopic.
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
        ).toList()..add( ListTile( title: Image.asset( "assets/icon.jpeg" ) ) )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if( isGenerating == false ) {
            isGenerating = true;
            setState( () => convo = ["Generating"] );
            extractConvo( await pipe(prompt) );
            speakConvo();
            setState(() {});
            isGenerating = false;
          }
        },
        child: Icon( Icons.chat )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }
}