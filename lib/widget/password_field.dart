import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;

  const PasswordTextField({super.key, required this.controller});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}
class _PasswordTextFieldState extends State<PasswordTextField> {

  bool _isVisible = false;


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: !_isVisible,
      decoration: InputDecoration(
        labelText: 'Mot de passe',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          onPressed: () {

            setState(() {
              _isVisible = !_isVisible;
            });
          },
          icon: Icon(
            _isVisible ? Icons.visibility :  Icons.visibility_off ,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer un mot de passe.';
        }
        return null;
      },
    );
  }
}
