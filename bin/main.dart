import 'package:split_icon/split_icon.dart' as split_icon;
import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:io/ansi.dart';

import 'temp.dart';

main(List<String> arguments) {
  // Platform.environment.forEach((k,v)=>print('$k $v'));
  // 执行命令
  // Process.run(executable, arguments);
  File pubspec = File("./pubspec.yaml");
  var pubspecDoc = loadYaml(pubspec.readAsStringSync());
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
          .replaceAll("flutter_icons:file://${Platform.isWindows?'/':''}", "")
          .replaceAll("/lib/", "");
      break;
    }
  }
  if (flutterIconPath == null) {
    print(yellow
        .wrap("${DateTime.now()}: Get the flutter_icons dependency first"));
    return;
  }
  File flutterIconsFile = File(flutterIconPath + '/pubspec.yaml');
  List includes;
  String yamlString = tempYaml;
  if (pubspecDoc['flutter_icons'] != null &&
      pubspecDoc['flutter_icons']['includes'] != null) {
    includes = pubspecDoc['flutter_icons']['includes'];
    includes.forEach((key){
      yamlString += fontsMap[key];
    });
  }else{
    yamlString += allFonts;
  }
  flutterIconsFile.writeAsStringSync(yamlString);
  print(green.wrap("${DateTime.now()}: Finish the work"));
}
