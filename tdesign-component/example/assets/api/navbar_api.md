## API
### TNavBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| actions | List<TNavBarItem>? | - | 右侧操作项（对齐 AppBar.actions） |
| backIconColor | Color? | - | 返回图标颜色（可覆盖 Theme） |
| backgroundColor | Color? | - | 背景颜色（可覆盖 Theme） |
| belowTitleWidget | Widget? | - | NavBar 下方的 Widget |
| border | TNavBarBorder? | - | 操作项边框配置（可覆盖 Theme） |
| boxShadow | List<BoxShadow>? | - | 底部阴影（可覆盖 Theme） |
| centerTitle | bool | true | 标题是否居中 |
| flexibleSpace | Widget? | - | 固定背景 Widget |
| height | double? | - | 高度（可覆盖 Theme，默认 48） |
| key | Key? | - | 组件标识 |
| leading | List<TNavBarItem>? | - | 左侧操作项（对齐 AppBar.leading） |
| onBack | VoidCallback? | - | 返回事件；`null` 禁用返回 |
| opacity | double? | - | 透明度（可覆盖 Theme，默认 1.0） |
| padding | EdgeInsetsGeometry? | - | 内部填充（可覆盖 Theme） |
| title | String? | - | 标题文案 |
| titleColor | Color? | - | 标题颜色（可覆盖 Theme） |
| titleFont | Font? | - | 标题字体尺寸（可覆盖 Theme） |
| titleFontFamily | FontFamily? | - | 标题字体样式（可覆盖 Theme） |
| titleFontWeight | FontWeight? | - | 标题字体粗细（可覆盖 Theme） |
| titleMargin | double? | - | 中间文案左右间距（可覆盖 Theme） |
| titleWidget | Widget? | - | 标题控件，优先级高于 title 文案 |
| useBorderStyle | bool? | - | 是否使用边框模式（可覆盖 Theme） |
| useDefaultBack | bool | true | 是否使用默认返回按钮 |


### TNavBarThemeData
#### ThemeExtension 属性

| 字段 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| titleColor | Color? | - | 默认标题颜色 |
| backIconColor | Color? | - | 默认返回图标颜色 |
| titleFont | Font? | - | 默认标题字体尺寸 |
| titleFontWeight | FontWeight? | - | 默认标题字体粗细 |
| titleFontFamily | FontFamily? | - | 默认标题字体样式 |
| backgroundColor | Color? | - | 默认背景颜色 |
| height | double? | - | 默认高度 |
| padding | EdgeInsetsGeometry? | - | 默认内部填充 |
| titleMargin | double? | - | 默认标题左右间距 |
| opacity | double? | - | 默认透明度 |
| useBorderStyle | bool? | - | 默认是否使用边框模式 |
| border | TNavBarBorder? | - | 默认操作项边框配置 |
| boxShadow | List<BoxShadow>? | - | 默认底部阴影 |

#### 使用示例

```dart
// 全局注入
MaterialApp(
  theme: ThemeData(
    extensions: const [
      TNavBarThemeData(
        height: 56,
        backgroundColor: Colors.white,
        titleFontWeight: FontWeight.w600,
      ),
    ],
  ),
)

// 子树注入
Theme(
  data: Theme.of(context).copyWith(
    extensions: [
      ...Theme.of(context).extensions.values,
      TNavBarThemeData(
        titleColor: Colors.white,
        backgroundColor: Colors.blue,
      ),
    ],
  ),
  child: TNavBar(title: '页面标题'),
)
```


### TNavBarItem
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| action | TBarItemAction? | - | 操作回调；`null` 禁用 |
| customWidget | Widget? | - | 自定义组件，优先级高于 icon |
| icon | IconData? | - | 图标 |
| iconColor | Color? | - | 图标颜色 |
| iconSize | double? | 24.0 | 图标尺寸 |
| iconWidget | Widget? | - | 图标组件（已废弃，建议用 customWidget） |
| padding | EdgeInsetsGeometry? | - | 内部填充 |


### TBarItemAction
#### 类型定义

```dart
typedef TBarItemAction = void Function();
```


### v1.0 与 0.2.x API 对照

| 0.2.x | v1.0 | 说明 |
| --- | --- | --- |
| leftBarItems | leading | 对齐 AppBar 命名 |
| rightBarItems | actions | 对齐 AppBar 命名 |
| screenAdaptation | — | 废弃：外层手动处理安全区域 |
| TNavBarItemBorder | TNavBarBorder | 改名；迁入 ThemeData |
| titleColor / backIconColor / ... | TNavBarThemeData | 13 个 L4 样式 → Theme |
| — | TNavBarThemeData | 新增 ThemeExtension |
