

// The Laplace filter approximates the second order derivate,
// that is, the rate of change of slope in the image. It can be
// used for edge detection. The Laplace filter gives negative
// response on the higher side of the edge and positive response
// on the lower side.

// This is the filter kernel:
// 0  1  0
// 1 -4  1
// 0  1  0

uniform float scale;
uniform float pixelSize;
uniform sampler2D Image;
varying vec2 vTexCoord;

void main(void)
{
   vec2 s11,s12,s13,s21,s22,s23,s31,s32,s33;
   vec4 laplace;
 
  
   s11 =  vTexCoord + pixelSize *vec2( -1.0, -1.0);
   s12 =  vTexCoord + pixelSize *vec2( 0.0, -1.0);
   s13 =  vTexCoord + pixelSize *vec2( 1.0, -1.0);
   s21 =  vTexCoord + pixelSize *vec2( -1.0, 0.0);
  
   s23 =  vTexCoord + pixelSize *vec2( 1.0, 0.0);
   s31 =  vTexCoord + pixelSize *vec2( -1.0, 1.0);
   s32 =  vTexCoord + pixelSize *vec2( 0.0, 1.0);
   s33 =  vTexCoord + pixelSize *vec2( 1.0, 1.0);
   
//   samples1 =  vTexCoord + pixelSize *vec2(-1.0,  0.0);
//   samples2 =  vTexCoord + pixelSize *vec2( 1.0,  0.0);
//   samples3 =  vTexCoord + pixelSize *vec2( 0.0,  1.0);

 
   laplace = -1 * texture2D(Image, vTexCoord);
   laplace += 2*texture2D(Image, s11);
   laplace += 0*texture2D(Image, s12);
   laplace += 0*texture2D(Image, s13);
   laplace += 0*texture2D(Image, s21);
   laplace += 0*texture2D(Image, s23);
   laplace += 0*texture2D(Image, s31);
   laplace += 0*texture2D(Image, s32);
   laplace += -texture2D(Image, s33); 

   gl_FragColor = 0.5 + scale * laplace;
   
}