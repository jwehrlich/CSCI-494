//
//  EnvObj_Shell.m
//  Artillery
//
//  Created by default on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EnvObj_Shell.h"

@implementation EnvObj_Shell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:1. green:1. blue:1. alpha:1.];
        gravity = 4.f;
    }
    return self;
}

-(void)explode{
    NSLog(@"eploding shell");
    [self removeFromSuperview];
}

-(void)startUpdate:(CGPoint)startPoint: (CGPoint)vel: (NSArray*)subviews: (NSString*)tankName{
    //NSLog(@"Seting up fire");
    FiredFromTank = tankName;
    position=startPoint;
    velocity=vel;
    subViewsInMainView=subviews;
    velocity.x *= .5;
    [self update];
}

-(void)update{
    //NSLog(@"Update until i hit");
    CGPoint origPosition = position;
    
    velocity.y += gravity;
    position.x += velocity.x;
    position.y += velocity.y;
    
    CGFloat slope = (origPosition.y-position.y)/(origPosition.x-position.x);
    CGFloat b = origPosition.y-slope*origPosition.x;
    int nextXtoCheck;
    
    //NSLog(@"startX:%f, startY:%f, slope:%f", origPosition.x, origPosition.y, slope);
    for(int y = origPosition.y; y<position.y; y++){
        nextXtoCheck = (y-b)/slope;
        self.center = CGPointMake(nextXtoCheck, y);
        //NSLog(@"nextX:%i, nextY:%i", nextXtoCheck, y);
        if([self clearArea:nextXtoCheck :y]){
            return;
        }
    }
    
    self.center = CGPointMake(position.x, position.y);
    [self performSelector:@selector(update) withObject:self afterDelay:(.1) ];
}

static const int MAX_WIDTH = 480;
static const int MAX_HEIGHT = 320;
-(BOOL)clearArea: (CGFloat)x: (CGFloat)y{
    if(x<0 || x>MAX_WIDTH || y>MAX_HEIGHT){
        [UpdateTimer invalidate];
        UpdateTimer = nil;
        [self explode];
        //NSLog(@"Out of bounds explode");
        return true;
    }
    for(UIView* theView in subViewsInMainView){
        if(![self isEqual:theView]){
            if(CGRectIntersectsRect(CGRectMake(x, y, 1, 1), theView.frame)){
                [UpdateTimer invalidate];
                UpdateTimer = nil;
                if([theView isKindOfClass:[EnvObj_Ground class]]){
                    [(EnvObj_Ground*)theView explode];
                }
                if([theView isKindOfClass:[EnvObj_Tank class]]){
                    if([(EnvObj_Tank*)theView getName] != FiredFromTank){
                        [(EnvObj_Tank*)theView explode];
                    }else{
                        continue;
                    }
                }
                [self explode];
                return true;
            }
        }
    }
    return false;
}

@end
