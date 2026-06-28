## API
### TSideBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| children | List<TSideBarItem> | const [] | 单项 |
| contentPadding | EdgeInsetsGeometry? | - | 自定义文本框内边距（可覆盖 Theme） |
| controller | TSideBarController? | - | 控制器 |
| height | double? | - | 高度（可覆盖 Theme） |
| key | Key? | - | 组件标识 |
| loading | bool? | - | 加载效果 |
| loadingWidget | Widget? | - | 自定义加载动画 |
| onChanged | ValueChanged<int>? | - | 选中值发生变化（Controller控制） |
| onSelected | ValueChanged<int>? | - | 选中值发生变化（点击事件） |
| selectedBgColor | Color? | - | 选择的背景颜色（可覆盖 Theme） |
| selectedColor | Color? | - | 选中值后颜色（可覆盖 Theme） |
| selectedTextStyle | TextStyle? | - | 选中样式（可覆盖 Theme） |
| style | TSideBarStyle? | - | 样式（可覆盖 Theme，v1.0 改为可选） |
| themeData | TSideBarThemeData? | - | 子树级主题数据（v1.0 新增） |
| unSelectedBgColor | Color? | - | 未选择的背景颜色（可覆盖 Theme） |
| unSelectedColor | Color? | - | 未选中颜色（可覆盖 Theme） |
| value | int? | - | 选项值（v1.0 删除 defaultValue，合并到 value） |


### TSideBarItem
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| badge | TBadge? | - | 徽标 |
| disabled | bool | false | 是否禁用 |
| icon | IconData? | - | 图标 |
| key | Key? | - | 组件标识 |
| label | String | '' | 标签 |
| textStyle | TextStyle? | - | 标签样式 |
| value | int | -1 | 值 |


### TSideBarStyle
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| normal | 普通样式 |
| outline | 轮廓样式 |


### TSideBarThemeData
#### 简介
侧边栏组件 ThemeExtension，管理子树级默认样式（v1.0 新增）
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| style | TSideBarStyle? | - | 默认样式 |
| height | double? | - | 默认高度 |
| contentPadding | EdgeInsetsGeometry? | - | 默认内边距 |
| selectedColor | Color? | - | 默认选中颜色 |
| unSelectedColor | Color? | - | 默认未选中颜色 |
| selectedTextStyle | TextStyle? | - | 默认选中文字样式 |
| selectedBgColor | Color? | - | 默认选中背景颜色 |
| unSelectedBgColor | Color? | - | 默认未选中背景颜色 |
