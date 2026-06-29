## API
### TToast

轻提示组件。V1.0：`TToastConfig`→`TToastThemeData`，`duration`（int 毫秒）→`Duration`，L4 色/字号/图标迁入 `TToastThemeData`。

#### 静态方法

##### TToast.dismissAll

关闭所有 Toast。

返回类型：`void`


##### TToast.dismissLoading

关闭加载 Toast（向后兼容）。

返回类型：`void`


##### TToast.dismissToast

关闭指定的 Toast。

返回类型：`void`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| toastId | String | - | Toast 标识 |


##### TToast.showFail

失败提示 Toast。

返回类型：`String`（toastId）

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 上下文（E 类首参） |
| text | String? | - | 文案 |
| direction | IconTextDirection | IconTextDirection.horizontal | 图标与文本排列方向 |
| duration | Duration | const Duration(milliseconds: 3000) | 展示时长（V1.0: 由 int 毫秒改为 Duration） |
| preventTap | bool? | - | 是否拦截点击穿透（V1.0: 可由 TToastThemeData 注入） |
| backgroundColor | Color? | - | 背景色（V1.0: 可由 TToastThemeData 注入） |
| maxLines | int? | - | 最大行数 |
| textStyle | TextStyle? | - | 文案样式（V1.0: 可由 TToastThemeData 注入） |
| iconSize | double? | - | 图标尺寸（V1.0: 可由 TToastThemeData 注入） |
| iconColor | Color? | - | 图标颜色（V1.0: 可由 TToastThemeData 注入） |
| toastId | String? | - | Toast 标识，传入则复用 |


##### TToast.showIconText

带图标的 Toast。

返回类型：`String`（toastId）

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 上下文 |
| text | String? | - | 文案 |
| icon | IconData? | - | 图标 |
| direction | IconTextDirection | IconTextDirection.horizontal | 图标与文本排列方向 |
| duration | Duration | const Duration(milliseconds: 3000) | 展示时长（V1.0: 由 int 毫秒改为 Duration） |
| preventTap | bool? | - | 是否拦截点击穿透 |
| backgroundColor | Color? | - | 背景色 |
| maxLines | int? | - | 最大行数 |
| textStyle | TextStyle? | - | 文案样式 |
| iconSize | double? | - | 图标尺寸 |
| iconColor | Color? | - | 图标颜色 |
| toastId | String? | - | Toast 标识 |


##### TToast.showLoading

带文案的加载 Toast。

返回类型：`String`（toastId）

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 上下文 |
| text | String? | - | 文案 |
| duration | Duration | const Duration(seconds: 99999999) | 展示时长（V1.0: 由 int 毫秒改为 Duration） |
| preventTap | bool? | - | 是否拦截点击穿透 |
| customWidget | Widget? | - | 自定义内容 |
| backgroundColor | Color? | - | 背景色 |
| textStyle | TextStyle? | - | 文案样式 |
| iconSize | double? | - | 图标尺寸 |
| iconColor | Color? | - | 图标颜色 |
| toastId | String? | - | Toast 标识 |


##### TToast.showLoadingWithoutText

不带文案的加载 Toast。

返回类型：`String`（toastId）

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 上下文 |
| duration | Duration | const Duration(seconds: 99999999) | 展示时长（V1.0: 由 int 毫秒改为 Duration） |
| preventTap | bool? | - | 是否拦截点击穿透 |
| backgroundColor | Color? | - | 背景色 |
| iconSize | double? | - | 图标尺寸 |
| iconColor | Color? | - | 图标颜色 |
| toastId | String? | - | Toast 标识 |


##### TToast.showSuccess

成功提示 Toast。

返回类型：`String`（toastId）

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 上下文 |
| text | String? | - | 文案 |
| direction | IconTextDirection | IconTextDirection.horizontal | 图标与文本排列方向 |
| duration | Duration | const Duration(milliseconds: 3000) | 展示时长（V1.0: 由 int 毫秒改为 Duration） |
| preventTap | bool? | - | 是否拦截点击穿透 |
| backgroundColor | Color? | - | 背景色 |
| maxLines | int? | - | 最大行数 |
| textStyle | TextStyle? | - | 文案样式 |
| iconSize | double? | - | 图标尺寸 |
| iconColor | Color? | - | 图标颜色 |
| toastId | String? | - | Toast 标识 |


##### TToast.showText

普通文本 Toast。

返回类型：`String`（toastId）

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 上下文 |
| text | String? | - | 文案 |
| duration | Duration | const Duration(milliseconds: 3000) | 展示时长（V1.0: 由 int 毫秒改为 Duration） |
| maxLines | int? | - | 最大行数 |
| constraints | BoxConstraints? | - | 约束 |
| preventTap | bool? | - | 是否拦截点击穿透 |
| customWidget | Widget? | - | 自定义内容 |
| backgroundColor | Color? | - | 背景色 |
| textStyle | TextStyle? | - | 文案样式 |
| toastId | String? | - | Toast 标识 |


##### TToast.showWarning

警告 Toast。

返回类型：`String`（toastId）

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 上下文 |
| text | String? | - | 文案 |
| direction | IconTextDirection | IconTextDirection.horizontal | 图标与文本排列方向 |
| duration | Duration | const Duration(milliseconds: 3000) | 展示时长（V1.0: 由 int 毫秒改为 Duration） |
| preventTap | bool? | - | 是否拦截点击穿透 |
| backgroundColor | Color? | - | 背景色 |
| maxLines | int? | - | 最大行数 |
| textStyle | TextStyle? | - | 文案样式 |
| iconSize | double? | - | 图标尺寸 |
| iconColor | Color? | - | 图标颜色 |
| toastId | String? | - | Toast 标识 |


### IconTextDirection

图标与文本排列方向。

#### 枚举值

| 名称 | 说明 |
| --- | --- |
| horizontal | 横向 |
| vertical | 竖向 |


### TToastThemeData

#### 简介
TToast 组件级 ThemeExtension，控制子树的默认轻提示样式。Material 对照：[SnackBarThemeData]。通过 Theme 子树注入，单次 show 可破例覆盖。V1.0: 由 `TToastConfig` 迁移。

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景色（对应 Material SnackBarThemeData.backgroundColor） |
| textStyle | TextStyle? | - | 文案样式（对应 Material SnackBarThemeData.textStyle） |
| iconSize | double? | - | 图标尺寸（TDesign 扩展） |
| iconColor | Color? | - | 图标颜色（TDesign 扩展） |
| preventTap | bool? | - | 是否拦截点击穿透默认 |
| defaultDuration | Duration? | - | 默认展示时长（对应 Material SnackBar.duration） |
| borderRadius | double? | - | 圆角（TDesign 扩展） |
| padding | EdgeInsetsGeometry? | - | 内边距（TDesign 扩展） |
| maxWidth | double? | - | 最大宽度（TDesign 扩展） |
