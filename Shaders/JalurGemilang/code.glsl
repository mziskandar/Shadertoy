// "The MALAYSIAN Flag"
// by MZIskandar, Kuala Lumpur, Malaysia.
// Blog: http://digitalspine.blogspot.com
// Twitter: @mziskandar
// learned form Martijn Steinrucken aka The Art of Code/BigWings - 2020 [https://www.shadertoy.com/view/flsXRM]
// and jjovanovski [https://www.shadertoy.com/view/ftlSDr]
// ..and FabriceNeyret2 tips.

#define PI 3.14159265359
#define TAU (2. * PI)

vec3 RED = vec3(204.0/255.0, 0.0, 0.0);
vec3 WHITE = vec3(1.0);
vec3 BLUE = vec3(0.0, 0.0, 102.0/255.0);
vec3 YELLOW = vec3(254.0/255.0, 204.0/255.0, 0.0);

float drawCircle (vec2 uv, vec2 pos, float radius){
    return float(smoothstep(radius, radius - 0.002, length(uv - pos)));
}

float Star14(vec2 uv, float size) {
    float a = mod( atan(uv.x,uv.y)*14.,TAU ) / TAU -PI/TAU,
      angle = PI*(.5+.2),
          d = length(uv)*  sin(angle+abs(a)),
          w = fwidth(d);
    return length(uv)>.4 ? 0. : smoothstep(size + w, size - w, d);
}

vec2 Remap(vec2 p, float b, float l, float t, float r) {
    return vec2( (p.x-l) / (r-l), (p.y-b) / (t-b));
}

vec3 Flag(vec2 uv) {

    vec3 col = BLUE;
    vec2 st = Remap(uv, .384, 0.0, 1.0, 0.5);
    if(st.x>0. && st.x<1. && st.y>0. && st.y<1.) {
        vec2 stM = Remap(uv, 0.1, 0.1, 0.8, 0.5);
        float Moon = clamp( drawCircle(stM, vec2(0.23,0.85), 0.35)-drawCircle(stM, vec2(0.31,0.85), 0.30) ,0.0,1.0);
        vec2 stS = Remap(uv, 0.69, 0.34, 1.47, 0.8);
        float Star = Star14(stS.xy, 0.1);
        col += vec3(abs((Moon + Star))) * YELLOW;
    } else {
        float y = sin(uv.y*PI*13.);
        float w = fwidth(y);
        float stripes = smoothstep(-w, w, y);
        w = fwidth(uv.y);
        col = mix(WHITE, RED, stripes);
    }
    return col;
}


void mainImage( out vec4 fragColor, in vec2 fragCoord ){
    vec2 uv = fragCoord/iResolution.xy;

    float t = uv.x*7.-2.*iTime+uv.y*3.;
    uv.y += sin(t)*.05;
    
    vec3 col = Flag(uv);
    
    col *= .7+cos(t)*.3;
    fragColor = vec4(col,0.0);
}
