//
//  ImageFilter.cpp
//  HYPlayer
//
//  Created by templechen on 2020/2/12.
//  Copyright © 2020 templechen. All rights reserved.
//
#define GLES_SILENCE_DEPRECATION
#include "ImageFilter.h"
#import <Foundation/Foundation.h>
#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"
#include "string"

ImageFilter::ImageFilter() {
    
}

ImageFilter::~ImageFilter() {
    
}

void ImageFilter::init() {
    const char *vertex_shader_string = {
            "attribute vec4 aPosition;\n"
            "attribute vec4 aTextureCoord;\n"
            "varying vec4 vTextureCoord;\n"
            "void main()\n"
            "{\n"
            "    gl_Position = aPosition;\n"
            "    vTextureCoord = aTextureCoord;\n"
            "}\n"
    };
    const char *fragment_shader_string = {
            "precision mediump float;\n"
            "varying vec4 vTextureCoord;\n"
            "uniform sampler2D samplerObj;\n"
            "void main()\n"
            "{\n"
            "    //gl_FragColor = texture2D(samplerObj, vTextureCoord);\n"
            "    gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);\n"
            "}\n"
    };
    vertexShader = loadShader(GL_VERTEX_SHADER, vertex_shader_string);
    fragmentShader = loadShader(GL_FRAGMENT_SHADER, fragment_shader_string);
    program = createShaderProgram(vertexShader, fragmentShader);
    NSLog(@"%d %d %d", vertexShader, fragmentShader, program);
    
    glGenBuffers(1, &bonesBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, bonesBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(imageVertex), imageVertex, GL_STATIC_DRAW);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    glGenBuffers(1, &indicesBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indicesBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(imageIndices), imageIndices, GL_STATIC_DRAW);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    
    loadImage();
}

void ImageFilter::doFrame() {
    NSLog(@"doFrame");
    glUseProgram(program);
    glBindBuffer(GL_ARRAY_BUFFER, bonesBuffer);
    int32_t stride = sizeof(GLfloat) * 4;
    glVertexAttribPointer(IMAGE_ATTRIB_POS, 2, GL_FLOAT, GL_FALSE, stride, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(IMAGE_ATTRIB_POS);
    glVertexAttribPointer(IMAGE_ATTRIB_TEX_COORD, 2, GL_FLOAT, GL_FALSE, stride, BUFFER_OFFSET(2 * sizeof(GLfloat)));
    glEnableVertexAttribArray(IMAGE_ATTRIB_TEX_COORD);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indicesBuffer);
    GLint vertexCount = sizeof(imageIndices) / (sizeof(imageIndices[0]));
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, textureId);
    GLuint samplerObj = glGetUniformLocation(program, "samplerObj");
    glUniform1i(samplerObj, 0);
    glDrawElements(GL_TRIANGLES, vertexCount, GL_UNSIGNED_SHORT, BUFFER_OFFSET(0));
    glBindBuffer(GL_ARRAY_BUFFER, 0);
}

void ImageFilter::bindAttributes(GLuint program) {
    glBindAttribLocation(program, IMAGE_ATTRIB_POS, "aPosition");
    glBindAttribLocation(program, IMAGE_ATTRIB_TEX_COORD, "aTextureCoord");
}

void ImageFilter::loadImage() {
    int x, y, comp;
    std::string fileloc = "test.jpeg";
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"jpeg" inDirectory:@"image"];
    NSLog(@"test.jpeg path is %@", path);
    unsigned char *data = stbi_load(fileloc.data(), &x, &y, &comp, STBI_default);

    glGenTextures(1, &textureId);
    GLuint format = GL_RGB;
    if (comp == 1) {
        format = GL_LUMINANCE;
    } else if (comp == 2) {
        format = GL_LUMINANCE_ALPHA;
    } else if (comp == 3) {
        format = GL_RGB;
    } else if (comp == 4) {
        format = GL_RGBA;
    } else {
        //todo
        NSLog(@"unSupport type %d", comp);
    }
    if (nullptr != data) {
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, textureId);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexImage2D(GL_TEXTURE_2D, 0, format, x, y, 0, format, GL_UNSIGNED_BYTE, data);
        glBindTexture(GL_TEXTURE_2D, 0);
        stbi_image_free(data);
        NSLog(@"load image success %s", fileloc.data());
    } else {
        NSLog(@"load image fail %s", fileloc.data());
    }
}


