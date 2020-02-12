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

class IFilter {
    
public:
    
    virtual void init() = 0;
    
    virtual void doFrame() = 0;
    
    virtual void bindAttributes(GLuint program) = 0;
    
protected:
    
    GLuint program;
    GLuint vertexShader;
    GLuint fragmentShader;

    //utils
    GLuint loadShader(GLenum type, const char *shaderSrc);
    GLuint createShaderProgram(GLuint vertexShader, GLuint fragmentShader);
};

#endif /* IFilter_hpp */
