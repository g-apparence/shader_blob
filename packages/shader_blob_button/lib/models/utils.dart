import 'dart:math';

import 'package:vector_math/vector_math.dart';

Vector2 randomVector(int min, int max) {
  var maxMinusMin = max - min;
  return Vector2(
    min + (Random().nextDouble() * maxMinusMin),
    min + (Random().nextDouble() * maxMinusMin),
  );
}

double randomDouble(double min, double max) {
  return min + (Random().nextDouble() * (max - min));
}

/// angle is in radians
Vector2 rotateFromCenter(Vector2 p, Vector2 center, double angle) {
  var newX =
      cos(angle) * (p.x - center.x) - sin(angle) * (p.y - center.y) + center.x;
  var newY =
      sin(angle) * (p.x - center.x) + cos(angle) * (p.y - center.y) + center.y;
  return Vector2(newX, newY);
}

/// angle is in radians
Vector2 rotate(Vector2 p, double angle) {
  var newX = p.x * cos(angle) - p.y * sin(angle);
  var newY = p.x * sin(angle) + p.y * cos(angle);
  return Vector2(newX, newY);
}

double toRadian(double degrees) {
  return 2 * pi * (degrees / 360);
}
