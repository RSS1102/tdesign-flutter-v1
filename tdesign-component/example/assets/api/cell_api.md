## API
### TCell
#### 简介
单元格组件
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| arrow | bool? | false | 是否显示右侧箭头 |
| bordered | bool? | true | 是否显示下边框，仅在TCellGroup组件下起作用 |
| image | ImageProvider? | - | 主图 |
| imageCircle | double? | 50 | 主图圆角，默认50（圆形） |
| imageSize | double? | - | 主图尺寸 |
| imageWidget | Widget? | - | 主图组件 |
| note | String? | - | 和标题同行的说明文字 |
| noteMaxLine | int | 1 | 说明文字组件 最大行数 |
| noteMaxWidth | double? | - | 说明文字组件 最大宽度，超过部分显示省略号，防止文字溢出 |
| noteWidget | Widget? | - | 说明文字组件 |
| onLongPress | GestureLongPressCallback? | - | 长按事件 |
| onTap | GestureTapCallback? | - | 点击事件（为 null 时禁用交互） |
| prefix | IconData? | - | 左侧图标，出现在单元格标题的左侧 |
| prefixWidget | Widget? | - | 左侧图标组件 |
| required | bool? | false | 是否显示表单必填星号 |
| rightIcon | IconData? | - | 最右侧图标 |
| rightIconWidget | Widget? | - | 最右侧图标组件 |
| style | TCellThemeData? | - | 自定义样式（ThemeExtension） |
| subtitle | String? | - | 下方内容描述文字 |
| subtitleWidget | Widget? | - | 下方内容描述组件 |
| title | String? | - | 标题 |
| titleWidget | Widget? | - | 标题组件 |
