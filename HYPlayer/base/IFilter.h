//
//  IFilter.hpp
//  HYPlayer
//
//  Created by templechen on 2020/2/12.
//  Copyright © 2020 templechen. All rights reserved.
//

#ifndef IFilter_hpp
#define IFilter_hpp

#include <stdio.h>
#import <OpenGLES/ES3/gl.h>
#include "vecmath.h"

#define BUFFER_OFFSET(i) ((char*)NULL + (i))
#define PI 3.1415926f

class IFilter {
    
public:
    
    virtual void init() = 0;
    
    virtual void doFrame() = 0;
    
    virtual void bindAttributes(GLuint program) = 0;
    
    virtual void genBuffers(const GLvoid* vertexArray, int vertexSize, const GLvoid* indicesArray, int indicesSize);
    
    GLuint loadImage(const char* path);

    virtual void setNativeWindowSize(int width, int height);
    
protected:
    
    GLuint program;
    GLuint vertexShader;
    GLuint fragmentShader;
    
    GLuint bonesBuffer = -1;
    GLuint indicesBuffer = -1;

    //utils
    GLuint loadShader(GLenum type, const char *shaderSrc);
    GLuint createShaderProgram(GLuint vertexShader, GLuint fragmentShader);
    
    //mvpMatrix
    ndk_helper::Mat4 projectionMatrix;
    ndk_helper::Mat4 viewMatrix;
    ndk_helper::Mat4 modelMatrix;
    int scrollX = 0;
    int scrollY = 0;
    float scaleIndex = 1.0f;
    GLuint mvpMatrixLocation = -1;
};

#endif /* IFilter_hpp */
