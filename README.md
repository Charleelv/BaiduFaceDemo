# BaiduFaceDemo
Integrate Baidu's OCR and Face functions

###【使用说明】
#####1、修改bundleID与百度智能云后台创建的项目保持一致；
#####2、更换BaiduFace文件夹下的BDFaceSDK里的idl-key.face-ios和idl-license.face-ios
#####3、更改一下FACE_LICENSE_NAME和FACE_LICENSE_ID即可。

##基于百度SDK的二次开发
###应用场景：前端只取照片以及Face的采集结果，全部传给服务端，服务端调用百度Service生成OCR信息以及Face比对结果
####功能主要集中在BaiduFace-Category中，人脸采集、核验、活体检测，本Demo使用的是人脸采集FaceViewController+FaceCollect.h
###集成和使用中遇到的问题：
####集成部分：
#####1、在百度智能云的后台，找到创建的项目，选择“集成文件下载-iOS”，即可拿到Demo，其中FACE_LICENSE_NAME和FACE_LICENSE_ID是已经生成好的，不需要更改；
#####2、build Phases里link Binary 里导入libc++.tbd、libz.tbd、CoreTelephony.framework
####使用部分：
#####1、duplicate symbol ／undefind symbol出现的原因(https://blog.csdn.net/xiao_scy_xiao/article/details/53125957)
#####2、在人脸采集结果处理的时候，给后端传值，sec_level这个字段，默认是common，但是【5.2+版本时传lite】

##以下为百度SDK使用说明：

## 名镜5.0实名认证解决方案
## 版本信息：
#####5.0.0
#####Edit Time:2021.12.3

## 关键流程代码说明
####1.1 人脸识别SDK初始化和OCR SDK初始化代码如下 在ViewController文件中：

#####1.1.1 获取token和初始化入口代码：

    [self getAccessToken]; // 获取token
    [self initFaceServiceAndInfoCollectService]; // 初始化人脸SDK和OCR的SDK方法

#####【重要】出于安全角度的考虑安全原因，AccessToken的获取建议在用户服务器上做一层转发，也就是AK,SK写到自己服务器，而不是客户端来做获取。

#####1.1.2 分别初始人脸和OCR SDK的入口函数：



    //人脸识别初始化函数
    - (void)initFaceServiceAndInfoCollectService {
    __weak typeof(self) this = self;
    /// 初始化 人脸识别Service
    self.logicService = [[BDFaceLogicService alloc] initWithController:self face:^{
        [this initFaceSDK];
    } ocr:^{
        [this initOcrSDK];
    }];}

initFaceSDK：
人脸SDK初始化设置，默认：动作+炫彩活体 可以通过改变liveSelectMode 设置动作类型。
包含人脸SDK鉴权设置和人脸参数和阈值设置，此处列出鉴权设置代码如下：



    [[BDFaceBaseKitManager sharedInstance] initCollectWithLicenseID:FACE_LICENSE_ID andLocalLicenceName:FACE_LICENSE_NAME andExtradata:@{} callback:^(BDFaceInitRemindCode code, NSDictionary *extradata) {
        NSLog(@"%ld", (long)code);
    }];

initOcrSDK：
包含OCR鉴权设置相关代码：



    NSString *licenseFile = [[NSBundle mainBundle] pathForResource:FACE_API_ORC_KEY ofType:FACE_SECRET_OCR_KEY];
    NSData *licenseFileData = [NSData dataWithContentsOfFile:licenseFile];
    [[AipOcrService shardService] authWithLicenseFileData:licenseFileData];
    NSLog(@"ocr sd version: %@", [AipOcrService ocrSdkVersion]);

####1.2开始身份认证流程代码
[**self** startCheck];

####1.3 开始活体检测流程代码
[self startLiveCheck];

####1.4 采集身份信息流程

#####1.4.1手动输入采集身份信息流程，如下函数如果配置返回NO即可；
[BDConfigDataService useOCR] 
根据返回值判断手动还是OCR方式录入身份信息

#####1.5.1直接输入身份证信息识别，也就是使用代码传入姓名和身份证的方式来，传入参数，直接打开采集页面，不使用OCR部分代码来采集身份证信息，如下所示配置

    // BDConfigDataService useOCR] = 2即可：
    if ([BDConfigDataService useOCR] == 2) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:tempDict];
       
    // 这里需要传入真实的姓名和身份证号，最后才能检测成功    
    // 用户姓名
    NSString *userName = @"";
    // 用户身份证号
    NSString *userIdCarNumber = @"";
    parameters[BDFaceLogicServiceNameKey]  = userName ?: @"";
    parameters[BDFaceLogicServiceCardNumberKey]  = userIdCarNumber ?: @"";
    [self checkFaceAction:parameters];   

#####1.5.2采集人脸函数


    // 人脸采集
    - (void)checkFaceAction:(NSMutableDictionary *)parameters {
        __weak typeof(self) this = self;
        [self startCheckFace:parameters response:^(int code, NSDictionary *callBack) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 0 表示成功
                if (code == 0) {
                    NSDictionary *responseDic = callBack[BDFaceLogicServiceReturnKeyForResultData];
                    [this showRequestSuccessResult:responseDic];
                } else {
                    NSString *errorMessage = callBack[BDFaceLogicServiceReturnKeyForResultMsg];
                    [this showMainStepFailResult:errorMessage];
                }
                
            });
        }];
    }

#####1.5.3 人证核验流程


    - (void)startCheckFace:(NSDictionary *)dic response:(void(^)(int code, NSDictionary *callBack))response {
        
        NSString *name = dic[BDIDInfoCollectControllerNameKey];
        NSString *cardNumber = dic[BDIDInfoCollectControllerIdNumberKey]; // dic[BDIDInfoCollectControllerIdNumberKey];
        NSNumber *cardType = dic[BDIDInfoCollectControllerCarTypeKey];
        NSString *tokenString = dic[BDFaceLogicServiceTokenKey];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
        {
            // 删除从OCR传递过来的，保留其他值。
            [parameters removeObjectForKey:BDIDInfoCollectControllerNameKey];
            [parameters removeObjectForKey:BDIDInfoCollectControllerIdNumberKey];
            [parameters removeObjectForKey:BDIDInfoCollectControllerCarTypeKey];
            [parameters removeObjectForKey:BDFaceLogicServiceTokenKey];
        }
        parameters[BDFaceLogicServiceNameKey] = name ?: @"";
        parameters[BDFaceLogicServiceCardNumberKey] = cardNumber ?: @"";
        parameters[BDFaceLogicServiceTokenKey] = tokenString ?: @"";
        // 默认身份证识别
        parameters[BDFaceLogicServiceCardTypeKey] = cardType ?: @(0);
        
        [self.logicService startRecognize:parameters callBack:^(int resultCode, NSDictionary * _Nonnull resultDic) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (response) {
                    response(resultCode, resultDic);
                }
            });
        }];
    }

#####1.5.4 处理返回结果 


    dispatch_async(dispatch_get_main_queue(), ^{
                // 0 表示成功
                if (code == 0) {
                    NSDictionary *responseDic = callBack[BDFaceLogicServiceReturnKeyForResultData];
                    [this showRequestSuccessResult:responseDic];
                } else {
                    NSString *errorMessage = callBack[BDFaceLogicServiceReturnKeyForResultMsg];
                    [this showMainStepFailResult:errorMessage];
                }
                
            });

#####1.5.5 处理服务端成功返回的信息


    - (void)showRequestSuccessResult:(NSDictionary *)responseDic;

####1.6 OCR采集身份信息

#####1.6.1打开相机开始识别

    // 打开相机使用OCR
    - (void)startOCRSdk {
    // 设置成功失败回调
    [self configCallback];
    
    // 清空ocr缓存
    [AipCaptureCardVC clearIdCard];
    // 设置ocr页面的配置，可以通过设置config的属性来配置
    BDAipOCRConfig *config = [[BDAipOCRConfig alloc] init];
    // 身份证识别页面，传入参数cofnig页面配置； didGetImage 拍照完成，返回图片；success:传入成功回调Block; failure:传入失败block
    UIViewController *detectController = [[AipOcrService shardService] startOcrRecognize:config didGetImage:^(UIImage *image) {
        _idCardImage = image;
    } success:_successHandler failure:_failHandler];
    
    // 设置ocr页面返回按钮的action Block
    __weak typeof(UIViewController *)weakDetect = detectController;
    [[AipOcrService shardService] setGoBackAction:^{
        [weakDetect.navigationController popViewControllerAnimated:YES];
    }];
    [self.navigationController pushViewController:detectController animated:YES];
    _vc = detectController;
   }


#####1.6.2处理成功和失败回调
  扫描SDK成功后调用[self configCallback]完成回调 包含成功回调successHandler 和失败回调failHandler 处理。



    - (void)configCallback {
    // 这是默认的识别成功的回调
    _successHandler = ^(id result){}
       
       // 失败回调
    _failHandler = ^(NSError *error){}
 }


#####1.6.3 OCR 识别成功后点击下一步开启采集功能调用人证核验接口与上面手动录入模式的方式一样在这里不具体介绍流程了。

####1.7活体检测流程

#####1.7.1活体检测流程函数



    - (void)startLiveCheck {
        NSDictionary *tokenDic = @{BDFaceLogicServiceTokenKey : self.accessToken ?: @""};
        __weak typeof(self) this = self;
        self.logicService.showLoadingAction = ^(void) {
            [this showCheckLiveLoadingAction];
        };
        [self.logicService startRecognizeToCheckLive:tokenDic callBack:^(int resultCode, NSDictionary * _Nonnull resultDic) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 0 表示成功
                if (resultCode == 0) {
                    NSDictionary *responseDic = resultDic[@"data"];
                    [this showCheckLiveRequestSuccessResult:responseDic];
                } else {
                    NSString *errorMessage = resultDic[BDFaceLogicServiceReturnKeyForResultMsg];
                    [self showCheckLiveFailResult:errorMessage];
                }
                
            });
        }];
    }
}


####1.8 采集人脸流程（用于做人脸比对使用）



    - - (void)startFaceCollect:(void(^)(NSNumber *code, NSDictionary *result))response;

采集到人脸信息后，使用接口https://aip.baidubce.com/rest/2.0/face/v4/mingjing/match进行人脸比对，具体解密图片同时人脸比对参考https://ai.baidu.com/ai-doc/FACE/Oktmssfse

