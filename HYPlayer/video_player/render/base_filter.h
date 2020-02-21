//
//  base_filter.hpp
//  HYPlayer
//
//  Created by templechen on 2020/2/21.
//  Copyright © 2020 templechen. All rights reserved.
//

#ifndef base_filter_hpp
#define base_filter_hpp

#include <stdio.h>

#import <OpenGLES/ES3/gl.h>
#include "matrix_util.h"

extern "C" {
#include <libavutil/frame.h>
};

static GLfloat videoVertex[] = {
        1.0f, 1.0f,
        -1.0f, 1.0f,
        -1.0f, -1.0f,
        1.0f, 1.0f,
        -1.0f, -1.0f,
        1.0f, -1.0f,
};

static GLfloat videoTexture[] = {
        1.0f, 1.0f,
        0.0f, 1.0f,
        0.0f, 0.0f,
        1.0f, 1.0f,
        0.0f, 0.0f,
        1.0f, 0.0f
};

#define GET_STR(x) #x

class base_filter {

public:
    base_filter();

    virtual ~base_filter();

    virtual void init_program();

    void drawFrame(AVFrame *avFrame);

    int screen_width = 0;
    int screen_height = 0;

protected:

    int width;
    int height;

    GLuint vertexShader;
    GLuint fragmentShader;
    GLuint program;

    const GLchar *aPosition = "aPosition";
    const GLchar *aTextureCoordinate = "aTextureCoordinate";
    const GLchar *uTextureMatrix = "uTextureMatrix";
    const GLchar *uTextureY = "uTextureY";
    const GLchar *uTextureU = "uTextureU";
    const GLchar *uTextureV = "uTextureV";
    const GLchar *uCoordinateMatrix = "uCoordMatrix";
    GLint aPositionLocation = -1.0;
    GLint aTextureCoordinateLocation = -1.0;
    GLint uTextureMatrixLocation = -1.0;
    GLint uTextureYLocation = -1.0;
    GLint uTextureULocation = -1.0;
    GLint uTextureVLocation = -1.0;
    GLint uCoordMatrixLocation = -1.0;

    virtual void initVertexShader();

    virtual void initFragmentShader();

    virtual void createTextures();

    virtual void releaseTextures();

    virtual void drawTextures(AVFrame *avFrame);

    const char *vertex_shader_string;

    const char *fragment_shader_string;

    ESMatrix *textureMatrix;

    void initMatrix();

    GLuint yTexture;
    GLuint uTexture;
    GLuint vTexture;

    void checkVideoSize(AVFrame *frame);

    ESMatrix *uCoordMatrix;

    void initCoordMatrix();
};

#endif /* base_filter_hpp */
