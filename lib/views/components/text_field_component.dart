import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldComponent extends StatefulWidget {
  const TextFieldComponent({
    Key? key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.onChanged,
    this.formatters,
    this.keyboardType,
    this.isPassword = false,
    this.fieldFocus,
    this.nextFocus,
    this.onFieldSubmitted,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
  }) : super(key: key);

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final List<TextInputFormatter>? formatters;
  final TextInputType? keyboardType;
  final bool isPassword;
  final FocusNode? fieldFocus;
  final FocusNode? nextFocus;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;

  @override
  State<TextFieldComponent> createState() => _TextFieldComponentState();
}

class _TextFieldComponentState extends State<TextFieldComponent> {
  String? errorText;
  final _key = GlobalKey<FormFieldState>();
  late bool isVisibleChar = widget.isPassword;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: widget.label != null,
          replacement: const SizedBox.shrink(),
          child: Positioned(top: 2, left: 11, child: Text(widget.label ?? '')),
        ),
        TextFormField(
          key: _key,
          inputFormatters: widget.formatters,
          textCapitalization: widget.textCapitalization,
          validator: (v) {
            errorText = widget.validator?.call(v);
            return errorText;
          },
          onChanged: (v) {
            if (errorText?.isNotEmpty == true) {
              _key.currentState?.validate();
            }
            widget.onChanged?.call(v);
          },
          keyboardType: widget.keyboardType,
          controller: widget.controller,
          obscureText: isVisibleChar,
          focusNode: widget.fieldFocus,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          cursorHeight: 16,
          textAlign: TextAlign.start,
          textInputAction: widget.textInputAction,
          textAlignVertical: TextAlignVertical.top,
          onFieldSubmitted: (value) {
            if (widget.onFieldSubmitted != null) {
              widget.onFieldSubmitted!(value);
            }
            widget.fieldFocus?.unfocus();
            if (widget.nextFocus != null) {
              FocusScope.of(context).requestFocus(widget.nextFocus);
            }
          },
          decoration: InputDecoration(
            hintText: widget.hint,
            contentPadding: const EdgeInsets.only(top: 32, left: 11),
            suffixIcon: !widget.isPassword
                ? null
                : InkWell(
                    onTap: () => setState(() => isVisibleChar = !isVisibleChar),
                    child: Icon(
                      isVisibleChar ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    ),
                  ),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              gapPadding: 0,
              borderSide: BorderSide(
                color: Colors.blue.withOpacity(0.9),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              gapPadding: 0,
              borderSide: BorderSide(
                color: Colors.blue.withOpacity(0.9),
              ),
            ),
            errorText: errorText,
            errorStyle: const TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
