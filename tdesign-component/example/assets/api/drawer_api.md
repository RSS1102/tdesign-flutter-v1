## API
### TDrawer
#### 简介
抽屉组件
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 上下文 |
| child | Widget? | - | 自定义内容，优先级高于`items`/`footer`/`title`（v1.0 由 `contentWidget` 改名） |
| backgroundColor | Color? | - | 组件背景颜色（优先级高于 ThemeData） |
| bordered | bool? | true | 是否显示边框（优先级高于 ThemeData） |
| closeOnOverlayClick | bool? | true | 点击蒙层时是否关闭抽屉 |
| drawerTop | double? | - | 距离顶部的距离 |
| footer | Widget? | - | 抽屉的底部 |
| hover | bool? | true | 是否开启点击反馈（优先级高于 ThemeData） |
| isShowLastBordered | bool? | true | 是否显示最后一行分割线（优先级高于 ThemeData） |
| items | List<TDrawerItem>? | - | 抽屉里的列表项 |
| onClose | VoidCallback? | - | 关闭时触发 |
| onItemClick | TDrawerItemClickCallback? | - | 点击抽屉里的列表项触发 |
| placement | TDrawerPlacement? | TDrawerPlacement.right | 抽屉方向 |
| showOverlay | bool? | true | 是否显示遮罩层 |
| style | TCellStyle? | - | 列表自定义样式（优先级高于 ThemeData） |
| title | String? | - | 抽屉的标题 |
| titleWidget | Widget? | - | 抽屉的标题组件 |
| visible | bool? | - | 组件是否可见 |
| width | double? | 280 | 宽度（优先级高于 ThemeData） |
| themeData | TDrawerThemeData? | - | 子树级主题数据（v1.0 新增） |


### TDrawerWidget
#### 简介
抽屉内容组件
可用于 Scaffold 中的 drawer 属性
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget? | - | 自定义内容，优先级高于`items`/`footer`/`title`（v1.0 由 `contentWidget` 改名） |
| backgroundColor | Color? | - | 组件背景颜色 |
| bordered | bool? | true | 是否显示边框 |
| footer | Widget? | - | 抽屉的底部 |
| hover | bool? | true | 是否开启点击反馈 |
| isShowLastBordered | bool? | true | 是否显示最后一行分割线 |
| items | List<TDrawerItem>? | - | 抽屉里的列表项 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onItemClick | TDrawerItemClickCallback? | - | 点击抽屉里的列表项触发 |
| style | TCellStyle? | - | 列表自定义样式 |
| title | String? | - | 抽屉的标题 |
| titleWidget | Widget? | - | 抽屉的标题组件 |
| width | double? | 280 | 宽度 |


### TDrawerItem
#### 简介
抽屉里的列表项
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| content | Widget? | - | 完全自定义 |
| icon | Widget? | - | 每列图标 |
| title | String? | - | 每列标题 |


### TDrawerPlacement
#### 简介
抽屉方向
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| left | - |
| right | - |


### TDrawerThemeData
#### 简介
抽屉组件 ThemeExtension，管理子树级默认样式（v1.0 新增）
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| width | double? | - | 默认宽度 |
| backgroundColor | Color? | - | 默认背景颜色 |
| bordered | bool? | - | 是否默认显示边框 |
| isShowLastBordered | bool? | - | 是否默认显示最后一行分割线 |
| hover | bool? | - | 是否默认开启点击反馈 |
| style | TCellStyle? | - | 默认列表自定义样式 |


### TDrawerItemClickCallback
#### 类型定义

```dart
typedef TDrawerItemClickCallback = void Function(int index, TDrawerItem item);
```
