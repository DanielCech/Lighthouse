//
//  BreakpointHandler.m
//  HeraclesTrainer
//
//  Created by Dan on 26.04.16.
//  Copyright © 2016 STRV. All rights reserved.
//

#import "BreakpointHandler.h"

@implementation BreakpointHandler

+ (void)createBreakpoint;
{
#if DEBUG
    asm("svc 0");
#endif
}

@end
