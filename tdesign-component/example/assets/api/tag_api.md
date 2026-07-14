## API
### TTag
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String | - | 标签内容 |
| colorScheme | TTagColorScheme? | - | 语义色 |
| icon | IconData? | - | 图标内容，可随状态改变颜色 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onCloseTap | GestureTapCallback? | - | 关闭图标点击事件 |
| size | TTagSize | TTagSize.medium | 标签大小 |


### TSelectTag
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String | - | 标签内容 |
| colorScheme | TTagColorScheme? | - | 语义色（选中时使用） |
| icon | IconData? | - | 图标内容，可随状态改变颜色 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onChanged | ValueChanged<bool>? | - | 选中状态变更回调；为 null 时禁用选择 |
| size | TTagSize | TTagSize.medium | 标签大小 |
| value | bool | - | 是否选中 |


### TTagSize
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| extraLarge | - |
| large | - |
| medium | - |
| small | - |
| custom | - |


### TTagShape
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| square | - |
| round | - |
| mark | - |
