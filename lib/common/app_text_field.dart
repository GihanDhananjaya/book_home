import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/app_colors.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final Widget? icon;
  Widget? action;
  final String? hint;
  final String? errorMessage;
  final Function(String)? onTextChanged;
  final TextInputType? inputType;
  final bool? isEnable;
  final int? maxLength;
  final String? guideTitle;
  final bool? obscureText;
  final bool? shouldRedirectToNextField;
  final String? regex;
  final int? maxLines;
  final bool? isCurrency;
  final FocusNode? focusNode;
  final Function(String)? onSubmit;

  AppTextField(
      {this.controller,
        this.icon,
        this.action,
        this.hint,
        this.guideTitle,
        this.errorMessage,
        this.maxLength = 50,
        this.maxLines = 1,
        this.onTextChanged,
        this.inputType,
        this.regex,
        this.focusNode,
        this.onSubmit,
        this.isEnable = true,
        this.obscureText = false,
        this.isCurrency = false,
        this.shouldRedirectToNextField = true});

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  double borderRadius = 5;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.hint}${widget.isCurrency! ? ' (Rs)' : ''}',
          style: TextStyle(fontSize: 12.5, color: AppColors.fontLabelGray),
        ),
        const SizedBox(
          height: 2,
        ),
        TextField(
          onChanged: (text) {
            setState(() {
              if (widget.regex != null && text.isEmpty) {
                widget.action = null;
              } else {
                if (widget.regex != null && widget.regex!.isNotEmpty) {
                  if (RegExp(widget.regex!).hasMatch(text)) {
                    widget.action = const Icon(
                      CupertinoIcons.checkmark_circle_fill,
                      color: AppColors.colorSuccess,
                    );
                  } else {
                    widget.action = const Icon(
                      CupertinoIcons.multiply_circle_fill,
                      color: AppColors.colorFailed,
                    );
                  }
                }
              }
            });

            if (widget.onTextChanged != null) {
              widget.onTextChanged!(text);
            }
          },
          onSubmitted: (value) {
            if (widget.onSubmit != null) widget.onSubmit!(value);
          },
          focusNode: widget.focusNode,
          controller: widget.controller,
          obscureText: widget.obscureText!,
          textInputAction: widget.shouldRedirectToNextField!
              ? TextInputAction.next
              : TextInputAction.done,
          enabled: widget.isEnable,
          maxLines: widget.maxLines,
          textCapitalization: TextCapitalization.sentences,
          maxLength: widget.maxLength,
          inputFormatters: [
            if (widget.isCurrency!) CurrencyTextInputFormatter(symbol: ''),
            LengthLimitingTextInputFormatter(widget.maxLength),
          ],
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          keyboardType: widget.inputType ?? TextInputType.text,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(16),
              isDense: true,
              errorText: widget.errorMessage,
              counterText: "",
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: AppColors.colorDisableWidget, width: 1.0),
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadius),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: AppColors.colorPrimary, width: 1.0),
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadius),
                ),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: AppColors.colorDisableWidget, width: 1.0),
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadius),
                ),
              ),
              prefixIcon: widget.icon,
              prefixIconConstraints: const BoxConstraints(
                minWidth: 55,
              ),
              suffixIcon: widget.action,
              filled: true,
              hintStyle:
              TextStyle(color: AppColors.colorDisableWidget, fontSize: 14),
              fillColor: Colors.white),
        ),
      ],
    );
  }
}
