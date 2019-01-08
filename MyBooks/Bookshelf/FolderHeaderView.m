#import "FolderHeaderView.h"

@interface FolderHeaderView () <UITextFieldDelegate>

@end

@implementation FolderHeaderView


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFolderState) name:@"passwordchange" object:nil];
    }
    
    return self;
}

- (void)setBookDict:(NSMutableDictionary *)bookDict
{
    if (bookDict) {
        _bookDict = bookDict;
        [self setupViewData];
    }
}

- (void)refreshFolderState
{
    NSString *passwordLength = self.bookDict[@"password"];
    NSString *buttontitle = passwordLength.length ? @"取消密码" : @"添加密码";
    
    [self.cancelButton setTitle:buttontitle forState:UIControlStateNormal];
}

- (void)setupViewData
{
    self.titleTextField.text = self.bookDict[@"folderName"];
    if (isSunTheme) {
        self.titleTextField.textColor = MAINTHEME_SUN_BookTitle;
    }else
    {
        self.titleTextField.textColor = MAINTHEME_MOON_BookTitle;

    }
    self.titleTextField.delegate = self;
    
    NSString *passwordLength = self.bookDict[@"password"];
//    显示密码状态
    NSString *lockImageName;
    if (iphone) {
        lockImageName = passwordLength.length ? @"bookShelf_lock_btn" : @"bookShelf_unlocking_btn";
    }else
    {
        lockImageName = passwordLength.length ? @"bookShelf_lock_btn_ipad" : @"bookShelf_unlocking_btn_ipad";
    }
    
    [self.lockImageView setImage:[UIImage imageNamed:lockImageName]];
//    显示取消密码按钮
    NSString *buttontitle = passwordLength.length ? @"取消密码" : @"添加密码";
    
    [self.cancelButton setTitle:buttontitle forState:UIControlStateNormal];
}

- (IBAction)configurePassword:(id)sender
{
//    添加密码
    if ([self.cancelButton.titleLabel.text isEqualToString:@"取消密码"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelPassword" object:nil userInfo:nil];
        [self.lockImageView setImage:[UIImage imageNamed:@"bookShelf_unlocking_btn"]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changePassword" object:nil userInfo:nil];
        [self.lockImageView setImage:[UIImage imageNamed:@"bookShelf_lock_btn"]];
    }
}

- (IBAction)tapped:(id)sender
{
    if ([self.titleTextField isFirstResponder]) {
        [self.titleTextField resignFirstResponder];
        return;
    }
    self.block(sender);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewFolderName" object:textField.text userInfo:nil];
    [self.titleTextField resignFirstResponder];
    
    return YES;
}

@end
