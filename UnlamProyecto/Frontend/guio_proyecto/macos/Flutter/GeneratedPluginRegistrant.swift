//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import device_info_plus
import path_provider_foundation
import shared_preferences_foundation
import speech_to_text_macos
import text_to_speech_macos
import url_launcher_macos

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  DeviceInfoPlusMacosPlugin.register(with: registry.registrar(forPlugin: "DeviceInfoPlusMacosPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  SpeechToTextMacosPlugin.register(with: registry.registrar(forPlugin: "SpeechToTextMacosPlugin"))
  TextToSpeechMacOsPlugin.register(with: registry.registrar(forPlugin: "TextToSpeechMacOsPlugin"))
  UrlLauncherPlugin.register(with: registry.registrar(forPlugin: "UrlLauncherPlugin"))
}
