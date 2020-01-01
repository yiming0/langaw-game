import 'dart:developer';
import 'dart:ui';
import 'dart:math' as math;

import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:langaw/langaw-game.dart';

class Fly {
  final LangawGame game;
  Rect flyRect;

  List<Sprite> flyingSprite;
  Sprite deadSprite;
  double flyingSpriteIndex = 0;
  bool isDead = false;
  bool isOffScreen = false;
  Offset targetLocation;

  double get speed => game.tileSize * 3;

  Fly(this.game) {
    setTargetLocation();
  }

  void setTargetLocation() {
    double x = game.rnd.nextDouble() *
        (game.screenSize.width - (game.tileSize * 2.025));
    double y = game.rnd.nextDouble() *
        (game.screenSize.height - (game.tileSize * 2.025));
    targetLocation = Offset(x, y);
  }

  void render(Canvas c) {
    if (isDead) {
      deadSprite.renderRect(c, flyRect.inflate(2));
    } else {
      flyingSprite[flyingSpriteIndex.toInt()].renderRect(c, flyRect.inflate(2));
    }
  }

  void update(double t) {
    flyingSpriteIndex += 30 * t;
    while (flyingSpriteIndex >= 2) {
      flyingSpriteIndex -= 2;
    }

    if (isDead) {
      flyRect = flyRect.translate(0, game.tileSize * 12 * t);
    } else {
      double stepDistance = speed * t;
      Offset toTarget = targetLocation - Offset(flyRect.left, flyRect.top);
      if (stepDistance < toTarget.distance) {
        Offset stepToTarget = Offset.fromDirection(toTarget.direction, stepDistance);
        flyRect = flyRect.shift(roundMove(stepToTarget, t));
      } else {
        flyRect = flyRect.shift(roundMove(toTarget, t));
        setTargetLocation();
      }
    }

    if (flyRect.top > game.screenSize.height || flyRect.left > game.screenSize.width) {
      isOffScreen = true;
    }
  }

  void onTapDown() {
    isDead = true;
    game.spawnFly();
  }

  Offset roundMove(Offset offset, double t) {
    return offset;
    double r = game.tileSize * 1;
//    log(Offset(r * math.sin(t*2), r * math.cos(t*2)).toString());
    return offset + Offset(r * math.sin(t*2), r * math.cos(t*2));
  }
}
