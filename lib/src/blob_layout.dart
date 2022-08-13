import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/particle.dart';

typedef BlobListBuilder = List<Particle> Function(Size area);

class BlobLayout extends StatefulWidget {
  final BlobListBuilder? blobBuilder;
  final Color? blobsColor;
  final List<Particle>? blobs;

  const BlobLayout({
    Key? key,
    this.blobBuilder,
    this.blobsColor,
    this.blobs,
  }) : super(key: key);

  factory BlobLayout.builder({
    required BlobListBuilder builder,
    required Color blobsColor,
  }) =>
      BlobLayout(
        blobBuilder: builder,
        blobsColor: blobsColor,
      );

  factory BlobLayout.from({
    required List<Particle> blobs,
    required Color blobsColor,
  }) =>
      BlobLayout(
        blobs: blobs,
        blobsColor: blobsColor,
      );

  @override
  State<BlobLayout> createState() => _BlobLayoutState();
}

class _BlobLayoutState extends State<BlobLayout>
    with SingleTickerProviderStateMixin {
  late Future<FragmentProgram> _loadShader;

  late final AnimationController _animController;

  late Animation<double> _tween;

  List<Particle>? _blobs;

  List<Particle>? get blobs => widget.blobs ?? _blobs;

  @override
  void initState() {
    super.initState();
    _loadShader = Future(() async {
      var file = await rootBundle
          .load('packages/flutter_blob/assets/shaders/blob.sprv');
      return FragmentProgram.compile(
        spirv: file.buffer,
      );
    }).catchError((e) {
      debugPrint("error while loading shader");
      debugPrint("$e");
      return e;
    });

    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 5000));
    _tween = Tween<double>(begin: 0, end: 10).animate(_animController);
    _animController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return FutureBuilder<FragmentProgram>(
          future: _loadShader,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            return animatedShader(
              snapshot.data!,
              Size(
                constraints.maxWidth,
                constraints.maxHeight,
              ),
            );
          });
    });
  }

  Widget animatedShader(FragmentProgram program, Size size) {
    return AnimatedBuilder(
      animation: _tween,
      builder: (context, child) {
        if (widget.blobBuilder != null) {
          _blobs ??= widget.blobBuilder!(size);
        }
        for (int i = 0; i < blobs!.length; i++) {
          blobs![i].update();
        }
        final shader = program.shader(
          floatUniforms: Float32List.fromList(
            <double>[
              size.width,
              size.height,
              widget.blobsColor!.red / 255.0,
              widget.blobsColor!.green / 255.0,
              widget.blobsColor!.blue / 255.0,
              widget.blobsColor!.opacity,
              ...blobs![0].toArray(), //
              ...blobs![1].toArray(), //
              ...blobs![2].toArray(), //
              ...blobs![3].toArray(), //
              ...blobs![4].toArray(), //
              ...blobs![5].toArray(), //
              ...blobs![6].toArray(), //
              ...blobs![7].toArray(), //
            ],
          ),
          // samplerUniforms: ,
        );
        return CustomPaint(painter: ShaderPainter(shader));
      },
    );
  }
}

class ShaderPainter extends CustomPainter {
  ShaderPainter(this.shader) : _paint = Paint()..shader = shader;

  final Shader shader;

  final Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
