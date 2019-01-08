//
//  OpenGLView.m
//  one
//
//  Created by liruncheng on 14-4-24.
//  Copyright (c) 2014年 liruncheng. All rights reserved.
//

#import "OpenGLView.h"
#include "pageT.h"

@implementation OpenGLView{
    pageT page;
    bool firstUIiamge;
    bool start;
    GLuint* textures;
    
    unsigned int texWidth;
    unsigned int texHeight;
    
    int timeX;
    
    UIView *m_view;
    
    //GLubyte *spriteData;
    
    CADisplayLink* displayLink;
}

- (void)dealloc
{
//    if(textures)
//    {
//        glDeleteTextures(2, textures);
//    }
//    free(textures);
//    textures = 0;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.enableSetNeedsDisplay = NO;
        
        start = true;
        firstUIiamge = true;
    }

    return self;
}

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (void)setupLayer {
    _eaglLayer = (CAEAGLLayer*) self.layer;
    _eaglLayer.opaque = YES;
}

- (void)setSubView : (UIView*) view
{
    [self removeFromSuperview];
    [m_view release];
    m_view = view;
    [self addSubview:m_view];
}

- (void)setupContext {
    
//    CGRect rect = [[UIScreen mainScreen] bounds];
    CGRect rect = self.bounds;
    CGFloat scale_screen=[UIScreen mainScreen].scale;
    CGSize size = rect.size;
    CGFloat the_width = size.width * scale_screen;
    CGFloat the_height = size.height * scale_screen;
    page.setupGraphics((int)the_width, (int)the_height);
    
    dat = [NSDate dateWithTimeIntervalSinceNow:0];
    _time =[dat timeIntervalSince1970];
    
    textures = new GLuint[2];
    glGenTextures(2, textures);
    page.setTextures(textures);
    
//    NSLog(@"%s",glGetString(GL_EXTENSIONS));
}

- (void)setFingerPosition : (float)x : (float)y {
    //page.setFingerPosition(x, y);
    page.setFingerPosition((float)(page.getOneWidthPix() * x - page.getBili()), (float)(1.0f - page.getOneHeightPix() * y));
}

- (bool)getRenderOver {
    return page.getRenderOver();
}

- (void)texturesExchange{
    int h = textures[0];
    textures[0] = textures[1];
    textures[1] = h;
}

- (void)render {
    dat = [NSDate dateWithTimeIntervalSinceNow:0];
    now_time =[dat timeIntervalSince1970];
    timeX = (now_time - _time) * 1000;
    page.renderFrame(timeX);
//    color += 0.01;
//    if(color > 1.0) color = 0;
//    glClearColor(0.0, color, 0.5, 1.0);
//    glClear(GL_COLOR_BUFFER_BIT);
    _time = now_time;
}

- (void) UIimageTotexture : (unsigned) index : (UIImage*) image{
    CGImageRef textureImage;
    CGContextRef textureContext;
    
    textureImage = image.CGImage;
    unsigned int width = (unsigned int)CGImageGetWidth(textureImage);
    unsigned int height = (unsigned int)CGImageGetHeight(textureImage);
    
    if(firstUIiamge)
    {
//        if(width <= 512) texWidth = 512;
//        else if(width > 512 && width <= 1024) texWidth = 1024;
//        else if(width > 1024 && width <= 2048) texWidth = 2048;
//        else texWidth = 4096;
//    
//        if(height <= 512) texHeight = 512;
//        else if(height > 512 && height <= 1024) texHeight = 1024;
//        else if(height > 1024 && height <= 2048) texHeight = 2048;
//        else texHeight = 4096;
        
        texWidth = width;
        texHeight = height;
        
        GLubyte *data;
        data = (GLubyte *) malloc(texWidth * texHeight * 4);
        
        glBindTexture(GL_TEXTURE_2D, textures[0]);
        
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, texWidth, texHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
        
        glBindTexture(GL_TEXTURE_2D, textures[1]);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, texWidth, texHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
        
        free(data);
        
        firstUIiamge = false;
    }
    
    GLubyte *spriteData;
    spriteData = (GLubyte *) malloc(width * height * 4);
    textureContext = CGBitmapContextCreate(spriteData, width, height, 8, width * 4,
                                           CGImageGetColorSpace(textureImage), kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(textureContext, CGRectMake(0.0, 0.0, (float)width, (float)height), textureImage);
    
    glBindTexture(GL_TEXTURE_2D, textures[index]);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);
    CGContextRelease(textureContext);
    
//    NSLog(@"width = %d, height = %d", width, height);
//    NSLog(@"textures 1 = %d, 2 = %d", textures[0], textures[1]);
    [self display];
}

- (void)delinit_page {
//    page.removeAll();
    page.removeAll();
    if(!start)
    {
        glDeleteTextures(2, textures);
    }
    free(textures);
//    [super dealloc];
}

- (void)setfingerOn : (bool) on {
    page.setFingerOn(on);
}

- (void)displayThis{
    [self display];
}

- (void)render:(CADisplayLink*)displayLink {
    [self display];
}

- (void)setNight : (bool) on{
    page.setNight(on);
}

- (void)setRightToLeft : (bool) on{
    page.setRightToLeft(on);
}

- (void)setGoonOrBack : (bool) on{
    page.setGoonOrBack(on);
}

- (void)resetPageTurnEndPositionParamter{
    page.resetPageTurnEndPositionParamter();
}

- (void)resetPageTurnBeginPositionParamter{
    page.resetPageTurnBeginPositionParamter();
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
