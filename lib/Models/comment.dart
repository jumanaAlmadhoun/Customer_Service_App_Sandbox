import 'package:flutter/cupertino.dart';

class Comment with ChangeNotifier {
  String? comment;
  String? commentCategory;
//------------------------------------------------------
  static const String COMMENT_BODY = 'comment';
  static const String COMMENT_CATEGORY = 'category';
  static const String WATER_COMMENTS = 'WATER';
  static const String FLOWMETER_COMMENTS = 'FLOWMETER';
  static const String WATER_SRC_COMMENTS = 'WATER_SRC';
  static const String CLEAN_COMMENTS = 'CLEAN';
  static const String ELEC_COMMENTS = 'ELEC';
  static const String STEAM_COMMENTS = 'STEAM';
  static const String RECOMENDATION_COMMENTS = 'REC';
  static const String GENERAL_COMMENTS = 'GEN';
 //--------------------PM-----------------------------

  Comment({
    this.comment,
    this.commentCategory,
  });
}
