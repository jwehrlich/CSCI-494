//
//  ViewController.h
//  Artillery
//
//  Created by default on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnvObj.h"
#import "EnvObj_Ground.h"
#import "EnvObj_Tank.h"
#import "EnvObj_Shell.h"

@interface ViewController : UIViewController{
    EnvObj_Tank* tankA;
    EnvObj_Tank* tankB;
    int turnNum;
}

-(void) clearEnvironment;
-(void) setupEnvironment: (int)maxWidth: (int)maxHeight;
-(void) setupTanks: (int)maxWidth: (int)maxHeight;
//-(void) fireShot: (int)startX: (int)startY: (int)velocity;
-(void) fireshotTankA: (NSNotification *)notification;
-(void) fireshotTankB: (NSNotification *)notification;
-(void)rotateTurn;

-(void)gameOver:(NSNotification *)notification;

-(CGFloat)findTopYfromX:(int)x:(int)maxHeight;

-(int)randomWidth:(int)start:(int)end;

-(void)AITurn;

@end
