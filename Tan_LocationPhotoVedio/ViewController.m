//
//  ViewController.m
//  Tan_LocationPhotoVedio
//
//  Created by PX_Mac on 16/5/7.  
//  Copyright © 2016年 PX_Mac. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgView; //显示拍照的照片

@property (strong, nonatomic) UIImagePickerController *picker;
@property (assign, nonatomic) BOOL isChange; //是否切换拍照和录制视频
@property (assign, nonatomic) NSInteger currentTag; //当前tag

@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;//视频播放控制器
@property (nonatomic, strong) NSURL *movieUrl; //视频录制路径
@property (nonatomic, strong) UIView *movieView; //播放器的View

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

//初始化picker
- (UIImagePickerController *)picker{
    if (_isChange || _picker == nil){
        _picker = [[UIImagePickerController alloc]init];
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;//设置image picker的来源
        _picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;//设置使用哪个摄像头，这里设置为后置摄像头
        
        if (self.currentTag == 1) { //录制视频
            _picker.mediaTypes = @[(NSString *)kUTTypeMovie];
            _picker.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
            _picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;//设置摄像头模式（拍照，录制视频）
            //NSLog(@"录制视频");
        }
        else{ //拍照
            _picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            //移除视频播放器控件
            if (self.moviePlayer != nil){
                [self.movieView removeFromSuperview];
                self.moviePlayer = nil;
            }
        }
        _picker.allowsEditing=YES;//允许编辑
        _picker.delegate=self;//设置代理，检测操作
    }
    return _picker;
}

//视频播放器
-(MPMoviePlayerController *)moviePlayer{
    if (!_moviePlayer) {
        _moviePlayer = [MPMoviePlayerController new];
        _moviePlayer.view.frame = self.imgView.frame;
        _moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.movieView = _moviePlayer.view;
        [self.view addSubview:self.movieView];
    }
    _moviePlayer.contentURL = self.movieUrl;
    
    return _moviePlayer;
}

//拍照和视频录制: tag = 0表示拍照，= 1表示录制视频
- (IBAction)openVideo:(UIButton *)sender {
    
    if (self.currentTag != sender.tag) self.isChange = YES;
    
    self.currentTag = sender.tag;
    
    [self presentViewController:self.picker animated:YES completion:nil];
}

#pragma mark - 代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {//当是拍照时
        UIImage *image;
        //如果允许编辑则获得编辑后的照片，否则获取原始照片
        if (self.picker.allowsEditing) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];//获取编辑后的照片
        }else{
            image = [info objectForKey:UIImagePickerControllerOriginalImage];//获取原始照片
        }
        [self.imgView setImage:image];//显示照片
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//保存相片到相簿
    }
    else if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){//当是录制视频时
        
        NSURL *url=[info objectForKey:UIImagePickerControllerMediaURL];//视频路径
        NSString *urlStr=[url path];
        
        //         //保存视频到相簿
        //        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
        //            UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, nil, nil);//保存视频到相簿
        //        }
        self.movieUrl =[NSURL fileURLWithPath:urlStr];
        [self.moviePlayer play];
    }
    
    // 关闭照片选择器
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //NSLog(@"取消....");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
