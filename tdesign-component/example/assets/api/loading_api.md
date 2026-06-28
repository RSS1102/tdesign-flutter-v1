## API
### TLoading
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| icon | TLoadingIcon? | TLoadingIcon.circle | 图标，支持圆形、点状、菊花状 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| size | TLoadingSize | - | 尺寸 |
| text | String? | - | 文案 |
| themeData | TLoadingThemeData? | - | 组件级主题配置，优先级高于 Theme Extension |


### TLoadingSize
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| small | 小尺寸 |
| medium | 中尺寸 |
| large | 大尺寸 |


### TLoadingIcon
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| circle | 圆形 |
| point | 点状 |
| activity | 菊花状 |


### TLoadingThemeData
#### 简介
TLoading 组件级 ThemeExtension，控制子树的默认加载样式。实例 `themeData` 优先于 Theme Extension。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| axis | Axis? | - | 文案和图标相对方向 |
| customIcon | Widget? | - | 自定义图标，优先级高于 icon |
| duration | int? | - | 一次刷新的时间（毫秒），控制动画速度 |
| iconColor | Color? | - | 图标颜色 |
| refreshWidget | Widget? | - | 失败刷新组件 |
| textColor | Color? | - | 文案颜色 |
