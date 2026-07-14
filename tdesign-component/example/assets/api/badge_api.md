## API
### TBadge
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| variant | TBadgeVariant | - | 红点形态 |
| count | String? | - | 红点数量 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| maxCount | String? | '99' | 最大红点数量 |
| size | TBadgeSize | TBadgeSize.small | 红点尺寸 |


### TBadgeVariant
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| redPoint | 红点样式 |
| message | 消息样式 |
| bubble | 气泡样式 |
| square | 方形样式 |
| subscript | 角标样式 |


### TBadgeBorder
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| large | 大圆角 8px |
| small | 小圆角 2px |


### TBadgeSize
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| large | 宽 20px |
| small | 宽 16px |
