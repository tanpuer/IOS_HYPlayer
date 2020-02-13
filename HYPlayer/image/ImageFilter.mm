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
#include "string"

ImageFilter::ImageFilter() {
    
}

ImageFilter::~ImageFilter() {
    
}

void ImageFilter::init() {
    const char *vertex_shader_string = {
            "attribute vec4 aPosition;\n"
            "attribute vec2 aTextureCoord;\n"
            "varying vec2 vTextureCoord;\n"
            "void main()\n"
            "{\n"
            "    gl_Position = aPosition;\n"
            "    vTextureCoord = aTextureCoord;\n"
            "}\n"
    };
    const char *fragment_shader_string = {
            "precision mediump float;\n"
            "varying vec2 vTextureCoord;\n"
            "uniform sampler2D samplerObj;\n"
            "void main()\n"
            "{\n"
            "    gl_FragColor = texture2D(samplerObj, vTextureCoord);\n"
            "}\n"
    };
    vertexShader = loadShader(GL_VERTEX_SHADER, vertex_shader_string);
    fragmentShader = loadShader(GL_FRAGMENT_SHADER, fragment_shader_string);
    program = createShaderProgram(vertexShader, fragmentShader);
    samplerObj = glGetUniformLocation(program, "samplerObj");
    NSLog(@"%d %d %d", vertexShader, fragmentShader, program);
    genBuffers(imageVertex, sizeof(imageVertex), imageIndices, sizeof(imageIndices));
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"jpeg" inDirectory:@""];
    textureId = loadImage([path cStringUsingEncoding:NSASCIIStringEncoding]);
}

void ImageFilter::doFrame() {
//    NSLog(@"doFrame");
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
    glUniform1i(samplerObj, 0);
    glDrawElements(GL_TRIANGLES, vertexCount, GL_UNSIGNED_SHORT, BUFFER_OFFSET(0));
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindTexture(GL_TEXTURE_2D, 0);
}

void ImageFilter::bindAttributes(GLuint program) {
    glBindAttribLocation(program, IMAGE_ATTRIB_POS, "aPosition");
    glBindAttribLocation(program, IMAGE_ATTRIB_TEX_COORD, "aTextureCoord");
}
