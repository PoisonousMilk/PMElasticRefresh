# PMElasticRefresh
[![LICENSE](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/PoisonousMilk/PMElasticRefresh/blob/master/License)&nbsp;
[![BLOG](https://img.shields.io/badge/blog-ayjkdev.top-orange.svg)](http://ayjkdev.top/)&nbsp;

完善后详细的实现会更新在[博客](http://ayjkdev.top/)上。

Use elastic animation to make refresh more funny.

# Installtion
Download and run the Demo. When we make the `PMElasticRefresh` move perfected, We will support [CocoaPods](https://cocoapods.org/). 

# Usage
Import header file:
```objc
#import "PMElasticRefresh.h"
```

Inital and use `pm_RefreshHeader` to add refresh header
```objc
self.mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
[self.mainTableView pm_RefreshHeader];
[self.view addSubview:self.mainTableView];
```

End refresh
```objc
[self.mainTableView endRefresh];
```

# Changelog

v 0.0.1 first commit

# Licence
PMElasticRefresh is provided under the MIT license. See LICENSE file for details.	

=================
# 中文介绍
使用弹性动画让刷新变的更有趣。

# 安装
下载并运行这个Demo。当我们把`PMElasticRefresh`变的更完善的时候，会发布到[CocoaPods](https://cocoapods.org/)上。

# 使用
导入头文件:
```objc
#import "PMElasticRefresh.h"
```

初始化并调用`pm_RefreshHeader`来加上刷新头
```objc
self.mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
[self.mainTableView pm_RefreshHeader];
[self.view addSubview:self.mainTableView];
```

结束刷新
```objc
[self.mainTableView endRefresh];
```

# 版本更新

v 0.0.1 首次提交

# 许可证

PMElasticRefresh 使用 MIT 许可证，详情见 LICENSE 文件。	