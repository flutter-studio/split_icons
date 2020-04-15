import 'package:split_icon/split_icon.dart' as split_icon;
import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:io/ansi.dart';

main(List<String> arguments) {
  Platform.environment.forEach((k,v)=>print('$k $v'));
  // 执行命令
  // Process.run(executable, arguments);
  File pubspec = File("./pubspec.yaml");
  var pubspecDoc = loadYaml(pubspec.readAsStringSync());
  List excludes;
  if (pubspecDoc['flutter_icons'] != null &&
      pubspecDoc['flutter_icons']['excludes'] != null) {
    excludes = pubspecDoc['flutter_icons']['excludes'];
    File packages = File('./.packages');
    if (!packages.existsSync()) {
      print(yellow.wrap("${DateTime.now()}: Get the dependencies first"));
      return;
    }
    List<String> lines = packages.readAsLinesSync();
    // flutter_icons:file:///Users/makisu/development/flutter/.pub-cache/hosted/pub.flutter-io.cn/flutter_icons-1.0.0+1/lib/
    var flutterIconPath;
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].contains("flutter_icons")) {
        flutterIconPath = lines[i]
            .replaceAll("flutter_icons:file://", "")
            .replaceAll("/lib/", "");
        break;
      }
    }
    if (flutterIconPath == null) {
      print(yellow.wrap("${DateTime.now()}: Get the flutter_icons dependency first"));
      return;
    }
    File flutterIconsFile = File(flutterIconPath + '/pubspec.yaml');
    var iconsDoc = loadYaml(flutterIconsFile.readAsStringSync());
    Map iconMap = Map.of(iconsDoc);
    Map flutter = Map.of(iconMap['flutter']);
    Map environment = Map.of(iconMap['environment']);
    environment["sdk"] = "\"${environment['sdk']}\"";
    List fonts = List.of(flutter['fonts']);
    fonts.retainWhere((font)=>!excludes.contains(font['family']));
    flutter['fonts'] = fonts;
    iconMap['flutter'] = flutter;
    iconMap['environment'] = environment;
    print(iconMap['environment']['sdk']);
    // flutterIconsFile.writeAsStringSync(iconMap.toString());
  }
  print(green.wrap("${DateTime.now()}: Finish the work"));

}
