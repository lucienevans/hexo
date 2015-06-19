title: android实现拍照功能
tags:
  - 应用
id: 112
categories:
  - Android
date: 2014-08-27 21:24:08
---

[toc]

Android框架包含了对多种摄像头和摄像特性的支持，应用程序可以进行图片和视频的捕获。

## 需要考虑的问题

在让应用程序使用Android设备的摄像头之前，应该考虑一些期望如何使用此硬件的问题。
<!--more-->
*   **摄像头需求**—— 摄像头的使用对于应用程序是否确实如此重要，以至于在没有摄像头的设备上就不期望安装此应用了？如果确实如此，应该 [在manifest中声明摄像头需求](http://blog.sina.com.cn/s/blog_48d491300100ztl9.html#manifest)。
*   **快速拍照还是自定义摄像**—— 应用程序如何使用摄像头？仅仅是对快速拍照和视频片段感兴趣，还是要提供一种使用摄像头的新方式？对于快速拍照和摄像而言，可以考虑 [使用内置的摄像头应用](http://blog.sina.com.cn/s/blog_48d491300100ztl9.html#exist_app) 。为了开发一种定制的摄像头功能，请查看 [创建摄像头应用](http://blog.sina.com.cn/s/blog_48d491300100ztl9.html#build_app) 一节。
*   **存储**—— 应用程序产生的图像和视频是否期望仅对自身可见，还是可以共享——以便相册或其它媒体应用也能够使用？当应用程序被卸载后，还期望图像和视频可用么？请查看 [保存媒体文件](http://blog.sina.com.cn/s/blog_48d491300100ztl9.html#saveFile) 一节来了解如何实现这些选项。

## 概述

通过 [Camera](http://developer.android.com/reference/android/hardware/Camera.html) API或摄像头意图 [Intent](http://developer.android.com/reference/android/content/Intent.html) ，Android框架为图像和视频捕获提供支持。下面列出了有关的类：

*   `[Camera](http://developer.android.com/reference/android/hardware/Camera.html)`此类是控制摄像头的主要API。在创建摄像头应用程序时，此类用于拍摄照片或视频。
*   `[SurfaceView](http://developer.android.com/reference/android/view/SurfaceView.html)`此类用于向用户提供摄像头实时预览功能。
*   `[MediaRecorder](http://developer.android.com/reference/android/media/MediaRecorder.html)`此类用于从摄像头录制视频。
*   `[Intent](http://developer.android.com/reference/android/content/Intent.html)`动作类型为`[MediaStore.ACTION_IMAGE_CAPTURE](http://developer.android.com/reference/android/provider/MediaStore.html#ACTION_IMAGE_CAPTURE)` 或`[MediaStore.ACTION_VIDEO_CAPTURE](http://developer.android.com/reference/android/provider/MediaStore.html#ACTION_VIDEO_CAPTURE)` 的意图, 可在不直接使用`[Camera](http://developer.android.com/reference/android/hardware/Camera.html)`对象的情况下捕获图像和视频。

## Manifest声明

开始开发摄像头API的应用之前，应该确保已经在manifest中正确声明了对摄像头的使用及其它相关的feature。

**Camera权限**——应用程序必须对请求摄像头的使用权限。
<pre class="lang:default decode:true ">&lt;uses-permission android:name = "android.permission.CAMERA" /&gt;
注意：如果是 通过意图 来使用摄像头的，应用程序就不必请求本权限。</pre>
**Camera Feature**——应用程序必须同时声明对camera feature的使用，例如：
<pre class="lang:default decode:true">&lt;uses-feature android:name = "android.hardware.camera" /&gt;</pre>
关于摄像头feature的清单，参阅manifest [Feature参考](http://developer.android.com/guide/topics/manifest/uses-feature-element.html#features-reference)。

在manifest中加入camera feature，将会使得Android Market在没有摄像头或不支持指定feature的设备上禁止安装该应用程序。关于Android Market基于feature过滤的使用详情，请参阅 [Android Market和基于Feature的过滤](http://developer.android.com/guide/topics/manifest/uses-feature-element.html#market-feature-filtering)。

如果应用程序_可能用到_摄像头或摄像头feature，但却不是_必需_的，则应在manifest中指定包含<span style="color: #007000;">android:required</span> 属性的feature，并将该属性设为<span style="color: #007000;">false</span>：
<pre class="lang:default decode:true ">&lt;uses-feature android:name = "android.hardware.camera" android:required = "false" /&gt;</pre>
**存储权限**——如果应用程序要把图像或视频保存到设备的外部存储上（SD卡），则还必须在&gt;manifest中指定如下权限。
<pre class="lang:default decode:true ">&lt;uses-permission android:name = "android.permission.WRITE_EXTERNAL_STORAGE" /&gt;</pre>
**录音权限**——要用音频捕获来录音，应用程序必须请求音频捕获权限。
<pre class="lang:default decode:true ">&lt;uses-permission android:name = "android.permission.RECORD_AUDIO" /&gt;</pre>

##  使用内置摄像头应用程序

有一种快捷的方法可以让应用程序不用额外编写很多代码就能实现拍照或摄像，这就是用意图 [Intent](http://developer.android.com/reference/android/content/Intent.html) 来调用内置的Android摄像头应用程序。摄像头intent会请求通过内置摄像应用来捕获图像或视频，并把控制权返回给应用程序。本节展示了如何用这种方法来捕获图像。

通常按以下步骤来提交一个摄像头intent：

*   **构建一个摄像头Intent**——用以下意图类型之一，创建一个请求图像或视频的 [Intent](http://developer.android.com/reference/android/content/Intent.html)：

    *   [MediaStore.ACTION_IMAGE_CAPTURE](http://developer.android.com/reference/android/provider/MediaStore.html#ACTION_IMAGE_CAPTURE) ——向内置摄像头程序请求图像拍摄的intent action类型。
    *   [MediaStore.ACTION_VIDEO_CAPTURE](http://developer.android.com/reference/android/provider/MediaStore.html#ACTION_VIDEO_CAPTURE) ——向内置摄像头程序请求视频录制的intent action类型。

*   **启动摄像头Intent**——用 [startActivityForResult()](http://developer.android.com/reference/android/app/Activity.html#startActivityForResult(android.content.Intent,%20int)) 方法执行摄像头intent。启动完毕后摄像头应用的用户界面就会显示在屏幕上，用户就可以拍照或摄像了。
*   **接收Intent结果**——在应用程序中设置 [onActivityResult()](http://developer.android.com/reference/android/app/Activity.html#onActivityResult(int,%20int,%20android.content.Intent)) 方法，用于接收从摄像头intent返回的数据。当用户拍摄完毕后（或者取消操作），系统会调用此方法。

### 捕获图像的intent

如果希望程序以最少的代码实现拍照功能，利用摄像头intent捕获图像是一条捷径。图像捕捉intent还可以包含以下附加信息：

*   [MediaStore.EXTRA_OUTPUT](http://developer.android.com/reference/android/provider/MediaStore.html#EXTRA_OUTPUT)——本设置需要一个 [Uri](http://developer.android.com/reference/android/net/Uri.html)对象，用于指定存放图片的路径和文件名。本设置是可选项，但强烈建议使用。如果未指定本设置值，那么摄像应用将会把所请求的图片以默认文件名和路径进行保存，并将数据置入intent的 [Intent.getData()](http://developer.android.com/reference/android/content/Intent.html#getData())部分返回。
以下例子演示了如何构建并执行一个图像捕获intent。此例中的<span style="color: #007000;">getOutputMediaFileUri()</span> 方法引自[保存媒体文件](http://blog.sina.com.cn/s/blog_48d491300100ztl9.html#saveFile)中的例程代码。
<pre class="lang:default decode:true">private static final int CAPTURE_IMAGE_ACTIVITY_REQUEST_CODE=100;

private Uri fileUri;

@Override

public void onCreate (Bundle  savedInstanceState){

  super.onCreate(savedInstanceState);

  setContentView(R.layout.main);

  //创建拍照 Intent并将控制权返回给调用的程序

  Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);

  fileUri = getOutputMediaFileUri(MEDIA_TYPE_IMAGE);

  //创建保存图片的文件

  intent.putExtra(MediaStore.EXTRA_OUTPUT, fileUri);

  //设置图片文件名

  //启动图像捕获Intent

  startActivityForResult(intent, CAPTURE_IMAGE_ACTIVITY_REQUEST_CODE);

}</pre>
[startActivityForResult()](http://developer.android.com/reference/android/app/Activity.html#startActivityForResult(android.content.Intent,%20int)) 方法执行完毕后，用户将看到内置摄像头应用程序的界面。用户拍照完毕（或取消操作）后，用户界面返回应用程序，这时必须截获 [onActivityResult()](http://developer.android.com/reference/android/app/Activity.html#onActivityResult(int,%20int,%20android.content.Intent)) 方法来接收intent的返回结果并执行后续操作。关于如何接收完整的intent，请参阅 接收摄像头Intent的结果。

### 捕获视频的intent

如果希望程序以最少的代码实现摄像功能，利用摄像头intent捕获视频是一条捷径。视频捕捉intent可以包含以下附带信息：

*   [MediaStore.EXTRA_OUTPUT](http://developer.android.com/reference/android/provider/MediaStore.html#EXTRA_OUTPUT)——本设置需要一个 [Uri](http://developer.android.com/reference/android/net/Uri.html) ，用于指定保存视频的路径和文件名。本设置是可选项，但强烈建议使用。如果未指定本设置值，那么摄像应用将会把所请求的视频以默认文件名和路径进行保存，并将数据置入intent的 [Intent.getData()](http://developer.android.com/reference/android/content/Intent.html#getData()) 部分返回。
*   [MediaStore.EXTRA_VIDEO_QUALITY](http://developer.android.com/reference/android/provider/MediaStore.html#EXTRA_VIDEO_QUALITY)——本值用0表示最低品质及最小的文件尺寸，用1表示最高品质和较大的文件尺寸。
*   [MediaStore.EXTRA_DURATION_LIMIT](http://developer.android.com/reference/android/provider/MediaStore.html#EXTRA_DURATION_LIMIT)——本值用于限制所捕获视频的长度，以秒为单位。
*   [MediaStore.EXTRA_SIZE_LIMIT](http://developer.android.com/reference/android/provider/MediaStore.html#EXTRA_SIZE_LIMIT)——本值用于限制所捕获视频的文件尺寸，以字节为单位。
以下例子演示了如何构建并执行一个视频捕获intent。本例中的<span style="color: #007000;">getOutputMediaFileUri()</span>方法引自 [保存媒体文件](http://blog.sina.com.cn/s/blog_48d491300100ztl9.html#saveFile)中的例程代码。
<pre class="lang:default decode:true ">private static final int CAPTURE_VIDEO_ACTIVITY_REQUEST_CODE =200;

private Uri fileUri;

@Override

public void onCreate(Bundle savedInstanceState){

  super.onCreate(savedInstanceState);

  setContentView(R.layout.main);

  //创建新的Intent

  intent new Intent(MediaStore.ACTION_VIDEO_CAPTURE);

  fileUri = getOutputMediaFileUri(MEDIA_TYPE_VIDEO);

  //创建保存视频的文件

  intent.putExtra(MediaStore.EXTRA_OUTPUT, fileUri);

  //设置视频文件名

  intent.putExtra(MediaStore.EXTRA_VIDEO_QUALITY,1);

  //设置视频的品质为高

  //启动视频捕获Intent

  startActivityForResult(intent, CAPTURE_VIDEO_ACTIVITY_REQUEST_CODE);

}</pre>
[startActivityForResult()](http://developer.android.com/reference/android/app/Activity.html#startActivityForResult(android.content.Intent,%20int)) 方法执行完毕后，用户将看到一个改动过的摄像程序界面。用户摄像完毕（或取消操作）后，用户界面返回应用程序，这时必须截获 [onActivityResult()](http://developer.android.com/reference/android/app/Activity.html#onActivityResult(int,%20int,%20android.content.Intent)) 方法来接收intent的返回结果并执行后续操作。关于如何接收完整的intent，请参阅下一节。

### 接受摄像头的结果

一旦已构建并运行了图像或视频的摄像头intent，应用程序就必须进行设置，以接收intent返回的结果。本节展示了如何 截获摄像头intent的回调方法，以便应用程序对捕获到的图片及视频进行进一步的处理。

要接收intent的返回结果，必须覆盖启动intent的activity中的 [onActivityResult()](http://developer.android.com/reference/android/app/Activity.html#onActivityResult(int,%20int,%20android.content.Intent))方法。以下例子演示了如何覆盖[onActivityResult()](http://developer.android.com/reference/android/app/Activity.html#onActivityResult(int,%20int,%20android.content.Intent))来获取上述章节例程中的 [图像捕获intent](http://blog.sina.com.cn/s/blog_48d491300100ztl9.html#intent_image)或 [视频捕获intent](http://blog.sina.com.cn/s/blog_48d491300100ztl9.html#intent_video)的结果。
<pre class="lang:default decode:true">private static final int CAPTURE_IMAGE_ACTIVITY_REQUEST_CODE = 100;

private static final int CAPTURE_VIDEO_ACTIVITY_REQUEST_CODE = 200;

@Override protected void onActivityResult(int requestCode, int resultCode,Intent data){

   if (requestCode==CAPTURE_IMAGE_ACTIVITY_REQUEST_CODE) {

       if (resultCode==RESULT_OK) {

           //捕获的图像保存到Intent指定的fileUri

           Toast..makeText(this,"Image saved to:\n"+

        data.getData(),Toast.LENGTH_LONG).show();

    }
        else if (resultCode==RESULT_CANCELED) {

         //用户取消了图像捕获

    else {
    //图像捕获失败，提示用户
    }
  }

   if(requestCode==CAPTURE_VIDEO_ACTIVITY_REQUEST_CODE) {

      if (resultCode==RESULT_OK) {

      //捕获的视频保存到Intent指定的fileUri

      Toast.makeText(this,"Video saved to:\n" +

        data.getData();

        Toast.LENGTH_LONG).show();
     }
        else  if (resultCode == RESULT_CANCELED) {
       //用户取消了视频捕获
    }
   else {
   //视频捕获失败，提示用户
    }
  }
}</pre>
一旦activity接收到成功的结果，就说明捕获到的图像或视频已保存到指定位置了，应用程序就可对其进行访问。

&nbsp;

**原文地址：[http://blog.sina.com.cn/s/blog_48d491300100ztl9.html](http://blog.sina.com.cn/s/blog_48d491300100ztl9.html)**
