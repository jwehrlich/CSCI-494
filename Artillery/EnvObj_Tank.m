//
//  EnvObj_Tank.m
//  Artillery
//
//  Created by default on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EnvObj_Tank.h"
#import "EnvObj_Shell.h"

@implementation EnvObj_Tank
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:.5 green:.5 blue:.8 alpha:1.];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        [self setTurretLoc:frame.origin.x+frame.size.width/2: frame.origin.y];
    }
    return self;
}


#pragma mark - Set/Get functions
-(void)setName:(NSString*)name{
    myName = name;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(explode:) 
                                                 name:[NSString stringWithFormat:@"%@Explode",name]
                                               object:nil];
}

-(NSString*)getName{ return myName; }

-(void)setTurretLoc:(int) x: (int) y{
    turretX = x;
    turretY = y;
}

-(int)getTurretX{
    return turretX;
}

-(int)getTurretY{
    return turretY;
}


-(void)blinkOn{
    
}

-(void)blinkOff{
    
}


#pragma mark - Guesture Functions
-(BOOL) gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer
       shouldReceiveTouch:(UITouch*)touch
{
    return TRUE;
}

-(void) handleTap:(UITapGestureRecognizer*)tap
{
    [self fireShot:20:200:50:10];
}


-(void) fireShot: (int)startX: (int)startY: (int)velocity: (int)angle{
    NSLog(@"tapped %@",myName);
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"Fire%@",myName] object:nil];
}



-(void)explode{
    NSLog(@"eploding tank");
    
    NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:myName, @"loserName", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TankExploded" object:nil userInfo:userInfo];
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
