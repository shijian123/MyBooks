//
//  OpenGLView.h
//  one
//
//  Created by liruncheng on 14-4-24.
//  Copyright (c) 2014年 liruncheng. All rights reserved.
//2014年07月29日

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <GLKit/GLKMath.h>
#import <time.h>
#import <QuartzCore/QuartzCore.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>


@interface OpenGLView : GLKView{
    CAEAGLLayer* _eaglLayer;
    GLuint _colorRenderBuffer;
    
    NSDate* dat;// = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a;//=[dat timeIntervalSince1970]*1000;
    double now_time;
    double _time;
}

- (void)setupContext;
- (void)setFingerPosition : (float)x : (float)y;
- (bool)getRenderOver;
- (void)render;
- (void)UIimageTotexture : (unsigned) index : (UIImage*) image;
- (void)delinit_page;
- (void)setfingerOn : (bool) on;
- (void)setNight : (bool) on;
- (void)setRightToLeft : (bool) on;
- (void)setGoonOrBack : (bool) on;
- (void)resetPageTurnEndPositionParamter;
- (void)resetPageTurnBeginPositionParamter;
- (void)texturesExchange;


- (void)setSubView : (UIView*) view;


@end
