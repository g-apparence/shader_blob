import 'dart:math';
import 'dart:ui';

import 'package:blob_button/models/utils.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';

abstract class Blob {
  Size size;

  final Vector2 basePosition;
  Vector2 position;

  Vector2 velocity;

  double radius;

  Blob({
    required this.size,
    required this.position,
    required this.basePosition,
    required this.velocity,
    required this.radius,
  });

  update();

  toArray() {
    return [position.x, position.y, radius];
  }

  Map<String, dynamic> toJson() => {
        'size': '${size.width}*${size.height}',
        'position': '${position.x},${position.y}',
        'basePosition': '${basePosition.x},${basePosition.y}',
        'velocity': '${velocity.x},${velocity.y}',
        'radius': radius,
      };
}

class BasicBloc extends Blob {
  BasicBloc({
    required super.size,
    required super.position,
    required super.basePosition,
    required super.velocity,
    required super.radius,
  });

  factory BasicBloc.random(Size area) {
    Vector2 velocity = randomVector(-5, 5);
    Vector2 position = Vector2(
      Random().nextDouble() * area.width,
      Random().nextDouble() * area.height,
    );
    double radius = 40 + Random().nextDouble() * 50;

    return BasicBloc(
      size: area,
      basePosition: position.clone(),
      position: position.clone(),
      velocity: velocity,
      radius: radius,
    );
  }

  @override
  void update() {
    position.add(velocity);
    if (position.x > size.width || position.x < 0) {
      velocity = -velocity;
    }
    if (position.y > size.height || position.y < 0) {
      velocity = -velocity;
    }
  }
}

/// A blob that is init on the center
/// - goes to the other side once touch a border
class BouncingBloB extends Blob {
  BouncingBloB({
    required super.size,
    required super.position,
    required super.basePosition,
    required super.velocity,
    required super.radius,
  });

  factory BouncingBloB.random(Size area) {
    Vector2 velocity = randomVector(-2, 2);
    Vector2 position = Vector2(area.width / 2, area.height / 2);
    double radius = 25 + Random().nextDouble() * 40;

    return BouncingBloB(
      size: area,
      basePosition: position.clone(),
      position: position.clone(),
      velocity: velocity,
      radius: radius,
    );
  }

  @override
  void update() {
    position.add(velocity);
    var distance = basePosition.distanceTo(position);
    if (distance > 50 || distance <= -50) {
      velocity = -velocity;
    }
  }
}

/// A blob that is ejected from the center
/// once touch a border directly recreated on the center
class EjectedBloB extends Blob {
  EjectedBloB({
    required super.size,
    required super.position,
    required super.basePosition,
    required super.velocity,
    required super.radius,
  });

  factory EjectedBloB.random(Size area) {
    Vector2 velocity = Vector2(
      -5 + (Random().nextDouble() * 5) * 2,
      -5 + (Random().nextDouble() * 5) * 2,
    );
    Vector2 position = Vector2(area.width / 2, area.height / 2);
    double radius = 6 + Random().nextDouble() * 10;

    return EjectedBloB(
      size: area,
      basePosition: position.clone(),
      position: position.clone(),
      velocity: velocity,
      radius: radius,
    );
  }

  @override
  void update() {
    position.add(velocity);
    var distance = basePosition.distanceTo(position);
    if (distance > 250 || distance <= -250) {
      position = basePosition.clone();
      velocity = Vector2(
        -5 + (Random().nextDouble() * 10),
        -5 + (Random().nextDouble() * 10),
      );
    }
  }
}

/// A blob that is init on the center
/// - goes to the other side once touch a border
class RotatingBloB extends Blob {
  Vector2 center;
  double angle; // in degree
  double angleVelocity;
  double angleAcceleration;

  RotatingBloB({
    required super.size,
    required super.position,
    required super.basePosition,
    required super.velocity,
    required super.radius,
    required this.center,
    required this.angle,
    required this.angleVelocity,
    required this.angleAcceleration,
  });

  factory RotatingBloB.random(Size area) {
    Vector2 velocity = randomVector(-2, 2);
    // change this for more strange effect
    final minRadius = min(area.width, area.height) * 0.1;
    // change this for more strange effect
    final minPosition = min(area.width, area.height) * 0.2;

    Vector2 position = Vector2(area.width / 2, area.height / 2) +
        Vector2(randomDouble(-minPosition, minPosition),
            randomDouble(-minPosition, minPosition));
    double radius = minRadius + Random().nextDouble() * minRadius;

    return RotatingBloB(
      size: area,
      center: Vector2(area.width / 2, area.height / 2),
      basePosition: position.clone(),
      position: position.clone(),
      velocity: velocity,
      radius: radius,
      angle: 0,
      angleVelocity: 0,
      angleAcceleration: 0.05,
    );
  }

  @override
  void update() {
    position = rotateFromCenter(position, center, angle);
    angle = angleVelocity; // baseAngle + angleVelocity
    angleVelocity += angleAcceleration;
    if (angleVelocity > 0.1) {
      angleVelocity = .1;
    }
    if (angleVelocity < -0.1) {
      angleVelocity = -.1;
    }
    angleAcceleration = randomDouble(-0.01, 0.01);
  }
}
