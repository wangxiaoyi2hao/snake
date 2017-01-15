//
//  HomeViewController.m
//  TanChiShe
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 lanqiao. All rights reserved.
//

#import "HomeViewController.h"
#import "CellPoint.h"
@interface HomeViewController ()
{
    UIImageView*TouImage;
    NSTimer *timer;
    CellPoint*cell;
    NSTimer*timer1;
    NSTimer*timer2;
    NSTimer*timer3;
    NSTimer*timer4;
    NSMutableArray*mutArray;
    int direc;
    CellPoint*_foodPoint;
    
}
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //音乐🎵
    NSURL*url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"back2" ofType:@"mp3"]];
    _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    _audioPlayer.numberOfLoops=-1;
    [_audioPlayer play];
    
    mutArray=[NSMutableArray array];
    CellPoint*c1=[CellPoint new];
    c1.x=1;
    c1.y=0;
    CellPoint*c2=[CellPoint new];
    c2.x=2;
    c2.y=0;
    CellPoint*c3=[CellPoint new];
    c3.x=3;
    c3.y=0;
    CellPoint*c4=[CellPoint new];
    c4.x=4;
    c4.y=0;
    [mutArray addObject:c1];
    [mutArray addObject:c2];
    [mutArray addObject:c3];
    [mutArray addObject:c4];
    
    
    timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timeWork) userInfo:nil repeats:YES];
    
    
    
    
    //轻扫手势
    UISwipeGestureRecognizer*swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    swipe.numberOfTouchesRequired=1;
    swipe.direction=UISwipeGestureRecognizerDirectionLeft;
    [_viewContent addGestureRecognizer:swipe];
    UISwipeGestureRecognizer*swipe2=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    swipe2.numberOfTouchesRequired=1;
    swipe2.direction=UISwipeGestureRecognizerDirectionRight;
    [_viewContent addGestureRecognizer:swipe2];
    UISwipeGestureRecognizer*swipe3=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    swipe3.numberOfTouchesRequired=1;
    swipe3.direction=UISwipeGestureRecognizerDirectionDown;
    [_viewContent addGestureRecognizer:swipe3];
    UISwipeGestureRecognizer*swipe4=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    swipe4.numberOfTouchesRequired=1;
    swipe4.direction=UISwipeGestureRecognizerDirectionUp;
    [_viewContent addGestureRecognizer:swipe4];
    
    //制造，，，，，，食物
    if (_foodPoint==nil) {
        while (YES) {
            NSLog(@"开始制造食物");
            //随机产生x,y坐标
            int randomx=arc4random()%20;
            int randomY=arc4random()%30;
            //产生食物
            _foodPoint=[[CellPoint alloc] init];
            _foodPoint.x=randomx;
            _foodPoint.y=randomY;
           //判断产生的食物是否出现在蛇身上
            for (int i=0; i<mutArray.count; i++) {
                CellPoint*po=[mutArray objectAtIndex:i];
                if (_foodPoint.x!=po.x||_foodPoint.y!=po.y) {
                    NSLog(@"食物制造成功 ");
                    UIImageView*Ima=[[UIImageView alloc] initWithFrame:CGRectMake(_foodPoint.x*16, _foodPoint.y*16, 16, 16)];
                    [Ima setImage:[UIImage imageNamed:@"greenstar"]];
                    Ima.tag=10;
                    [self.view addSubview:Ima];
                    return;
                }
            }
            
            
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)timeWork{
    //移除蛇
    for (UIView*view in _viewContent.subviews) {
        [view removeFromSuperview];
    }
    //取出蛇头
    CellPoint*snakeHead=[mutArray objectAtIndex:mutArray.count-1];
    

    //控制蛇身向右走
    for (int i=0; i<mutArray.count-1; i++) {
        CellPoint*snake1=[mutArray objectAtIndex:i];
        CellPoint*snake2=[mutArray objectAtIndex:i+1];
        snake1.x=snake2.x;
        snake1.y=snake2.y;
    }
    //蛇头向右走
    snakeHead.x++;
    if (snakeHead.x<0||snakeHead.x>20-2) {
        [timer invalidate];
        NSLog(@"死啦");
        [_audioPlayer stop];
        GameOver.center=CGPointMake(150, 250);
        [self.view addSubview:GameOver];
        _viewContent.userInteractionEnabled=NO;
    }
    direc=4;
    //重新加载蛇
    for (int j=0; j<mutArray.count; j++) {
        CellPoint*sheshen=[mutArray objectAtIndex:j];
        if (j!=mutArray.count-1) {
            UIImageView*Ima=[[UIImageView alloc] initWithFrame:CGRectMake(sheshen.x*16, sheshen.y*16, 16, 16)];
            [Ima setImage:[UIImage imageNamed:@"greenstar"]];
            [_viewContent addSubview:Ima];

        }else{
            UIImageView*Ima=[[UIImageView alloc] initWithFrame:CGRectMake(sheshen.x*16, sheshen.y*16, 16, 16)];
            [Ima setImage:[UIImage imageNamed:@"redstar"]];
            [_viewContent addSubview:Ima];
        }
    }
    
    
}

      /*---------------------轻扫后坐标改变-------------------------*/

-(void)timexia{
    
    //制造，，，，，，食物
    if (_foodPoint==nil) {
        while (YES) {
            NSLog(@"开始制造食物");
            //随机产生x,y坐标
            int randomx=arc4random()%20;
            int randomY=arc4random()%30;
            //产生食物
            _foodPoint=[[CellPoint alloc] init];
            _foodPoint.x=randomx;
            _foodPoint.y=randomY;
            //判断产生的食物是否出现在蛇身上
            for (int i=0; i<mutArray.count; i++) {
                CellPoint*po=[mutArray objectAtIndex:i];
                if (_foodPoint.x!=po.x||_foodPoint.y!=po.y) {
                    NSLog(@"食物制造成功 ");
                    UIImageView*Ima=[[UIImageView alloc] initWithFrame:CGRectMake(_foodPoint.x*16, _foodPoint.y*16, 16, 16)];
                    [Ima setImage:[UIImage imageNamed:@"greenstar"]];
                    Ima.tag=10;
                    [self.view addSubview:Ima];
                    return;
                }
            }
            
            
        }
    }

    
    //移除蛇
    for (UIView*view in _viewContent.subviews) {
        [view removeFromSuperview];
    }
    //取出蛇头
    CellPoint*snakeHead=[mutArray objectAtIndex:mutArray.count-1];
    //控制蛇身向右走
    for (int i=0; i<mutArray.count-1; i++) {
        CellPoint*snake1=[mutArray objectAtIndex:i];
        CellPoint*snake2=[mutArray objectAtIndex:i+1];
        snake1.x=snake2.x;
        snake1.y=snake2.y;
    }
    //蛇头向下走
    snakeHead.y++;
    for (int i=0; i<mutArray.count-1; i++) {
        CellPoint*p=[mutArray objectAtIndex:i];
        if (snakeHead.x==p.x&&snakeHead.y==p.y) {
            NSLog(@"撞自己了");
            [_audioPlayer stop];
            GameOver.center=CGPointMake(150, 250);
            [self.view addSubview:GameOver];
            [timer1 invalidate];
        }
    }
    if (_foodPoint!=nil) {
        if (snakeHead.x==_foodPoint.x&&snakeHead.y==_foodPoint.y) {
            [mutArray addObject:_foodPoint];
            _foodPoint=nil;
            for (UIView*view in self.view.subviews) {
                if (view.tag==10) {
                    [view removeFromSuperview];
                }
            }
        }
    }

    if (snakeHead.y<0||snakeHead.y>30) {
        [timer4 invalidate];
        [timer1 invalidate];
        [timer2 invalidate];
        [timer3 invalidate];
        NSLog(@"死啦");
        [_audioPlayer stop];
        GameOver.center=CGPointMake(150, 250);
        [self.view addSubview:GameOver];
        _viewContent.userInteractionEnabled=NO;
        
}

    //重新加载蛇
    for (int j=0; j<mutArray.count; j++) {
        CellPoint*sheshen=[mutArray objectAtIndex:j];
        if (j!=mutArray.count-1) {
            UIImageView*Ima=[[UIImageView alloc] initWithFrame:CGRectMake(sheshen.x*16, sheshen.y*16, 16, 16)];
            [Ima setImage:[UIImage imageNamed:@"greenstar"]];
            [_viewContent addSubview:Ima];
            
        }else{
            UIImageView*Ima=[[UIImageView alloc] initWithFrame:CGRectMake(sheshen.x*16, sheshen.y*16, 16, 16)];
            [Ima setImage:[UIImage imageNamed:@"redstar"]];
            [_viewContent addSubview:Ima];
        }
    }
}

-(void)timeyou{
    //制造，，，，，，食物
    if (_foodPoint==nil) {
        while (YES) {
            NSLog(@"开始制造食物");
            //随机产生x,y坐标
            int randomx=arc4random()%20;
            int randomY=arc4random()%30;
            //产生食物
            _foodPoint=[[CellPoint alloc] init];
            _foodPoint.x=randomx;
            _foodPoint.y=randomY;
            //判断产生的食物是否出现在蛇身上
            for (int i=0; i<mutArray.count; i++) {
                CellPoint*po=[mutArray objectAtIndex:i];
                if (_foodPoint.x!=po.x||_foodPoint.y!=po.y) {
                    NSLog(@"食物制造成功 ");
                    UIImageView*Ima=[[UIImageView alloc] initWithFrame:CGRectMake(_foodPoint.x*16, _foodPoint.y*16, 16, 16)];
                    [Ima setImage:[UIImage imageNamed:@"greenstar"]];
                    Ima.tag=10;
                    [self.view addSubview:Ima];
                    return;
                }
            }
            
            
        }
    }

        //移除蛇
        for (UIView*view in _viewContent.subviews) {
            [view removeFromSuperview];
        }
        //取出蛇头
        CellPoint*snakeHead=[mutArray objectAtIndex:mutArray.count-1];
        
        
        //控制蛇身向右走
        for (int i=0; i<mutArray.count-1; i++) {
            CellPoint*snake1=[mutArray objectAtIndex:i];
            CellPoint*snake2=[mutArray objectAtIndex:i+1];
            snake1.x=snake2.x;
            snake1.y=snake2.y;
        }
            //蛇头向右走
        snakeHead.x++;
    for (int i=0; i<mutArray.count-1; i++) {
        CellPoint*p=[mutArray objectAtIndex:i];
        if (snakeHead.x==p.x&&snakeHead.y==p.y) {
            NSLog(@"撞自己了");
            [_audioPlayer stop];
            GameOver.center=CGPointMake(150, 250);
            [self.view addSubview:GameOver];
            [timer2 invalidate];
        }
    }
    if (_foodPoint!=nil) {
        if (snakeHead.x==_foodPoint.x&&snakeHead.y==_foodPoint.y) {
            [mutArray addObject:_foodPoint];
            _foodPoint=nil;
            for (UIView*view in self.view.subviews) {
                if (view.tag==10) {
                    [view removeFromSuperview];
                }
            }
        }
    }

    if (snakeHead.x<0||snakeHead.x>20-2) {
        [timer4 invalidate];
        [timer1 invalidate];
        [timer2 invalidate];
        [timer3 invalidate];
        NSLog(@"死啦");
        [_audioPlayer stop];
        GameOver.center=CGPointMake(150, 250);
        [self.view addSubview:GameOver];
        _viewContent.userInteractionEnabled=NO;
    }

        //重新加载蛇
        for (int j=0; j<mutArray.count; j++) {
            CellPoint*sheshen=[mutArray objectAtIndex:j];
            if (j!=mutArray.count-1) {
                UIImageView*Ima=[[UIImageView alloc] initWithFrame:CGRectMake(sheshen.x*16, sheshen.y*16, 16, 16)];
                [Ima setImage:[UIImage imageNamed:@"greenstar"]];
                [_viewContent addSubview:Ima];
                
            }else{
                UIImageView*Ima=[[UIImageView alloc] initWithFrame:CGRectMake(sheshen.x*16, sheshen.y*16, 16, 16)];
                [Ima setImage:[UIImage imageNamed:@"redstar"]];
                [_viewContent addSubview:Ima];
            }
        }
}

-(void)timezuo{
    //制造，，，，，，食物
    if (_foodPoint==nil) {
        while (YES) {
            NSLog(@"开始制造食物");
            //随机产生x,y坐标
            int randomx=arc4random()%20;
            int randomY=arc4random()%30;
            //产生食物
            _foodPoint=[[CellPoint alloc] init];
            _foodPoint.x=randomx;
            _foodPoint.y=randomY;
            //判断产生的食物是否出现在蛇身上
            for (int i=0; i<mutArray.count; i++) {
                CellPoint*po=[mutArray objectAtIndex:i];
                if (_foodPoint.x!=po.x||_foodPoint.y!=po.y) {
                    NSLog(@"食物制造成功 ");
                    UIImageView*Ima=[[UIImageView alloc] initWithFrame:CGRectMake(_foodPoint.x*16, _foodPoint.y*16, 16, 16)];
                    [Ima setImage:[UIImage imageNamed:@"greenstar"]];
                    Ima.tag=10;
                    [self.view addSubview:Ima];
                    return;
                }
            }
            
            
        }
    }

    //移除蛇
    for (UIView*view in _viewContent.subviews) {
        [view removeFromSuperview];
    }
    //取出蛇头
    CellPoint*snakeHead=[mutArray objectAtIndex:mutArray.count-1];
    //控制蛇身向右走
    for (int i=0; i<mutArray.count-1; i++) {
        CellPoint*snake1=[mutArray objectAtIndex:i];
        CellPoint*snake2=[mutArray objectAtIndex:i+1];
        snake1.x=snake2.x;
        snake1.y=snake2.y;
    }
    //蛇头向左走
    snakeHead.x--;
    for (int i=0; i<mutArray.count-1; i++) {
        CellPoint*p=[mutArray objectAtIndex:i];
        if (snakeHead.x==p.x&&snakeHead.y==p.y) {
            NSLog(@"撞自己了");
            [_audioPlayer stop];
            GameOver.center=CGPointMake(150, 250);
            [self.view addSubview:GameOver];
            [timer3 invalidate];
        }
    }
    if (_foodPoint!=nil) {
        if (snakeHead.x==_foodPoint.x&&snakeHead.y==_foodPoint.y) {
            [mutArray addObject:_foodPoint];
            _foodPoint=nil;
            for (UIView*view in self.view.subviews) {
                if (view.tag==10) {
                    [view removeFromSuperview];
                }
            }
        }
    }

    if (snakeHead.x<0||snakeHead.x>20-2) {
        [timer4 invalidate];
        [timer1 invalidate];
        [timer2 invalidate];
        [timer3 invalidate];
       _viewContent.userInteractionEnabled=NO;
        NSLog(@"死啦");
        [_audioPlayer stop];
        GameOver.center=CGPointMake(150, 250);
        [self.view addSubview:GameOver];
    }

    //重新加载蛇
    for (int j=0; j<mutArray.count; j++) {
        CellPoint*sheshen=[mutArray objectAtIndex:j];
        if (j!=mutArray.count-1) {
            UIImageView*Ima=[[UIImageView alloc] initWithFrame:CGRectMake(sheshen.x*16, sheshen.y*16, 16, 16)];
            [Ima setImage:[UIImage imageNamed:@"greenstar"]];
            [_viewContent addSubview:Ima];
            
        }else{
            UIImageView*Ima=[[UIImageView alloc] initWithFrame:CGRectMake(sheshen.x*16, sheshen.y*16, 16, 16)];
            [Ima setImage:[UIImage imageNamed:@"redstar"]];
            [_viewContent addSubview:Ima];
        }
    }
}

-(void)timeshang{
    //制造，，，，，，食物
    if (_foodPoint==nil) {
        while (YES) {
            NSLog(@"开始制造食物");
            //随机产生x,y坐标
            int randomx=arc4random()%20;
            int randomY=arc4random()%30;
            //产生食物
            _foodPoint=[[CellPoint alloc] init];
            _foodPoint.x=randomx;
            _foodPoint.y=randomY;
            //判断产生的食物是否出现在蛇身上
            for (int i=0; i<mutArray.count; i++) {
                CellPoint*po=[mutArray objectAtIndex:i];
                if (_foodPoint.x!=po.x||_foodPoint.y!=po.y) {
                    NSLog(@"食物制造成功 ");
                    UIImageView*Ima=[[UIImageView alloc] initWithFrame:CGRectMake(_foodPoint.x*16, _foodPoint.y*16, 16, 16)];
                    [Ima setImage:[UIImage imageNamed:@"greenstar"]];
                    Ima.tag=10;
                    [self.view addSubview:Ima];
                    return;
                }
            }
            
            
        }
    }

    //移除蛇
    for (UIView*view in _viewContent.subviews) {
        [view removeFromSuperview];
    }
    //取出蛇头
    CellPoint*snakeHead=[mutArray objectAtIndex:mutArray.count-1];
    
    
    //控制蛇身向右走
    for (int i=0; i<mutArray.count-1; i++) {
        CellPoint*snake1=[mutArray objectAtIndex:i];
        CellPoint*snake2=[mutArray objectAtIndex:i+1];
        snake1.x=snake2.x;
        snake1.y=snake2.y;
    }
    //蛇头向上走
    snakeHead.y--;
    for (int i=0; i<mutArray.count-1; i++) {
        CellPoint*p=[mutArray objectAtIndex:i];
        if (snakeHead.x==p.x&&snakeHead.y==p.y) {
            NSLog(@"撞自己了");
            [_audioPlayer stop];
            GameOver.center=CGPointMake(150, 250);
            [self.view addSubview:GameOver];
            [timer4 invalidate];
        }
    }
    if (_foodPoint!=nil) {
        if (snakeHead.x==_foodPoint.x&&snakeHead.y==_foodPoint.y) {
            [mutArray addObject:_foodPoint];
            _foodPoint=nil;
            for (UIView*view in self.view.subviews) {
                if (view.tag==10) {
                    [view removeFromSuperview];
                }
            }
        }
    }

    if (snakeHead.y<0||snakeHead.y>30) {
        [timer4 invalidate];
        [timer1 invalidate];
        [timer2 invalidate];
        [timer3 invalidate];
       _viewContent.userInteractionEnabled=NO;
        NSLog(@"死啦");
        [_audioPlayer stop];
        GameOver.center=CGPointMake(150, 250);
        [self.view addSubview:GameOver];
    }

    //重新加载蛇
    for (int j=0; j<mutArray.count; j++) {
        CellPoint*sheshen=[mutArray objectAtIndex:j];
        if (j!=mutArray.count-1) {
            UIImageView*Ima=[[UIImageView alloc] initWithFrame:CGRectMake(sheshen.x*16, sheshen.y*16, 16, 16)];
            [Ima setImage:[UIImage imageNamed:@"greenstar"]];
            [_viewContent addSubview:Ima];
            
        }else{
            UIImageView*Ima=[[UIImageView alloc] initWithFrame:CGRectMake(sheshen.x*16, sheshen.y*16, 16, 16)];
            [Ima setImage:[UIImage imageNamed:@"redstar"]];
            [_viewContent addSubview:Ima];
        }
    }
}

   /*-----------------------------判断向那轻扫------------------------------*/


-(void)handleTap:(UISwipeGestureRecognizer*)gesture{
    
    if (gesture.direction==UISwipeGestureRecognizerDirectionLeft) {
        if (direc!=4&&direc!=3) {
            NSLog(@"向左");
            direc=3;
            [timer invalidate];
            [timer1 invalidate];
            [timer2 invalidate];
            [timer4 invalidate];
            timer3=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timezuo) userInfo:nil repeats:YES];
        }
    }if (gesture.direction==UISwipeGestureRecognizerDirectionRight) {
        if (direc!=3&&direc!=4) {
            NSLog(@"向右");
            direc=4;
            [timer invalidate];
            [timer1 invalidate];
            [timer3 invalidate];
            [timer4 invalidate];
            timer2=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timeyou) userInfo:nil repeats:YES];
        }
    }if (gesture.direction==UISwipeGestureRecognizerDirectionDown) {
        if (direc!=1&&direc!=2) {
            NSLog(@"向下");
            direc=2;
            [timer invalidate];
            [timer2 invalidate];
            [timer3 invalidate];
            [timer4 invalidate];
            timer1=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timexia) userInfo:nil repeats:YES];
        }
    }if (gesture.direction==UISwipeGestureRecognizerDirectionUp) {
        if (direc!=2&&direc!=1) {
            NSLog(@"向上");
            direc=1;
            [timer invalidate];
            [timer1 invalidate];
            [timer2 invalidate];
            [timer3 invalidate];
            timer4=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timeshang) userInfo:nil repeats:YES];
        }
    }
}
-(IBAction)chongLai:(id)sender{
    _viewContent.userInteractionEnabled=YES;
    _foodPoint=nil;
    for (UIView*view in self.view.subviews) {
        if (view.tag==10) {
            [view removeFromSuperview];
        }
    }

    [GameOver removeFromSuperview];
    for (UIView *view in _viewContent.subviews) {
        [view removeFromSuperview];
    }
    [self viewDidLoad];
    
}
@end
