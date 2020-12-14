//
//  TimerViewController.m
//  timerApp
//
//  Created by xiaokangyan on 2020/12/14.
//

#import "TimerViewController.h"
#import <Foundation/Foundation.h>

#define RIGHT_X(object) (object.frame.origin.x + object.frame.size.width)
#define BOTTOM_Y(object) (object.frame.origin.y + object.frame.size.height)
#define BUTTON_WIDTH (80)
#define BUTTON_HEIGHT (80)
#define BUTTON_INSERT ((self.view.bounds.size.width - BUTTON_WIDTH * 3) / 4)


@interface timeCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation timeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
    }
    return self;
}

@end

@interface TimerViewController ()

{
    NSTimer *_timer;//定时器
}

@property (nonatomic, strong) UILabel *countLabel;  //计时次数
@property (nonatomic, strong) UILabel *timeLabel;   //计时器显示
@property (nonatomic, strong) UIButton *startBtn;   //开始计时按钮
@property (nonatomic, strong) UIButton *countBtn;   //计次按钮
@property (nonatomic, strong) UIButton *clearBtn;   //清零按钮
@property (nonatomic, strong) UITableView *tableView;   //展示计次时间
@property (nonatomic, strong) NSMutableArray<NSString *> *timeArray;    //记录计次时间

@end

@implementation TimerViewController

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

- (void)setUpUI
{
    NSLog(@"start to set up UI");
    _countLabel = [[UILabel alloc] init];
    _countLabel.frame = CGRectMake(20, 65, 110, 50);
    _countLabel.font = [UIFont systemFontOfSize:30];
    _countLabel.text = @"0";
    [self.view addSubview:_countLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.adjustsFontSizeToFitWidth = YES;
    _timeLabel.font = [UIFont systemFontOfSize:75];
    _timeLabel.frame = CGRectMake(0, BOTTOM_Y(_countLabel) + 80, self.view.bounds.size.width, 150);
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.text = @"00:00:00";
    [self.view addSubview:_timeLabel];
    
    _startBtn = [[UIButton alloc] init];
    _startBtn.frame = CGRectMake(BUTTON_INSERT, BOTTOM_Y(_timeLabel) + 30, BUTTON_WIDTH, BUTTON_HEIGHT);
    [_startBtn setTitle:@"开始" forState:UIControlStateNormal];
    [_startBtn setTitle:@"停止" forState:UIControlStateSelected];
    [_startBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_startBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [_startBtn addTarget:self action:@selector(startBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startBtn];

    _countBtn = [[UIButton alloc] init];
    _countBtn.frame = CGRectMake(RIGHT_X(_startBtn) + BUTTON_INSERT, _startBtn.frame.origin.y, BUTTON_WIDTH, BUTTON_HEIGHT);
    [_countBtn setTitle:@"计次" forState:UIControlStateNormal];
    [_countBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_countBtn addTarget:self action:@selector(countBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_countBtn];

    _clearBtn = [[UIButton alloc] init];
    _clearBtn.frame = CGRectMake(RIGHT_X(_countBtn) + BUTTON_INSERT, _startBtn.frame.origin.y, BUTTON_WIDTH, BUTTON_HEIGHT);
    [_clearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_clearBtn setTitle:@"清零" forState:UIControlStateNormal];
    [_clearBtn addTarget:self action:@selector(clearBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_clearBtn];

    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, BOTTOM_Y(_startBtn), self.view.bounds.size.width, self.view.bounds.size.height - BOTTOM_Y(_startBtn));
    [self.view addSubview:_tableView];
    
    _timeArray = [[NSMutableArray alloc] init];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
}

- (void)startBtnTapped:(UIButton *)sender
{
    if(sender.selected)
    {
        NSLog(@"stopBtnTapped");
        sender.selected = NO;
    }
    else
    {
        NSLog(@"startBtnTapped");
        sender.selected = YES;
    }
}

- (void)countBtnTapped
{
    NSLog(@"countBtnTapped");
}

- (void)clearBtnTapped
{
    NSLog(@"clearBtnTapped");
}

@end
