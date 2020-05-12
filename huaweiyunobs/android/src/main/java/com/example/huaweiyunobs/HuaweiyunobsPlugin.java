package com.example.huaweiyunobs;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import com.obs.services.ObsClient;
import com.obs.services.model.PutObjectResult;

import java.io.File;

/** HuaweiyunobsPlugin */
public class HuaweiyunobsPlugin implements FlutterPlugin, MethodCallHandler {
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "huaweiyunobs");
    channel.setMethodCallHandler(new HuaweiyunobsPlugin());
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "huaweiyunobs");
    channel.setMethodCallHandler(new HuaweiyunobsPlugin());
  }
  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("_uploadFileToHuaWeiYun")) {
      String message=uploadfile(call);
      if(message=="success"){
        result.success(message);
      }else{
        result.error("UNAVAILABLE", "上传文件报错", null);
      }
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }

  private String uploadfile(MethodCall call) {
    String url="";
    final MethodCall thecall=call;
    final String endPoint = call.argument("endPoint");
    final String ak = call.argument("ak");
    final String sk = call.argument("sk");
    // 创建ObsClient实例


    Thread thread= new Thread(new Runnable() {
      @Override
      public void run() {
        ObsClient obsClient = new ObsClient(ak, sk, endPoint);
        String fileurl=thecall.argument("filepath").toString();
        PutObjectResult bb=obsClient.putObject(thecall.argument("bucketname").toString(), thecall.argument("objectname").toString(),
            new File(fileurl)); // localfile为待上传的本地文件路径，需要指定到具体的文件名
      }
    });
    thread.start();
    try {
      thread.join();
    } catch (InterruptedException e) {
      e.printStackTrace();
      Thread.currentThread().interrupt();
      return "error";
    }
    return "success";

  }
}
