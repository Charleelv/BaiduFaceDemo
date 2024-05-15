//
//  BDIDInfoCollectController.m
//  JingRong_Safe_IDLFaceSDKDemoOC
//
//  Created by Zhang,Jian(MBD) on 2021/9/24.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import "BDIDInfoCollectController.h"
#import "BDIDInfoAutoCollectController.h"
#import "VerifyRegexTool.h"
#import "BDBaseToastView.h"
#import <BDFaceBaseKit/BDFaceBaseKit.h>
#import "BDConfigDataService.h"

// 身份正类型枚举
enum BDCardType {
    // 中国居民二代身份证
    CardType_IDCard_CHINA = 0,
    
    // 港澳台来往内陆通行证
    CardType_IDCard_HM = 1,
    
    // 外国人永久居留证
    CardType_IDCard_FOREIGNER = 2,
    
    // 定居国外
    CardType_IDCard_SETTLEABROAD = 3,
};
@interface BDIDInfoCollectController ()<UITextFieldDelegate>

/**
 * 返回Button
 */
@property (weak, nonatomic) IBOutlet UIButton *backButton;
/**
 * 导航栏上面的titleLabel
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**
 * 页面上的主标题
 */
@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;
/**
 * 选择身份证或者其他证件
 */
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
/**
 * 姓名text
 */
@property (weak, nonatomic) IBOutlet UITextField *nameText;
/**
 * 证件号text
 */
@property (weak, nonatomic) IBOutlet UITextField *numberText;
/***
 * 下一步Button
 */
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

// 身份证类型选择存储临时变量
@property (copy, nonatomic) NSString *selectStr;

// 获取textfield坐标Y值
@property (nonatomic, assign)int textviewHeight;

// 键盘高Y值
@property (nonatomic, assign)int boardHeight;

// 身份证号输入框的view
@property (weak, nonatomic) IBOutlet UIView *inputNumBackView;

// 姓名输入框view
@property (weak, nonatomic) IBOutlet UIView *inputNameBackView;

// 传递的身份类型
@property (assign, nonatomic) NSInteger inputCardTypeId;

// 选择身份类型的右箭头图标
@property (weak, nonatomic) IBOutlet UIImageView *selectImgIcon;

// 选择身份类型的按钮
@property (weak, nonatomic) IBOutlet UIButton *selectCardTypeButton;

@end

@implementation BDIDInfoCollectController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: YES];

    // 创建键盘弹出监听
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(keyboardWillShow:) name: UIKeyboardWillShowNotification object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(textChange) name: UITextFieldTextDidChangeNotification object: nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nameText.delegate = self;
    self.numberText.delegate = self;
    [_selectCardTypeButton setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:217/255.0 green:223/255.0 blue:230/255.0 alpha:1]] forState:UIControlStateHighlighted];
    [_nextButton setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.29]] forState:UIControlStateHighlighted];

    // 根据身份证选择类型判断是否可选
    [self initCardType];
}
/**
 * 根据身份类型判断是否可以选择其他身份
 */
-(void)initCardType {
    if ([BDConfigDataService supportMultiCard]) {
        _selectImgIcon.hidden = NO;
        _selectCardTypeButton.enabled = YES;
        _selectCardTypeButton.userInteractionEnabled = YES;
    } else {
        _selectImgIcon.hidden = YES;
        _selectCardTypeButton.enabled = NO;
        _selectCardTypeButton.userInteractionEnabled = NO;
    }
}

/**
 * 根据选择的身份类型确定对应枚举的身份类型
 */
-(NSInteger)cardTypeString:(NSString *)str {
    enum BDCardType china = (CardType_IDCard_CHINA);
    enum BDCardType hm = (CardType_IDCard_HM);
    enum BDCardType foreigner = (CardType_IDCard_FOREIGNER);
    enum BDCardType abroad = (CardType_IDCard_SETTLEABROAD);
    if ([str isEqualToString: @"中国居民二代身份证"]) {
        return  china;
    } else if ([str isEqualToString: @"港澳台来往内陆通行证"]) {
        return hm;
    } else if ([str isEqualToString: @"外国人永久居留证"]) {
        return foreigner;
    } else if ([str isEqualToString: @"定居海外的中国公民护照"]) {
        return abroad;
    }
    return 0;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self name: UIKeyboardWillShowNotification object: nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self name:UITextFieldTextDidChangeNotification object: nil];
}

#pragma mark -IBAction
/**
 * 返回按钮方法
 * -parameter:sender 点击的按钮
 */
- (IBAction)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * 切换身份证类型
 * - parameter:sender 点击的按钮
 */
- (IBAction)selectIdTypeAction:(UIButton *)sender {
    NSArray *cardTypeArray = [NSArray arrayWithObjects:@"中国居民二代身份证", @"港澳台来往内陆通行证", @"外国人永久居留证", @"定居海外的中国公民护照",@"港澳台居民居住证", @"取消", nil];
    UIAlertController *alert = [[UIAlertController alloc] init];
    for (int i=0; i<cardTypeArray.count; i++) {
        if (i == cardTypeArray.count - 1) {
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:cardTypeArray[cardTypeArray.count - 1] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancle];
        } else {
            UIAlertAction *action = [UIAlertAction actionWithTitle:cardTypeArray[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.selectCardTypeButton setTitle:cardTypeArray[i] forState:UIControlStateNormal];
                _inputCardTypeId = [self cardTypeString: cardTypeArray[i]];
            }];
            [alert addAction:action];
        }
    }
    [self presentViewController:alert animated:true completion:nil];
}

/**
 * 点击下一步按钮
 * - parameter:sender 点击的按钮
 */
- (IBAction)nextStepAction:(UIButton *)sender {
    [self.view endEditing:true];
    if ([self.selectCardTypeButton.titleLabel.text isEqualToString:@"中国居民二代身份证"]) {
        if (![VerifyRegexTool checkRealName:_nameText]) {
            NSLog(@"姓名校验不通过");
            [BDBaseToastView showToast:[UIApplication sharedApplication].keyWindow text:@"姓名校验不通过"];
            _nameText.textColor = [UIColor colorWithRed:255/255.0 green:25/255.0 blue:79/255.0 alpha:1.0];
            return;
        }
        if (![VerifyRegexTool checkIDCardNum:_numberText]) {
            NSLog(@"请填写正确的证件号");
            [BDBaseToastView showToast:[UIApplication sharedApplication].keyWindow text:@"请填写正确的证件号"];
            _numberText.textColor = [UIColor colorWithRed:255/255.0 green:25/255.0 blue:79/255.0 alpha:1.0];
            return;
        }
    } else if ([self.selectCardTypeButton.titleLabel.text isEqualToString:@"港澳台来往内陆通行证"]) {
        // 港澳台居民往来内陆通行证姓名验证
        if (![VerifyRegexTool checkRealName: _nameText]) {
            NSLog(@"姓名校验不通过");
            [BDFaceToastView showToast:[UIApplication sharedApplication].keyWindow text:@"姓名校验不通过"];
            _numberText.textColor = [UIColor colorWithRed:255/255.0 green:25/255.0 blue:79/255.0 alpha:1.0];
            return;
        }
        // 港澳台居民往来内陆通行证号码验证
        if(![VerifyRegexTool isValidForGAT:_numberText.text]){
            [BDFaceToastView showToast:[UIApplication sharedApplication].keyWindow text:@"请填写正确的证件号"];
            _numberText.textColor = [UIColor colorWithRed:255/255.0 green:25/255.0 blue:79/255.0 alpha:1.0];
            return;;
        }
    } else if ([self.selectCardTypeButton.titleLabel.text isEqualToString:@"外国人永久居留证"]) {
        // 外国人永久居留证号码验证
        if (_numberText.text.length == 18) {
            if (![[_numberText.text substringToIndex:1] isEqual:@"9"]) {
                    [BDFaceToastView showToast:[UIApplication sharedApplication].keyWindow text:@"请填写正确的证件号"];
                    _numberText.textColor = [UIColor colorWithRed:255/255.0 green:25/255.0 blue:79/255.0 alpha:1.0];
                return;
            } else {
                if(![VerifyRegexTool isVaildIDCardNo:_numberText.text]){
                    [BDFaceToastView showToast:[UIApplication sharedApplication].keyWindow text:@"请填写正确的证件号"];
                    _numberText.textColor = [UIColor colorWithRed:255/255.0 green:25/255.0 blue:79/255.0 alpha:1.0];
                    return;
                }
            }
        } else {
            if(![VerifyRegexTool isValidForForeignersPermit:_numberText.text]){
                [BDFaceToastView showToast:[UIApplication sharedApplication].keyWindow text:@"请填写正确的证件号"];
                _numberText.textColor = [UIColor colorWithRed:255/255.0 green:25/255.0 blue:79/255.0 alpha:1.0];
                return;;
            }
        }
    }
    else if ([self.selectCardTypeButton.titleLabel.text isEqualToString:@"定居海外的中国公民护照"]) {
        // 定居国外的中国公民护照姓名验证
        if (![VerifyRegexTool checkRealName: _nameText]) {
            NSLog(@"姓名校验不通过");
            [BDFaceToastView showToast:[UIApplication sharedApplication].keyWindow text:@"姓名校验不通过"];
            _nameText.textColor = [UIColor colorWithRed:255/255.0 green:25/255.0 blue:79/255.0 alpha:1.0];
            return;
        }
        // 定居国外的中国公民护照号码验证
        if(![VerifyRegexTool isValidForCitizenPassport:_numberText.text]){
            [BDFaceToastView showToast:[UIApplication sharedApplication].keyWindow text:@"请填写正确的证件号"];
            _numberText.textColor = [UIColor colorWithRed:255/255.0 green:25/255.0 blue:79/255.0 alpha:1.0];
            return;;
        }
    } else if ([self.selectCardTypeButton.titleLabel.text isEqualToString:@"港澳台居民居住证"]) {
        if (![VerifyRegexTool checkRealName: _nameText]) {
            NSLog(@"姓名校验不通过");
            [BDFaceToastView showToast:[UIApplication sharedApplication].keyWindow text:@"姓名校验不通过"];
            _nameText.textColor = [UIColor colorWithRed:255/255.0 green:25/255.0 blue:79/255.0 alpha:1.0];
            return;
        }
        if (![VerifyRegexTool isValidForGATCard:_numberText.text]) {
            [BDFaceToastView showToast:[UIApplication sharedApplication].keyWindow text:@"请填写正确的证件号"];
            _numberText.textColor = [UIColor colorWithRed:255/255.0 green:25/255.0 blue:79/255.0 alpha:1.0];
            return;
        } else {
            // 判断港台前6位区号
            if ([[_numberText.text substringToIndex:6] isEqual: @"810000"] || [[_numberText.text substringToIndex:6] isEqual: @"820000"] || [[_numberText.text substringToIndex:6] isEqual: @"830000"]) {
                NSLog(@"%@", _numberText.text);
            } else {
                [BDFaceToastView showToast:[UIApplication sharedApplication].keyWindow text:@"请填写正确的证件号"];
                _numberText.textColor = [UIColor colorWithRed:255/255.0 green:25/255.0 blue:79/255.0 alpha:1.0];
                return;
            }
        }
    }

    // 人脸采集
    NSDictionary *dic = @{BDIDInfoCollectControllerIdNumberKey : _numberText.text ?: @"",
                       BDIDInfoCollectControllerNameKey : _nameText.text ?: @"",
                          BDIDInfoCollectControllerCarTypeKey : [NSString stringWithFormat: @"%ld", (long)_inputCardTypeId] ?: @""
    };
    if (self.action) {
        self.action(dic);
    }
}

/**
 * 键盘高度变化判断
 */
-(void)keyboardWillShow:(NSNotification *)keyboardNotification {
    // 获取键盘高度
    NSDictionary *userInfo = [keyboardNotification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    _boardHeight = keyboardRect.size.height;
    
    // 获取屏幕view的高度
    CGFloat heights = self.view.frame.size.height;
    
    // 键盘顶部到
    CGFloat keyboardY = heights - _boardHeight - 60;
    
    // 最底部textfield的Y值
    CGFloat textfieldY = _textviewHeight + 52;
    
    int offset = textfieldY - keyboardY;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        float width = self.view.frame.size.width;
         
        float height = self.view.frame.size.height;

        if (offset > 0) {
        CGRect rect = CGRectMake(0.0f, -offset, width, height);
        self.view.frame = rect;
        }

    }];
}

#pragma mark textfieldDelegate

/**
 * 切换其他身份类型后监听键盘输入
 */
-(void)textChange {
        if (_nameText.text.length == 0 || _numberText.text.length == 0) {
            self.nextButton.enabled = NO;
            self.nextButton.alpha = 0.29;
        } else {
            self.nextButton.enabled = YES;
            self.nextButton.alpha = 1;
        }
}

/**
 * textfield编辑开始时文字颜色判断
 */
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == _numberText) {
        _textviewHeight = 380;
    } else if (textField == _nameText) {
        _textviewHeight = 380;
    }
    
    if (textField == _nameText) {
        _nameText.textColor = [UIColor colorWithRed:23/255.0 green:29/255.0 blue:36/255.0 alpha:1.0];
    } else {
        _numberText.textColor = [UIColor colorWithRed:23/255.0 green:29/255.0 blue:36/255.0 alpha:1.0];
    }
}

/**
 选中高亮状态下的按钮颜色
 */
- (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);  //图片尺寸
    UIGraphicsBeginImageContext(rect.size); //填充画笔
    CGContextRef context = UIGraphicsGetCurrentContext(); //根据所传颜色绘制
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect); //联系显示区域
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext(); // 得到图片信息
    UIGraphicsEndImageContext(); //消除画笔
    return image;
}

#pragma mark- 取消键盘响应

/**
 * 取消全局键盘编辑
 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        
        float width = self.view.frame.size.width;
        float height = self.view.frame.size.height;
        CGRect rect = CGRectMake(0, 0, width, height);
        self.view.frame = rect;
    }];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
