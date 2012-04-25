//
//  EnvMap.h
//  Artillery
//
//  Created by Jason Jones on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnvObj.h"

@interface EnvMap : NSObject{
    int maxHeight;
    int maxWidth;
    EnvObj* map;
}

-(void)addToMap: (EnvObj*) object;


@end
