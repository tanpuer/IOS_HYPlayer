//
//  ImageFilter.hpp
//  HYPlayer
//
//  Created by templechen on 2020/2/12.
//  Copyright © 2020 templechen. All rights reserved.
//

#ifndef ImageFilter_hpp
#define ImageFilter_hpp

#include <stdio.h>
#include "../base/IFilter.h"

static GLfloat imageVertex[] = {
    -1.0, 1.0, 0.0, 0.0,
    -1.0, -1.0, 0.0, 1.0,
    1.0, -1.0, 1.0, 1.0,
    1.0, 1.0, 1.0, 0.0
};

static GLshort imageIndices[] = {
    0, 1, 3, 3, 1, 2
};

enum IMAGE_SHADER_ATTRIBUTES {
    IMAGE_ATTRIB_POS,
    IMAGE_ATTRIB_TEX_COORD
};

class ImageFilter : public IFilter{
    
public:
    
    ImageFilter();
    ~ImageFilter();
    void init() override;
    void doFrame() override;
    void bindAttributes(GLuint program) override;
    
private:
    
    GLuint textureId = -1;
    GLuint samplerObj = -1;
    
};

#endif /* ImageFilter_hpp */
