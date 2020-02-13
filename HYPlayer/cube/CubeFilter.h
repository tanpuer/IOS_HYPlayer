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

class CubeFilter : public IFilter {
    
public:
    void init() override;
    void doFrame() override;
    void bindAttributes(GLuint program) override;
private:
    
};

#endif /* CubeFilter_hpp */
