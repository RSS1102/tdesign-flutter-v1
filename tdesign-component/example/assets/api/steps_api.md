## API
### TSteps
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| activeIndex | int | 0 | 步骤条当前激活的索引（v1.0 推荐使用 value） |
| value | int? | - | 步骤条当前激活的索引（v1.0 新增，优先级高于 activeIndex） |
| direction | TStepsDirection | TStepsDirection.horizontal | 步骤条方向 |
| key | Key? | - | 组件标识 |
| readOnly | bool | false | 步骤条readOnly模式（可覆盖 Theme） |
| simple | bool | false | 步骤条simple模式（可覆盖 Theme） |
| status | TStepsStatus | TStepsStatus.success | 步骤条状态（可覆盖 Theme） |
| steps | List<TStepsItemData> | - | 步骤条数据 |
| verticalSelect | bool | false | 步骤条垂直自定义步骤条选择模式（可覆盖 Theme） |
| themeData | TStepsThemeData? | - | 子树级主题数据（v1.0 新增） |


### TStepsItemData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| content | String? | - | 内容 |
| customContent | Widget? | - | 自定义内容 |
| customTitle | Widget? | - | 自定义标题 |
| errorIcon | IconData? | - | 失败图标 |
| successIcon | IconData? | - | 成功图标 |
| title | String? | - | 标题 |


### TStepsDirection
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| horizontal | 水平 |
| vertical | 垂直 |


### TStepsStatus
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| success | 成功 |
| error | 错误 |


### TStepsThemeData
#### 简介
步骤条组件 ThemeExtension，管理子树级默认样式（v1.0 新增）
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| status | TStepsStatus? | - | 默认步骤条状态 |
| simple | bool? | - | 默认 simple 模式 |
| readOnly | bool? | - | 默认 readOnly 模式 |
| verticalSelect | bool? | - | 默认垂直选择模式 |
