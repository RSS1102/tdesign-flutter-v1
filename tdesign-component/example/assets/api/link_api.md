## API
### TLink
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget? | - | 链接内容，一般是 `Text` |
| colorScheme | TLinkColorScheme? | - | 语义颜色方案，未传时使用 Theme `TLinkThemeData.defaultColorScheme` |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onPressed | VoidCallback? | - | 点击回调。为 null 时链接为禁用态 |
| prefixIcon | Widget? | - | 前置图标（仅在 `variant` 为 `TLinkVariant.icon` 时生效） |
| semanticLabel | String? | - | 语义标签（无障碍） |
| size | TLinkSize? | - | 尺寸，未传时使用 Theme `TLinkThemeData.defaultSize` |
| suffixIcon | Widget? | - | 后置图标（仅在 `variant` 为 `TLinkVariant.icon` 时生效） |
| tooltip | String? | - | 悬浮提示 |
| uri | Uri? | - | 跳转 URI |
| variant | TLinkVariant? | - | 链接形态，未传时使用 Theme `TLinkThemeData.defaultVariant` |


### TLinkThemeData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| defaultColorScheme | TLinkColorScheme? | - | 未传链接 colorScheme 时的默认语义色 |
| defaultSize | TLinkSize? | - | 未传链接 size 时的默认尺寸 |
| defaultVariant | TLinkVariant? | - | 未传链接 variant 时的默认链接形态 |
| fontSize | double? | - | 文本字号 |
| iconSize | double? | - | 图标尺寸 |
| leftGapWithIcon | double? | - | 前置图标与文本间距 |
| rightGapWithIcon | double? | - | 后置图标与文本间距 |


### TLinkVariant
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
| primary | 品牌主色链接 |
| defaultTheme | 默认文本色链接 |
| danger | 危险操作链接 |
| warning | 警告提示链接 |
| success | 成功状态链接 |


### TLinkSize
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| small | 小尺寸链接 |
| medium | 中尺寸链接 |
| large | 大尺寸链接 |
