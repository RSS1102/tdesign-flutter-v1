## API
### TDivider
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| layout | TDividerLayout? | horizontal | 横/竖分割线 |
| align | TDividerAlign? | center | 中间内容在线条中的位置（仅 horizontal 生效） |
| dashed | bool? | false | 是否为虚线（仅 horizontal 生效） |
| child | Widget? | - | 中间子元素（替代 0.2.x 的 text + widget 双通道） |
| key | Key? | - | 组件标识 |


### TDividerLayout
#### 枚举值

| 名称 | 说明 |
| --- | --- |
| horizontal | 水平分割线 |
| vertical | 垂直分割线 |


### TDividerAlign
#### 枚举值

| 名称 | 说明 |
| --- | --- |
| left | 中间内容靠左 |
| center | 中间内容居中 |
| right | 中间内容靠右 |


### TDividerThemeData
#### 构造参数

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| color | Color? | - | 线条颜色 |
| thickness | double? | 0.5 | 线粗：横线 = 高度，竖线 = 宽度 |
| margin | EdgeInsetsGeometry? | - | 外边距 |
| gapPadding | EdgeInsetsGeometry? | EdgeInsets.symmetric(horizontal: 8) | 线与中间内容间距 |
| textStyle | TextStyle? | - | child 为文本时的默认样式 |
| indent | double? | - | 左缩进（对齐 Material DividerTheme） |
| endIndent | double? | - | 右缩进（对齐 Material DividerTheme） |

**注入方式**：
```dart
// 子树注入
Theme(
  data: Theme.of(context).copyWith(
    extensions: [
      TDividerThemeData(color: Colors.red, thickness: 2),
    ],
  ),
  child: ...
)

// mergeExtension 注入
context.theme.mergeExtension(TDividerThemeData(dashed: true))
```
