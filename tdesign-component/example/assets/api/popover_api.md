## API
### TPopover

气泡浮层。V1.0：`TPopoverTheme`→`TPopoverColorScheme`，`theme`→`colorScheme`，`overlayColor`→`barrierColor`，L4 padding/width/height/radius 迁入 `TPopoverThemeData`。

#### 静态方法

##### TPopover.showPopover

命令式入口（E 类），显示气泡浮层。

返回类型：`Future`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 上下文（E 类首参） |
| content | String? | - | 显示内容 |
| contentWidget | Widget? | - | 自定义内容 |
| colorScheme | TPopoverColorScheme? | - | 弹出气泡语义色（V1.0: 由 `theme` 改名） |
| placement | TPopoverPlacement? | - | 浮层出现位置 |
| showArrow | bool? | true | 是否显示浮层箭头 |
| offset | double | 4 | 偏移 |
| arrowSize | double | 8 | 箭头大小（V1.0: 默认值可由 TPopoverThemeData 注入） |
| closeOnClickOutside | bool | true | 点击蒙层是否关闭 |
| padding | EdgeInsetsGeometry? | - | 内容内边距（V1.0: 可由 TPopoverThemeData 注入） |
| width | double? | - | 内容宽度（V1.0: 可由 TPopoverThemeData 注入） |
| height | double? | - | 内容高度（V1.0: 可由 TPopoverThemeData 注入） |
| barrierColor | Color? | Colors.transparent | 蒙层色（V1.0: 由 `overlayColor` 改名；可由 TPopoverThemeData 注入） |
| radius | BorderRadius? | - | 圆角（V1.0: 可由 TPopoverThemeData 注入） |
| onTap | OnTap? | - | 点击事件 |
| onLongTap | OnLongTap? | - | 长按事件 |


### TPopoverColorScheme

气泡语义色枚举（V1.0: 由 `TPopoverTheme` 迁移，避免与 ThemeExtension 混淆）。

#### 枚举值

| 名称 | 说明 |
| --- | --- |
| dark | 暗色 |
| light | 亮色 |
| info | 品牌色 |
| success | 成功 |
| warning | 警告 |
| error | 错误 |


### TPopoverPlacement

浮层出现位置（12 向定位）。

#### 枚举值

| 名称 | 说明 |
| --- | --- |
| topLeft | 上左 |
| top | 上 |
| topRight | 上右 |
| rightTop | 右上 |
| right | 右 |
| rightBottom | 右下 |
| bottomRight | 下右 |
| bottom | 下 |
| bottomLeft | 下左 |
| leftBottom | 左下 |
| left | 左 |
| leftTop | 左上 |


### TPopoverThemeData

#### 简介
TPopover 组件级 ThemeExtension，控制子树的默认气泡样式。Material 对照：Overlay / Dialog 蒙层。通过 Theme 子树注入，单次 show 可破例覆盖。

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| colorScheme | TPopoverColorScheme? | - | 语义色（dark/light/info/success/warning/error） |
| backgroundColor | Color? | - | 气泡背景色 |
| padding | EdgeInsetsGeometry? | - | 内边距 |
| minWidth | double? | - | 最小宽度 |
| maxHeight | double? | - | 最大高度 |
| borderRadius | double? | - | 圆角 |
| barrierColor | Color? | - | 蒙层色（对应 Dialog.barrierColor） |
| arrowSize | double? | - | 箭头尺寸 |


### OnTap

#### 类型定义

```dart
typedef OnTap = Function(String? content);
```


### OnLongTap

#### 类型定义

```dart
typedef OnLongTap = Function(String? content);
```
