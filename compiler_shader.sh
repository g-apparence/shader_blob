#!/bin/sh

glslc --target-env=opengl \
  -fshader-stage=fragment \
  -o ./packages/shader_blob_button/assets/shaders/$1.sprv \
  shaders/$1.glsl 
