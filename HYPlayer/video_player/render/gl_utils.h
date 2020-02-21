//
//  gl_utils.hpp
//  HYPlayer
//
//  Created by templechen on 2020/2/21.
//  Copyright © 2020 templechen. All rights reserved.
//

#ifndef gl_utils_hpp
#define gl_utils_hpp

#include <stdio.h>
#ifdef __cplusplus
extern "C" {
#endif

#include <stdio.h>
#include <stdlib.h>
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

GLuint createProgram(const char *vertexShader, const char *fragShader);

GLuint loadShader(GLenum type, const char *shaderSrc);

void checkActiveUniform(GLuint program);

GLuint createTexture(GLenum type);

GLuint createTextureWithBytes(unsigned char *bytes, int width, int height);

GLuint createTextureWithOldTexture(GLuint texture, unsigned char *bytes, int width, int height);

void createFrameBuffer(GLuint *framebuffer, GLuint *texture, int width, int height);

void createFrameBuffers(GLuint *frambuffers, GLuint *textures, int width, int height, int size);

void checkGLError(const char *op);

#define SHADER_STRING(s) #s

GLuint createShaderProgram(GLuint vertexShader, GLuint fragmentShader);

#ifdef __cplusplus
}
#endif

#endif /* gl_utils_hpp */
