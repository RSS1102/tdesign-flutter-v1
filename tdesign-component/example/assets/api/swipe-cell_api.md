## API
### TSwipeCell
#### 简介
滑动单元格组件

#### 静态方法

##### TSwipeCell.close

根据groupTag关闭`TSwipeCell`
current：保留当前不关闭

返回类型：`void`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| tag | Object? | - | - |
| current | SlidableController? | - | - |


##### TSwipeCell.of

获取上下文最近的`controller`

返回类型：`SlidableController?`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | - |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| cell | Widget | - | 单元格 `TCell` |
| controller | SlidableController? | - | 自定义控制滑动窗口 |
| direction | Axis? | Axis.horizontal | 可拖动的方向 |
| enabled | bool | true | 是否启用滑动（默认 true，false 表示禁用） |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| left | TSwipeCellPanel? | - | 左侧滑动操作项面板 |
| onChanged | Function(TSwipeDirection direction, bool open)? | - | 滑动展开事件 |
| right | TSwipeCellPanel? | - | 右侧滑动操作项面板 |


### TSwipeDirection
#### 简介
滑动方向
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| right | - |
| left | - |
