//
//  GLRenderer.h
//  HYPlayer
//
//  Created by templechen on 2020/2/12.
//  Copyright © 2020 templechen. All rights reserved.
//

class GLRenderer {
  
public:
    void viewCreated(void *layer);
    void viewChanged(int width, int height);
    void viewDoFrame();
    void viewDestroyed();
};
