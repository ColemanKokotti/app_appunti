import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';

class MagnifierOverlay extends StatelessWidget {
  final ValueNotifier<Offset> position;
  final ValueNotifier<double> zoomLevel;
  final double magnifierSize;

  const MagnifierOverlay({
    super.key,
    required this.position,
    required this.zoomLevel,
    this.magnifierSize = 150.0,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Offset>(
      valueListenable: position,
      builder: (context, currentPosition, _) {
        return ValueListenableBuilder<double>(
          valueListenable: zoomLevel,
          builder: (context, zoom, _) {
            return Positioned(
              left: currentPosition.dx - magnifierSize / 2,
              top: currentPosition.dy - magnifierSize / 2,
              child: _buildMagnifier(currentPosition, zoom),
            );
          },
        );
      },
    );
  }

  Widget _buildMagnifier(Offset position, double zoom) {
    // Create the transformation matrix
    final Matrix4 matrix = Matrix4.identity()
      ..scale(zoom, zoom)
      ..translate(
        -(position.dx - magnifierSize / (2 * zoom)),
        -(position.dy - magnifierSize / (2 * zoom)),
      );

    // Convert to Float64List which is required by ImageFilter.matrix
    final Float64List float64List = Float64List.fromList(matrix.storage.toList());

    return Container(
      width: magnifierSize,
      height: magnifierSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: BackdropFilter(
        filter: ui.ImageFilter.matrix(float64List),
        child: const SizedBox.expand(),
      ),
    );
  }
}