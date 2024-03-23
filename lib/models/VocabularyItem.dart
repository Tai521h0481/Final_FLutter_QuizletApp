import 'package:flutter/material.dart';

class VocabularyItem {
  String? id; // ID của từ vựng, nếu có
  TextEditingController termController;
  TextEditingController definitionController;
  String originalTerm; // Giá trị ban đầu của từ
  String originalDefinition; // Giá trị ban đầu của nghĩa


  VocabularyItem({
    this.id,
    required this.termController,
    required this.definitionController,
    required this.originalTerm,
    required this.originalDefinition,
  });
}
