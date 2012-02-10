// Basic idea:
// Rings = sin(radius)
// Spiral = slow offset according to angle, so sin(angle + radius)
// Add time for animation

uniform float time_0_X;
uniform float rings;
varying vec2 vTexCoord;
varying vec4 MyCol;

void main(void)
{
 float exponent = 0.2;
 
 float speed = -1.5;
  
 float ang = atan(vTexCoord.y/ vTexCoord.x);   
 float rad = pow(dot(vTexCoord, vTexCoord), exponent);  
 float col =  0.5 * (1.0 + sin(ang + rings * rad + speed * time_0_X)); 
 vec4 value = vec4(vec3(MyCol),col*MyCol.a);

 
// vec4 value =  vec4( 0.5 * (1.0 + sin(ang + rings * rad + speed * time_0_X)));
 if( vTexCoord.x < 0.0 ) 
  {   
  // value = 1.0 - value;
    value = vec4(vec3(MyCol),(1-col)*MyCol.a);
  }
 gl_FragColor =   value;
}