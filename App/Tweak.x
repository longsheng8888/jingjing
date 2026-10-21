#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

// 读取设置
NSDictionary* getSettings() {
    return [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.xiaolong.grab.plist"] ?: @{};
}

// 挂钩货拉拉的推送方法
%hook HLLHallOrderProvider

- (void)orderNewBatchPushTask:(id)task {
    %orig;
    NSDictionary *prefs = getSettings();
    if (![prefs[@"enabled"] boolValue]) return;
    // 这里放置你原本的推送日志或逻辑
    NSLog(@"[小龙生] 收到推送任务");
}

- (id)convertOrderModelsWithJson:(id)json {
    id result = %orig;
    NSDictionary *prefs = getSettings();
    if (![prefs[@"enabled"] boolValue]) return result;
    
    int minFee = [prefs[@"minFee"] intValue] ?: 7;
    int maxDist = [prefs[@"maxDist"] intValue] ?: 5;
    
    // 在这里处理订单遍历，如果达标就调用抢单
    NSLog(@"[小龙生] 订单数据更新，当前阈值: %d元 %dkm", minFee, maxDist);
    
    return result;
}

%end
