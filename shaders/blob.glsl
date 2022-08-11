#version 320 es

precision mediump float;

#define NUM_BALLS 6

layout(location=0) uniform vec2 u_resolution;
//layout(location=1) uniform vec2 u_mouse;
//layout(location=2) uniform float u_time;
//layout(location=1) uniform float u_vertex;

// Flutter seems not supporting arrays in GLSL
// layout(location=1) uniform vec3[NUM_BALLS] balls;
layout(location=1) uniform vec4 color;
layout(location=2) uniform vec3 ball1;
layout(location=3) uniform vec3 ball2;
layout(location=4) uniform vec3 ball3;
layout(location=5) uniform vec3 ball4;
layout(location=6) uniform vec3 ball5;
layout(location=7) uniform vec3 ball6;
layout(location=8) uniform vec3 ball7;
layout(location=9) uniform vec3 ball8;


// outputs
layout(location = 0) out vec4 fragColor;

float circle(in vec2 _st, in float _radius, in vec2 center){
    vec2 dist = _st-center;
	return 1.-smoothstep(_radius-(_radius*0.01),
                         _radius+(_radius*0.01),
                         dot(dist,dist)*4.0);
}

bool energyField(in vec3 balls[NUM_BALLS], in vec2 p, in float gooeyness, in float iso) {
    float en = 0.0;
    for(float i=0.0; i<2.0; i+=1.0) {
        float radius = balls[int(i)].z;
        float denom =  max(0.0001, pow(length(vec2(balls[int(i)].xy - p)), gooeyness));
        en += (radius / denom);
    }
    return en > iso;
}

float energy(in vec3 balls[NUM_BALLS], in vec2 p, in float gooeyness, in float iso) {
    float sumCount = 0.0;
    for(float i=0.0; i<2.0; i+=1.0) {
        vec2 diff = p - balls[int(i)].xy ;
        float l = length(diff);
        l = balls[int(i)].z / l;
        sumCount += pow(l, gooeyness);
    }
    return sumCount;
}

float energyBall(in vec3 ball, in vec2 p, in float gooeyness) {
    vec2 diff = p - ball.xy ;
    float l = length(diff);
    l = ball.z / l;
    return pow(l, gooeyness);
}


void main() {
    vec2 st = gl_FragCoord.xy / u_resolution.xy;

    float gooeyness = 3.4; // attraction power value => less = more attraction
    float energyValue = energyBall(ball1, gl_FragCoord.xy, gooeyness);
    energyValue += energyBall(ball2, gl_FragCoord.xy, gooeyness);
    energyValue += energyBall(ball3, gl_FragCoord.xy, gooeyness);
    energyValue += energyBall(ball4, gl_FragCoord.xy, gooeyness);
    energyValue += energyBall(ball5, gl_FragCoord.xy, gooeyness);
    energyValue += energyBall(ball6, gl_FragCoord.xy, gooeyness);
    energyValue += energyBall(ball7, gl_FragCoord.xy, gooeyness);
    energyValue += energyBall(ball8, gl_FragCoord.xy, gooeyness);

    float steppedEnergyValue = step(.5, energyValue);
    if(steppedEnergyValue > 0.0) {
        fragColor = vec4(steppedEnergyValue) * vec4(color.rgba);
    } else {
        fragColor = vec4(0.0, 0.0, 0.0, 0.0);
    }
}