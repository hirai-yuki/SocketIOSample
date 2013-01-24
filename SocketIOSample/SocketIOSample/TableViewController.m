//
//  TableViewController.m
//  SocketIOSample
//
//  Created by hirai.yuki on 2013/01/24.
//  Copyright (c) 2013年 hirai.yuki. All rights reserved.
//

#import "TableViewController.h"
#import "SocketIOPacket.h"

// 送信フォーム用セル
@interface FormCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end

@implementation FormCell
@end


@interface TableViewController ()

@property (strong, nonatomic) FormCell *formCell;
@property (strong, nonatomic) NSMutableArray *datas;
@property (strong, nonatomic) SocketIO *socketIO;
- (IBAction)sendEvent:(id)sender;

@end

@implementation TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(applicationWillResignActive)
               name:@"applicationWillResignActive"
             object:nil];
    [nc addObserver:self
           selector:@selector(applicationDidBecomeActive)
               name:@"applicationDidBecomeActive"
             object:nil];
    
    // データ初期化
    self.datas = [NSMutableArray array];

    // socketIOクライアント生成
    self.socketIO = [[SocketIO alloc] initWithDelegate:self];
}

- (void)applicationDidBecomeActive
{
    // localhost:3000に接続開始
    [self.socketIO connectToHost:@"localhost" onPort:3000];
}

- (void)applicationWillResignActive
{
    // 接続終了
    [self.socketIO disconnect];
}

// イベント送信
- (IBAction)sendEvent:(id)sender
{
    // 文字が入力されていなければ何もしない
    if (self.formCell.textField.text.length == 0) {
        return;
    }
    
    // イベント送信
    [self.socketIO sendEvent:@"message:send" withData:@{@"message" : self.formCell.textField.text}];

    // テキストフィールドをリセット
    self.formCell.textField.text = @"";
}

#pragma mark - socket.IO-objC method

// サーバとの接続が成功したときに実行されるメソッド
- (void)socketIODidConnect:(SocketIO *)socket
{
    NSLog(@"%s", __func__);
    
    self.formCell.textField.enabled = YES;
    self.formCell.sendButton.enabled = YES;
}

// イベントを受信したときに実行されるメソッド
- (void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    NSLog(@"%s", __func__);
    
    if ([packet.name isEqualToString:@"message:receive"]) {
        // メッセージが空でなければ追加
        if (packet.args[0][@"message"]) {
            [self.datas insertObject:packet.args[0][@"message"] atIndex:0];
            [self.tableView reloadData];
        }
    }
}

// サーバとの接続が切断されたときに実行されるメソッド
- (void)socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error
{
    NSLog(@"%s", __func__);
    
    self.formCell.textField.enabled = NO;
    self.formCell.sendButton.enabled = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
        default:
            return self.datas.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            static NSString *CellIdentifier = @"FormCell";
            if (self.formCell == nil) {
                self.formCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            }
            return self.formCell;
        }
            
        case 1:
        default:
        {
            static NSString *CellIdentifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.textLabel.text = self.datas[indexPath.row];
            return cell;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"検索フォーム";
            
        case 1:
        default:
            return @"メッセージ";
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 64.0;
            
        case 1:
        default:
            return 44.0;
    }
}

@end
