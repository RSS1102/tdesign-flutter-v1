## API
### TLink
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget? | - | 链接内容，一般是 Text |
| color | Color? | - | 自定义链接文本颜色（覆盖 colorScheme 计算色） |
| colorScheme | TLinkColorScheme? | TLinkColorScheme.primary | 语义颜色方案 |
| fontSize | double? | - | 自定义字体大小 |
| iconSize | double? | - | 自定义图标尺寸 |
| key | Key? | - | 组件标识 |
| leftGapWithIcon | double? | - | 前置图标与文本间距 |
| onPressed | VoidCallback? | - | 点击回调。为 null 时链接为禁用态 |
| prefixIcon | Widget? | - | 前置图标（仅在 variant 为 TLinkType.icon 时生效） |
| rightGapWithIcon | double? | - | 后置图标与文本间距 |
| semanticLabel | String? | - | 语义标签（无障碍） |
| size | TLinkSize | TLinkSize.medium | 链接尺寸 |
| suffixIcon | Widget? | - | 后置图标（仅在 variant 为 TLinkType.icon 时生效） |
| tooltip | String? | - | 悬浮提示 |
| uri | Uri? | - | 跳转 URI |
| variant | TLinkType | TLinkType.basic | 链接形态 |


### TLinkType
#### 枚举值

| 名称 | 说明 |
| --- | --- |
| basic | 纯文本链接 |
| underline | 下划线链接 |
| icon | 带图标链接（通过 prefixIcon / suffixIcon 区分前后） |


### TLinkColorScheme
#### 枚举值

| 名称 | 说明 |
| --- | --- |
| primary | 主要（品牌色） |
| defaultTheme | 默认（正文色） |
| danger | 危险（错误色） |
| warning | 警告色 |
| success | 成功色 |


### TLinkSize
#### 枚举值

| 名称 | 说明 |
| --- | --- |
| small | 小号（字号 12，图标 14） |
| medium | 中号（字号 14，图标 16） |
| large | 大号（字号 16，图标 18） |


### TLinkThemeData
#### ThemeExtension

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| defaultVariant | TLinkType? | 默认链接形态 |
| defaultSize | TLinkSize? | 默认尺寸 |
| defaultColorScheme | TLinkColorScheme? | 默认语义色 |
| color | Color? | 链接文本颜色 |
| iconSize | double? | 图标尺寸 |
| fontSize | double? | 文本字号 |
| leftGapWithIcon | double? | 前置图标与文本间距 |
| rightGapWithIcon | double? | 后置图标与文本间距 |


### TLinkConfiguration
#### InheritedWidget

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| onTapAll | void Function(Uri? uri)? | 统一跳转回调 |
| child | Widget | 子树 |
