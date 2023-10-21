import 'package:crud_project/common/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInputField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final bool isPasswordField;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final bool enableSpaceKey;
  final bool onlyAlpha;
  final TextCapitalization textCapitalization;
  final int characterLimit;
  final Color fillColor;
  final AutovalidateMode autoValidateMode;
  final int? maxLines;

  const TextInputField(
      {Key? key,
      this.labelText,
      this.hintText,
      this.isPasswordField = false,
      this.keyboardType,
      this.textInputAction,
      this.validator,
      this.controller,
      this.onChanged,
      this.enableSpaceKey = false,
      this.onlyAlpha = false,
      this.textCapitalization = TextCapitalization.none,
      this.characterLimit = -1,
      this.fillColor = AppColors.surface,
      this.autoValidateMode = AutovalidateMode.onUserInteraction,
      this.maxLines})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TextInputFieldState();
  }
}

class _TextInputFieldState extends State<TextInputField> {
  bool _wasOnChangedCalled = true;
  bool _obscureText = false;

  @override
  void initState() {
    _obscureText = widget.isPasswordField;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.labelText != null)
          Container(
            padding: const EdgeInsets.only(left: 8, bottom: 4),
            alignment: Alignment.centerLeft,
            child: Text(
              widget.labelText!,
              textAlign: TextAlign.left,
              style: _getLabelColor(context),
            ),
          ),
        TextFormField(
          inputFormatters: [
            LengthLimitingTextInputFormatter(widget.characterLimit),
            //disable space key
            if (!widget.enableSpaceKey)
              FilteringTextInputFormatter.deny(RegExp(r'\s')),
            // deny anything other then alphabetic chars
            if (widget.onlyAlpha)
              FilteringTextInputFormatter.deny(RegExp(
                  r'[^a-zA-ZÈÉÊËÙÚÛÜÎÌÍÏÒÓÔÖÂÀÁÄẞÇèéêëùúûüîìíïòóôöâàáäsßç\-\s]')),
          ],
          maxLines: widget.maxLines,
          textCapitalization: widget.textCapitalization,
          autovalidateMode: widget.autoValidateMode,
          controller: widget.controller,
          validator: widget.validator,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onChanged: (_) {
            _wasOnChangedCalled = false;
            widget.onChanged?.call(_);
          },
          decoration: InputDecoration(
            errorMaxLines: 4,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            hintText: widget.hintText,
            fillColor: widget.fillColor,
            suffixIcon: widget.isPasswordField
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() {
                      _obscureText = !_obscureText;
                    }),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  TextStyle? _getLabelColor(BuildContext context) {
    if (widget.validator?.call(widget.controller?.text) != null &&
        !_wasOnChangedCalled) {
      return Theme.of(context)
          .textTheme
          .labelSmall
          ?.copyWith(color: AppColors.error);
    }
    return Theme.of(context).textTheme.labelSmall;
  }
}
