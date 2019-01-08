/*
 * pageT.h
 *
 *  Created on: 2014-6-16
 *      Author: liruncheng
 */

#ifndef PAGET_H_
#define PAGET_H_

#include <GLKit/GLKMath.h>

static void printGLString(const char *name, GLenum s) {
    const char *v = (const char *) glGetString(s);
//    LOGI("GL %s = %s\n", name, v);
}

static void checkGlError(const char* op) {
    for (GLint error = glGetError(); error; error = glGetError()) {
//        LOGI("after %s() glError (0x%x)\n", op, error);
    }
}

class pageT
{
public:
	pageT();
	~pageT();

	void removeAll();
	void createPlane();
	void createEdgeShadow();
	void createShadowPlane();

	void resetPageTurnEndPositionParamter();
	void resetPageTurnBeginPositionParamter();

	bool setupGraphics(int w, int h);
	void setFingerPosition(float x, float y);
	void curl(float curlPos[2], float curlDir[2], float radius);

	void renderFrame(int s);
	void renderOver();

	void fingerUp();

	bool getRightToLeft(){ return _right_to_left; }
	bool getGoonOrBack(){ return _goon_or_back; }
	bool getRenderOver(){ return _fingerOn; }

	void setRightToLeft(bool on){ _right_to_left = on; }
	void setGoonOrBack(bool on){ _goon_or_back = on; }
	//void setAutoOrManual(bool on){ _auto_or_manual = on; }
	void setNight(bool on);
	void setFingerOn(bool on);

	void setTextures(GLuint *textures);

	float getBili(){ return bili; }
	float getOneWidthPix() { return one_widthPix; }
	float getOneHeightPix() { return one_heightPix; }

protected:
	GLuint loadShader(GLenum shaderType, const char* pSource);
	GLuint createProgram(const char* pVertexSource, const char* pFragmentSource);

private:
//	const EGLContext mEglContext;

	GLint _ortho;
	GLint _lineParamter;
	GLint _sin_cos;
	GLint _R_PiR;
	GLint _texture;
	GLint _the_color;

	GLint _orthoEgde;
	GLint _lineParamterEgde;
	GLint _sin_cosEgde;
	GLint _R_PiREgde;

	GLint _worldMat;
	GLint _self_sin_cos;
	GLint _self_pos;

	//shader Program and attribute handle
	GLuint gProgram;
	GLuint _shadowProgram;
	GLuint _shadowEgdeProgram;

	GLuint gvPositionHandle;
	GLuint gvTexcoordHandle;

	GLuint _shadowPositionHandle;
	GLuint _shadowTexcoordHandle;
    
    GLuint _vaoPlane;
    GLuint _vaoSelfShadow;
    GLuint _vaoEdgeShadow[2];

	//textures pointer
	GLuint *page_texture;

	//all buffer handle
	GLuint _vbo, _ibo, _tbo;
	GLuint _shadowVbo, _shadowTbo;
	GLuint _shadowEgdeBottomVbo, _shadowEgdeBottomTbo;
	GLuint _shadowEgdeRightVbo, _shadowEgdeRightTbo;

	//used to create plane;
	float one_widthPix;
	float one_heightPix;

	unsigned width;//pixel width / 10
	unsigned height;//pixel height / 10

	unsigned widthSize;// = width + 1;
	unsigned heightSize;// = height + 1;

	double Pi;// = 3.141592653589793238462;
	float bili;
	float one_bili;

	GLKMatrix4 worldMat;

	float _max_left;

	GLfloat lineParamter[4];
	GLfloat sin_cos[3];
	GLfloat sin_cos_shadow[3];
	GLfloat R_PiR[3];

	float pos[2];
	float dir[2];
	float grey;

	float define_position[2];
	float define_direction[2];

	bool _fingerHelp;
	bool _fingerOn;
	bool _horizon; //
	bool _right_to_left;//true is right to left
	bool _goon_or_back;//true is go on;

	float _xNowValue, _xMaxValue;
	float _dotRadian, _dotLong;
	float _helpPosition[2];
	float _yDir;

	float dotTime; // 1.0 / dotTime = use time (ms)  0.002 * 500ms = 1

	int _nowTime;

	float _radius; //半径

	float _helpValue;// = (sqrt(dir[0] * dir[0] + dir[1] * dir[1]));
	float _sin_cos_0;// = (dir[0] / help);
	float _sin_cos_1;// = (dir[1] / help);
};


#endif /* PAGET_H_ */
