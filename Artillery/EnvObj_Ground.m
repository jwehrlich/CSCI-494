//
//  EnvObj_Ground.m
//  Artillery
//
//  Created by default on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EnvObj_Ground.h"

@implementation EnvObj_Ground
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.9 green:0.8 blue:.6 alpha:1.];    }
    return self;
}

-(void)explode{
    //NSLog(@"Exploding ground");
    [self removeFromSuperview];
}
@end
