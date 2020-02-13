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
    0, 3, 2, 1, 0, 2,
    0, 1, 4, 5, 4, 1,
    4, 5, 6, 7, 4, 6,
    3, 7, 2, 2, 7, 6,
    0, 4, 3, 4, 7, 3,
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
