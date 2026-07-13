## API
### TRefreshHeader
#### 简介
TDesign刷新头部
结合EasyRefresh类实现下拉刷新,继承自Header类，字段含义与父类一致
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色（L4，可经 themeData 提供） |
| clamping | bool? | - | - |
| completeDuration | Duration? | - | 完成延时（L4，可经 themeData 提供） |
| enableHapticFeedback | bool | true | 开启震动反馈（保留实例，≠ 禁用） |
| enableInfiniteRefresh | bool | false | 是否开启无限刷新（保留实例，≠ 禁用） |
| extent | double? | 48.0 | Header容器高度（L4，可经 themeData 提供） |
| float | bool? | false | 是否悬浮（L4，可经 themeData 提供） |
| frictionFactor | - | - | - |
| hapticFeedback | bool? | - | - |
| hitOver | - | - | - |
| horizontalFrictionFactor | - | - | - |
| horizontalReadySpringBuilder | - | - | - |
| horizontalSpring | - | - | - |
| infiniteHitOver | bool? | - | - |
| infiniteOffset | double? | - | 无限刷新偏移量（L4，可经 themeData 提供） |
| key | Key? | - | Key |
| listenable | - | - | - |
| loadingIcon | TLoadingIcon? | TLoadingIcon.circle | loading样式（L4，可经 themeData 提供） |
| maxOverOffset | - | - | - |
| notifyWhenInvisible | - | - | - |
| overScroll | bool? | true | 越界滚动（L4，可经 themeData 提供） |
| position | - | - | - |
| processedDuration | Duration? | - | - |
| readySpringBuilder | - | - | - |
| safeArea | - | false | - |
| secondaryCloseTriggerOffset | - | - | - |
| secondaryDimension | - | - | - |
| secondaryTriggerOffset | - | - | - |
| secondaryVelocity | - | - | - |
| spring | - | - | - |
| springRebound | - | - | - |
| themeData | TRefreshThemeData? | - | 组件级主题配置，优先级高于 Theme Extension |
| triggerDistance | double? | 48.0 | 触发刷新任务的偏移量，同`triggerOffset`（L4，可经 themeData 提供） |
| triggerOffset | double? | - | - |
| triggerWhenReach | - | - | - |
| triggerWhenRelease | - | - | - |
| triggerWhenReleaseNoWait | - | - | - |


### TRefreshThemeData
#### 简介
TRefreshHeader 组件级 ThemeExtension，控制子树的下拉刷新默认样式。实例 `themeData` 优先于 Theme Extension。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色 |
| completeDuration | Duration? | - | 完成延时 |
| extent | double? | - | Header容器高度 |
| float | bool? | - | 是否悬浮 |
| infiniteOffset | double? | - | 无限刷新偏移量 |
| loadingIcon | TLoadingIcon? | - | loading样式 |
| overScroll | bool? | - | 越界滚动 |
| triggerDistance | double? | - | 触发刷新任务的偏移量 |
