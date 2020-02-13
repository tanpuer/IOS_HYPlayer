//
//  IFilter.cpp
//  HYPlayer
//
//  Created by templechen on 2020/2/12.
//  Copyright © 2020 templechen. All rights reserved.
//
#define GLES_SILENCE_DEPRECATION
#include "IFilter.h"
#include "vector"
#include <string>
#import <Foundation/Foundation.h>
#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

void IFilter::genBuffers(const GLvoid *vertexArray, int vertexSize, const GLvoid *indicesArray, int indicesSize) {
    glGenBuffers(1, &bonesBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, bonesBuffer);
    glBufferData(GL_ARRAY_BUFFER, vertexSize * sizeof(GLfloat), vertexArray, GL_STATIC_DRAW);
    glBindBuffer(GL_ARRAY_BUFFER, 0);

    glGenBuffers(1, &indicesBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indicesBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, indicesSize * sizeof(GLshort), indicesArray, GL_STATIC_DRAW);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
}

GLuint IFilter::loadImage(const char *path) {
    int x, y, comp;
    GLuint textureId = -1;
    unsigned char *data = stbi_load(path, &x, &y, &comp, STBI_default);
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
        NSLog(@"load image success %s %d", path, textureId);
    } else {
        NSLog(@"load image fail %s", path);
    }
    return textureId;
}

GLuint IFilter::loadShader(GLenum type, const char *shaderSrc) {
    GLuint shader;
    GLint compiled;
    // 创建shader
    shader = glCreateShader(type);
    if (shader == 0) {
        return 0;
    }
    // 加载着色器的源码
    glShaderSource(shader, 1, &shaderSrc, NULL);
    // 编译源码
    glCompileShader(shader);
    // 检查编译状态
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
    if (!compiled) {
        GLint infoLen = 0;
        // 查询日志的长度判断是否有日志产生
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLen);

        if (infoLen > 1) {
            // 分配一个足以存储日志信息的字符串
            char *infoLog = (char *) malloc(sizeof(char) * infoLen);
            // 检索日志信息
            glGetShaderInfoLog(shader, infoLen, NULL, infoLog);
            // 使用完成后需要释放字符串分配的内存
            free(infoLog);
        }
        // 删除编译出错的着色器释放内存
        glDeleteShader(shader);
        return 0;
    }
    return shader;
}

GLuint IFilter::createShaderProgram(GLuint vertexShader, GLuint fragmentShader) {
    GLuint program;
    GLint linked;
    program = glCreateProgram();
    if (program == 0) {
        glDeleteShader(vertexShader);
        glDeleteShader(fragmentShader);
        return 0;
    }
    glAttachShader(program, vertexShader);
    glAttachShader(program, fragmentShader);
    // 链接program程序
    
    //bind attribute
    bindAttributes(program);
    
    glLinkProgram(program);
    // 检查链接状态
    glGetProgramiv(program, GL_LINK_STATUS, &linked);
    if (!linked) {
        GLint infoLen = 0;
        // 检查日志信息长度
        glGetProgramiv(program, GL_INFO_LOG_LENGTH, &infoLen);
        if (infoLen > 1) {
            // 分配一个足以存储日志信息的字符串
            char *infoLog = (char *) malloc(sizeof(char) * infoLen);
            // 检索日志信息
            glGetProgramInfoLog(program, infoLen, NULL, infoLog);
            // 使用完成后需要释放字符串分配的内存
            free(infoLog);
        }
        // 删除着色器释放内存
        glDeleteShader(vertexShader);
        glDeleteShader(fragmentShader);
        glDeleteProgram(program);
        return 0;
    }
    return program;
}
