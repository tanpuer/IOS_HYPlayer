//
//  GLFilter.cpp
//  HYPlayer
//
//  Created by templechen on 2020/2/12.
//  Copyright © 2020 templechen. All rights reserved.
//
#define GLES_SILENCE_DEPRECATION
#include "TriangleFilter.h"
#include <string>
#import <Foundation/Foundation.h>
#include "vector"

#define BUFFER_OFFSET(i) ((char*)NULL + (i))

GLFilter::GLFilter() {
    
}

GLFilter::~GLFilter() {
    glDeleteProgram(program);
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    glDeleteBuffers(1, &bonesBuffer);
    glDeleteBuffers(1, &indicesBuffer);
}

void GLFilter::init() {
    const char *vertex_shader_string = {
            "attribute vec4 aPosition;\n"
            "void main()\n"
            "{\n"
            "    gl_Position = aPosition;\n"
            "}\n"
    };
    const char *fragment_shader_string = {
            "precision mediump float;\n"
            "void main()\n"
            "{\n"
            "    gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);\n"
            "}\n"
    };
    vertexShader = loadShader(GL_VERTEX_SHADER, vertex_shader_string);
    fragmentShader = loadShader(GL_FRAGMENT_SHADER, fragment_shader_string);
    program = createShaderProgram(vertexShader, fragmentShader);
    NSLog(@"%d %d %d", vertexShader, fragmentShader, program);
    
    glGenBuffers(1, &bonesBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, bonesBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertex), vertex, GL_STATIC_DRAW);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    glGenBuffers(1, &indicesBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indicesBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
}

void GLFilter::doFrame() {
    NSLog(@"doFrame");
    glUseProgram(program);
    glBindBuffer(GL_ARRAY_BUFFER, bonesBuffer);
    int32_t stride = sizeof(GLfloat) * 2;
    glVertexAttribPointer(ATTRIB_POS, 2, GL_FLOAT, GL_FALSE, stride, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(ATTRIB_POS);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indicesBuffer);
    GLint vertexCount = sizeof(vertex) / (sizeof(vertex[0]) * 2);
    glDrawElements(GL_TRIANGLES, vertexCount, GL_UNSIGNED_SHORT, BUFFER_OFFSET(0));
    glBindBuffer(GL_ARRAY_BUFFER, 0);
}

void GLFilter::bindAttributes(GLuint program) {
    glBindAttribLocation(program, ATTRIB_POS, "aPosition");
}
