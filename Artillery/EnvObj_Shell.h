//
//  EnvObj_Shell.h
//  Artillery
//
//  Created by default on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EnvObj.h"
#import "EnvObj_Ground.h"
#import "EnvObj_Tank.h"

@interface EnvObj_Shell : EnvObj
{
    CGPoint velocity;
    CGPoint position;
    int Radius;
    CGFloat gravity;
    NSArray* subViewsInMainView;
    
    NSTimer* UpdateTimer;
    NSString* FiredFromTank;
}

-(void)startUpdate:(CGPoint)startPoint :(CGPoint)vel: (NSArray*)subviews: (NSString*)tankName;
-(void)update;
//-(BOOL)checkForObstacle;
-(BOOL)clearArea: (CGFloat)x: (CGFloat)y;
//-(void)clearSurrounding:(CGPoint)start: (int)radius;

@end
