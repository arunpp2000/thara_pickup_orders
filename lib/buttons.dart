import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FFButtonOptions {
  FFButtonOptions({
    this.textStyle,
    this.elevation,
    this.height,
    this.width,
    this.padding,
    this.color,
    this.disabledColor,
    this.disabledTextColor,
    this.splashColor,
    this.iconSize,
    this.iconColor,
    this.iconPadding,
    this.borderRadius,
    this.borderSide,
  });

  TextStyle? textStyle;
  double? elevation;
  double? height;
  double? width;
  EdgeInsetsGeometry? padding;
  Color? color;
  Color? disabledColor;
  Color? disabledTextColor;
  Color? splashColor;
  double? iconSize;
  Color? iconColor;
  EdgeInsetsGeometry? iconPadding;
  double? borderRadius;
  BorderSide? borderSide;
}

class FFButtonWidget extends StatelessWidget {
  const FFButtonWidget({
    Key? key,
    this.text,
    this.onPressed,
    this.icon,
    this.iconData,
    this.options,
    this.loading = false,
  }) : super(key: key);

  final String? text;
  final Widget? icon;
  final IconData? iconData;
  final VoidCallback? onPressed;
  final FFButtonOptions? options;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    Widget textWidget = loading
        ? Center(
      child: Container(
        width: 23,
        height: 23,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            options?.textStyle?.color ?? Colors.white,
          ),
        ),
      ),
    )
        : AutoSizeText(
      text!,
      style: options?.textStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    if (icon != null || iconData != null) {
      textWidget = Flexible(child: textWidget);
      return Container(
        height: options?.height,
        width: options?.width,
        child: ElevatedButton(
          // icon: Padding(
          //   padding: options.iconPadding ?? EdgeInsets.zero,
          //   child: icon ??
          //       FaIcon(
          //         iconData,
          //         size: options.iconSize,
          //         color: options.iconColor ?? options.textStyle.color,
          //       ),
          // ),
          child: textWidget,
          onPressed: loading ? () {} : onPressed,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(options.borderRadius),
          //   side: options.borderSide ?? BorderSide.none,
          // ),
          // color: options.color,
          // colorBrightness: ThemeData.estimateBrightnessForColor(options.color),
          // textColor: options.textStyle.color,
          // disabledColor: options.disabledColor,
          // disabledTextColor: options.disabledTextColor,
          // elevation: options.elevation,
          // splashColor: options.splashColor,
        ),
      );
    }

    return Container(
      height: options?.height,
      width: options?.width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(options?.color),
          padding: MaterialStateProperty.all(options?.padding),
          textStyle: MaterialStateProperty.all(
              TextStyle(color: options?.textStyle?.color)),
          elevation: MaterialStateProperty.all(options?.elevation),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(options?.borderRadius ?? 28),
              side: options?.borderSide ?? BorderSide.none,
            ),
          ),
        ),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(options.borderRadius ?? 28),
        //   side: options.borderSide ?? BorderSide.none,
        // ),
        // textColor: options.textStyle.color,
        // color: options.color,
        // colorBrightness: ThemeData.estimateBrightnessForColor(options.color),
        // disabledColor: options.disabledColor,
        // disabledTextColor: options.disabledTextColor,
        // padding: options.padding,
        // elevation: options.elevation,
        child: textWidget,
      ),
    );
    //   Container(
    //   height: options.height,
    //   width: options.width,
    //   child: RaisedButton(
    //     onPressed: onPressed,
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(options.borderRadius ?? 28),
    //       side: options.borderSide ?? BorderSide.none,
    //     ),
    //     textColor: options.textStyle.color,
    //     color: options.color,
    //     colorBrightness: ThemeData.estimateBrightnessForColor(options.color),
    //     disabledColor: options.disabledColor,
    //     disabledTextColor: options.disabledTextColor,
    //     padding: options.padding,
    //     elevation: options.elevation,
    //     child: textWidget,
    //   ),
    // );
  }
}