//
//  BDIDInfoAutoCollectController.m
//  JingRong_Safe_IDLFaceSDKDemoOC
//
//  Created by Zhang,Jian(MBD) on 2021/9/27.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import "BDIDInfoAutoCollectController.h"
#import "VerifyRegexTool.h"
#import "BDBaseToastView.h"
#import <BDFaceBaseKit/BDFaceBaseKit.h>
#import "BDFaceAlertView.h"
#import "BDShootingRequireView.h"
#import "BDFacePoorNetworkController.h"
#import "BDFaceVerificationFailController.h"
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
    
    // 港澳台居民居住证
    CardType_IDCard_HM_CITIZEN = 4,
};
@interface BDIDInfoAutoCollectController ()<UITextFieldDelegate, BDAlertViewDelegate>

//身份证类型文字
@property (weak, nonatomic) IBOutlet UILabel *cardTypeText;

//身份证照片
@property (weak, nonatomic) IBOutlet UIImageView *cardImage;

//输入的姓名
@property (weak, nonatomic) IBOutlet UITextField *inputNameText;

//输入的身份证号
@property (weak, nonatomic) IBOutlet UITextField *inputNumberText;

// 下一步按钮
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

// 错误信息
@property (weak, nonatomic) IBOutlet UILabel *errorMsgText;

// 正常状态显示页面
@property (weak, nonatomic) IBOutlet UIView *normalView;

// 错误状态显示页面
@property (weak, nonatomic) IBOutlet UIView *errorView;

// 错误状态身份证图片
@property (weak, nonatomic) IBOutlet UIImageView *errorCardImage;

// 使用Ocr录入信息初始画面
@property (weak, nonatomic) IBOutlet UIView *useOcrView;

// ocr创建的VC
@property (weak, nonatomic) UIViewController *vc;

// ocr扫描后保存的身份证信息
@property (strong, nonatomic) UIImage *idCardImage;

// 选择身份信息画面
@property (weak, nonatomic) IBOutlet UIView *selectView;

// 身份类型箭头图片
@property (weak, nonatomic) IBOutlet UIImageView *cardTypeIcon;

// 选择身份类型按钮
@property (weak, nonatomic) IBOutlet UIButton *selectCardTypeBtn;

// 身份类型选择姓名输入框
@property (weak, nonatomic) IBOutlet UITextField *cardTypeNameTextField;

// 身份类型选择身份证件号码输入框
@property (weak, nonatomic) IBOutlet UITextField *cardTypeNumberTextField;

// 身份类型选择画面下一步按钮
@property (weak, nonatomic) IBOutlet UIButton *cardTypeNextBtn;

// 选择身份类型后保存的临时字符串
@property (copy, nonatomic) NSString *selectTypeString;

// 导航栏标题文字
@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;

// 获取textfield坐标Y值
@property (nonatomic, assign)int textviewHeight;

// 键盘高Y值
@property (nonatomic, assign)int boardHeight;

// 中国身份证状态下姓名输入框
@property (weak, nonatomic) IBOutlet UIView *inputTextBackView;

// 中国身份证状态下身份证号输入框
@property (weak, nonatomic) IBOutlet UIView *inputNumberBackView;

// 其他证件类型状态姓名输入框
@property (weak, nonatomic) IBOutlet UIView *cardTypeNameBackView;

// 其他证件类型状态下身份证号输入框
@property (weak, nonatomic) IBOutlet UIView *cardTypeNumberBackView;

// 身份采集信息错误提示文字
@property (weak, nonatomic) IBOutlet UILabel *infoErrorMessage;

// 传递的身份类型
@property (assign, nonatomic) NSInteger inputCardTypeId;

// 身份证图片背景
@property (weak, nonatomic) IBOutlet UIView *cardImgBackView;

// 点击上传身份证框按钮
@property (weak, nonatomic) IBOutlet UIButton *selectOCRCardButton;

// 打开OCR身份证背景view
@property (weak, nonatomic) IBOutlet UIView *cardImgBackgroundView;

//打开OCR身份证背景图片
@property (weak, nonatomic) IBOutlet UIImageView *cardImageBackImageView;

// OCR背景阴影view
@property (weak, nonatomic) IBOutlet UIView *backShadowView;


@end

@implementation BDIDInfoAutoCollectController

// 默认的识别成功的回调
void (^_successHandler)(NSDictionary *);
// 默认的识别失败的回调
void (^_failHandler)(NSError *);

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: YES];

    // 创建键盘弹出监听
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(keyboardWillShow:) name: UIKeyboardWillShowNotification object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(textChange) name: UITextFieldTextDidChangeNotification object: nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: YES];
    
    // 移除监听
    [[NSNotificationCenter defaultCenter] removeObserver: self name: UIKeyboardWillShowNotification object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self name:UITextFieldTextDidChangeNotification object: nil];
}

/**
 * 切换其他身份类型后监听键盘输入
 */
-(void)textChange {
    if (![_selectTypeString  isEqual: @"中国居民二代身份证"]) {
        if (_cardTypeNameTextField.text.length == 0 || _cardTypeNumberTextField.text.length == 0) {
            self.cardTypeNextBtn.enabled = NO;
            self.cardTypeNextBtn.alpha = 0.29;
        } else {
            self.cardTypeNextBtn.enabled = YES;
            self.cardTypeNextBtn.alpha = 1;
        }
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
    enum BDCardType citizen = (CardType_IDCard_HM_CITIZEN);
    if ([str isEqualToString: @"中国居民二代身份证"]) {
        return  china;
    } else if ([str isEqualToString: @"港澳台来往内陆通行证"]) {
        return hm;
    } else if ([str isEqualToString: @"外国人永久居留证"]) {
        return foreigner;
    } else if ([str isEqualToString: @"定居海外的中国公民护照"]) {
        return abroad;
    } else if ([str isEqualToString: @"港澳台居民居住证"]) {
        return citizen;
    }
    return 0;
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
    CGFloat keyboardY = heights - _boardHeight - 64;
    
    // 最底部textfield的Y值
    CGFloat textfieldY = _textviewHeight + 52;
    
    int offset = keyboardY - textfieldY;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        float width = self.view.frame.size.width;
         
        float height = self.view.frame.size.height;

        if (offset < 0) {
        CGRect rect = CGRectMake(0.0f, offset, width, height);
            self.view.frame = rect;
        }

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

-(void)initImageShadowView {
    _cardImageBackImageView.layer.cornerRadius = 10;
    // 添加图片阴影效果
    _cardImageBackImageView.layer.shadowColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
       // 设置阴影偏移量
    _cardImageBackImageView.layer.shadowOffset = CGSizeMake(0,1);
       // 设置阴影透明度
    _cardImageBackImageView.layer.shadowOpacity = 0.1;
       // 设置阴影半径
    _cardImageBackImageView.layer.shadowRadius = 8;
    _cardImageBackImageView.clipsToBounds = NO;
    _cardImgBackgroundView.layer.cornerRadius = 10;
    _cardImgBackgroundView.layer.borderWidth = 1.5;
    _cardImgBackgroundView.layer.borderColor = [UIColor colorWithRed:148/255.0 green:202/255.0 blue:255/255.0 alpha:1].CGColor;
    _backShadowView.layer.cornerRadius = 10;
    // 添加图片阴影效果
    _backShadowView.layer.shadowColor = [UIColor colorWithHexString:@"#000000" alpha:0.1].CGColor;
       // 设置阴影偏移量
    _backShadowView.layer.shadowOffset = CGSizeMake(0,1);
       // 设置阴影透明度
    _backShadowView.layer.shadowOpacity = 1;
       // 设置阴影半径
    _backShadowView.layer.shadowRadius = 3;
    _backShadowView.clipsToBounds = NO;
}

- (void)configCallback {
    __weak typeof(self) weakSelf = self;
    
    // 这是默认的识别成功的回调
    _successHandler = ^(id result){
        NSMutableString *message = [NSMutableString string];
        
        if (result[@"words_result"]) {
            if ([result[@"words_result"] isKindOfClass:[NSDictionary class]]) {
                [result[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if ([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]) {
                        [message appendFormat:@" %@: %@\n", key, obj[@"words"]];
                    } else {
                        [message appendFormat:@" %@: %@\n", key, obj];
                    }
                    
                }];
            } else if ([result[@"words_result"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *obj in result[@"words_result"]) {
                    if ([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]) {
                        [message appendFormat:@" %@\n", obj[@"words"]];
                    } else {
                        [message appendFormat:@" %@\n", obj];
                    }
                    
                }
            }
            
        } else {
            [message appendFormat:@" %@", result];
        }
        // 将获取到的数据进行拆分
        NSArray * _arrayList = [message componentsSeparatedByString:@" "];
        
        // 线程切换
        dispatch_async(dispatch_get_main_queue(), ^{
            self.useOcrView.hidden = YES;
            if ([result[@"image_status"] isEqual: @"reversed_side"]) {
                NSLog(@"%@", result[@"image_status"]);
                [weakSelf toNoInfoPageWithErrorMessage:@"请采集身份证正面信息"];
            } else if ([result[@"image_status"] isEqual: @"non_idcard"]
                       || [result[@"image_status"] isEqual: @"other_type_card"]
                       || [result[@"image_status"] isEqual: @"unknown"]) {
                [weakSelf toNoInfoPageWithErrorMessage:@"身份信息不正确,请重新采集"];
            } else if ([result[@"image_status"] isEqual: @"blurred"]
                       || [result[@"image_status"] isEqual: @"over_exposure"]
                       || [result[@"image_status"] isEqual: @"over_dark"]) {
                [weakSelf toNoInfoPageWithErrorMessage:@"身份证照片质量低，请重新采集"];
            } else {
                // 开启新的页面
                NSArray * _nameList = [_arrayList[2] componentsSeparatedByString:@"\n"];
                NSArray * _idCardNumberList = [_arrayList[6] componentsSeparatedByString:@"\n"];
                [weakSelf.vc.navigationController popViewControllerAnimated:YES];
                [self initName:_nameList[0] numberName:_idCardNumberList[0] cardImage: weakSelf.idCardImage];
            }
        });
        
    };
    
    _failHandler = ^(NSError *error){
        NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[error code], [error localizedDescription]];
        NSArray * _arrayList = [msg componentsSeparatedByString:@":"];
        NSLog(@"msg: %@", _arrayList[0]);
        // 线程切换
        dispatch_async(dispatch_get_main_queue(), ^{
            UIViewController *root = weakSelf.navigationController.viewControllers[0];
            if ([_arrayList[0] isEqual: @"216633"]
                || [_arrayList[0] isEqual: @"216200"]) {
                
//                [weakSelf startOCRSdk];
                
            } else if ([_arrayList[0] isEqual: @"282112"]
                       || [_arrayList[0] isEqual: @"282000"]
                       || [_arrayList[0] isEqual: @"216634"]
                       || [_arrayList[0] isEqual: @"216630"]
                       || [_arrayList[0] isEqual: @"282100"]
                       || [_arrayList[0] isEqual: @"282102"]
                       || [_arrayList[0] isEqual: @"283504"]) {
                
                __strong typeof(weakSelf) strongSelf = weakSelf;
                BDFacePoorNetworkController * ocr = [[BDFacePoorNetworkController alloc] init];
                ocr.status = 0;
                [strongSelf.vc.navigationController pushViewController:ocr animated:YES];
                
            } else {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                UIViewController *root = weakSelf.navigationController.viewControllers[0];
                BDFaceVerificationFailController * ocr = [[BDFaceVerificationFailController alloc] init];
                ocr.titleText = @"身份信息采集";
                ocr.iconImage = [UIImage imageNamed:@"icon_fail"];
                ocr.name = @"参数格式错误";
                ocr.nameText = @"请参考API说明文档，修改参数";
                ocr.btnText = @"关闭";
                [strongSelf.vc.navigationController pushViewController:ocr animated:YES];
            }
            
        });
        
    };
}

/**
 * 身份证信息识别错误
 */
- (void)toNoInfoPageWithErrorMessage:(NSString *)message {
    self.topTitleLabel.text = @"确认个人信息";
    [self.vc.navigationController popViewControllerAnimated: YES];
    [self initErrorMsg: message cardImage :self.idCardImage];
}

/**
 * 根据身份类型判断是否可以选择其他身份
 */
-(void)initCardType {
    if ([BDConfigDataService supportMultiCard]) {
        _cardTypeIcon.hidden = NO;
        _selectCardTypeBtn.enabled = YES;
        _selectCardTypeBtn.userInteractionEnabled = YES;
    } else {
        _cardTypeIcon.hidden = YES;
        _selectCardTypeBtn.enabled = NO;
        _selectCardTypeBtn.userInteractionEnabled = NO;
    }
}

#pragma mark - UI处理

/**
 * 点击上传身份证
 */
- (IBAction)useOcrInfoVC:(UIButton *)sender {
    // ocr采集身份证
//    [self startOCRSdk];
}

/**
 * 身份证错误信息画面
 * parameters msg: 错误信息内容
 * parameters img: 传递的身份证图片
 */
-(void)initErrorMsg:(NSString*)msg cardImage:(UIImage*)img {
    _errorView.hidden = NO;
    _normalView.hidden = YES;
    self.errorMsgText.text = msg;
    self.errorCardImage.image = img;
}

/**
 * 正常状态的画面
 * parameters name: 姓名
 * parameters numberName: 身份证号
 * parameters cardImage: 身份证图片
 */
-(void)initName:(NSString *)name numberName:(NSString *)numberName cardImage:(UIImage*)cardImage {
    self.topTitleLabel.text = @"确认个人信息";
    _errorView.hidden = YES;
    _normalView.hidden = NO;
    _infoErrorMessage.hidden = YES;
    self.inputNameText.text = name;
    self.inputNumberText.text = numberName;
    self.cardImage.image = cardImage;
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

#pragma mark - IBAction

/**
 * 选择证件类型处理
 */
- (IBAction)selectCardTypeAction:(UIButton *)sender {
    NSArray *cardTypeArray = [NSArray arrayWithObjects:@"中国居民二代身份证", @"港澳台来往内陆通行证", @"外国人永久居留证", @"定居海外的中国公民护照",@"港澳台居民居住证", @"取消", nil];
    UIAlertController *alert = [[UIAlertController alloc] init];
    for (int i=0; i<cardTypeArray.count; i++) {
        if (i == cardTypeArray.count - 1) {
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:cardTypeArray[cardTypeArray.count - 1] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancle];
        } else {
            UIAlertAction *action = [UIAlertAction actionWithTitle:cardTypeArray[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.selectCardTypeBtn setTitle:cardTypeArray[i] forState:UIControlStateNormal];
                if (_selectTypeString == cardTypeArray[i]) {
                    
                } else {
                    _selectTypeString = cardTypeArray[i];
//                    self.cardTypeNameTextField.text = @"";
//                    self.cardTypeNumberTextField.text = @"";
//                    self.inputNameText.text = @"";
//                    self.inputNumberText.text = @"";
                }
                
                if (i == 0) {
                    self.selectView.hidden = YES;
                    self.useOcrView.hidden = NO;
                } else {
                    self.selectView.hidden = NO;
                    self.useOcrView.hidden = YES;
                    self.normalView.hidden = YES;
                }
                _inputCardTypeId = [self cardTypeString: cardTypeArray[i]];
            }];
            [alert addAction:action];
            [UIView animateWithDuration:0.3 animations:^{
                
                float width = self.view.frame.size.width;
                float height = self.view.frame.size.height;
                CGRect rect = CGRectMake(0, 0, width, height);
                self.view.frame = rect;
                _textviewHeight = 0;
            }];
        }
    }
    [self presentViewController:alert animated:true completion:nil];
}

/**
 * 中国居民身份状态下一步按钮处理
 * parameters sender: 响应者
 */
- (IBAction)nextStepAction:(UIButton *)sender {
    [self.view endEditing:true];
    if ([self.selectCardTypeBtn.titleLabel.text isEqualToString:@"中国居民二代身份证"]) {
        if (![VerifyRegexTool checkRealName: _inputNameText]) {
            NSLog(@"姓名校验不通过");
            self.infoErrorMessage.hidden = NO;
            return;
        }
        if (![VerifyRegexTool checkIDCardNum: _inputNumberText]) {
            NSLog(@"请填写正确的证件号");
            self.infoErrorMessage.hidden = NO;
            return;
        }
    }

    // 回调下一步信息
    NSDictionary *dic = @{BDIDInfoCollectControllerIdNumberKey : _inputNumberText.text ?: @"",
                       BDIDInfoCollectControllerNameKey : _inputNameText.text ?: @"",
                          BDIDInfoCollectControllerCarTypeKey : [NSString stringWithFormat: @"%ld", (long)_inputCardTypeId] ?: @""
    };
    if (self.action) {
        self.action(dic);
    }
}

/**
 选择OCR方式的下一步按钮(默认不可编辑)
 */
- (IBAction)cardTypeNextStepAction:(UIButton *)sender {
    [self.view endEditing:true];
    if ([self.selectCardTypeBtn.titleLabel.text isEqualToString:@"中国居民二代身份证"]) {
        if (![VerifyRegexTool checkRealName: _cardTypeNameTextField]) {
            NSLog(@"姓名校验不通过");
            [BDFaceToastView showToast:[UIApplication sharedApplication].keyWindow text:@"姓名校验不通过"];
            _cardTypeNameTextField.textColor = [UIColor colorWithRed:255/255.0 green:25/255.0 blue:79/255.0 alpha:1.0];
            return;
        }
        if (![VerifyRegexTool checkIDCardNum: _cardTypeNumberTextField]) {
            NSLog(@"请填写正确的证件号");
            [BDFaceToastView showToast:[UIApplication sharedApplication].keyWindow text:@"请填写正确的证件号"];
            _cardTypeNumberTextField.textColor = [UIColor colorWithRed:255/255.0 green:25/255.0 blue:79/255.0 alpha:1.0];
            return;
        }
    } else if ([self.selectCardTypeBtn.titleLabel.text isEqualToString:@"港澳台来往内陆通行证"]) {
        // 港澳台居民往来内陆通行证姓名验证
        if (![VerifyRegexTool checkRealName: _cardTypeNameTextField]) {
            NSLog(@"姓名校验不通过");
            [BDFaceToastView showToast:[UIApplication sharedApplication].keyWindow text:@"姓名校验不通过"];
            _cardTypeNameTextField.textColor = [UIColor colorWithRed:255/255.0 green:25/255.0 blue:79/255.0 alpha:1.0];
            return;
        }
        // 港澳台居民往来内陆通行证号码验证
        if(![VerifyRegexTool isValidForGAT:_cardTypeNumberTextField.text]){
            [BDFaceToastView showToast:[UIApplication sharedApplication].keyWindow text:@"请填写正确的证件号"];
            _cardTypeNumberTextField.textColor = [UIColor colorWithRed:255/255.0 green:25/255.0 blue:79/255.0 alpha:1.0];
            return;;
        }
    } else if ([self.selectCardTypeBtn.titleLabel.text isEqualToString:@"外国人永久居留证"]) {
        // 外国人永久居留证号码验证
        if (_cardTypeNumberTextField.text.length == 18) {
            if (![[_cardTypeNumberTextField.text substringToIndex:1] isEqual:@"9"]) {
                    [BDFaceToastView showToast:[UIApplication sharedApplication].keyWindow text:@"请填写正确的证件号"];
                _cardTypeNumberTextField.textColor = [UIColor colorWithRed:255/255.0 green:25/255.0 blue:79/255.0 alpha:1.0];
                return;
            } else {
                if(![VerifyRegexTool isVaildIDCardNo:_cardTypeNumberTextField.text]){
                    [BDFaceToastView showToast:[UIApplication sharedApplication].keyWindow text:@"请填写正确的证件号"];
                    _cardTypeNumberTextField.textColor = [UIColor colorWithRed:255/255.0 green:25/255.0 blue:79/255.0 alpha:1.0];
                    return;
                }
            }
        } else {
            if(![VerifyRegexTool isValidForForeignersPermit:_cardTypeNumberTextField.text]){
                [BDFaceToastView showToast:[UIApplication sharedApplication].keyWindow text:@"请填写正确的证件号"];
                _cardTypeNumberTextField.textColor = [UIColor colorWithRed:255/255.0 green:25/255.0 blue:79/255.0 alpha:1.0];
                return;;
            }
        }
    } else if ([self.selectCardTypeBtn.titleLabel.text isEqualToString:@"定居海外的中国公民护照"]) {
        // 定居国外的中国公民护照姓名验证
        if (![VerifyRegexTool checkRealName: _cardTypeNameTextField]) {
            NSLog(@"姓名校验不通过");
            [BDFaceToastView showToast:[UIApplication sharedApplication].keyWindow text:@"姓名校验不通过"];
            _cardTypeNameTextField.textColor = [UIColor colorWithRed:255/255.0 green:25/255.0 blue:79/255.0 alpha:1.0];
            return;
        }
        // 定居国外的中国公民护照号码验证
        if(![VerifyRegexTool isValidForCitizenPassport:_cardTypeNumberTextField.text]){
            [BDFaceToastView showToast:[UIApplication sharedApplication].keyWindow text:@"请填写正确的证件号"];
            _cardTypeNumberTextField.textColor = [UIColor colorWithRed:255/255.0 green:25/255.0 blue:79/255.0 alpha:1.0];
            return;;
        }
    } else if ([self.selectCardTypeBtn.titleLabel.text isEqualToString:@"港澳台居民居住证"]) {
        if (![VerifyRegexTool checkRealName: _cardTypeNameTextField]) {
            NSLog(@"姓名校验不通过");
            [BDFaceToastView showToast:[UIApplication sharedApplication].keyWindow text:@"姓名校验不通过"];
            _cardTypeNameTextField.textColor = [UIColor colorWithRed:255/255.0 green:25/255.0 blue:79/255.0 alpha:1.0];
            return;
        }
        if (![VerifyRegexTool isValidForGATCard: _cardTypeNumberTextField.text]) {
            [BDFaceToastView showToast:[UIApplication sharedApplication].keyWindow text:@"请填写正确的证件号"];
            _cardTypeNumberTextField.textColor = [UIColor colorWithRed:255/255.0 green:25/255.0 blue:79/255.0 alpha:1.0];
            return;
        } else {
            // 判断港台前6位区号
            if ([[_cardTypeNumberTextField.text substringToIndex:6] isEqual: @"810000"] || [[_cardTypeNumberTextField.text substringToIndex:6] isEqual: @"820000"] || [[_cardTypeNumberTextField.text substringToIndex:6] isEqual: @"830000"]) {
                NSLog(@"%@", _cardTypeNumberTextField.text);
            } else {
                [BDFaceToastView showToast:[UIApplication sharedApplication].keyWindow text:@"请填写正确的证件号"];
                _cardTypeNumberTextField.textColor = [UIColor colorWithRed:255/255.0 green:25/255.0 blue:79/255.0 alpha:1.0];
                return;
            }
        }
    }

    // 回调下一步信息
    NSDictionary *dic = @{BDIDInfoCollectControllerIdNumberKey : _cardTypeNumberTextField.text ?: @"",
                       BDIDInfoCollectControllerNameKey : _cardTypeNameTextField.text ?: @"",
                          BDIDInfoCollectControllerCarTypeKey : [NSString stringWithFormat: @"%ld", (long)_inputCardTypeId] ?: @""
    };
    if (self.action) {
        self.action(dic);
    }
}

/**
 * 返回按钮
 * parameters sender: 响应者
 */
- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * 正常状态下重新采集按钮
 * parameters sender: 响应者
 */
- (IBAction)reAcquisitionInNormal:(UIButton *)sender {
//    [self startOCRSdk];
}

/**
 * 错误状态下重新采集按钮
 * parameters sender: 响应者
 */
- (IBAction)reAcquisitionInerror:(UIButton *)sender {
//    [self startOCRSdk];
}

/**
 * 身份信息正常状态下查看拍照规则
 */
- (IBAction)normalAlertAction:(UIButton *)sender {
    [self.view endEditing:true];
    BDShootingRequireView * alertView = [[BDShootingRequireView alloc] init];
    alertView.delegate = self;
    alertView.frame = CGRectMake(32, 120, 311, 440);
    [BDFaceAlertView showView: alertView position: 0];
}

- (void)closeCurrentPage {
    [BDFaceAlertView dismiss];
}

/**
 * 身份信息错误状态下查看拍照规则
 */
- (IBAction)errorAlertAction:(UIButton *)sender {
    BDShootingRequireView * alertView = [[BDShootingRequireView alloc] init];
    alertView.delegate = self;
    alertView.frame = CGRectMake(32, 120, 311, 440);
    [BDFaceAlertView showView:alertView position:0];
}


#pragma mark textfieldDelegate

/**
 * 编辑开始时文字颜色判断
 * parameters textField: 编辑响应者
 */
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _inputNameText) {
        _textviewHeight = 510;
        _cardTypeNameTextField.textColor = [UIColor colorWithRed:23/255.0 green:29/255.0 blue:36/255.0 alpha:1.0];
    } else if (textField == _inputNumberText) {
        _textviewHeight = 510;
        _cardTypeNumberTextField.textColor = [UIColor colorWithRed:23/255.0 green:29/255.0 blue:36/255.0 alpha:1.0];
    }
    if (textField == _cardTypeNameTextField) {
        _textviewHeight = 370;
        _cardTypeNameTextField.textColor = [UIColor colorWithRed:23/255.0 green:29/255.0 blue:36/255.0 alpha:1.0];
    } else if (textField == _cardTypeNumberTextField) {
        _textviewHeight = 370;
        _cardTypeNumberTextField.textColor = [UIColor colorWithRed:23/255.0 green:29/255.0 blue:36/255.0 alpha:1.0];
    }
}


/**
 * 编辑结束的时候调用
 */
-(void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.3 animations:^{

        float width = self.view.frame.size.width;
        float height = self.view.frame.size.height;
        CGRect rect = CGRectMake(0.0f, 0, width, height);
        self.view.frame = rect;

    }];
}

#pragma mark- 取消键盘响应

/**
 * 取消全局键盘编辑
 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view resignFirstResponder];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
