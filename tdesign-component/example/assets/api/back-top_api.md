## API
### TBackTop
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| controller | ScrollController? | - | 页面滚动的控制器 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onPressed | VoidCallback? | - | 点击回调；`null` 表示禁用（A 类） |
| showText | bool | false | 是否展示文案 |
| visibilityOffset | double? | - | 滚动偏移 ≥ 阈值时才显示；未传时取 Theme `defaultVisibilityOffset` |
| tooltip | String? | - | 读屏 / Tooltip 提示文案 |
| colorScheme | TBackTopColorScheme? | - | 配色方案（light / dark）；未传时取 Theme |
| shape | TBackTopShape? | - | 形状（circle / halfCircle）；未传时取 Theme |


### TBackTopShape
#### 枚举值

| 名称 | 说明 |
| --- | --- |
| circle | 圆形返回顶部 |
| halfCircle | 半圆形返回顶部 |


### TBackTopColorScheme
#### 枚举值

| 名称 | 说明 |
| --- | --- |
| light | 明亮配色 |
| dark | 暗黑配色 |


### TBackTopThemeData
#### ThemeExtension 属性

| 字段 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| shape | TBackTopShape? | - | 默认形状 |
| colorScheme | TBackTopColorScheme? | - | 默认配色方案 |
| defaultVisibilityOffset | double? | - | 默认显示阈值；未传 `visibilityOffset` 时生效 |
| defaultRight | double? | - | 默认距屏幕右侧偏移 |
| defaultBottom | double? | - | 默认距屏幕底部偏移 |
| halfCircleRightInset | double? | - | 半圆形态右侧负 inset（吸收 0.2.x `right: -16`） |

#### 使用示例

```dart
// 全局注入
MaterialApp(
  theme: ThemeData(
    extensions: const [
      TBackTopThemeData(
        shape: TBackTopShape.circle,
        colorScheme: TBackTopColorScheme.light,
        defaultVisibilityOffset: 100,
      ),
    ],
  ),
)

// 子树注入
Theme(
  data: Theme.of(context).copyWith(
    extensions: [
      ...Theme.of(context).extensions.values,
      const TBackTopThemeData(shape: TBackTopShape.halfCircle),
    ],
  ),
  child: TBackTop(controller: scrollController, onPressed: () {}),
)
```

### v1.0 与 0.2.x API 对照

| 0.2.x | v1.0 | 说明 |
| --- | --- | --- |
| onClick | onPressed | 换名；`null` 表禁用 |
| style / TBackTopStyle | shape / TBackTopShape | 枚举改名；迁入 Theme |
| theme / TBackTopTheme | colorScheme / TBackTopColorScheme | 枚举改名；迁入 Theme |
| 手写 ScrollController.addListener | visibilityOffset | 内置显隐控制 |
| — | tooltip | 新增无障碍提示 |
| — | TBackTopThemeData | 新增 ThemeExtension |
