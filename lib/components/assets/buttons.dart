import 'package:flutter/material.dart';

class PrimaryButton extends StatefulWidget {
  Function onPressed;
  Widget child;
  Color colorPrimary;
  Color colorSecondary;
  Color? activatedColor;

  PrimaryButton({
    required this.onPressed,
    required this.child,
    required this.colorPrimary,
    required this.colorSecondary,
    this.activatedColor,
  });

  @override
  State<StatefulWidget> createState() {
    return PrimaryButtonState(
        colorPrimary: colorPrimary, colorSecondary: colorSecondary);
  }
}

class PrimaryButtonState extends State<PrimaryButton> {
  Color colorPrimary;
  Color colorSecondary;

  PrimaryButtonState(
      {required this.colorPrimary, required this.colorSecondary});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) async {
        setState(() {
          colorPrimary = widget.colorPrimary.withOpacity(0.7);
          colorSecondary = widget.colorSecondary.withOpacity(0.7);
        });

        await Future.delayed(Duration(milliseconds: 100));

        setState(() {
          colorPrimary = widget.colorPrimary.withOpacity(1);
          colorSecondary = widget.colorSecondary.withOpacity(1);
        });
      },
      onTap: () {
        widget.onPressed();
      },
      child: Container(
        height: 40,
        width: 130,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(colors: [colorPrimary, colorSecondary]),
            boxShadow: [
              BoxShadow(
                  blurStyle: BlurStyle.normal,
                  color: Color(0xff999999),
                  blurRadius: 1,
                  spreadRadius: 0.1,
                  offset: Offset(2, 2)),
            ]),
        child: widget.child,
      ),
    );
  }
}
