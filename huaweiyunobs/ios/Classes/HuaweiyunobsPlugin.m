#import "HuaweiyunobsPlugin.h"
#import "OBS/OBS.h"

@implementation HuaweiyunobsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"huaweiyunobs"
            binaryMessenger:[registrar messenger]];
  HuaweiyunobsPlugin* instance = [[HuaweiyunobsPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"_uploadFileToHuaWeiYun" isEqualToString:call.method]) {
       int aa=[self getBatteryLevel:call];
      if(aa==1){
         result(@("success"));
      }else{
         result(@("error"));
      }
//    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}
- (int)getBatteryLevel :(FlutterMethodCall*) call {
   static OBSClient *client;
     NSDictionary *args = call.arguments;
     // 初始化身份验证
     OBSStaticCredentialProvider *credentailProvider = [[OBSStaticCredentialProvider alloc] initWithAccessKey:args[@"ak"] secretKey:args[@"sk"]];
     NSString* newendPoint = [@"https://" stringByAppendingString: args[@"endPoint"]];
     //初始化服务配置
     OBSServiceConfiguration *conf = [[OBSServiceConfiguration alloc] initWithURLString:newendPoint credentialProvider:credentailProvider];
     // 初始化client
     client = [[OBSClient alloc] initWithConfiguration:conf];
//     //指定待上传文件名及文件类型
//     NSString *filePath = [[NSBundle mainBundle]pathForResource:@"fileName" ofType:@"Type"];
     // 文件上传
     OBSPutObjectWithFileRequest *request = [[OBSPutObjectWithFileRequest alloc]initWithBucketName:args[@"bucketname"] objectKey:args[@"objectname"] uploadFilePath:args[@"filepath"]];
     // 开启后台上传，当应用退出到后台后，上传任务仍然会进行
     request.background = YES;
         
     // 上传进度
     request.uploadProgressBlock = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
         NSLog(@"%0.1f%%",(float)floor(totalBytesSent*10000/totalBytesExpectedToSend)/100);
     };
         
     [client putObject:request completionHandler:^(OBSPutObjectResponse *response, NSError *error){
         // 判断error状态
         if(error){
             // 打印错误信息
             NSLog(@"文件上传失败");
             NSLog(@"%@",error);

         }
         // 上传文件成功，返回200，打印返回响应值
         if([response.statusCode isEqualToString:@"200"]){
             NSLog(@"文件上传成功");
             NSLog(@"%@",response);
             NSLog(@"%@",response.etag);
         }
     }];
    return 1;
}
@end
