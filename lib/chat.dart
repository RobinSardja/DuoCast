import 'package:duocast/data.dart';
import 'package:flutter/material.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final languages = ["english", "french", "spanish"];
  late String nativeLanguage;
  late String prompt;
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
    await tts.stop();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    foreignLanguage = languages[ widget.settings.getInt("foreignLanguage") ?? defaultData.foreignLanguage ];
    nativeLanguage = languages[ widget.settings.getInt("nativeLanguage") ?? defaultData.nativeLanguage ];
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