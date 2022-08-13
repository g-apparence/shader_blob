import 'dart:math';
import 'dart:ui';

import 'package:vector_math/vector_math.dart';

import 'utils.dart';

abstract class Particle {
  final Size area;

  final Vector2 basePosition;

  final double baseRadius;

  Vector2 position;

  Vector2 velocity;

  double radius;

  Particle({
    required this.area,
    required this.position,
    required this.basePosition,
    required this.velocity,
    required this.radius,
    required this.baseRadius,
  });

  update();

  /// reduce the blob size according to time ratio
  updateSize(double radius, double time) {
    assert(time <= 1.0 && time >= 0, "time must be between 0 and 1");
    var newRadius = lerpDouble(radius, baseRadius, time);
    if (newRadius != null) {
      this.radius = newRadius;
    }
  }

  toArray() {
    return [position.x, position.y, radius];
  }

  Map<String, dynamic> toJson() => {
        'size': '${area.width}*${area.height}',
        'position': '${position.x},${position.y}',
        'basePosition': '${basePosition.x},${basePosition.y}',
        'velocity': '${velocity.x},${velocity.y}',
        'radius': radius,
        'baseRadius': baseRadius,
      };
}

class BasicParticle extends Particle {
  BasicParticle({
    required super.area,
    required super.position,
    required super.basePosition,
    required super.velocity,
    required super.radius,
    required super.baseRadius,
  });

  factory BasicParticle.random(Size area) {
    Vector2 velocity = randomVector(-5, 5);
    Vector2 position = Vector2(
      Random().nextDouble() * area.width,
      Random().nextDouble() * area.height,
    );
    double radius = 40 + Random().nextDouble() * 50;

    return BasicParticle(
      area: area,
      basePosition: position.clone(),
      position: position.clone(),
      velocity: velocity,
      radius: radius,
      baseRadius: radius,
    );
  }

  @override
  void update() {
    position.add(velocity);
    if (position.x > area.width || position.x < 0) {
      velocity = -velocity;
    }
    if (position.y > area.height || position.y < 0) {
      velocity = -velocity;
    }
  }
}

/// A blob that is init on the center
/// - goes to the other side once touch a border
class BouncingParticle extends Particle {
  BouncingParticle({
    required super.area,
    required super.position,
    required super.basePosition,
    required super.velocity,
    required super.radius,
    required super.baseRadius,
  });

  factory BouncingParticle.random(Size area) {
    Vector2 velocity = randomVector(-2, 2);
    Vector2 position = Vector2(area.width / 2, area.height / 2);
    double radius = 25 + Random().nextDouble() * 40;

    return BouncingParticle(
      area: area,
      basePosition: position.clone(),
      position: position.clone(),
      velocity: velocity,
      radius: radius,
      baseRadius: radius,
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
class EjectedParticle extends Particle {
  EjectedParticle({
    required super.area,
    required super.position,
    required super.basePosition,
    required super.velocity,
    required super.radius,
    required super.baseRadius,
  });

  factory EjectedParticle.random(Size area) {
    Vector2 velocity = Vector2(
      -5 + (Random().nextDouble() * 5) * 2,
      -5 + (Random().nextDouble() * 5) * 2,
    );
    Vector2 position = Vector2(area.width / 2, area.height / 2);
    double radius = 6 + Random().nextDouble() * 10;

    return EjectedParticle(
      area: area,
      basePosition: position.clone(),
      position: position.clone(),
      velocity: velocity,
      radius: radius,
      baseRadius: radius,
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
class RotatingParticle extends Particle {
  Vector2 center;
  double angle; // in degree
  double angleVelocity;
  double angleAcceleration;

  RotatingParticle({
    required super.area,
    required super.position,
    required super.basePosition,
    required super.velocity,
    required super.radius,
    required super.baseRadius,
    required this.center,
    required this.angle,
    required this.angleVelocity,
    required this.angleAcceleration,
  });

  factory RotatingParticle.random(Size area) {
    Vector2 velocity = randomVector(-2, 2);
    // change this for more strange effect
    final minRadius = min(area.width, area.height) * 0.1;
    // change this for more strange effect
    final minPosition = min(area.width, area.height) * 0.2;

    Vector2 position = Vector2(area.width / 2, area.height / 2) +
        Vector2(randomDouble(-minPosition, minPosition),
            randomDouble(-minPosition, minPosition));
    double radius = minRadius + Random().nextDouble() * minRadius;

    return RotatingParticle(
      area: area,
      center: Vector2(area.width / 2, area.height / 2),
      basePosition: position.clone(),
      position: position.clone(),
      velocity: velocity,
      radius: radius,
      baseRadius: radius,
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

  // slow() {
  // }
}
