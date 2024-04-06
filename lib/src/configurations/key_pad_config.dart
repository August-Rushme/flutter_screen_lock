/*
 * @Author: August_rush
 * @Date: 2024-03-27 11:30:56
 * @LastEditors: August_rush 864011713@qq.com
 * @LastEditTime: 2024-04-06 15:41:43
 * @FilePath: \flutter_screen_lock_august\lib\src\configurations\key_pad_config.dart
 * @Description: 
 * 
 * Copyright (c) 2024 by ${git_name_email}, All Rights Reserved. 
 */
import 'package:flutter_screen_lock_august/flutter_screen_lock_august.dart';

class KeyPadConfig {
  const KeyPadConfig({
    this.buttonConfig,
    this.actionButtonConfig,
    this.inputStrings = _numbers,
    List<String>? displayStrings,
    this.clearOnLongPressed = false,
  }) : displayStrings = displayStrings ?? inputStrings;

  /// Config for numeric [KeyPadButton]s.
  final KeyPadButtonConfig? buttonConfig;

  /// Config for actionable [KeyPadButton]s.
  final KeyPadButtonConfig? actionButtonConfig;

  /// The strings the user can input.
  final List<String> inputStrings;

  /// The strings that are displayed to the user.
  /// Mapped 1:1 to [inputStrings].
  /// Defaults to [inputStrings].
  final List<String> displayStrings;

  /// Whether to clear the input when long pressing the clear key.
  final bool clearOnLongPressed;

  static const List<String> _numbers = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'OK',
  ];

  /// Copies a [KeyPadConfig] with new values.
  KeyPadConfig copyWith({
    KeyPadButtonConfig? buttonConfig,
    List<String>? inputStrings,
    List<String>? displayStrings,
    bool? clearOnLongPressed,
  }) {
    return KeyPadConfig(
      buttonConfig: buttonConfig ?? this.buttonConfig,
      inputStrings: inputStrings ?? this.inputStrings,
      displayStrings: displayStrings ?? this.displayStrings,
      clearOnLongPressed: clearOnLongPressed ?? this.clearOnLongPressed,
    );
  }
}
