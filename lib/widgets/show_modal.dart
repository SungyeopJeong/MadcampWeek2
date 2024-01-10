import 'package:flutter/material.dart';

Future<T?> showModal<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool dismissible = true,
}) {
  return showModalBottomSheet(
    useRootNavigator: true,
    context: context,
    isScrollControlled: true,
    enableDrag: dismissible,
    isDismissible: dismissible,
    barrierColor: Colors.black.withOpacity(0.4),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: builder,
  );
}
