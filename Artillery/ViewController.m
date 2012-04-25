//
//  ViewController.m
//  Artillery
//
//  Created by default on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

static const int MAX_HEIGHT = 320;
static const int MAX_WIDTH = 480;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
    self.view.backgroundColor = [[UIColor alloc]
                                 initWithPatternImage:[UIImage imageNamed:@"iPhone_background_480x300.png"]];  
    [self setupEnvironment:MAX_WIDTH:MAX_HEIGHT];
    [self setupTanks:MAX_WIDTH:MAX_HEIGHT];
    //[self fireShot:50 :220 :50 :10];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fireshotTankA:) name:@"FireTankA" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fireshotTankB:) name:@"FireTankB" object:nil];
         
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameOver:)
                                                 name:[NSString stringWithFormat:@"TankExploded"]
                                               object:nil];
    
    //Setup blinking tank
    turnNum=0;
    [self rotateTurn];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark - Environment Setup
static int startingHeight;
static int currentHeight;
-(void) setupEnvironment: (int)maxWidth: (int)maxHeight{
    startingHeight = currentHeight = maxHeight*15/16;
    
    int i,j, tmpInt;
    for(i=0; i<maxWidth; i+=5){
        tmpInt = arc4random()%8-4;
        if(tmpInt+currentHeight < maxHeight && tmpInt+currentHeight > startingHeight)
            currentHeight += tmpInt;
        
        for(j=currentHeight; j<maxHeight; j+=3){
            EnvObj_Ground* view = [[EnvObj_Ground alloc]  initWithFrame:CGRectMake( i, j, 5, 5) ];
            [self.view addSubview:view];
        }
    }
}

-(void)clearEnvironment{
    for(UIView* theView in [self.view subviews]){
        [theView removeFromSuperview];
    }
}

-(CGFloat)findTopYfromX: (int)x: (int)maxHeight{
    int currentY = startingHeight-10;
    
    
    for(UIView* theView in [self.view subviews]){
        if(![self isEqual:theView]){
            for(int y=currentY; y<maxHeight; y++){
                if(CGRectIntersectsRect(CGRectMake(x, y, 2, 2), theView.frame)){
                    return y;
                }
            }
        }
    }    return currentY;
}

static const int tankWidthHeight = 20;
-(void) setupTanks: (int)maxWidth: (int)maxHeight{
    int randWidth = [self randomWidth:maxWidth*1/8 :maxWidth*1/4];
    tankA = [[EnvObj_Tank alloc] initWithFrame:CGRectMake(randWidth,
                                                          [self findTopYfromX:randWidth+(tankWidthHeight/2):maxHeight]-20, 
                                                          tankWidthHeight, 
                                                          tankWidthHeight)];
    
    randWidth = [self randomWidth:maxWidth*3/4 :maxWidth*7/8];
    tankB = [[EnvObj_Tank alloc] initWithFrame:CGRectMake(maxWidth*3/4, 
                                                          [self findTopYfromX:maxWidth*3/4+10:maxHeight]-20, 
                                                          tankWidthHeight, 
                                                          tankWidthHeight)];
    [tankA setName:@"TankA"];
    [tankB setName:@"TankB"];
    [self.view addSubview:tankA];
    [self.view addSubview:tankB];
}


-(int)randomWidth:(int)start :(int)end{
    int width = arc4random()%(end-start)+start;
    NSLog(@"TankStart: %i",width);
    return width;
}


-(void) fireShot: (CGPoint)startPoint: (CGPoint)velocity{
    EnvObj_Shell* shell = [[EnvObj_Shell alloc] initWithFrame:CGRectMake(startPoint.x, startPoint.y, 8, 8)];
    [self.view addSubview:shell];
    
    NSString* tankName;
    if(turnNum == 1)
        tankName = @"TankA";
    else
        tankName = @"TankB";
    
    //NSLog(@"Start fire");
    [shell startUpdate:startPoint:velocity:[self.view subviews]: tankName];
}

-(void) fireshotTankA: (NSNotification *)notification{
    if(turnNum == 0){
        //Setup the initial velocity
        CGPoint velocity;
        velocity.x = 10;
        velocity.y = -100;
        
        //setup the starting point
        CGPoint startPoint;
        startPoint.x = [tankA getTurretX];
        startPoint.y = [tankA getTurretY];
        
        [self fireShot:startPoint :velocity];
        [self rotateTurn];
    }
}

-(void) fireshotTankB: (NSNotification *)notification{
    if(turnNum == 1){
        //Setup the initial velocity
        CGPoint velocity;
        velocity.x = -10;
        velocity.y = -100;
        
        //setup the starting point
        CGPoint startPoint;
        startPoint.x = [tankB getTurretX];
        startPoint.y = [tankB getTurretY];
        
        [self fireShot:startPoint :velocity];
        [self rotateTurn];
    }
}

-(void)rotateTurn{
    if(turnNum != 0){
        turnNum = 0;
        [tankA blinkOn];
        [tankB blinkOff];
        [self AITurn];
        [self rotateTurn];
    }else{
        turnNum = 1;
        [tankA blinkOff];
        [tankB blinkOn];
    }
}

#pragma mark - Touch Handling

static CGPoint startPoint;

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    startPoint = [touch locationInView:self.view];
    //NSLog(@"X:%f, Y:%f",touchPoint.x, touchPoint.y);
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint endPoint = [touch locationInView:self.view];
    
    CGFloat dX = .35*(endPoint.x-startPoint.x);
    CGFloat dY = .35*(endPoint.y-startPoint.y);
    NSLog(@"dX:%f, dY:%f", dX, dY);
    
    if(dY < 0){
        if(turnNum==1){
            CGPoint velocity;
            velocity.x = dX;
            velocity.y = dY;
            
            NSLog(@"pVelX:%f, pVelY:%f", dX, dY);
            //setup the starting point
            CGPoint startPoint;
            startPoint.x = [tankA getTurretX];
            startPoint.y = [tankA getTurretY];
            
            [self fireShot:startPoint :velocity];
            [self rotateTurn];
        }else{
            CGPoint velocity;
            velocity.x = dX;
            velocity.y = dY;
            
            //setup the starting point
            CGPoint startPoint;
            startPoint.x = [tankB getTurretX];
            startPoint.y = [tankB getTurretY];
            
            [self fireShot:startPoint :velocity];
            [self rotateTurn];
        }
    }
    
}

#pragma mark - Artificial Intelligence
-(void)AITurn{
    int yVelocity = -1*(arc4random()%100);
    int xVelocity = -1*(arc4random()%100);
    NSLog(@"VelX:%i, VelY:%i",xVelocity, yVelocity);
    [self fireShot:CGPointMake([tankB getTurretX], [tankB getTurretY]) :CGPointMake(xVelocity, yVelocity) ];
}


#pragma mark - End of Game

-(void)gameOver:(NSNotification *)notification{
    NSString* player = [[notification userInfo] valueForKey:@"loserName"];
    NSLog(@"%@ is the loser",player);
    
    UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Loser" message:player delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert2 show];
    [self clearEnvironment];
    [self setupEnvironment:MAX_WIDTH:MAX_HEIGHT];
    [self setupTanks:MAX_WIDTH:MAX_HEIGHT];
}

@end
