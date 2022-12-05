import 'package:flutter/material.dart';
import 'dart:math' as math;

class AppUtils {
  static bool emailValidation(String value) {
    final validEmail = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return validEmail.hasMatch(value);
  }

  static String? fieldEmpty(String? value) {
    if (value!.isNotEmpty) {
      return null;
    } else {
      return "Field cannot be empty";
    }
  }

  static bool numericValidation(String value) {
    final validNum = RegExp(r"^[1-9]\d*(\.\d+)?$");
    return validNum.hasMatch(value);
  }

  static String? emailValidate(String? value) {
    if (value!.isNotEmpty) {
      if (emailValidation(value.trim())) {
        return null;
      } else {
        return "Invalid email";
      }
    } else {
      return "Enter your email";
    }
  }

  static String? numberValidate(String? value) {
    if (value!.isNotEmpty) {
      if (numericValidation(value.trim())) {
        return null;
      } else {
        return "Invalid number";
      }
    } else {
      return "Field cannot be empty";
    }
  }

  static String? passwordValidate(String? value) {
    if (value!.isNotEmpty) {
      if (value.length < 6) {
        return "Password must be at least 6 characters";
      } else {
        return null;
      }
    } else {
      return "Enter your password";
    }
  }

  static String? passwordValidateWithEquality(String? value, String? value2) {
    if (value!.isNotEmpty) {
      if (value.length < 6) {
        return "Password must be at least 6 characters";
      } else if (value != value2) {
        return "Passwords do not match";
      } else {
        return null;
      }
    } else {
      return "Enter your password";
    }
  }

  static String? phoneValidate(String? value) {
    if (value!.isNotEmpty) {
      if (value.length < 10 || value.length > 10) {
        return "Invalid phone number";
      } else {
        return null;
      }
    } else {
      return "Field cannot be empty";
    }
  }

  static Future<void> getDatePicker(BuildContext context,
      {required DateTime initialDate,
      required Function(DateTime date) onDatePicked,
      DateTime? firstDate}) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime.now(),
        lastDate: DateTime(2100));
    if (picked != null && picked != initialDate) onDatePicked(picked);
  }

  static Future<void> getTimePicker(BuildContext context, TimeOfDay initialTime,
      Function(TimeOfDay timeOfDay) onTimePicked) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
    );

    if (pickedTime != null && pickedTime != initialTime) {
      onTimePicked(pickedTime);
    }
  }

  ///Creates a super secure password with given input
  static String generatePassword({
    bool letter = true,
    bool numbersInclusive = true,
    bool specialInclusive = true,
    bool onlyUppercase = false,
    int length = 20,
  }) {
    assert(length >= 6);
    const letterLowerCase = "abcdefghijklmnopqrstuvwxyz";
    const letterUpperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    const number = '0123456789';
    const special = '@#%^*>\$@?/[]=+';

    String chars = "";
    if (letter) {
      if (onlyUppercase) {
        chars += letterUpperCase;
      } else {
        chars += '$letterLowerCase$letterUpperCase';
      }
    }

    if (numbersInclusive) chars += number;
    if (specialInclusive) chars += special;

    return List.generate(length, (index) {
      final indexRandom = math.Random.secure().nextInt(chars.length);
      return chars[indexRandom];
    }).join('');
  }

  ///Generates readable text from total duration passed in as parameter
  ///
  ///For example:
  ///`convertSecondstoTimeframe(Duration(seconds:2000))` returns _"33 minutes"_
  static String convertSecondstoTimeframe(Duration duration,
      {bool shortNames = false, bool uppercase = false}) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    String hourText = "hours";
    String minuteText = "minutes";
    String secondText = "seconds";

    if (shortNames) {
      hourText = "h";
      minuteText = "m";
      secondText = "s";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours != 0) {
      return "${twoDigits(duration.inHours)} $hourText $twoDigitMinutes $minuteText $twoDigitSeconds $secondText";
    } else if (duration.inMinutes != 0) {
      return "$twoDigitMinutes $minuteText $twoDigitSeconds $secondText";
    } else {
      return "$twoDigitSeconds $secondText";
    }
  }

  static String formatTimer(Duration d) {
    final minutes = _pad2(d.inMinutes % 60);
    final seconds = _pad2(d.inSeconds % 60);
    final hours = _pad2(d.inHours);

    return '$hours:$minutes:$seconds';
  }

  static String _pad2(int i) => i.toString().padLeft(2, '0');
}
