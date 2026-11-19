import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

/// Copies a picked image into the app's documents folder so it survives
/// cache clears. On web the picker path (a blob URL) is used as is.
Future<String> persistPickedImage(XFile picked) async {
  if (kIsWeb) return picked.path;
  final dir = await getApplicationDocumentsDirectory();
  final dot = picked.path.lastIndexOf('.');
  final ext = dot == -1 ? 'jpg' : picked.path.substring(dot + 1);
  final target =
      '${dir.path}/img_${DateTime.now().microsecondsSinceEpoch}.$ext';
  await File(picked.path).copy(target);
  return target;
}

/// Shows a note photo, or a placeholder when there is none.
class NoteImage extends StatelessWidget {
  final String? path;
  final double? height;
  final double? width;
  final IconData placeholderIcon;

  const NoteImage({
    super.key,
    required this.path,
    this.height,
    this.width,
    this.placeholderIcon = Icons.eco_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final placeholder = Container(
      height: height,
      width: width ?? double.infinity,
      color: cs.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(placeholderIcon, color: cs.outline, size: 36),
    );

    final p = path;
    if (p == null || p.isEmpty) return placeholder;

    Widget image;
    if (kIsWeb || p.startsWith('http') || p.startsWith('blob:')) {
      image = Image.network(
        p,
        height: height,
        width: width ?? double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => placeholder,
      );
    } else {
      image = Image.file(
        File(p),
        height: height,
        width: width ?? double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => placeholder,
      );
    }
    return image;
  }
}
