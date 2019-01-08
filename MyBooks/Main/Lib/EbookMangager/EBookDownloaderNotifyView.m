#import "EBookDownloaderNotifyView.h"
@interface EBookDownloaderNotifyView ()
@end
@implementation EBookDownloaderNotifyView
@synthesize downProgress,BookInfor;
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [BookInfor release];
    [downProgress release];
    [super dealloc];
}
 
+(void)ShowEBookDownloaderNotifyViewWithBookInfor:(NSDictionary*)bookInfor{
    @synchronized(self) {
        @autoreleasepool {
            @try {
    EBookDownloaderNotifyView *NewsView=  [[[EBookDownloaderNotifyView alloc] initWithNibName:@"EBookDownloaderNotifyView" bundle:nil] autorelease];
         [NewsView loadWithBookInfor: bookInfor];
      }@catch (NSException *exception){}@finally{}}}
}
- (void)viewDidLoad
{
    [self retain];
    [super viewDidLoad];
    self.downProgress.hidden=YES;
    self.downProgress.trackImage=[UIImage imagefileNamed:@"EbookManagerImage.bundle2/EbookManager-Downloading-Big-TrackImage"];
    self.downProgress.progressImage=[UIImage imagefileNamed:@"EbookManagerImage.bundle2/EbookManager-Downloading-Big-ProgressImage"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EBookLocalStoreProgressUpdateFunction:) name:EBookLocalStoreProgressUpdate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EBookLocalStorRequestErrorFunction:) name:EBookLocalStorRequestError object:nil];
    notilocked=NO;
 }
- (UIWindow *)overlayWindow {
    if(!overlayWindow) {
        overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayWindow.backgroundColor = [UIColor clearColor];
        overlayWindow.userInteractionEnabled = YES;
    }
    return overlayWindow;
}
-(void)loadWithBookInfor:(NSDictionary*)bookInfor{
    self.BookInfor=bookInfor;
    ((UILabel*)[self.view viewWithTag:200]).text=[self.BookInfor objectForKey:@"name"];
     ((UIButton *)[self.view viewWithTag:101]).enabled=![[EBookLocalStore defaultEBookLocalStore] CheckBookListExistsAtBookInfor:bookInfor];
    self.view.frame=CGRectMake((self.overlayWindow.frame.size.width-270)/2.0, overlayWindow.frame.size.height-190 , 270, 190);
    [self.overlayWindow addSubview: self.view];
    [self.overlayWindow makeKeyAndVisible];
    [UIView beginAnimations:@"showEBookDownloaderNotifyView" context:nil];
    [UIView setAnimationDuration:0.5];
    self.view.frame=CGRectMake((self.overlayWindow.frame.size.width-270)/2.0, (overlayWindow.frame.size.height-190)/2.0 , 270, 190);
    [UIView commitAnimations];

}
-(void)EBookLocalStoreProgressUpdateFunction:(NSNotification *)notification{
    NSDictionary *bookInfor=[notification userInfo];
   if ([[bookInfor objectForKey:@"url"] isEqualToString:[self.BookInfor objectForKey:@"url"]] ) {
        self.downProgress.hidden=NO;
        [self.downProgress setProgress:[[bookInfor objectForKey:@"percent"] floatValue]];
    }
}
-(void)EBookLocalStorRequestDoneFunction:(NSNotification *)notification{
    NSDictionary *bookInfor=[notification userInfo];
    if ([[bookInfor objectForKey:@"url"] isEqualToString:[self.BookInfor objectForKey:@"url"]] ) {
         self.downProgress.hidden=NO;
        [self.downProgress setProgress:[[bookInfor objectForKey:@"percent"] floatValue]];
         //调阅读器  StartBookReadingNotification
        [self dismissAndStartBookReadingNotification:YES];
    }

}
-(void)EBookLocalStorRequestErrorFunction:(NSNotification *)notification{
   // NSDictionary *bookInfor=[notification userInfo];
   // NSLog(@"RequestError=%@",bookInfor);
    //启动重试策略
    UIAlertView *av = [[[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"网络异常导致超时", @"", nil)  
                                                 message:@"请检查您的网络,然后重试" 
                                                delegate:self 
                                       cancelButtonTitle:NSLocalizedStringFromTable(@"取消", @"", nil)
                                       otherButtonTitles:NSLocalizedStringFromTable(@"重试", @"", nil) ,nil] autorelease];
    if(!notilocked)
    {
        notilocked=YES;
        [av show];
        [self performSelector:@selector(opennoti) withObject:nil afterDelay:10];
    }
}
-(void)opennoti
{
    notilocked=NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonInde{
   
	if(buttonInde==1){
        if (![EBookLocalStore AddNewBookToDownload:self.BookInfor] ) {
            //关闭当前页面并调阅读器
            [self dismissAndStartBookReadingNotification:YES];
        };
 	}else {
        [self dismissAndStartBookReadingNotification:YES];
    }
}

-(IBAction)buttonClick:(id)sender{
    UIButton *btn=(UIButton *)sender;
    switch (btn.tag) {
        case 100:
             //立刻阅读
            ((UIButton *)[self.view viewWithTag:100]).enabled=NO;
            ((UIButton *)[self.view viewWithTag:101]).enabled=NO;
            [[NSNotificationCenter defaultCenter] removeObserver:self name:EBookLocalStorRequestDone  object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EBookLocalStorRequestDoneFunction:) name:EBookLocalStorRequestDone object:nil];
            if (![EBookLocalStore AddNewBookToDownload:self.BookInfor] ) {
                //关闭当前页面并调阅读器
                [self dismissAndStartBookReadingNotification:YES];
           };
            break;
        case 101:
            //关闭当前页面，后台下载
            [EBookLocalStore AddNewBookToDownload:self.BookInfor];
            [self dismissAndStartBookReadingNotification:NO];

            break;
        case 102:
            //关闭当前页面
            [self dismissAndStartBookReadingNotification:NO];
            break;
        default:
            break;
    }
}
- (void)dismissAndStartBookReadingNotification:(BOOL)isStart{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[UIView animateWithDuration:0.75
						  delay:0
						options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
					 animations:^{	
                         self.view.frame=CGRectMake((self.overlayWindow.frame.size.width-270)/2.0, overlayWindow.frame.size.height , 270, 190);

					 }
					 completion:^(BOOL finished){ 
                             [self.view removeFromSuperview];
                             self.view = nil;
                             [overlayWindow release];
                             overlayWindow = nil;
                             [[UIApplication sharedApplication].windows.lastObject makeKeyAndVisible];
                             if (isStart) {
                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"StartBookReadingNotification" object:nil userInfo:self.BookInfor];
                              }
                             [self release];
                     }];
}

@end
