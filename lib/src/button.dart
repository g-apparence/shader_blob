import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as math;

import 'blob_layout.dart';
import 'models/blob.dart';

class BlobButton extends StatefulWidget {
  final GestureTapCallback onTap;
  final Color? backgroundColor;
  final List<Blob> blobs;
  final Size size;
  final Icon icon;

  const BlobButton._({
    Key? key,
    required this.onTap,
    required this.backgroundColor,
    required this.size,
    required this.blobs,
    required this.icon,
  }) : super(key: key);

  factory BlobButton.bouncing({
    Key? key,
    required GestureTapCallback onTap,
    required Icon icon,
    Color? backgroundColor,
  }) {
    Size area = const Size(100, 100);
    List<Blob> blobs = [];
    for (int i = 0; i < 8; i++) {
      blobs.add(RotatingBloB.random(area));
    }
    return BlobButton._(
      key: key,
      backgroundColor: backgroundColor,
      onTap: onTap,
      blobs: blobs,
      size: area,
      icon: icon,
    );
  }

  @override
  State<BlobButton> createState() => _BlobButtonState();
}

class _BlobButtonState extends State<BlobButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  late Animation<double> _btnTween;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _btnTween = Tween<double>(begin: 1.0, end: 0.0) //
        .animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.decelerate,
      ),
    );
    _btnTween.addListener(_btnTweenUpdate);
  }

  // TODO idea: create a build for the onTap effect and let user provide it's own if desired
  _btnTweenUpdate() {
    var rotatingBlobs = widget.blobs.whereType<RotatingBloB>();
    final area = widget.blobs.first.area;
    final minRadius = min(area.width, area.height) * 0.03;
    final center = math.Vector2(area.width / 2, area.height / 2);
    for (var blob in rotatingBlobs) {
      blob.updateSize(minRadius, _btnTween.value);
      var before = blob.position.clone();
      var bfPrime = before - center;
      if (_btnTween.status == AnimationStatus.forward) {
        bfPrime.scale(0.02);
        blob.position.add(bfPrime);
      } else if (_btnTween.status == AnimationStatus.reverse) {
        bfPrime.scale(-0.02);
        blob.position.add(bfPrime);
      }
    }
  }

  @override
  void dispose() {
    _btnTween.removeListener(_btnTweenUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _animController //
            .forward(from: 0)
            .then((value) => _animController.reverse());
        widget.onTap();
      },
      child: SizedBox(
        width: widget.size.width,
        height: widget.size.height,
        child: Stack(
          children: [
            Positioned.fill(
              child: BlobLayout.from(
                blobs: widget.blobs,
                blobsColor: widget.backgroundColor ?? Colors.blue,
              ),
            ),
            Positioned.fill(
              child: widget.icon,
            ),
          ],
        ),
      ),
    );
  }
}
