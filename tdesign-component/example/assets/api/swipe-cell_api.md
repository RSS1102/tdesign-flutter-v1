## API
### TSwipeCell

滑动单元格组件。V1.0：`onChange`→`onChanged`，`disabled`→`enabled: false`，L4 字段（slidableKey/cell/opened/groupTag/closeWhenOpened/closeWhenTapped/dragStartBehavior/duration）迁入 `TSwipeCellThemeData`。

#### 静态方法

##### TSwipeCell.close

根据 `groupTag` 关闭 `TSwipeCell`。`current` 保留当前不关闭。

返回类型：`void`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| tag | Object? | - | 组标识 |
| current | SlidableController? | - | 保留当前不关闭 |


##### TSwipeCell.of

获取上下文最近的 `controller`。

返回类型：`SlidableController?`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 上下文 |


#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| cell | Widget | - | 单元格（通常为 `TCell`） |
| left | TSwipeCellPanel? | - | 左侧滑动操作项面板 |
| right | TSwipeCellPanel? | - | 右侧滑动操作项面板 |
| controller | SlidableController? | - | 自定义控制滑动窗口 |
| direction | Axis? | Axis.horizontal | 可拖动的方向 |
| enabled | bool? | false | 是否启用滑动（V1.0: 由 `disabled` 改名，禁用用 `enabled: false`） |
| onChanged | Function(TSwipeDirection direction, bool open)? | - | 滑动展开事件（V1.0: 由 `onChange` 改名） |
| slidableKey | Key? | - | 滑动组件的 Key（V1.0: 可由 TSwipeCellThemeData 注入） |
| opened | List<bool>? | const [false, false] | 默认打开，[left, right]（V1.0: 可由 TSwipeCellThemeData 注入） |
| groupTag | Object? | - | 组，配置后 `closeWhenOpened`、`closeWhenTapped` 才起作用（V1.0: 可由 TSwipeCellThemeData 注入） |
| closeWhenOpened | bool? | true | 同一组中一个打开时是否关闭其他（V1.0: 可由 TSwipeCellThemeData 注入） |
| closeWhenTapped | bool? | true | 同一组中被点击时是否关闭其他（V1.0: 可由 TSwipeCellThemeData 注入） |
| dragStartBehavior | DragStartBehavior? | DragStartBehavior.start | 拖动开始行为（V1.0: 可由 TSwipeCellThemeData 注入） |
| duration | Duration? | const Duration(milliseconds: 200) | 打开关闭动画时长（V1.0: 可由 TSwipeCellThemeData 注入） |
| key | Key? | - | 组件标识 |


### TSwipeDirection

#### 枚举值

| 名称 | 说明 |
| --- | --- |
| right | 向右 |
| left | 向左 |


### TSwipeCellThemeData

#### 简介
TSwipeCell 组件级 ThemeExtension，控制子树的默认滑动单元格样式。Material 对照：flutter_slidable 包装。通过 Theme 子树注入，实例字段优先于 Theme Extension。

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| slidableKey | Key? | - | 滑动组件的 Key |
| opened | List<bool>? | - | 默认打开，[left, right] |
| groupTag | Object? | - | 组标识 |
| closeWhenOpened | bool? | - | 同组打开时是否关闭其他 |
| closeWhenTapped | bool? | - | 同组点击时是否关闭其他 |
| dragStartBehavior | DragStartBehavior? | - | 拖动开始行为 |
| duration | Duration? | - | 打开关闭动画时长 |
