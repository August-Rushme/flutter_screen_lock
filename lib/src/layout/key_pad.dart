import 'package:flutter/material.dart';
import 'package:flutter_screen_lock_august/flutter_screen_lock_august.dart';
import 'package:flutter_screen_lock_august/src/layout/key_pad_button.dart';

/// [GridView] or [Wrap] make it difficult to specify the item size intuitively.
/// We therefore arrange them manually with [Column]s and [Row]s
class KeyPad extends StatelessWidget {
  const KeyPad({
    super.key,
    required this.inputState,
    required this.didCancelled,
    this.enabled = true,
    KeyPadConfig? config,
    this.customizedButtonChild,
    this.customizedButtonTap,
    this.deleteButton,
    this.cancelButton,
    this.okButton, // 新添加的参数
    this.onOkButtonPressed, // 新添加的参数
  }) : config = config ?? const KeyPadConfig();
  final Widget? okButton;
  final Future<bool> Function(String input)? onOkButtonPressed;
  final InputController inputState;
  final VoidCallback? didCancelled;
  final bool enabled;
  final KeyPadConfig config;
  final Widget? customizedButtonChild;
  final VoidCallback? customizedButtonTap;
  final Widget? deleteButton;
  final Widget? cancelButton;

  KeyPadButtonConfig get actionButtonConfig =>
      config.actionButtonConfig ?? const KeyPadButtonConfig(fontSize: 18);
  Widget _buildOkButton() {
    // 如果没有提供 okButton 和 onOkButtonPressed，则显示隐藏的按钮
    if (okButton == null || onOkButtonPressed == null) {
      return _buildHiddenButton();
    }

    return KeyPadButton.transparent(
      onPressed: enabled
          ? () async {
              // 获取当前输入的密码
              String currentInput = inputState.currentInput.value;
              // 调用 onOkButtonPressed 回调，并传递当前输入
              bool validationResult = await onOkButtonPressed!(currentInput);
              // 根据 validationResult 可以进一步处理，例如显示提示或者关闭屏幕锁
              if (validationResult) {
                // 可以在这里添加验证成功后的逻辑
              } else {
                // 可以在这里添加验证失败后的逻辑
              }
            }
          : null,
      config: actionButtonConfig,
      child: okButton ??
          const Text(
            'OK',
            textAlign: TextAlign.center,
          ),
    );
  }

  Widget _buildDeleteButton() {
    return KeyPadButton.transparent(
      onPressed: () => inputState.removeCharacter(),
      onLongPress: config.clearOnLongPressed ? () => inputState.clear() : null,
      config: actionButtonConfig,
      child: deleteButton ?? const Icon(Icons.backspace),
    );
  }

  Widget _buildCancelButton() {
    if (didCancelled == null) {
      return _buildHiddenButton();
    }

    return KeyPadButton.transparent(
      onPressed: didCancelled,
      config: actionButtonConfig,
      child: cancelButton ??
          const Text(
            'Cancel',
            textAlign: TextAlign.center,
          ),
    );
  }

  Widget _buildHiddenButton() {
    return KeyPadButton.transparent(
      onPressed: null,
      config: actionButtonConfig,
    );
  }

  Widget _buildRightSideButton() {
    return ValueListenableBuilder<String>(
      valueListenable: inputState.currentInput,
      builder: (context, value, child) {
        if (!enabled || value.isEmpty) {
          return _buildCancelButton();
        } else {
          return _buildDeleteButton();
        }
      },
    );
  }

  Widget _buildLeftSideButton() {
    if (customizedButtonChild == null) {
      return _buildHiddenButton();
    }

    return KeyPadButton.transparent(
      onPressed: customizedButtonTap!,
      config: actionButtonConfig,
      child: customizedButtonChild!,
    );
  }

  Widget _generateRow(BuildContext context, int rowNumber) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final number = (rowNumber - 1) * 3 + index + 1;
        final input = config.inputStrings[number];
        final display = config.displayStrings[number];

        return KeyPadButton(
          config: config.buttonConfig,
          onPressed: enabled ? () => inputState.addCharacter(input) : null,
          child: Text(display),
        );
      }),
    );
  }

  Widget _generateLastRow(BuildContext context) {
    final input = config.inputStrings[0];
    final display = config.displayStrings[0];

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildOkButton(),
        KeyPadButton(
          config: config.buttonConfig,
          onPressed: enabled ? () => inputState.addCharacter(input) : null,
          child: Text(display),
        ),
        _buildRightSideButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(config.displayStrings.length == 11);
    assert(config.inputStrings.length == 11);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _generateRow(context, 1),
        _generateRow(context, 2),
        _generateRow(context, 3),
        _generateLastRow(context),
      ],
    );
  }
}
