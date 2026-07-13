## API
### TTabBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | tabBar背景色，当variant为card时控制选中tab颜色（可覆盖 Theme） |
| controller | TabController? | - | tab控制器 |
| decoration | Decoration? | - | tabBar修饰（可覆盖 Theme） |
| dividerColor | Color? | - | 分割线颜色（可覆盖 Theme） |
| dividerHeight | double | 0.5 | 分割线高度，小于等于0则不展示分割线 |
| height | double? | - | tabBar高度（可覆盖 Theme） |
| indicator | Decoration? | - | 自定义引导控件（可覆盖 Theme） |
| indicatorColor | Color? | - | tabBar下标颜色（可覆盖 Theme） |
| indicatorHeight | double? | - | tabBar下标高度（可覆盖 Theme） |
| indicatorPadding | EdgeInsets? | - | 引导padding（可覆盖 Theme） |
| indicatorWidth | double? | - | tabBar下标宽度（可覆盖 Theme） |
| isScrollable | bool | false | 是否滚动（可覆盖 Theme） |
| key | Key? | - | 组件标识 |
| labelColor | Color? | - | tabBar 已选标签颜色（可覆盖 Theme） |
| labelPadding | EdgeInsetsGeometry? | - | tab间距（可覆盖 Theme） |
| labelStyle | TextStyle? | - | 已选label字体（可覆盖 Theme） |
| onTap | Function(int)? | - | 点击事件 |
| physics | ScrollPhysics? | - | 自定义滑动（可覆盖 Theme） |
| selectedBgColor | Color? | - | 被选中背景色，只有variant为capsule时有效（可覆盖 Theme） |
| showIndicator | bool | false | 是否展示引导控件 |
| tabAlignment | TabAlignment? | - | 对齐方式（可覆盖 Theme） |
| tabs | List<TTab> | - | tab数组 |
| unSelectedBgColor | Color? | - | 未选中背景色，只有variant为capsule时有效（可覆盖 Theme） |
| unselectedLabelColor | Color? | - | tabBar未选标签颜色（可覆盖 Theme） |
| unselectedLabelStyle | TextStyle? | - | unselectedLabel字体（可覆盖 Theme） |
| variant | TTabBarVariant | TTabBarVariant.filled | 选项卡样式（v1.0 由 outlineType 改名，可覆盖 Theme） |
| width | double? | - | tabBar宽度 |


### TTab
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| badge | TBadge? | - | 徽标 |
| child | Widget? | - | 子widget |
| contentHeight | double? | - | 中间内容高度（可覆盖 Theme） |
| enabled | bool | true | 是否可用，默认true；`false` 即禁用（v1.0 由 enable 改名） |
| height | double? | - | tab高度（可覆盖 Theme） |
| icon | Widget? | - | 图标 |
| iconMargin | EdgeInsetsGeometry | const EdgeInsets.only(bottom: 4.0, right: 4.0) | 图标间距（可覆盖 Theme） |
| key | Key? | - | 组件标识 |
| size | TTabSize | TTabSize.small | 选项卡尺寸 |
| text | String? | - | 文字内容 |
| textMargin | EdgeInsetsGeometry? | - | 文本边距（可覆盖 Theme） |


### TTabBarView
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| children | List<Widget> | - | 子widget列表 |
| controller | TabController? | - | 控制器 |
| key | Key? | - | 组件标识 |
| physics | ScrollPhysics? | - | 滑动物理特性；未传时取 Theme defaultPhysics，Theme 也未配时默认不可滑动（v1.0 由 isSlideSwitch 改名） |


### TTabBarVariant
#### 简介
选项卡样式（v1.0 新增，替代 TTabBarOutlineType/TTabOutlineType）
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| filled | 填充样式 |
| capsule | 胶囊样式 |
| card | 卡片 |


### TTabSize
#### 简介
选项卡尺寸
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| large | 大尺寸 |
| small | 小尺寸 |


### TTabBarThemeData
#### 简介
TabBar 组件 ThemeExtension，管理子树级默认样式（v1.0 新增）
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 默认背景颜色 |
| variant | TTabBarVariant? | - | 默认选项卡样式 |
| height | double? | - | 默认高度 |
| indicatorColor | Color? | - | 默认下标颜色 |
| indicatorHeight | double? | - | 默认下标高度 |
| indicatorWidth | double? | - | 默认下标宽度 |
| labelColor | Color? | - | 默认已选标签颜色 |
| unselectedLabelColor | Color? | - | 默认未选标签颜色 |
| labelStyle | TextStyle? | - | 默认已选字体 |
| unselectedLabelStyle | TextStyle? | - | 默认未选字体 |
| isScrollable | bool? | - | 默认是否滚动 |
| labelPadding | EdgeInsetsGeometry? | - | 默认tab间距 |
| indicatorPadding | EdgeInsets? | - | 默认引导padding |
| indicator | Decoration? | - | 默认自定义引导控件 |
| showIndicator | bool? | - | 默认是否展示引导控件 |
| physics | ScrollPhysics? | - | 默认滑动特性（TTabBar） |
| defaultPhysics | ScrollPhysics? | - | 默认滑动特性（TTabBarView） |
| dividerColor | Color? | - | 默认分割线颜色 |
| dividerHeight | double? | - | 默认分割线高度 |
| selectedBgColor | Color? | - | 默认选中背景色 |
| unSelectedBgColor | Color? | - | 默认未选中背景色 |
| tabAlignment | TabAlignment? | - | 默认对齐方式 |
| iconMargin | EdgeInsetsGeometry? | - | 默认图标间距（TTab） |
| textMargin | EdgeInsetsGeometry? | - | 默认文本边距（TTab） |
| contentHeight | double? | - | 默认中间内容高度（TTab） |
| decoration | Decoration? | - | 默认修饰 |
