# WeChatPlugin

## 功能列表

* 防撤回
* 每日汇报功能  （可用于报平安 ╮(╯▽╰)╭）


## 原理

根据 [老汉](https://github.com/imoldman) 的 [wechatNoRevoke](https://github.com/imoldman/wechatNoRevoke) 实现。 

更复杂的做法可以参考 [XcodeAppPluginTemplate](https://github.com/AlayshChen/XcodeAppPluginTemplate)

## 使用方法

* 打开 `WeChatPlugin.xcodeproj` 进行编译得到 `libWeChatPlugin.dylib`
* 将 `libWeChatPlugin.dylib` 和 `wechat.sh` 放在相同目录
* 运行 `wechat.sh` 启动微信
* 如果有需要可以通过 `Automator` 制作一个执行 `wechat.sh` 的 App 并开机启动

## 说明

* 只对 Mac 版本微信起效
* 如果在收到原始消息前，消息已被撤回本插件不起效
* 这个插件严重依赖于微信本身 API，对应 API 发生变化将导致插件失效或崩溃