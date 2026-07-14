## API
### TCollapse
#### 简介
折叠面板列表组件，需配合 `TCollapsePanel` 使用
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| animationDuration | Duration | kThemeAnimationDuration | 折叠面板列表的动画时长 |
| children | List<TCollapsePanel> | - | 折叠面板列表的子组件 |
| elevation | double | 0 | 折叠面板列表的阴影 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| mode | TCollapseMode | TCollapseMode.multiple | 折叠面板模式 |
| onChanged | ValueChanged<Object?>? | - | 手风琴模式下 value 变更回调 |
| onExpansionChanged | ExpansionPanelCallback? | - | 折叠面板列表的回调函数； 回调时，入参为当前点击的折叠面板的索引 index 和是否展开的状态 isExpanded |
| value | Object? | - | 手风琴模式下当前展开面板的 value |


### TCollapseMode
#### 简介
折叠面板模式
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| multiple | 多开模式 |
| accordion | 手风琴模式（仅一个面板展开） |
