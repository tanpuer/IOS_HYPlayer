//
//  GLLooper.hpp
//  HYPlayer
//
//  Created by templechen on 2020/2/12.
//  Copyright © 2020 templechen. All rights reserved.
//

#ifndef GLLooper_hpp
#define GLLooper_hpp

#include <stdio.h>
#include "Looper.hpp"
#include "GLRenderer.h"

class GLLooper : public Looper {
    
public:
    enum {
        kMsgGLViewCreated,
        kMsgGLViewChanged,
        kMsgGLViewDoFrame,
        kMsgGLViewDestroyed
    };
    
    void handleMessage(LooperMessage *msg) override;
    
    void pthreadExit() override;
    
private:
    
    GLRenderer *renderer = nullptr;
};

#endif /* GLLooper_hpp */
