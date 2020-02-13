//
//  CubeFilter.cpp
//  HYPlayer
//
//  Created by templechen on 2020/2/13.
//  Copyright © 2020 templechen. All rights reserved.
//
#define GLES_SILENCE_DEPRECATION
#include "CubeFilter.h"
#import <Foundation/Foundation.h>
#include "vecmath.h"

void CubeFilter::init() {
    const char *vertex_shader_string = {
            "attribute vec4 aPosition;\n"
            "attribute vec2 aTextureCoord;\n"
            "varying vec2 vTextureCoord;\n"
            "uniform mat4 uMVPMatrix;\n"
            "void main()\n"
            "{\n"
            "    gl_Position = uMVPMatrix * aPosition;\n"
            "    vTextureCoord = aTextureCoord;\n"
            "}\n"
    };
    const char *fragment_shader_string = {
            "precision mediump float;\n"
            "varying vec2 vTextureCoord;\n"
            "uniform sampler2D samplerObj;\n"
            "void main()\n"
            "{\n"
            "    gl_FragColor = vec4(1.0, 1.0, 0.0, 1.0);\n"
            "}\n"
    };
    vertexShader = loadShader(GL_VERTEX_SHADER, vertex_shader_string);
    fragmentShader = loadShader(GL_FRAGMENT_SHADER, fragment_shader_string);
    program = createShaderProgram(vertexShader, fragmentShader);
    samplerObj = glGetUniformLocation(program, "samplerObj");
    mvpMatrixLocation = glGetUniformLocation(program, "uMVPMatrix");
    NSLog(@"%d %d %d %d %d", vertexShader, fragmentShader, program, mvpMatrixLocation, samplerObj);
    genBuffers(cubeVertex, sizeof(cubeVertex), cubeIndices, sizeof(cubeIndices));
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"jpeg" inDirectory:@""];
    textureId = loadImage([path cStringUsingEncoding:NSASCIIStringEncoding]);
}

void CubeFilter::doFrame() {
    viewMatrix = ndk_helper::Mat4::LookAt(ndk_helper::Vec3(0.0f, 0.0f, 20.0f / scaleIndex),
                                          ndk_helper::Vec3(0.f, 0.f, 0.f),
                                          ndk_helper::Vec3(0.f, 1.f, 0.f));
    modelMatrix = ndk_helper::Mat4::Identity();
    ndk_helper::Mat4 scrollXMat = ndk_helper::Mat4::RotationY(-PI * scrollX / 180);
    ndk_helper::Mat4 scrollYMat = ndk_helper::Mat4::RotationX(-PI * scrollY / 180);
    scrollX+=2.0f;
    scrollY+=2.0f;
    modelMatrix = scrollXMat * scrollYMat * modelMatrix;
    viewMatrix = viewMatrix * modelMatrix;
    ndk_helper::Mat4 mat_vp = projectionMatrix * viewMatrix;
    
    glUseProgram(program);
    glBindBuffer(GL_ARRAY_BUFFER, bonesBuffer);
    int32_t stride = sizeof(GLfloat) * 5;
    glVertexAttribPointer(CUBE_ATTRIB_POS, 3, GL_FLOAT, GL_FALSE, stride, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(CUBE_ATTRIB_POS);
    glVertexAttribPointer(CUBE_ATTRIB_TEX_COORD, 2, GL_FLOAT, GL_FALSE, stride, BUFFER_OFFSET(3 * sizeof(GLfloat)));
    glEnableVertexAttribArray(CUBE_ATTRIB_TEX_COORD);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indicesBuffer);
    GLint vertexCount = sizeof(cubeIndices) / (sizeof(cubeIndices[0]));
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, textureId);
    glUniform1i(samplerObj, 0);
    glUniformMatrix4fv(mvpMatrixLocation, 1, GL_FALSE, mat_vp.Ptr());
    glDrawElements(GL_TRIANGLES, vertexCount, GL_UNSIGNED_SHORT, BUFFER_OFFSET(0));
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindTexture(GL_TEXTURE_2D, 0);
}

void CubeFilter::bindAttributes(GLuint program) {
    glBindAttribLocation(program, CUBE_ATTRIB_POS, "aPosition");
    glBindAttribLocation(program, CUBE_ATTRIB_TEX_COORD, "aTextureCoord");
}
