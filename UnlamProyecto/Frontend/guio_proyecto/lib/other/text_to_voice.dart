import 'package:flutter_tts/flutter_tts.dart';

FlutterTts tts = FlutterTts();

Future<void> initTts() async {
  try {
    var languages = await tts.getLanguages;
    if (languages.contains("es-AR")) {
      await tts.setLanguage("es-AR");
    } else if (languages.contains("es-ES")) {
      await tts.setLanguage("es-ES");
    } else {
      print("******************************* Idioma no disponible. Usando idioma predeterminado.");
    }

    await tts.setSpeechRate(0.5);
    await tts.setVolume(1.0);
    await tts.setPitch(1.0);
  } catch (e) {
    print("Error al inicializar FlutterTts: $e");
  }
}


Future<void> speak(String text) async {
  await tts.speak(text);
}

Future<void> detenerReproduccion() async {
  await tts.stop();
}