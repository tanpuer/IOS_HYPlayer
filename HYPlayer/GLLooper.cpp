//
//  GLLooper.cpp
//  HYPlayer
//
//  Created by templechen on 2020/2/12.
//  Copyright © 2020 templechen. All rights reserved.
//

#include "GLLooper.hpp"

void GLLooper::handleMessage(LooperMessage *msg) {
    switch (msg->what) {
        case kMsgGLViewCreated: {
            renderer = new GLRenderer();
            renderer->viewCreated(msg->obj);
            break;
        }
        case kMsgGLViewChanged: {
            if (renderer != nullptr) {
                renderer->viewChanged(msg->arg1, msg->arg2);
            }
            break;
        }
        case kMsgGLViewDoFrame: {
            if (renderer != nullptr) {
                renderer->viewDoFrame();
            }
            break;
        }
        case kMsgGLViewDestroyed: {
            if (renderer != nullptr) {
                renderer->viewDestroyed();
                quit();
            }
            break;
        }
        default:
            break;
    }
}

void GLLooper::pthreadExit() {
    if (renderer != nullptr) {
        delete renderer;
        renderer = nullptr;
    }
}
