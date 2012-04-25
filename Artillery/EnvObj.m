//
//  EnvObj.m
//  Artillery
//
//  Created by default on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EnvObj.h"


@implementation EnvObj
-(id)init{
    Strength = 1;
    Height = 10;
    Width = 10;
    return self;
}


-(BOOL)getHit:(int)strength{
    Strength -= strength;
 
    if(Strength <= 0){
        [self explode ];
        return TRUE;
    }
    return FALSE;
}

-(void)explode{}
@end
