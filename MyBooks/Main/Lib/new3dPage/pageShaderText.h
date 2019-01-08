/*
 * pageShader.h
 *
 *  Created on: 2014-5-15
 *      Author: liruncheng
 */

#ifndef PAGESHADER_H_
#define PAGESHADER_H_

static const char _vertexShader[] =
//"#version 300 es\n"
//"layout(location = 0) in vec4 vPosition;\n"
//"layout(location = 1) in vec2 vTexcoord;\n"
"attribute vec4 vPosition;\n"
"attribute vec2 vTexcoord;\n"
//"varying vec4 color;\n"
"varying vec2 texcoord;\n"
"varying float theL;\n"
"uniform vec4 lineParamter;\n"
"uniform vec3 sin_cos;\n"
"uniform vec3 R_PiR;\n"
"void main()"
"{\n"
"   vec4 position = vPosition;\n"
"   position.z = 0.1;\n"
"   vec4 endPosition;\n"
"   float newY = -(lineParamter.y * position.y + lineParamter.z);\n"
"  	if(newY >= position.x){"
"		endPosition = position;\n"
"		theL = 0.0;\n"
"  	}else{\n"
"		float l = abs(position.x * lineParamter.x + position.y * lineParamter.y + lineParamter.z) * lineParamter.w;\n"
"       theL = l * 1.5;\n"
"       if(l >= R_PiR.y){\n"
"			newY = 2.0 * l - R_PiR.y;\n"
"			endPosition = vec4(position.x + sin_cos.x * newY, position.y + sin_cos.y * newY, position.z + 2.0 * R_PiR.x, 1.0);\n"
"       }else{\n"
"			newY = l - sin(l * R_PiR.z) * R_PiR.x;\n"
"			endPosition = vec4(position.x + sin_cos.x * newY, position.y + sin_cos.y * newY, position.z + (R_PiR.x - cos(l * R_PiR.z) * R_PiR.x), 1.0);\n"
"		}\n"
"  	}\n"

//"   float newY = -(lineParamter.y * position.y + lineParamter.z);\n"
//"   float compare = 1.0 - step(position.x, newY);\n"
//"	float l = abs(position.x * lineParamter.x + position.y * lineParamter.y + lineParamter.z) * lineParamter.w;\n"
//"   theL = l * 1.5 * compare;\n"
//"   newY = step(R_PiR.y, l);\n"
//"   endPosition.xyz = position.xyz + sin_cos * compare * ( (2.0 * l - R_PiR.y) * newY + (l - sin(l * R_PiR.z) * R_PiR.x) * (1.0 - newY));\n"
//"   endPosition.z = position.z + compare * (2.0 * R_PiR.x * newY + (R_PiR.x - cos(l * R_PiR.z) * R_PiR.x) * (1.0 - newY));\n"
//"   endPosition.w = 1.0;\n"

//"   float newY = -(lineParamter.y * position.y + lineParamter.z);\n"
//"   float compare = 1.0 - step(position.x, newY);\n"
//"	float l = abs(position.x * lineParamter.x + position.y * lineParamter.y + lineParamter.z) * lineParamter.w;\n"
//"   theL = l * 1.5 * compare;\n"
//"   newY = step(R_PiR.y, l);\n"
//"	vec2 vec_a = vec2( (l * 2.0 - R_PiR.y), (l - sin(l * R_PiR.z) * R_PiR.x) );\n"
//"   vec2 vec_b = vec2(newY, (1.0 - newY));\n"
//"	float newX = dot(vec_a, vec_b);\n"
//"   endPosition.xy = position.xy + sin_cos.xy * compare * newX;\n"
//"   endPosition.w = 1.0;\n"

"   texcoord = vTexcoord;\n"
"	endPosition.x *= sin_cos.z;"
"   endPosition.z = - endPosition.z;\n"
"   gl_Position = endPosition;\n"
"}\n";

static const char gFragmentShader[] =
"precision mediump float;\n"
"varying vec2 texcoord;\n"
"varying float theL;\n"
"uniform float the_color;\n"
"uniform sampler2D texture;\n"
"void main() \n"
"{\n"
"	vec4 endColor = texture2D(texture, texcoord);\n"
//"   endColor = vec4(1.0, 1.0, 1.0, 0.0) - endColor;\n"
//"  	if(gl_FrontFacing){"
//"  		gl_FragColor = mix(endColor, vec4(0.125, 0.0625, 0.0625, 1.0), theL);\n"//color;\n"//
////"		gl_FragColor = endColor;\n"
//"  	}else{ \n"
//"		gl_FragColor = mix(endColor, vec4(0.125, 0.0625, 0.0625, 1.0), 1.2 - theL) * 0.8 + vec4(the_color) * 0.5 *  -(1.0 - float(gl_FrontFacing)*2.0);\n"
////"		gl_FragColor = endColor * 0.4 + vec4(0.6);\n"
//
//"	}\n"
"   float frontfacing = float(gl_FrontFacing);\n"
"   gl_FragColor = mix(endColor, vec4(0.125, 0.0625, 0.0625, 1.0), 1.2 * (1.0 - frontfacing) + -(1.0 - frontfacing*2.0) * theL);\n"
//"	gl_FragColor = vec4(1.0) - gl_FragColor;\n"
"	gl_FragColor.a = 1.0;\n"
"}\n";
//---------------------------------------------------------------------------------------------------
static const char _shadowSelfVertexShader[] =
"attribute vec4 vPosition;\n"
"attribute vec2 vTexcoord;\n"
"varying vec2 texcoord;\n"
"uniform vec3 sin_cos;\n"
"uniform vec2 pos;\n"
"uniform mat4 worldMat;\n"
"void main()\n"
"{\n"
"	vec4 endPosition = vPosition * worldMat;\n"
//"	endPosition.x = endPosition.x * sin_cos.y - endPosition.y * sin_cos.x;\n"
//"	endPosition.y = endPosition.x * sin_cos.x + endPosition.y * sin_cos.y;\n"
"	endPosition.x += pos.x;"
"	endPosition.y += pos.y;"
"   endPosition.x *= sin_cos.z;\n"
"	texcoord = vTexcoord;\n"
"   endPosition.z = 0.8;\n"
"   gl_Position = endPosition;\n"
"}\n"
;

static const char _shadowSelfFragmentShader[] =
"precision mediump float;\n"
"varying vec2 texcoord;\n"
"void main()\n"
"{\n"
"	float value = 1.0 - texcoord.x;\n"
"	gl_FragColor = vec4(0.192, 0.175, 0.175, value * 0.8);\n"
//"	gl_FragColor.w = value * 0.8;\n"
"}\n";
//---------------------------------------------------------------------------------------------------
static const char _shadowEgdeVertexShader[] =
"attribute vec4 vPosition;\n"
"attribute vec2 vTexcoord;\n"
"varying float texcoord;\n"
"uniform vec4 lineParamter;\n"
"uniform vec3 sin_cos;\n"
"uniform vec3 R_PiR;\n"
"void main()"
"{\n"
"   vec4 position = vPosition;\n"
"   vec4 endPosition;\n"
"   position.z = 0.1;\n"
//"   float newY = -(lineParamter.y * position.y + lineParamter.z);\n"
//"  	if(newY >= position.x){"
//"		endPosition = position;\n"
//"  	}else{\n"
//"		float l = abs(position.x * lineParamter.x + position.y * lineParamter.y + lineParamter.z) * lineParamter.w;\n"
//"       if(l >= R_PiR.y){\n"
//"			newY = 2.0 * l - R_PiR.y;\n"
//"			endPosition = vec4(position.x + sin_cos.x * newY, position.y + sin_cos.y * newY, position.z + 2.0 * R_PiR.x, 1.0);\n"
//"       }else{\n"
//"			newY = l - sin(l * R_PiR.z) * R_PiR.x;\n"
//"			endPosition = vec4(position.x + sin_cos.x * newY, position.y + sin_cos.y * newY, position.z + (R_PiR.x - cos(l * R_PiR.z) * R_PiR.x), 1.0);\n"
//"		}\n"
//"  	}\n"

"   float newY = -(lineParamter.y * position.y + lineParamter.z);\n"
"   float compare = 1.0 - step(position.x, newY);\n"
"	float l = abs(position.x * lineParamter.x + position.y * lineParamter.y + lineParamter.z) * lineParamter.w;\n"
"   newY = step(R_PiR.y, l);\n"
"   endPosition.xy = position.xy + sin_cos.xy * compare * ( (2.0 * l - R_PiR.y) * newY + (l - sin(l * R_PiR.z) * R_PiR.x) * (1.0 - newY));\n"
"   endPosition.z = position.z + compare * (2.0 * R_PiR.x * newY + (R_PiR.x - cos(l * R_PiR.z) * R_PiR.x) * (1.0 - newY));\n"
"   endPosition.w = 1.0;\n"

"	texcoord = vTexcoord.x;\n"
"	endPosition.x *= sin_cos.z;"
"   endPosition.z = - endPosition.z - 0.01;\n"
"   gl_Position = endPosition;\n"
"}\n";

static const char _shadowEgdeFragmentShader[] =
"precision mediump float;\n"
"varying float texcoord;\n"
"void main()\n"
"{\n"
"	gl_FragColor = vec4(0.192, 0.175, 0.175, texcoord);\n"
"}\n";

#endif /* PAGESHADER_H_ */
