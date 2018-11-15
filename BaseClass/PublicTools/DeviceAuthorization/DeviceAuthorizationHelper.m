//
//  DeviceAuthorizationHelper.m
//  HSRongyiBao
//
//  Created by 韩啸 on 2018/5/10.
//  Copyright © 2018年 hoomsun. All rights reserved.
//

#import "DeviceAuthorizationHelper.h"
#import "AuthorizationTool.h"
#import "HUD.h"

#define kButtonColor    [UIColor colorWithRed:255/255.0 green:211/255.0 blue:5/255.0 alpha:1.0]

static BOOL allowsEditing = YES;

typedef NS_ENUM(NSInteger, PhotoSelectionOption) {
    PhotoSelectionByAll,
    PhotoSelectionByPhotoLibrary,
    PhotoSelectionByShot
};



@interface DeviceAuthorizationHelper () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, copy) void (^photoSelectCompletion)(UIImage *image, BOOL isCancel);

@end



@implementation DeviceAuthorizationHelper

#pragma mark - Getter

- (UIImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}



#pragma mark - Initializer

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData{
    _pickerTitle = @"选择";
    _image       = nil;

//    _imagePicker = [[UIImagePickerController alloc] init];
//    _imagePicker.delegate = self;
}



#pragma mark - Func
+ (void)cameraIsNotAuthorizedAndShowAlertWithCompletion:(void (^)(BOOL needAlert))completion {
    NSString *title = @"提示";
    NSString *message = @"请打开相机访问权限";
    __block BOOL authorized;

    [AuthorizationTool requestCameraAuthorization:^(AuthorizationStatus status) {
        authorized = [self getAuthorizationBoolStatus:status];
        if (completion) {
            completion(!authorized);
        }

        if (authorized == NO) {
            [self showAlertControllerWithTitle:title message:message style:UIAlertControllerStyleAlert actionBlock:nil];
        }
    }];
}

+ (void)photoLibraryIsNotAuthorizedAndShowAlertWithCompletion:(void (^)(BOOL needAlert))completion {
    NSString *title = @"提示";
    NSString *message = @"请打开相册访问权限";
    __block BOOL authorized;

    [AuthorizationTool requestImagePickerAuthorization:^(AuthorizationStatus status) {
        authorized = [self getAuthorizationBoolStatus:status];
        if (completion) {
            completion(!authorized);
        }

        if (authorized == NO) {
            [self showAlertControllerWithTitle:title message:message style:UIAlertControllerStyleAlert actionBlock:nil];
        }
    }];
}

- (void)photoSelectionWithOption:(PhotoSelectionOption)option {
    switch (option) {
        case PhotoSelectionByAll:
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:_pickerTitle message:nil preferredStyle:UIAlertControllerStyleActionSheet];

            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancel];

            __weak typeof(self) weakself = self;
            UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [DeviceAuthorizationHelper photoLibraryIsNotAuthorizedAndShowAlertWithCompletion:^(BOOL needAlert) {
                    if (needAlert) {
                        return;
                    }
                    else {
                        weakself.imagePicker.sourceType    = UIImagePickerControllerSourceTypePhotoLibrary;
                        weakself.imagePicker.delegate      = weakself;
                        weakself.imagePicker.allowsEditing = weakself.allowsEditing;
                        weakself.imagePicker.navigationBar.tintColor = kButtonColor;
                        [weakself.superViewController presentViewController:weakself.imagePicker animated:YES completion:^(){
                            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
                        }];
                    }
                }];
            }];

            UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [DeviceAuthorizationHelper cameraIsNotAuthorizedAndShowAlertWithCompletion:^(BOOL needAlert) {
                    if (needAlert) {
                        return;
                    }
                    else {
                        weakself.imagePicker.sourceType    = UIImagePickerControllerSourceTypeCamera;
                        weakself.imagePicker.delegate      = weakself;
                        weakself.imagePicker.allowsEditing = weakself.allowsEditing;
                        weakself.imagePicker.navigationBar.tintColor = kButtonColor;
                        [weakself.superViewController presentViewController:weakself.imagePicker animated:YES completion:^(){
                            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
                        }];
                    }
                }];
            }];
            [alertController addAction:photoAction];
            [alertController addAction:cameraAction];

            [self.superViewController presentViewController:alertController animated:YES completion:nil];
        }
            break;

        case PhotoSelectionByPhotoLibrary:
        {
            [DeviceAuthorizationHelper photoLibraryIsNotAuthorizedAndShowAlertWithCompletion:^(BOOL needAlert) {
                if (needAlert) {
                    return;
                }
                else {
                    self.imagePicker.sourceType    = UIImagePickerControllerSourceTypePhotoLibrary;
                    self.imagePicker.delegate      = self;
                    self.imagePicker.allowsEditing = self.allowsEditing;
                    self.imagePicker.navigationBar.tintColor = kButtonColor;
                    [self.superViewController presentViewController:self.imagePicker animated:YES completion:^(){
                        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
                    }];
                }
            }];
        }
            break;

        case PhotoSelectionByShot:
        {
            [DeviceAuthorizationHelper cameraIsNotAuthorizedAndShowAlertWithCompletion:^(BOOL needAlert) {
                if (needAlert) {
                    return;
                }
                else {
                    self.imagePicker.sourceType    = UIImagePickerControllerSourceTypeCamera;
                    self.imagePicker.delegate      = self;
                    self.imagePicker.allowsEditing = self.allowsEditing;
                    self.imagePicker.navigationBar.tintColor = kButtonColor;
                    [self.superViewController presentViewController:self.imagePicker animated:YES completion:^(){
                        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
                    }];
                }
            }];
        }
            break;

        default:
            break;
    }
}

- (void)photoSelectionWithCompletion:(void (^)(UIImage *image, BOOL isCancel))completion {
    self.photoSelectCompletion = completion;
    [self photoSelectionWithOption:PhotoSelectionByAll];
}

- (void)photoFromShotWithCompletion:(void (^)(UIImage *image, BOOL isCancel))completion {
    self.photoSelectCompletion = completion;

    [self photoSelectionWithOption:PhotoSelectionByShot];
}

+ (void)locationIsNotAuthorizedAndShowAlertWithCompletion:(void (^)(BOOL needAlert, NSString *message))completion {
    __block NSString *message = nil;

    [AuthorizationTool requestLocationAuthorization:^(LocationAuthorizationStatus status) {
        if (status == LocationAuthorizationStatusNotDetermined ||
            status == LocationAuthorizationStatusAuthorizedAlways) {
            if (completion) {
                completion(NO, nil);
            }
            return;
        }
        else if (status == LocationAuthorizationStatusAuthorizedWhenInUse) {
            if (completion) {
                completion(YES, nil);
            }
            message = @"您需要修改定位权限为“始终”，才能持续定位并记录您的行车路径";
        }
        else if (status == LocationAuthorizationStatusDenied ||
                 status == LocationAuthorizationStatusRestricted) {
            if (completion) {
                completion(YES, nil);
            }
            message = @"您需要开启定位访问权限";
        }
        else if (status == LocationAuthorizationStatusNotSuppot) {
            if (completion) {
                completion(YES, @"该设备不支持定位");
            }
            return;
        }

        [self showAlertControllerWithTitle:@"提示" message:message style:UIAlertControllerStyleAlert actionBlock:nil];
    }];
}



#pragma mark - ImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [HUD show];

    UIImage *image = nil;
    if (allowsEditing) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
        if (image == nil) {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
    }
    else {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (image == nil) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        }
    }

    _image = image;

    if (!image) {
        NSLog(@"image error");
    }

    if ([self.delegate respondsToSelector:@selector(imageDidChooseFinished:)]) {
        [self.delegate imageDidChooseFinished:image];
    }

    __weak typeof(self) weakself = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        if (weakself.photoSelectCompletion) {
            weakself.photoSelectCompletion([image copy], NO);
        }

        weakself.imagePicker.delegate = nil;
        weakself.imagePicker = nil;
        weakself.photoSelectCompletion = nil;
        [HUD dismiss];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([self.delegate respondsToSelector:@selector(imageDidChooseCancel)]) {
        [self.delegate imageDidChooseCancel];
    }

    if (self.photoSelectCompletion) {
        self.photoSelectCompletion(nil, YES);
    }

    __weak typeof(self) weakself = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        weakself.imagePicker.delegate = nil;
        weakself.imagePicker = nil;
        weakself.photoSelectCompletion = nil;
    }];
}




#pragma mark - Private Func

+ (NSString *)bundleID {
    return [[NSBundle mainBundle] bundleIdentifier];
}

+ (BOOL)getAuthorizationBoolStatus:(AuthorizationStatus)status {
    if (status == AuthorizationStatusAuthorized) {
        return YES;
    }
    return NO;
}

+ (void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message style:(UIAlertControllerStyle)style actionBlock:(void(^ __nullable)(BOOL confirm))actionBlock{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancel];

    // 确认按钮
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (actionBlock) {
            actionBlock(YES);
        }

        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];

        if (@available(iOS 10, *)) {
            if (@available(iOS 10.0, *)) {
                if( [[UIApplication sharedApplication] canOpenURL:url] ) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
            }
        } else {
            if( [[UIApplication sharedApplication] canOpenURL:url] ) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }];
    [alertController addAction:confirm];

    __kindof UIViewController *vc = [self currentViewController];
    [vc presentViewController:alertController animated:YES completion:nil];
}


/// 获取当前VC
+ (UIViewController *)currentViewController {
    // Find best view controller
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findBestViewController:viewController];
}

+ (UIViewController *)findBestViewController:(UIViewController *)vc {
    if (vc.presentedViewController) {
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}

@end



@implementation DeviceAuthorizationPhone

+ (void)call:(NSString *)phone
  completion:(void (^)(BOOL finished, NSString *errorMessage))completion {
    if (!phone) {
        if (completion) {
            completion(NO, @"电话号码不存在");
        }
        return;
    }

    NSString *phoneUrlStr = [NSString stringWithFormat:@"tel://%@", phone];
    NSURL *url = [NSURL URLWithString:phoneUrlStr];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] openURL:url];
            if (completion) {
                completion(YES, nil);
            }
        });
    }
    else {
        if (completion) {
            completion(NO, @"该设备无法拨打电话");
        }
    }
}

@end

