## API
### TNoticeBar
#### 简介
公告栏
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| content | dynamic | - | 文本内容（字符串或字符串数组等） |
| direction | Axis? | Axis.horizontal | 滚动方向 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| left | Widget? | - | 左侧内容（自定义左侧内容，优先级高于prefixIcon） |
| maxLines | int? | 1 | 文本行数（仅静态有效） |
| onPressed | ValueChanged? | - | 点击事件 |
| right | Widget? | - | 右侧内容（自定义右侧内容，优先级高于suffixIcon） |
