## API
### TMessage

消息通知组件。V1.0：`MessageTheme`→`TMessageVariant`，`theme`→`variant`，`duration`（int 毫秒）→`Duration`，`offset`（List<double>）→`Offset?`，L4 色/圆角/阴影迁入 `TMessageThemeData`。

#### 静态方法

##### TMessage.showMessage

命令式入口（E 类），显示消息通知。

返回类型：`void`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 上下文（E 类首参） |
| content | String? | - | 通知内容 |
| variant | TMessageVariant? | - | 消息语义色（V1.0: 由 `theme` 改名） |
| duration | Duration? | - | 展示时长（V1.0: 由 int 毫秒改为 Duration） |
| closeBtn | dynamic | - | 关闭按钮 |
| icon | dynamic | - | 自定义消息前面的图标 |
| link | dynamic | - | 链接名称 |
| marquee | TMessageMarquee? | - | 跑马灯效果 |
| offset | Offset? | - | 相对于 placement 的偏移量（V1.0: 由 List<double> 改为 Offset） |
| onCloseBtnClick | VoidCallback? | - | 点击关闭按钮触发 |
| onDurationEnd | VoidCallback? | - | 计时结束后触发 |
| onLinkClick | VoidCallback? | - | 点击链接文本时触发 |
| visible | bool? | - | 是否显示 |


#### 默认构造方法

声明式构造（辅路径）；推荐使用 `showMessage`。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| content | String? | - | 通知内容 |
| variant | TMessageVariant? | TMessageVariant.info | 消息语义色（V1.0: 由 `theme` 改名） |
| duration | Duration? | - | 展示时长（V1.0: 由 int 毫秒改为 Duration） |
| closeBtn | dynamic | - | 关闭按钮 |
| icon | dynamic | true | 自定义消息前面的图标 |
| link | dynamic | - | 链接名称 |
| marquee | TMessageMarquee? | - | 跑马灯效果 |
| offset | Offset? | - | 相对于 placement 的偏移量（V1.0: 由 List<double> 改为 Offset） |
| onCloseBtnClick | VoidCallback? | - | 点击关闭按钮触发 |
| onDurationEnd | VoidCallback? | - | 计时结束后触发 |
| onLinkClick | VoidCallback? | - | 点击链接文本时触发 |
| visible | bool? | true | 是否显示 |
| key | Key? | - | 组件标识 |


### TMessageMarquee

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| delay | int? | - | 延迟时间（毫秒） |
| loop | int? | - | 循环次数 |
| speed | int? | - | 速度 |


### TMessageLink

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| name | String | - | 名称 |
| color | Color? | - | 颜色 |
| uri | Uri? | - | 资源链接 |


### TMessageVariant

消息语义色枚举（V1.0: 由 `MessageTheme` 迁移）。

#### 枚举值

| 名称 | 说明 |
| --- | --- |
| info | 普通通知 |
| success | 成功通知 |
| warning | 警示通知 |
| error | 错误通知 |


### TMessageThemeData

#### 简介
TMessage 组件级 ThemeExtension，控制子树的默认消息样式。Material 对照：[SnackBarThemeData]。通过 Theme 子树注入，单次 show 可破例覆盖。

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景色（对应 Material SnackBarThemeData.backgroundColor） |
| shape | ShapeBorder? | - | 形状（对应 Material SnackBarThemeData.shape） |
| elevation | double? | - | 阴影（对应 Material SnackBarThemeData.elevation） |
| defaultOffset | Offset? | - | 默认顶栏偏移（TDesign 扩展） |
| defaultMarquee | bool? | - | 默认跑马灯配置（TDesign 扩展） |
