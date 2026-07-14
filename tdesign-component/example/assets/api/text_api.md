## API
### TText

#### 工厂构造方法

##### TText.rich

富文本构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| textSpan | InlineSpan? | - | 透传至系统 `Text.rich` 的富文本片段 |
| font | Font? | - | 字体尺寸，包含 大小size 和 行高height |
| fontWeight | FontWeight? | - | 字体粗细 |
| fontFamily | FontFamily? | - | 字体ttf |
| textColor | Color? | - | 文本颜色 |
| backgroundColor | Color? | - | 背景颜色 |
| isTextThrough | bool? | false | 是否是横线穿过样式（删除线） |
| lineThroughColor | Color? | - | 删除线颜色，对应 TestStyle 的 decorationColor |
| package | String? | - | 字体包名 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| style | TextStyle? | - | 自定义的 TextStyle，其中指定的属性，将覆盖扩展的外层属性 |
| strutStyle | StrutStyle? | - | 透传至系统 `Text.strutStyle` 的段落支柱样式 |
| textAlign | TextAlign? | - | 透传至系统 `Text.textAlign` 的文本对齐方式 |
| textDirection | TextDirection? | - | 透传至系统 `Text.textDirection` 的文本方向 |
| locale | Locale? | - | 透传至系统 `Text.locale` 的区域设置 |
| softWrap | bool? | - | 透传至系统 `Text.softWrap`，控制是否自动换行 |
| overflow | TextOverflow? | - | 透传至系统 `Text.overflow` 的溢出处理方式 |
| textScaleFactor | double? | - | 文本缩放倍率，内部转换为系统 `Text.textScaler` |
| maxLines | int? | - | 透传至系统 `Text.maxLines` 的最大行数 |
| semanticsLabel | String? | - | 透传至系统 `Text.semanticsLabel` 的无障碍标签 |
| textWidthBasis | TextWidthBasis? | - | 透传至系统 `Text.textWidthBasis` 的宽度计算基准 |
| textHeightBehavior | ui.TextHeightBehavior? | - | 透传至系统 `Text.textHeightBehavior` 的高度行为 |
| forceVerticalCenter | bool | false | 是否强制居中 |
| isInFontLoader | bool | false | 是否在 FontLoader 中使用 |
| fontFamilyUrl | String? | - | 是否禁用懒加载 FontFamily 的能力 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| data | - | - | 透传至系统 `Text.data` 的文本内容 |
| backgroundColor | Color? | - | 背景颜色 |
| font | Font? | - | 字体尺寸，包含 大小size 和 行高height |
| fontFamily | FontFamily? | - | 字体ttf |
| fontFamilyUrl | String? | - | 是否禁用懒加载 FontFamily 的能力 |
| fontWeight | FontWeight? | - | 字体粗细 |
| forceVerticalCenter | bool | false | 是否强制居中 |
| isInFontLoader | bool | false | 是否在 FontLoader 中使用 |
| isTextThrough | bool? | false | 是否是横线穿过样式（删除线） |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| lineThroughColor | Color? | - | 删除线颜色，对应 TestStyle 的 decorationColor |
| locale | Locale? | - | 透传至系统 `Text.locale` 的区域设置 |
| maxLines | int? | - | 透传至系统 `Text.maxLines` 的最大行数 |
| overflow | TextOverflow? | - | 透传至系统 `Text.overflow` 的溢出处理方式 |
| package | String? | - | 字体包名 |
| semanticsLabel | String? | - | 透传至系统 `Text.semanticsLabel` 的无障碍标签 |
| softWrap | bool? | - | 透传至系统 `Text.softWrap`，控制是否自动换行 |
| strutStyle | StrutStyle? | - | 透传至系统 `Text.strutStyle` 的段落支柱样式 |
| style | TextStyle? | - | 自定义的 TextStyle，其中指定的属性，将覆盖扩展的外层属性 |
| textAlign | TextAlign? | - | 透传至系统 `Text.textAlign` 的文本对齐方式 |
| textColor | Color? | - | 文本颜色 |
| textDirection | TextDirection? | - | 透传至系统 `Text.textDirection` 的文本方向 |
| textHeightBehavior | ui.TextHeightBehavior? | - | 透传至系统 `Text.textHeightBehavior` 的高度行为 |
| textScaleFactor | double? | - | 文本缩放倍率，内部转换为系统 `Text.textScaler` |
| textWidthBasis | TextWidthBasis? | - | 透传至系统 `Text.textWidthBasis` 的宽度计算基准 |

#### 公开属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| textSpan | InlineSpan? | - | 透传至系统 `Text.rich` 的富文本片段 |


### TTextSpan
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| children | List<InlineSpan>? | - | - |
| context | BuildContext? | - | - |
| font | Font? | - | - |
| fontFamily | FontFamily? | - | - |
| fontWeight | FontWeight? | - | - |
| isTextThrough | bool? | false | - |
| lineThroughColor | Color? | - | - |
| mouseCursor | MouseCursor? | - | - |
| onEnter | PointerEnterEventListener? | - | - |
| onExit | PointerExitEventListener? | - | - |
| package | String? | - | - |
| recognizer | GestureRecognizer? | - | - |
| semanticsLabel | String? | - | - |
| style | TextStyle? | - | - |
| text | String? | - | - |
| textColor | Color? | - | - |


### TTextConfiguration
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget | - | - |
| globalFontFamily | FontFamily? | - | 全局字体族，设置后子树中所有 TText 将默认使用此字体 v1.0 变更：始终启用（删除 v0.2.x 的 kTextNeedGlobalFontFamily 全局开关）。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| paddingConfig | TTextPaddingConfig? | - | forceVerticalCenter=true 时，内置 padding 配置 |
