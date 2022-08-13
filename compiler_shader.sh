#!/bin/sh

glslc --target-env=opengl \
  -fshader-stage=fragment \
  -o ./assets/shaders/$1.sprv \
  shaders/$1.glsl 
