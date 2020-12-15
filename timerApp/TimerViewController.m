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

#pragma mark - timeCell

@interface timeCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation timeCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:20];
        _timeLabel.frame = CGRectMake(20, 0, self.bounds.size.width - 20, self.bounds.size.height);
        [self.contentView addSubview:_timeLabel];
    }
    return self;
}

- (void)configureWithString:(NSString *)string
{
    _timeLabel.text = string;
}

@end

#pragma mark - TimeViewController

@interface TimerViewController ()<UITableViewDelegate, UITableViewDataSource>

{
    NSTimer *_timer;    //定时器
    NSInteger _seconds; //计时器时间
    NSInteger _count;   //计次次数
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
    _timeLabel.font = [UIFont systemFontOfSize:75];
    _timeLabel.frame = CGRectMake(0, BOTTOM_Y(_countLabel) + 80, self.view.bounds.size.width, 150);
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.text = @"00:00.00";
    [self.view addSubview:_timeLabel];
    
    _startBtn = [[UIButton alloc] init];
    _startBtn.frame = CGRectMake(BUTTON_INSERT, BOTTOM_Y(_timeLabel) + 30, BUTTON_WIDTH, BUTTON_HEIGHT);
    _startBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    _startBtn.layer.shadowOffset = CGSizeMake(0, 0);
    _startBtn.layer.shadowOpacity = 0.5;
    _startBtn.layer.shadowRadius = 7;
    _startBtn.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _startBtn.layer.cornerRadius = BUTTON_HEIGHT / 2;
    [_startBtn setTitle:@"开始" forState:UIControlStateNormal];
    [_startBtn setTitle:@"停止" forState:UIControlStateSelected];
    [_startBtn setTitle:@"停止" forState:UIControlStateSelected | UIControlStateHighlighted];
    [_startBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_startBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [_startBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected | UIControlStateHighlighted];
    [_startBtn addTarget:self action:@selector(startBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startBtn];

    _countBtn = [[UIButton alloc] init];
    _countBtn.frame = CGRectMake(RIGHT_X(_startBtn) + BUTTON_INSERT, _startBtn.frame.origin.y, BUTTON_WIDTH, BUTTON_HEIGHT);
    _countBtn.layer.shadowOffset = CGSizeMake(0, 0);
    _countBtn.layer.shadowOpacity = 0.5;
    _countBtn.layer.shadowRadius = 7;
    _countBtn.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _countBtn.layer.cornerRadius = BUTTON_HEIGHT / 2;
    [_countBtn setTitle:@"计次" forState:UIControlStateNormal];
    [_countBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_countBtn addTarget:self action:@selector(countBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_countBtn];

    _clearBtn = [[UIButton alloc] init];
    _clearBtn.frame = CGRectMake(RIGHT_X(_countBtn) + BUTTON_INSERT, _startBtn.frame.origin.y, BUTTON_WIDTH, BUTTON_HEIGHT);
    _clearBtn.layer.shadowOffset = CGSizeMake(0, 0);
    _clearBtn.layer.shadowOpacity = 0.5;
    _clearBtn.layer.shadowRadius = 7;
    _clearBtn.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _clearBtn.layer.cornerRadius = BUTTON_HEIGHT / 2;
    [_clearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_clearBtn setTitle:@"清零" forState:UIControlStateNormal];
    [_clearBtn addTarget:self action:@selector(clearBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_clearBtn];

    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, BOTTOM_Y(_startBtn) + 15, self.view.bounds.size.width, self.view.bounds.size.height - BOTTOM_Y(_startBtn));
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[timeCell class] forCellReuseIdentifier:@"timeCell"];
    [self.view addSubview:_tableView];
    
    _timeArray = [[NSMutableArray alloc] init];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
}

#pragma mark - 按钮点击事件

- (void)startBtnTapped:(UIButton *)sender
{
    if(sender.selected)
    {
        NSLog(@"stopBtnTapped");
        sender.selected = NO;
        [_timer invalidate];
    }
    else
    {
        NSLog(@"startBtnTapped");
        sender.selected = YES;
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
            self->_seconds++;
            self.timeLabel.text = [NSString stringWithFormat:@"%02li:%02li.%02li",self->_seconds / 100 / 60 % 60, self->_seconds / 100 % 60, self->_seconds % 100];
        }];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)countBtnTapped
{
    NSLog(@"countBtnTapped");
    _count++;
    _countLabel.text = [NSString stringWithFormat: @"%ld",_count];
    [_timeArray addObject: _timeLabel.text];
    [_tableView reloadData];
}

- (void)clearBtnTapped
{
    NSLog(@"clearBtnTapped");
    _seconds = 0;
    _timeLabel.text = @"00:00.00";
    [_timeArray removeAllObjects];
    _count = 0;
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _timeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    timeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timeCell"];
    [cell configureWithString:_timeArray[indexPath.row]];
    return cell;
}

@end
