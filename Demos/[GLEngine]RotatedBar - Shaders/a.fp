uniform sampler2D image;
const vec3 LUMINANCE_WEIGHTS = vec3(0.27, 0.67, 0.06);
const vec3 LightColor = vec3(1.0,0.9,0.5);
const vec3 DarkColor = vec3(0.2,0.05,0.0);

void main(void)
{
	vec3 col = texture2D ( image, gl_TexCoord[0].xy ).xyz;

	//float lum = dot(LUMINANCE_WEIGHTS,col);
	//vec3 sepia = DarkColor*(1.0-lum) + LightColor*lum;
	gl_FragColor = vec4(col,1.0);
}