import 'package:flutter/material.dart';

import 'blob_layout.dart';
import 'models/blob.dart';

class BlobButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final Color? backgroundColor;
  final List<Blob> blobs;
  final Size size;

  const BlobButton._({
    Key? key,
    required this.onTap,
    required this.backgroundColor,
    required this.size,
    required this.blobs,
  }) : super(key: key);

  factory BlobButton.bouncing({
    required GestureTapCallback onTap,
    Color? backgroundColor,
  }) {
    Size area = const Size(100, 100);
    List<Blob> blobs = [];
    blobs.add(RotatingBloB.random(area));
    blobs.add(RotatingBloB.random(area));
    blobs.add(RotatingBloB.random(area));
    blobs.add(RotatingBloB.random(area));
    blobs.add(RotatingBloB.random(area));
    blobs.add(RotatingBloB.random(area));
    blobs.add(RotatingBloB.random(area));
    blobs.add(RotatingBloB.random(area));

    return BlobButton._(
      backgroundColor: backgroundColor,
      onTap: onTap,
      blobs: blobs,
      size: area,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 100,
        height: 100,
        child: Stack(
          children: [
            Positioned.fill(
              child: BlobLayout.from(
                blobs: blobs,
                blobsColor: backgroundColor ?? Colors.blue,
              ),
            ),
            const Positioned.fill(
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
