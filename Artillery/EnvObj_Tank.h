//
//  EnvObj_Tank.h
//  Artillery
//
//  Created by default on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EnvObj.h"

@interface EnvObj_Tank : EnvObj<UIGestureRecognizerDelegate>{
    NSString* myName;
    int turretX;
    int turretY;
}

-(void)fireShot: (int)startX: (int)startY: (int)velocity: (int)angle;
-(void)setName:(NSString*)name;
-(NSString*)getName;
-(void)setTurretLoc:(int) x: (int) y;
-(int)getTurretX;
-(int)getTurretY;
-(void)blinkOn;
-(void)blinkOff;

@end
