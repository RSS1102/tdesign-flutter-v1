## API
### TText

#### 工厂构造方法

##### TText.rich

富文本构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| textSpan | InlineSpan? | - | - |
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
| strutStyle | StrutStyle? | - | - |
| textAlign | TextAlign? | - | - |
| textDirection | TextDirection? | - | - |
| locale | Locale? | - | - |
| softWrap | bool? | - | - |
| overflow | TextOverflow? | - | - |
| textScaleFactor | double? | - | - |
| maxLines | int? | - | - |
| semanticsLabel | String? | - | - |
| textWidthBasis | TextWidthBasis? | - | - |
| textHeightBehavior | ui.TextHeightBehavior? | - | - |
| forceVerticalCenter | bool | false | 是否强制居中 |
| isInFontLoader | bool | false | 是否在 FontLoader 中使用 |
| fontFamilyUrl | String? | - | 是否禁用懒加载 FontFamily 的能力 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| data | - | - | 以下系统 text 属性，释义请参考系统 `Text` 中注释 |
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
| locale | Locale? | - | - |
| maxLines | int? | - | - |
| overflow | TextOverflow? | - | - |
| package | String? | - | 字体包名 |
| semanticsLabel | String? | - | - |
| softWrap | bool? | - | - |
| strutStyle | StrutStyle? | - | - |
| style | TextStyle? | - | 自定义的 TextStyle，其中指定的属性，将覆盖扩展的外层属性 |
| textAlign | TextAlign? | - | - |
| textColor | Color? | - | 文本颜色 |
| textDirection | TextDirection? | - | - |
| textHeightBehavior | ui.TextHeightBehavior? | - | - |
| textScaleFactor | double? | - | - |
| textWidthBasis | TextWidthBasis? | - | - |

#### 公开属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| textSpan | InlineSpan? | - | - |


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
| globalFontFamily | FontFamily? | - | 全局字体族（v1.0 始终生效，不再依赖全局开关） |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| paddingConfig | TTextPaddingConfig? | - | forceVerticalCenter=true 时，内置 padding 配置 |

### TTextThemeData（v1.0 新增）

组件级 ThemeExtension，通过 `Theme.of(context).mergeExtension()` 子树注入。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| defaultFont | Font? | - | 默认字体（含字号和行高） |
| defaultTextColor | Color? | - | 默认文本颜色 |
| defaultBackgroundColor | Color? | - | 默认背景色 |
| forceVerticalCenter | bool | false | 默认是否启用强制垂直居中（替代 v0.2.x 全局变量） |
| isTextThrough | bool | false | 默认删除线 |
| lineThroughColor | Color? | - | 删除线默认颜色 |
| isInFontLoader | bool | false | 是否处于字体加载器中 |
| strutStyle | StrutStyle? | - | 默认 strut 样式 |
| textWidthBasis | TextWidthBasis? | - | 默认文本宽度计算方式 |
| textHeightBehavior | ui.TextHeightBehavior? | - | 默认文本高度行为 |
| textScaleFactor | double? | - | 默认缩放因子 |

### TTextResolve（v1.0 新增）

样式解析器，提供 `resolve()`（TText 用）和 `resolveSpan()`（TTextSpan 用）两个入口，
合并 v0.2.x 双份 getTextStyle 为单一路径。包含 iOS PingFang SC 回退和 globalFontFamily 注入逻辑。
