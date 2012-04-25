//
//  EnvObj.h
//  Artillery
//
//  Created by default on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnvObj : UIView
{
    int Strength;
    int Height;
    int Width;
}
-(BOOL)getHit:(int)strength;
-(void)explode;
@end
