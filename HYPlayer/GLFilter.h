//
//  GLFilter.hpp
//  HYPlayer
//
//  Created by templechen on 2020/2/12.
//  Copyright © 2020 templechen. All rights reserved.
//

#ifndef GLFilter_hpp
#define GLFilter_hpp

#include <stdio.h>
#include "base/IFilter.hpp"

static GLfloat vertex[] = {
        0.0f, 0.5f,
        -0.5f, -0.5f,
        0.5f, -0.5f,
};

static short indices[] = {
    0, 1, 2
};

enum SHADER_ATTRIBUTES {
    ATTRIB_POS
};

class GLFilter : public IFilter{
    
public:
    
    GLFilter();
    ~GLFilter();
    void init() override;
    void doFrame() override;
    void bindAttributes(GLuint program) override;
    
private:

    GLuint bonesBuffer = -1;
    GLuint indicesBuffer = -1;

};

#endif /* GLFilter_hpp */
