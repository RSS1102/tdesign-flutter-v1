## API
### TSideBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| children | List<TSideBarItem> | const [] | 单项 |
| contentPadding | EdgeInsetsGeometry? | - | 自定义文本框内边距（优先级高于 ThemeData） |
| controller | TSideBarController? | - | 控制器 |
| height | double? | - | 高度（优先级高于 ThemeData） |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| loading | bool? | - | 加载效果 |
| loadingWidget | Widget? | - | 自定义加载动画 |
| onChanged | ValueChanged<int>? | - | 选中值发生变化（Controller控制） |
| onSelected | ValueChanged<int>? | - | 选中值发生变化（点击事件） |
| selectedBgColor | Color? | - | 选择的背景颜色（优先级高于 ThemeData） |
| selectedColor | Color? | - | 选中值后颜色（优先级高于 ThemeData） |
| selectedTextStyle | TextStyle? | - | 选中样式（优先级高于 ThemeData） |
| style | TSideBarVariant? | - | 样式（优先级高于 ThemeData） |
| unSelectedBgColor | Color? | - | 未选择的背景颜色（优先级高于 ThemeData） |
| unSelectedColor | Color? | - | 未选中颜色（优先级高于 ThemeData） |
| value | int? | - | 选项值 |
