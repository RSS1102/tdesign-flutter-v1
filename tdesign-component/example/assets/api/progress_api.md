## API
### TProgress
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| label | TLabelWidget? | - | 进度条标签 |
| onPressed | VoidCallback? | - | 点击事件 |
| value | double? | - | 进度值（0.0 到 1.0 之间的正数） |
| variant | TProgressVariant | - | 进度条形态 |


### TProgressVariant
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| linear | - |
| circular | - |
| micro | - |
| button | - |


### TProgressLabelPosition
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| inside | - |
| left | - |
| right | - |
