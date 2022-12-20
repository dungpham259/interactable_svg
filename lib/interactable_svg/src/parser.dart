


import 'package:flutter/services.dart' show rootBundle;
import 'package:svg_path_parser/svg_path_parser.dart';

import './size_controller.dart';
import './constant.dart';
import './models/region.dart';


class Parser {
  static Parser? _instance;

  static Parser get instance {
    _instance ??= Parser._init();
    return _instance!;
  }

  final sizeController = SizeController.instance;

  Parser._init();

  Future<List<Region>> svgToRegionList(String svgAddress) async {

    final svgMain = await rootBundle.loadString(
      svgAddress

    );

    List<Region> regionList = [];

    final regExp = RegExp(Constants.MAP_REGEXP,
        multiLine: true, caseSensitive: false, dotAll: false);

    regExp.allMatches(svgMain).forEach((regionData) {
      final region = Region(
          id: regionData.group(1)!,
          name: regionData.group(2)!,
          path: parseSvgPath(regionData.group(3)!));

      sizeController.addBounds(region.path.getBounds());
      regionList.add(region);
    });
    return regionList;
  }
}
