
#import <UIKit/UIKit.h>

//#import "AppDelegate.h"
//#import "JFBaseViewController.h"
//@class Appdelegate;

typedef enum{
    GestureViewControllerTypeSetting = 1,
    GestureViewControllerTypeLogin
}GestureViewControllerType;

typedef enum{
    buttonTagReset = 1,
    buttonTagManager,
    buttonTagForget,
    buttonTagSkip
    
}buttonTag;

@interface GestureViewController :UIViewController


/**
 *  控制器来源类型
 */
@property (nonatomic, assign) GestureViewControllerType type;

@property (nonatomic, strong) UIViewController *currentViewController;

@end
