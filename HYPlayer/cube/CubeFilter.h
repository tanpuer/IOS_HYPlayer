//
//  CubeFilter.hpp
//  HYPlayer
//
//  Created by templechen on 2020/2/13.
//  Copyright © 2020 templechen. All rights reserved.
//

#ifndef CubeFilter_hpp
#define CubeFilter_hpp

#include <stdio.h>
#include "IFilter.h"

static GLfloat cubeVertex[] = {
    -1.0, 1.0, -1.0, 0.0, 0.0,
    -1.0, -1.0, -1.0, 1.0, 0.0,
    -1.0, -1.0, 1.0, 1.0, 1.0,
    -1.0, 1.0, 1.0, 0.0, 1.0,
    1.0, 1.0, -1.0, 1.0, 0.0,
    1.0, -1.0, -1.0, 0.0, 0.0,
    1.0, -1.0, 1.0, 0.0, 1.0,
    1.0, 1.0, 1.0, 1.0, 1.0
};

static GLshort cubeIndices[] = {
    0, 1, 3, 3, 1, 2,
    4, 7, 6, 4, 6, 5,
    3, 2, 7, 6, 7, 2,
    0, 1, 4, 5, 1, 4,
    0, 3, 7, 4, 0, 7,
    1, 2, 6, 5, 1, 6
};

enum {
    CUBE_ATTRIB_POS,
    CUBE_ATTRIB_TEX_COORD
};

class CubeFilter : public IFilter {
    
public:
    void init() override;
    void doFrame() override;
    void bindAttributes(GLuint program) override;
private:
    GLuint textureId = -1;
    GLuint samplerObj = -1;
};

#endif /* CubeFilter_hpp */
