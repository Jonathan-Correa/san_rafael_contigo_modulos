import 'package:flutter/material.dart';

class PasswordChangeDigits {
  final List<CodeDigit> digits = [
    CodeDigit(controller: TextEditingController(), focusNode: FocusNode()),
    CodeDigit(controller: TextEditingController(), focusNode: FocusNode()),
    CodeDigit(controller: TextEditingController(), focusNode: FocusNode()),
    CodeDigit(controller: TextEditingController(), focusNode: FocusNode()),
    CodeDigit(controller: TextEditingController(), focusNode: FocusNode()),
    CodeDigit(controller: TextEditingController(), focusNode: FocusNode()),
  ];

  void dispose() {
    for (var digit in digits) {
      digit.controller.dispose();
      digit.focusNode.dispose();
    }
  }

  bool isCodeComplete() {
    for (var digit in digits) {
      if (digit.controller.text.isEmpty) return false;
    }

    return true;
  }

  String getCode() {
    String code = '';

    for (var digit in digits) {
      code += digit.controller.text;
    }

    return code;
  }
}

class CodeDigit {
  final TextEditingController controller;
  final FocusNode focusNode;

  const CodeDigit({
    required this.controller,
    required this.focusNode,
  });
}
