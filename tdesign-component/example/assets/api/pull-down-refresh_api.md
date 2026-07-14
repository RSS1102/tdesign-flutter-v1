## API
### TRefreshHeader
#### 简介
TDesign刷新头部
结合EasyRefresh类实现下拉刷新,继承自Header类，字段含义与父类一致
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | - |
| clamping | bool? | - | - |
| completeDuration | Duration? | - | - |
| enableHapticFeedback | bool | true | 开启震动反馈（保留实例，≠ 禁用） |
| enableInfiniteRefresh | bool | false | 是否开启无限刷新（保留实例，≠ 禁用） |
| extent | double? | - | - |
| float | bool? | - | - |
| frictionFactor | - | - | - |
| hapticFeedback | bool? | - | - |
| hitOver | - | - | - |
| horizontalFrictionFactor | - | - | - |
| horizontalReadySpringBuilder | - | - | - |
| horizontalSpring | - | - | - |
| infiniteHitOver | bool? | - | - |
| infiniteOffset | double? | - | - |
| key | Key? | - | Key |
| listenable | - | - | - |
| loadingIcon | TLoadingIcon? | - | - |
| maxOverOffset | - | - | - |
| notifyWhenInvisible | - | - | - |
| overScroll | bool? | - | - |
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
| triggerDistance | double? | - | - |
| triggerWhenReach | - | - | - |
| triggerWhenRelease | - | - | - |
| triggerWhenReleaseNoWait | - | - | - |

#### 公开属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| finalBackgroundColor | Color? | - | 背景颜色（从 themeData 或参数合并后的最终值） |
| finalCompleteDuration | Duration? | - | 完成延时（从 themeData 或参数合并后的最终值） |
| finalExtent | double | - | Header容器高度（从 themeData 或参数合并后的最终值） |
| finalFloat | bool | - | 是否悬浮（从 themeData 或参数合并后的最终值） |
| finalLoadingIcon | TLoadingIcon | - | loading样式（从 themeData 或参数合并后的最终值） |
| finalOverScroll | bool | - | 越界滚动（从 themeData 或参数合并后的最终值） |
| finalTriggerDistance | double | - | 触发刷新任务的偏移量（从 themeData 或参数合并后的最终值） |
