## API
### TFab
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String | '' | 图标 + 文字形态；非空时内嵌按钮为 round |
| icon | Widget? | Icon(Icons.add) | 图标 |
| child | Widget? | - | 自定义内容；有则替代内嵌 TButton |
| buttonProps | TButtonProps? | - | 内嵌 TButton 配置透传 |
| onPressed | VoidCallback? | - | 点击回调；null 时禁用 |
| tooltip | String? | - | 纯图标提示 |
| semanticLabel | String? | - | 读屏标签 |
| right | double? | 16 | 距屏幕右侧偏移 |
| bottom | double? | 32 | 距屏幕底部偏移 |
| draggable | bool \| TFabDragAxis | false | 拖拽轴向 |
| magnet | bool \| TFabMagnet | false | 拖拽结束吸附 |
| xBounds | TFabBounds? | - | 水平拖拽边界 |
| yBounds | TFabBounds? | - | 垂直拖拽边界 |
| onDragStart | TFabDragCallback? | - | 拖拽开始回调 |
| onDragEnd | TFabDragCallback? | - | 拖拽结束回调 |
| key | Key? | - | 组件标识 |


### TButtonProps
#### 构造参数

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| size | TButtonSize? | large | 按钮尺寸 |
| variant | TButtonVariant? | fill | 按钮变体 |
| colorScheme | TButtonColorScheme? | primary | 配色方案 |
| style | ButtonStyle? | - | P0 样式覆盖 |


### TFabDragAxis
#### 枚举值

| 名称 | 说明 |
| --- | --- |
| all | 全向拖拽 |
| vertical | 仅垂直 |
| horizontal | 仅水平 |


### TFabMagnet
#### 枚举值

| 名称 | 说明 |
| --- | --- |
| left | 吸附左侧 |
| right | 吸附右侧 |


### TFabBounds
#### 构造参数

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| start | double | - | 起点留白（水平: left，垂直: top） |
| end | double | - | 终点留白（水平: right，垂直: bottom） |


### TFabThemeData
#### 构造参数

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| defaultRight | double? | - | 默认右侧偏移 |
| defaultBottom | double? | - | 默认底部偏移 |
| defaultXBounds | TFabBounds? | - | 默认水平边界 |
| defaultYBounds | TFabBounds? | - | 默认垂直边界 |
| magnetAnimationDuration | Duration? | - | 吸附动画时长 |
| dragTapSlop | double? | - | 点击 vs 拖拽阈值 |


### TFabDragDetails
#### 属性

| 属性 | 类型 | 说明 |
| --- | --- | --- |
| position | Offset | 当前位置 |
| start | DragStartDetails? | 拖拽开始详情 |
| end | DragEndDetails? | 拖拽结束详情 |
