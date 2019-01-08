/*
 * pageT.cpp
 *
 *  Created on: 2014-6-16
 *      Author: liruncheng
 */

#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stddef.h>

#include "pageT.h"
#include "pageShaderText.h"

#if GL_OES_vertex_array_object

#define glGenVertexArrays glGenVertexArraysOES
#define glBindVertexArray glBindVertexArrayOES
#define glDeleteVertexArrays glDeleteVertexArraysOES

#endif

pageT::pageT() :
		gProgram(0), _shadowProgram(0), _shadowEgdeProgram(0), _vbo(0), _ibo(0), _tbo(
				0), _shadowVbo(0), _shadowTbo(0), _shadowEgdeRightVbo(0), _shadowEgdeRightTbo(
				0), _shadowEgdeBottomVbo(0), _shadowEgdeBottomTbo(0), page_texture(
				0), _radius(0.25f), Pi(3.141592653589793238462),
				dotTime(0.004), _vaoPlane(0), _vaoSelfShadow(0)
{

}

pageT::~pageT()
{
	removeAll();
}

GLuint pageT::loadShader(GLenum shaderType, const char* pSource)
{
	GLuint shader = glCreateShader(shaderType);
	if (shader) {
		glShaderSource(shader, 1, &pSource, NULL);
		glCompileShader(shader);
		GLint compiled = 0;
		glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
		if (!compiled) {
			GLint infoLen = 0;
			glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLen);
			if (infoLen) {
				char* buf = (char*) malloc(infoLen);
				if (buf) {
					glGetShaderInfoLog(shader, infoLen, NULL, buf);
//					LOGE("Could not compile shader %d:\n%s\n", shaderType, buf);
					free(buf);
				}
				glDeleteShader(shader);
				shader = 0;
			}
		}
	}
	return shader;
}

GLuint pageT::createProgram(const char* pVertexSource, const char* pFragmentSource)
{
	GLuint vertexShader = loadShader(GL_VERTEX_SHADER, pVertexSource);
	if (!vertexShader) {
		return 0;
	}

	GLuint pixelShader = loadShader(GL_FRAGMENT_SHADER, pFragmentSource);
	if (!pixelShader) {
		return 0;
	}

	GLuint program = glCreateProgram();
	if (program) {
		glAttachShader(program, vertexShader);
		checkGlError("glAttachShader");
		glAttachShader(program, pixelShader);
		checkGlError("glAttachShader");
		glLinkProgram(program);
		GLint linkStatus = GL_FALSE;
		glGetProgramiv(program, GL_LINK_STATUS, &linkStatus);
		if (linkStatus != GL_TRUE) {
			GLint bufLength = 0;
			glGetProgramiv(program, GL_INFO_LOG_LENGTH, &bufLength);
			if (bufLength) {
				char* buf = (char*) malloc(bufLength);
				if (buf) {
					glGetProgramInfoLog(program, bufLength, NULL, buf);
//					LOGE("Could not link program:\n%s\n", buf);
					free(buf);
				}
			}
			glDeleteProgram(program);
			program = 0;
		}
	}
	return program;
}

void pageT::removeAll()
{
	if (gProgram)
	{
		glDeleteProgram(gProgram);
	}
	if (_shadowProgram)
	{
		glDeleteProgram(_shadowProgram);
	}
	if (_shadowEgdeProgram)
	{
		glDeleteProgram(_shadowEgdeProgram);
	}
	if (_vbo)
	{
		glDeleteBuffers(1, &_vbo);
	}
	if (_ibo)
	{
		glDeleteBuffers(1, &_ibo);
	}
    if(_vaoPlane)
    {
        glDeleteVertexArrays(1, &_vaoPlane);
    }
//	if (_tbo)
//	{
//		glDeleteBuffers(1, &_tbo);
//	}
	if (_shadowVbo)
	{
		glDeleteBuffers(1, &_shadowVbo);
	}
    if(_vaoSelfShadow)
    {
        glDeleteVertexArrays(1, &_vaoSelfShadow);
    }
//	if (_shadowTbo)
//	{
//		glDeleteBuffers(1, &_shadowTbo);
//	}
	if (_shadowEgdeRightVbo)
	{
		glDeleteBuffers(1, &_shadowEgdeRightVbo);
	}
    
//	if (_shadowEgdeRightTbo)
//	{
//		glDeleteBuffers(1, &_shadowEgdeRightTbo);
//	}
	if (_shadowEgdeBottomVbo)
	{
		glDeleteBuffers(1, &_shadowEgdeBottomVbo);
	}
    
    if(_vaoEdgeShadow[0] && _vaoEdgeShadow[1])
    {
        glDeleteVertexArrays(2, _vaoEdgeShadow);
    }
//	if (_shadowEgdeBottomTbo)
//	{
//		glDeleteBuffers(1, &_shadowEgdeBottomTbo);
//	}
    
}

void pageT::createPlane()
{
//	GLfloat *gVertex = new GLfloat[widthSize * heightSize * 2 * sizeof(GLfloat)];
//	GLfloat *gTexcoord = new GLfloat[widthSize * heightSize * 2 * sizeof(GLfloat)];
	GLushort *gIndex = new GLushort[width * height * 2 * 3 * sizeof(GLushort)];
    
    GLfloat *gVertexTexcoord = new GLfloat[widthSize * heightSize * 2 * 2 * sizeof(GLfloat)];
    

	float detWidth = bili / width;
	float detWidthUV = 1.0 / width;
	float detHeight = 1.0 / height;
	//create the plane point;
	for (unsigned i = 0; i < heightSize; ++i)
	{
		for (unsigned j = 0; j < widthSize; ++j)
		{
//			*(gVertex + (i * widthSize + j) * 2) = j * detWidth * 2 - bili;
//			*(gVertex + (i * widthSize + j) * 2 + 1) = 1 - i * detHeight * 2;
//
//			*(gTexcoord + (i * widthSize + j) * 2) = j * detWidthUV;
//			*(gTexcoord + (i * widthSize + j) * 2 + 1) = i * detHeight;
            
            
            *(gVertexTexcoord + (i * widthSize + j) * 4) = j * detWidth * 2 - bili;
            *(gVertexTexcoord + (i * widthSize + j) * 4 + 1) = 1 - i * detHeight * 2;
            *(gVertexTexcoord + (i * widthSize + j) * 4 + 2) = j * detWidthUV;
            *(gVertexTexcoord + (i * widthSize + j) * 4 + 3) = i * detHeight;
		}
	}

	for (unsigned i = 0; i < height; ++i)
	{
		for (unsigned j = 0; j < width; ++j)
		{
			*(gIndex + (i * width + j) * 6) = i * widthSize + j;
			*(gIndex + (i * width + j) * 6 + 1) = (i + 1) * widthSize + j;
			*(gIndex + (i * width + j) * 6 + 2) = (i + 1) * widthSize + j + 1;

			*(gIndex + (i * width + j) * 6 + 3) = (i + 1) * widthSize + j + 1;
			*(gIndex + (i * width + j) * 6 + 4) = i * widthSize + j + 1;
			*(gIndex + (i * width + j) * 6 + 5) = i * widthSize + j;
		}
	}
    
    glGenVertexArrays(1, &_vaoPlane);
    glBindVertexArray(_vaoPlane);
    
    glGenBuffers(1, &_vbo);
	checkGlError("glGenBuffers");
	glBindBuffer(GL_ARRAY_BUFFER, _vbo);
	glBufferData(GL_ARRAY_BUFFER, widthSize * heightSize * 2 * 2 * sizeof(GLfloat), gVertexTexcoord, GL_STATIC_DRAW);
	glVertexAttribPointer(gvPositionHandle, 2, GL_FLOAT, GL_FALSE, 4 * sizeof(GLfloat), 0);
    glVertexAttribPointer(gvTexcoordHandle, 2, GL_FLOAT, GL_FALSE, 4 * sizeof(GLfloat), (const void*)(2 * sizeof(GLfloat) ));
    glEnableVertexAttribArray(gvPositionHandle);
    glEnableVertexAttribArray(gvTexcoordHandle);
    
//	glGenBuffers(1, &_vbo);
//	checkGlError("glGenBuffers");
//	glBindBuffer(GL_ARRAY_BUFFER, _vbo);
//	glBufferData(GL_ARRAY_BUFFER, widthSize * heightSize * 2 * sizeof(GLfloat), gVertex, GL_STATIC_DRAW);
//	glVertexAttribPointer(gvPositionHandle, 2, GL_FLOAT, GL_FALSE, 0, 0);
//    glEnableVertexAttribArray(gvPositionHandle);

//	glGenBuffers(1, &_tbo);
//	glBindBuffer(GL_ARRAY_BUFFER, _tbo);
//	glBufferData(GL_ARRAY_BUFFER, widthSize * heightSize * 2 * sizeof(GLfloat), gTexcoord, GL_STATIC_DRAW);
//    glVertexAttribPointer(gvTexcoordHandle, 2, GL_FLOAT, GL_FALSE, 0, 0);
//    glEnableVertexAttribArray(gvTexcoordHandle);

	glGenBuffers(1, &_ibo);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _ibo);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, width * height * 2 * 3 * sizeof(GLushort), gIndex, GL_STATIC_DRAW);
	
    glBindVertexArray(0);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
	   
//	delete[] gVertex;
//	delete[] gTexcoord;
	delete[] gIndex;
    
    delete[] gVertexTexcoord;
}

void pageT::createEdgeShadow()
{
	float l = 0.03f;
	float alpha = 0.25f;

	double detWidth = (double) bili / width;
	double detHeight = (double) 1.0 / height;
    
    glGenVertexArrays(2, _vaoEdgeShadow);

//	float *gVertex = new float[(widthSize * 2 + 1) * 2];
//	float *gTexcoord = new float[widthSize * 2 + 1];
    
    GLfloat *gVertexTexcoord = new float[(widthSize * 2 + 1) * 3];

	for (int i = 0; i < widthSize; ++i) {
//		*(gVertex + 4 * i) = i * detWidth * 2 - bili;
//		*(gVertex + 4 * i + 1) = -1.0f;
//
//		*(gVertex + 4 * i + 2) = i * detWidth * 2 - bili;
//		*(gVertex + 4 * i + 3) = -1.0f - l;
//
//		*(gTexcoord + 2 * i) = alpha;
//		*(gTexcoord + 2 * i + 1) = 0.0f;
        
        *(gVertexTexcoord + 6 * i) = i * detWidth * 2 - bili;
		*(gVertexTexcoord + 6 * i + 1) = -1.0f;
        
        *(gVertexTexcoord + 6 * i + 2) = alpha;
        
        
		*(gVertexTexcoord + 6 * i + 3) = i * detWidth * 2 - bili;
		*(gVertexTexcoord + 6 * i + 4) = -1.0f - l;
		
		*(gVertexTexcoord + 6 * i + 5) = 0.0f;
	}

//	*(gVertex + 4 * widthSize) = bili + l * 0.71;
//	*(gVertex + 4 * widthSize + 1) = -1.0f - l * 0.71;
//
//	*(gTexcoord + 2 * widthSize) = 0.0f;
    
    *(gVertexTexcoord + 6 * widthSize) = bili + l * 0.71;
	*(gVertexTexcoord + 6 * widthSize + 1) = -1.0f - l * 0.71;
    
	*(gVertexTexcoord + 6 * widthSize + 2) = 0.0f;
    
    glBindVertexArray(_vaoEdgeShadow[0]);
    
    glGenBuffers(1, &_shadowEgdeBottomVbo);
	checkGlError("glGenBuffers");
	glBindBuffer(GL_ARRAY_BUFFER, _shadowEgdeBottomVbo);
	glBufferData(GL_ARRAY_BUFFER, (widthSize * 2 + 1) * 3 * sizeof(GLfloat), gVertexTexcoord, GL_STATIC_DRAW);
    glVertexAttribPointer(gvPositionHandle, 2, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat), 0);
    glVertexAttribPointer(gvTexcoordHandle, 1, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat), (const void*)(2*sizeof(GLfloat)));
    glEnableVertexAttribArray(gvPositionHandle);
    glEnableVertexAttribArray(gvTexcoordHandle);

//	glGenBuffers(1, &_shadowEgdeBottomVbo);
//	checkGlError("glGenBuffers");
//	glBindBuffer(GL_ARRAY_BUFFER, _shadowEgdeBottomVbo);
//	glBufferData(GL_ARRAY_BUFFER, (widthSize * 2 + 1) * 2 * sizeof(GLfloat), gVertex, GL_STATIC_DRAW);
//    glVertexAttribPointer(gvPositionHandle, 2, GL_FLOAT, GL_FALSE, 0, 0);
//    glEnableVertexAttribArray(gvPositionHandle);
//
//	glGenBuffers(1, &_shadowEgdeBottomTbo);
//	glBindBuffer(GL_ARRAY_BUFFER, _shadowEgdeBottomTbo);
//	glBufferData(GL_ARRAY_BUFFER, (widthSize * 2 + 1) * sizeof(GLfloat), gTexcoord, GL_STATIC_DRAW);
//    glVertexAttribPointer(gvTexcoordHandle, 1, GL_FLOAT, GL_FALSE, 0, 0);
//    glEnableVertexAttribArray(gvTexcoordHandle);
    
    glBindVertexArray(0);
	glBindBuffer(GL_ARRAY_BUFFER, 0);

//	delete[] gVertex;
//	delete[] gTexcoord;
    delete[] gVertexTexcoord;

	//---------------------------------------------------------------------------------------------------

//	gVertex = new float[(heightSize * 2 + 1) * 2];
//	gTexcoord = new float[heightSize * 2 + 1];
    
    gVertexTexcoord = new float[(heightSize * 2 + 1) * 3];

	for (int i = 0; i < heightSize; ++i) {
//		*(gVertex + 4 * i) = bili + l;
//		*(gVertex + 4 * i + 1) = 1.0f - i * detHeight * 2.0f;
//
//		*(gVertex + 4 * i + 2) = bili;
//		*(gVertex + 4 * i + 3) = 1.0f - i * detHeight * 2.0f;
//
//		*(gTexcoord + 2 * i) = 0;
//		*(gTexcoord + 2 * i + 1) = alpha;
        
        *(gVertexTexcoord + 6 * i) = bili + l;
		*(gVertexTexcoord + 6 * i + 1) = 1.0f - i * detHeight * 2.0f;
        
        *(gVertexTexcoord + 6 * i + 2) = 0;
        
		*(gVertexTexcoord + 6 * i + 3) = bili;
		*(gVertexTexcoord + 6 * i + 4) = 1.0f - i * detHeight * 2.0f;
		
		*(gVertexTexcoord + 6 * i + 5) = alpha;
	}

//	*(gVertex + 4 * heightSize) = bili + l * 0.71;
//	*(gVertex + 4 * heightSize + 1) = -1.0f - l * 0.71;
//
//	*(gTexcoord + 2 * heightSize) = 0.0f;
    
    *(gVertexTexcoord + 6 * heightSize) = bili + l * 0.71;
	*(gVertexTexcoord + 6 * heightSize + 1) = -1.0f - l * 0.71;
    
	*(gVertexTexcoord + 6 * heightSize + 2) = 0.0f;

    glBindVertexArray(_vaoEdgeShadow[1]);
    
    glGenBuffers(1, &_shadowEgdeRightVbo);
	checkGlError("glGenBuffers");
	glBindBuffer(GL_ARRAY_BUFFER, _shadowEgdeRightVbo);
	glBufferData(GL_ARRAY_BUFFER, (heightSize * 2 + 1) * 3 * sizeof(GLfloat), gVertexTexcoord, GL_STATIC_DRAW);
    glVertexAttribPointer(gvPositionHandle, 2, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat), 0);
    glVertexAttribPointer(gvTexcoordHandle, 1, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat), (const void*)(2*sizeof(GLfloat)));
    glEnableVertexAttribArray(gvPositionHandle);
    glEnableVertexAttribArray(gvTexcoordHandle);
    
//	glGenBuffers(1, &_shadowEgdeRightVbo);
//	checkGlError("glGenBuffers");
//	glBindBuffer(GL_ARRAY_BUFFER, _shadowEgdeRightVbo);
//	glBufferData(GL_ARRAY_BUFFER, (heightSize * 2 + 1) * 2 * sizeof(GLfloat), gVertex, GL_STATIC_DRAW);
//    glVertexAttribPointer(gvPositionHandle, 2, GL_FLOAT, GL_FALSE, 0, 0);
//    glEnableVertexAttribArray(gvPositionHandle);
//
//	glGenBuffers(1, &_shadowEgdeRightTbo);
//	glBindBuffer(GL_ARRAY_BUFFER, _shadowEgdeRightTbo);
//	glBufferData(GL_ARRAY_BUFFER, (heightSize * 2 + 1) * sizeof(GLfloat), gTexcoord, GL_STATIC_DRAW);
//    glVertexAttribPointer(gvTexcoordHandle, 1, GL_FLOAT, GL_FALSE, 0, 0);
//    glEnableVertexAttribArray(gvTexcoordHandle);
    
    glBindVertexArray(0);
	glBindBuffer(GL_ARRAY_BUFFER, 0);
    
//	delete[] gVertex;
//	delete[] gTexcoord;
    delete[] gVertexTexcoord;

}
//============================================================================================================
void pageT::createShadowPlane()
{
	float xMin = -0.0f;
	float xMax = 0.35f + _radius * 0.5f;
	float yMin = -10.0f;
	float yMax = 10.0f;
//	GLfloat gVertex[] = { xMin, yMax, xMin, yMin, xMax, yMin, xMin, yMax, xMax,
//			yMin, xMax, yMax, };
//
//	GLfloat gTexcoord[] = { 0.0f, 0.0f, 0.0f, 1.0f, 1.0f, 1.0f, 0.0f, 0.0f,
//			1.0f, 1.0f, 1.0f, 0.0f, };
    
    GLfloat gVertexTexcoord[] = {
        xMin, yMax, 0.0f, 0.0f, xMin, yMin, 0.0f, 1.0f,
        xMax, yMin, 1.0f, 1.0f, xMin, yMax, 0.0f, 0.0f,
        xMax, yMin, 1.0f, 1.0f, xMax, yMax, 1.0f, 0.0f,
    };

    glGenVertexArrays(1, &_vaoSelfShadow);
    glBindVertexArray(_vaoSelfShadow);
    
    glGenBuffers(1, &_shadowVbo);
	checkGlError("glGenBuffers");
	glBindBuffer(GL_ARRAY_BUFFER, _shadowVbo);
	glBufferData(GL_ARRAY_BUFFER, 2 * 3 * 2 * 2 * sizeof(GLfloat), gVertexTexcoord, GL_STATIC_DRAW);
    glVertexAttribPointer(gvPositionHandle, 2, GL_FLOAT, GL_FALSE, 4 * sizeof(GLfloat), 0);
    glVertexAttribPointer(gvTexcoordHandle, 2, GL_FLOAT, GL_FALSE, 4 * sizeof(GLfloat), (const void*)(2*sizeof(GLfloat)));
    glEnableVertexAttribArray(gvPositionHandle);
    glEnableVertexAttribArray(gvTexcoordHandle);

//	glGenBuffers(1, &_shadowVbo);
//	checkGlError("glGenBuffers");
//	glBindBuffer(GL_ARRAY_BUFFER, _shadowVbo);
//	glBufferData(GL_ARRAY_BUFFER, 2 * 3 * 2 * sizeof(GLfloat), gVertex, GL_STATIC_DRAW);
//    glVertexAttribPointer(gvPositionHandle, 2, GL_FLOAT, GL_FALSE, 0, 0);
//    glEnableVertexAttribArray(gvPositionHandle);
//
//	glGenBuffers(1, &_shadowTbo);
//	glBindBuffer(GL_ARRAY_BUFFER, _shadowTbo);
//	glBufferData(GL_ARRAY_BUFFER, 2 * 3 * 2 * sizeof(GLfloat), gTexcoord, GL_STATIC_DRAW);
//    glVertexAttribPointer(gvTexcoordHandle, 2, GL_FLOAT, GL_FALSE, 0, 0);
//    glEnableVertexAttribArray(gvTexcoordHandle);
	
    glBindVertexArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
}

void pageT::resetPageTurnEndPositionParamter()
{
	pos[0] = _max_left;
	pos[1] = 0.0f;
	dir[0] = -1.0f;
	dir[1] = 0.0f;

	grey = -0.5f;
}

void pageT::resetPageTurnBeginPositionParamter()
{
	pos[0] = bili;
	pos[1] = 0.0f;
	dir[0] = -1.0f;
	dir[1] = 0.0f;

	grey = -0.5f;
}

void pageT::renderOver()
{
	_fingerOn = false;
}

void pageT::fingerUp()
{
	_fingerHelp = true;
}

void pageT::setFingerOn(bool on)
{
	_fingerOn = on;
	fingerUp();
	if(_fingerOn)
	{
		//grey = (dir[1] < 0) ? ((dir[0] / dir[1]) / Pi) : ((dir[0] / dir[1]) / Pi - 1);

		if (dir[1] >= 0) grey = atan(dir[0] / dir[1]) / Pi;
		else if(dir[1] < 0) grey = atan(dir[0] / dir[1]) / Pi - 1;

		_dotRadian = _horizon ? 0 : (fabs(grey + 0.5) * dotTime * 2);

		if (_right_to_left)
		{
			if (_goon_or_back)
				_dotLong = fabs(_max_left - pos[0]) * dotTime;
			else {
				_dotLong = fabs(pos[0] - dir[1] / dir[0] * (_sin_cos_1 - _yDir) + bili) * dotTime;
			}
		} else {
			if (_goon_or_back)
				_dotLong = fabs(pos[0] - bili) * dotTime;
			else
				_dotLong = fabs(pos[0] - _max_left) * dotTime;
		}
	}
}

void pageT::setNight(bool on)
{
	if(gProgram)
	{
		glUseProgram(gProgram);
		if(on) glUniform1f(_the_color, 0.0f);
		else glUniform1f(_the_color, 0.3f);
	}
}

void pageT::setTextures(GLuint *textures)
{
	page_texture = textures;
}

bool pageT::setupGraphics(int w, int h)
{
	bili = (float) w / h;
	one_bili = (float) h / w;

	define_position[0] = -bili;
	define_position[1] = one_bili;
	define_direction[0] = 1.0f;
	define_direction[1] = 0.0f;

	_fingerOn = false;
	_fingerHelp = true;
	_right_to_left = true;

	//_radius = r;
	_max_left = -bili - _radius * Pi;
	pos[0] = _max_left;

	glEnable(GL_CULL_FACE);
	glFrontFace(GL_CCW);
	//glEnable(GL_DEPTH_TEST);

	one_widthPix = (float) bili / w * 2.0f;
	one_heightPix = (float) 1.0f / h * 2.0f;

	width = w / 20;
	height = h / 20;

	widthSize = width + 1;
	heightSize = height + 1;

	printGLString("Version", GL_VERSION);
	printGLString("Vendor", GL_VENDOR);
	printGLString("Renderer", GL_RENDERER);
	printGLString("Extensions", GL_EXTENSIONS);

//	LOGI("setupGraphics(%d, %d)", w, h);
	gProgram = createProgram(_vertexShader, gFragmentShader);
	//_leftProgram = createProgram(_leftVertexShader, gFragmentShader);
	if (!gProgram) {
//		LOGE("Could not create program.");
		return false;
	}

	_lineParamter = glGetUniformLocation(gProgram, "lineParamter");
	_sin_cos = glGetUniformLocation(gProgram, "sin_cos");
	_R_PiR = glGetUniformLocation(gProgram, "R_PiR");
	_texture = glGetUniformLocation(gProgram, "texture");
	_the_color = glGetUniformLocation(gProgram, "the_color");
    glUniform1f(_the_color, 0.6f);
    glUniform1i(_texture, 0);

	_shadowProgram = createProgram(_shadowSelfVertexShader,
			_shadowSelfFragmentShader);
	if (!_shadowProgram) {
//		LOGE("Could not create program1.");
		return false;
	}

	_worldMat = glGetUniformLocation(_shadowProgram, "worldMat");
	_self_sin_cos = glGetUniformLocation(_shadowProgram, "sin_cos");
	_self_pos = glGetUniformLocation(_shadowProgram, "pos");

	_shadowEgdeProgram = createProgram(_shadowEgdeVertexShader,
			_shadowEgdeFragmentShader);
	if (!_shadowEgdeProgram) {
//		LOGE("Could not create program2.");
		return false;
	}

	_lineParamterEgde = glGetUniformLocation(_shadowEgdeProgram,
			"lineParamter");
	_sin_cosEgde = glGetUniformLocation(_shadowEgdeProgram, "sin_cos");
	_R_PiREgde = glGetUniformLocation(_shadowEgdeProgram, "R_PiR");

	gvPositionHandle = glGetAttribLocation(gProgram, "vPosition");
	
	checkGlError("glGetAttribLocation");
//	LOGI("glGetAttribLocation(\"vPosition\") = %d\n", gvPositionHandle);
	glBindAttribLocation(gProgram, gvPositionHandle, "vPosition");
	glBindAttribLocation(_shadowProgram, gvPositionHandle, "vPosition");
	glBindAttribLocation(_shadowEgdeProgram, gvPositionHandle, "vPosition");

	gvTexcoordHandle = glGetAttribLocation(gProgram, "vTexcoord");
	
	checkGlError("glGetAttribLocation");
//	LOGI("glGetAttribLocation(\"vTexcoord\") = %d\n", gvTexcoordHandle);
	glBindAttribLocation(gProgram, gvTexcoordHandle, "vTexcoord");
	glBindAttribLocation(_shadowProgram, gvTexcoordHandle, "vTexcoord");
	glBindAttribLocation(_shadowEgdeProgram, gvTexcoordHandle, "vTexcoord");

	//LOGI("sizeof(long long) = %d\n", sizeof(long long));

	createPlane();
	createShadowPlane();
	createEdgeShadow();
    
    glEnableVertexAttribArray(gvPositionHandle);
    glEnableVertexAttribArray(gvTexcoordHandle);
    
	glDisable(GL_DEPTH_TEST);
	//glEnable(GL_DEPTH_TEST);

	glViewport(0, 0, w, h);
	checkGlError("glViewport");
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
	return true;

}

#define FINGERSTARTUSED 0

void pageT::setFingerPosition(float x, float y)
{
	//LOGE("finger position: x = %f, y = %f", x, y);
	if (_fingerHelp)
	{
		_helpPosition[0] = bili;

		if (_right_to_left)
		{
			if (y < -0.4)
			{
				_helpPosition[1] = -1.0f;
				_horizon = false;
			}
			else if (y > 0.4)
			{
				_helpPosition[1] = 1.0f;
				_horizon = false;
			}
			else
			{
				_helpPosition[1] = y;
				_horizon = true;
			}
		} else {
			_horizon = true;
		}
		_fingerHelp = false;
	}
#if FINGERSTARTUSED
	if (_fingerOn)
	{
		//_xNowValue = x;

		//_xMaxValue = ((x < _xMaxValue) ^ _right_to_left) ? _xMaxValue : x;
#endif

		dir[0] = x - _helpPosition[0];
		dir[1] = _horizon ? 0 : (y - _helpPosition[1]);

		_helpValue = (sqrt(dir[0] * dir[0] + dir[1] * dir[1]));
		_sin_cos_0 = (dir[0] / _helpValue);
		_sin_cos_1 = (dir[1] / _helpValue);

		_yDir = (dir[1] >= 0) ? -1.0f : 1.0f;

		_helpValue = (_helpValue >= _radius * Pi) ? (_helpValue - (float) Pi * _radius) * 0.5f : -(sin(_helpValue / _radius) * _radius) * 0.5f;

		_sin_cos_0 = x - _helpValue * _sin_cos_0;
		_sin_cos_1 = y - _helpValue * _sin_cos_1;

		float h = dir[1] / dir[0] * (_sin_cos_1 - _yDir) + _sin_cos_0;

		pos[0] = _sin_cos_0;
		pos[1] = (h > -bili) ? (_sin_cos_1) : (dir[0] / dir[1] * (-bili - _sin_cos_0) + _yDir);

#if FINGERSTARTUSED
	}
#endif
}

void pageT::curl(float curlPos[2], float curlDir[2], float radius)
{
	lineParamter[0] = 1.0f; //y / x;
	lineParamter[1] = curlDir[1] / curlDir[0]; //-1;
	lineParamter[2] = curlPos[1] * (-lineParamter[1]) - curlPos[0]; //curlPos[1] - y / x * curlPos[0];
	lineParamter[3] = 1.0f / sqrt(1.0f + lineParamter[1] * lineParamter[1]);

	float help = (sqrt(curlDir[0] * curlDir[0] + curlDir[1] * curlDir[1]));
	sin_cos[0] = (curlDir[0] / help);
	sin_cos[1] = (curlDir[1] / help);
	sin_cos[2] = one_bili;

	R_PiR[0] = radius;
	R_PiR[1] = (float) radius * Pi;
	R_PiR[2] = (float) 1.0f / R_PiR[0];

    worldMat = GLKMatrix4MakeZRotation((float)(asin(sin_cos[1])));
    
	help = (float) (asin(sin_cos[1]));
    
	sin_cos_shadow[0] = sin(help);
	sin_cos_shadow[1] = -cos(help);
	sin_cos_shadow[2] = one_bili;
}

void pageT::renderFrame(int s)
{
	if(_fingerOn)
	{
		_nowTime = (s > 70) ? 1 : s;
		////////////////////////////////////////////
		if (_right_to_left)
		{
			if (_goon_or_back)
			{
				if (dir[1] >= 0)
				{
					if (grey <= -0.5f)
					{
						if (pos[0] > _max_left)
						{
							pos[0] -= _dotLong * _nowTime;
						}
						else
						{
							renderOver();
						}
					}
					else
					{
						if (grey - _dotRadian * _nowTime <= -0.5f)
						{
							grey = -0.5f;
						}
						else
						{
							grey -= _dotRadian * _nowTime;
						}
						pos[0] -= _dotLong * _nowTime;
					}
				}
				else if (dir[1] < 0)
				{
					if (grey >= -0.5f)
					{
						if (pos[0] > _max_left)
						{
							pos[0] -= _dotLong * _nowTime;
						}
						else
						{
							renderOver();
						}
					}
					else
					{
						if (grey + _dotRadian * _nowTime >= 0.5f)
						{
							grey = -0.5f;
						}
						else
						{
							grey += _dotRadian * _nowTime;
						}
						pos[0] -= _dotLong * _nowTime;
					}
				}
			}
			else
			{
				if (pos[0] < bili)
				{
					pos[0] += _dotLong * _nowTime;
					//pos[1] += _dotRadian * s;
				}
				else
				{
					renderOver();
				}
			}
		}
		else
		{
			if (_goon_or_back)
			{
				if (pos[0] < bili)
				{
					pos[0] += _dotLong * _nowTime;
				}
				else
				{
					renderOver();
				}
			}
			else
			{
				if (pos[0] > _max_left)
				{
					pos[0] -= _dotLong * _nowTime;
				}
				else
				{
					renderOver();
				}
			}
		}
		dir[0] = sin(grey * Pi);
		dir[1] = cos(grey * Pi);
	}

	glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);

//-------------------------------bottomPage------------------------------------------------------------------
	//curl(define_position, define_direction, _radius);
	glUseProgram(gProgram);

	glUniform4f(_lineParamter, define_direction[0] , define_direction[1], define_position[0], define_direction[0]);

	glBindTexture(GL_TEXTURE_2D, page_texture[0]);
	glCullFace(GL_BACK);
    glBindVertexArray(_vaoPlane);
	glDrawElements(GL_TRIANGLES, width * height * 2 * 3, GL_UNSIGNED_SHORT, 0);
    glBindVertexArray(0);
//---------------------------------pageSelfShadow--------------------------------------------------------------------
	curl(pos, dir, _radius);
    
	glEnable(GL_BLEND);

	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glBlendEquation(GL_FUNC_ADD);

	glUseProgram(_shadowProgram);
	glUniformMatrix4fv(_worldMat, 1, GL_FALSE, worldMat.m);
	glUniform3fv(_self_sin_cos, 1, sin_cos_shadow);
	glUniform2fv(_self_pos, 1, pos);

    glBindVertexArray(_vaoSelfShadow);
	glDrawArrays(GL_TRIANGLES, 0, 6);
	glDisable(GL_BLEND);

//------------------------------------page------------------------------------------------------------
	glUseProgram(gProgram);

	glUniform4fv(_lineParamter, 1, lineParamter);
	glUniform3fv(_sin_cos, 1, sin_cos);
	glUniform3fv(_R_PiR, 1, R_PiR);

	glBindTexture(GL_TEXTURE_2D, page_texture[1]);

    glBindVertexArray(_vaoPlane);
    
	glDrawElements(GL_TRIANGLES, width * height * 2 * 3, GL_UNSIGNED_SHORT, 0);

	glCullFace(GL_FRONT);

	glDrawElements(GL_TRIANGLES, width * height * 2 * 3, GL_UNSIGNED_SHORT, 0);
    glBindVertexArray(0);
//------------------------------------pageEdgeShadow------------------------------------------------------------
	glEnable(GL_BLEND);

	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glBlendEquation(GL_FUNC_ADD);

	glUseProgram(_shadowEgdeProgram);
	glUniform4fv(_lineParamterEgde, 1, lineParamter);
	glUniform3fv(_sin_cosEgde, 1, sin_cos);
	glUniform3fv(_R_PiREgde, 1, R_PiR);
    
    glBindVertexArray(_vaoEdgeShadow[0]);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 2 * widthSize + 1);
    
    glBindVertexArray(_vaoEdgeShadow[1]);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 2 * heightSize + 1);

	glDisable(GL_BLEND);

	glBindVertexArray(0);
}