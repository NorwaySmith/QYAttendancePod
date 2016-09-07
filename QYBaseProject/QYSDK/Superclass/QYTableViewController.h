
/**
 * UITableViewController基础类
 */
#import <UIKit/UIKit.h>
#import "QYTheme.h"


@interface QYTableViewController : UITableViewController
/**
 * 开启网络监控后，无网络默认显示无网络view
 */
-(void)openNetworkMonitor;
/**
 *  显示无网络view
 */
-(void)showNoNetworkView;
/**
 *  隐藏无网络view
 */
-(void)hideNoNetworkView;
@end
