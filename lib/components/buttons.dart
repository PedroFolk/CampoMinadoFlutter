import 'package:flutter/material.dart';

class MyButtons extends StatelessWidget {
  final Function()? onTap;
  final Icon teste;

  const MyButtons({super.key, required this.onTap, required this.teste});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
        child: (teste),
      ),
    );
  }
}
