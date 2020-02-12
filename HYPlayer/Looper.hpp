//
//  Looper.hpp
//  HYPlayer
//
//  Created by templechen on 2020/2/12.
//  Copyright © 2020 templechen. All rights reserved.
//

#ifndef Looper_hpp
#define Looper_hpp

#include <stdio.h>
#include <sys/types.h>
#include <semaphore.h>

class Looper {
    
    public:
        struct LooperMessage {
            int what;
            int arg1;
            int arg2;
            void *obj;
            LooperMessage *next;
            bool quit;
        };

    public:

        Looper();

        virtual ~Looper();

        void sendMessage(int what);

        void sendMessage(int what, void *obj);

        void sendMessage(int what, int arg1, int arg2);

        void sendMessage(int what, int arg1, int arg2, void *obj);

        virtual void handleMessage(LooperMessage *msg);

        void quit();

        virtual void pthreadExit();

        int quitMessage = -100;

    private:

        void addMessage(LooperMessage *msg);

        static void *trampoline(void *p);

        void loop();

        pthread_t worker_thread;
        sem_t headwriteprotect;
        sem_t headdataavailable;

        LooperMessage *head;

        bool running;
};

#endif /* Looper_hpp */
