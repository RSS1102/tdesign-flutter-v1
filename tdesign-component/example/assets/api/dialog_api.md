## API
### TDialogButtonOptions

弹窗按钮配置。

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| title | String | - | 标题内容 |
| onPressed | Function()? | - | 点击操作 |
| titleColor | Color? | - | 标题颜色 |
| titleSize | double? | - | 字体大小 |
| style | ButtonStyle? | - | 按钮样式（V1.0: 改用 ButtonStyle 替代 TButtonStyle） |
| type | TButtonVariant? | - | 按钮变体类型 |
| colorScheme | TButtonColorScheme? | - | 按钮配色方案（V1.0: 由 `theme` 改名） |
| height | double? | - | 按钮高度，建议使用默认高度 |
| fontWeight | FontWeight? | - | 字体粗细 |


### TConfirmDialog

只有一个按钮的弹窗控件，按钮样式支持普通和文字。

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| onPressed | Function()? | - | 点击回调 |
| backgroundColor | Color? | - | 背景颜色（V1.0: 可由 TDialogThemeData 注入） |
| radius | double | 12.0 | 圆角（V1.0: 可由 TDialogThemeData 注入） |
| title | String? | - | 标题 |
| titleColor | Color? | - | 标题颜色（V1.0: 可由 TDialogThemeData 注入） |
| titleAlignment | AlignmentGeometry? | - | 标题对齐模式 |
| contentWidget | Widget? | - | 内容 Widget |
| content | String? | - | 内容 |
| contentColor | Color? | - | 内容颜色（V1.0: 可由 TDialogThemeData 注入） |
| contentMaxHeight | double | 0 | 内容最大高度，0 表示不限制 |
| buttonText | String? | - | 按钮文字 |
| buttonTextColor | Color? | - | 按钮文字颜色 |
| buttonStyle | TDialogButtonStyle | TDialogButtonStyle.normal | 按钮样式 |
| showCloseButton | bool? | - | 显示右上角关闭按钮 |
| padding | EdgeInsets? | const EdgeInsets.fromLTRB(24, 32, 24, 0) | 内容内边距（V1.0: 可由 TDialogThemeData 注入） |
| buttonWidget | Widget? | - | 自定义按钮 |
| width | double? | - | 弹窗宽度（V1.0: 可由 TDialogThemeData 注入） |
| buttonStyleCustom | ButtonStyle? | - | 按钮自定义样式属性 |


### TDialogButtonStyle

#### 枚举值

| 名称 | 说明 |
| --- | --- |
| normal | 普通样式 |
| text | 文字样式 |


### TDialogThemeData

#### 简介
TDialog 组件级 ThemeExtension，控制子树的默认对话框样式。通过 Theme 子树注入，实例字段优先于 Theme Extension。Material 对照：[DialogThemeData]。

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景色（对应 Material DialogThemeData.backgroundColor） |
| shape | ShapeBorder? | - | 形状/圆角（对应 Material DialogThemeData.shape） |
| elevation | double? | - | 阴影（对应 Material DialogThemeData.elevation） |
| barrierColor | Color? | - | 蒙层色（对应 showDialog 的 barrierColor） |
| titleTextStyle | TextStyle? | - | 标题文案样式（对应 Material DialogThemeData.titleTextStyle） |
| contentTextStyle | TextStyle? | - | 内容文案样式（对应 Material DialogThemeData.contentTextStyle） |
| contentPadding | EdgeInsetsGeometry? | - | 内容内边距（TDesign 扩展） |
| contentMaxHeight | double? | - | 内容最大高度，0 表示不限制（TDesign 扩展） |
| actionButtonStyle | ButtonStyle? | - | 按钮区样式（对应 Material TextButtonThemeData） |
| width | double? | - | 弹窗宽度 |

#### 方法

##### merge

合并两个 ThemeExtension，`other` 优先于 `this`。

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| other | TDialogThemeData? | 待合并的 ThemeExtension |

返回类型：`TDialogThemeData`

##### copyWith

生成副本并覆盖指定字段。

返回类型：`TDialogThemeData`

##### lerp

线性插值（ThemeExtension 实现）。

返回类型：`TDialogThemeData`
