## API
### TDropdownMenu

下拉菜单容器。V1.0：菜单栏容器样式参数（width/height/decoration/arrowIcon/arrowColor/tabBarAlign/duration/isScrollable）迁入 `TDropdownThemeData`，通过 Theme 子树注入。

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| items | List<TDropdownItem>? | - | 下拉菜单项列表 |
| builder | TDropdownItemBuilder? | - | 下拉菜单构建器，优先级高于 `items` |
| closeOnClickOverlay | bool? | true | 是否在点击遮罩层后关闭菜单 |
| direction | TDropdownMenuDirection? | TDropdownMenuDirection.auto | 菜单展开方向（down、up、auto） |
| showOverlay | bool? | true | 是否显示遮罩层 |
| onMenuClosed | ValueChanged<int>? | - | 关闭菜单事件 |
| onMenuOpened | ValueChanged<int>? | - | 展开菜单事件 |
| labelBuilder | LabelBuilder? | - | 自定义标签内容 |
| key | Key? | - | 组件标识 |
| width | double? | - | menu 的宽度（V1.0: 可由 TDropdownThemeData 注入） |
| height | double? | - | menu 的高度（V1.0: 可由 TDropdownThemeData 注入） |
| decoration | Decoration? | - | 下拉菜单的装饰器（V1.0: 可由 TDropdownThemeData 注入） |
| arrowIcon | IconData? | - | 自定义箭头图标（V1.0: 可由 TDropdownThemeData 注入） |
| arrowColor | Color? | - | 自定义箭头颜色（V1.0: 可由 TDropdownThemeData 注入） |
| tabBarAlign | MainAxisAlignment? | MainAxisAlignment.center | label 与 arrowIcon 的对齐方式（V1.0: 可由 TDropdownThemeData 注入） |
| duration | double? | 200.0 | 动画时长，毫秒（V1.0: 可由 TDropdownThemeData 注入） |
| isScrollable | bool? | false | 是否开启滚动列表（V1.0: 可由 TDropdownThemeData 注入） |


### TDropdownItem

下拉菜单内容项。受控组件：`value` + `onChanged`；禁用用 `onChanged: null`。

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| label | String? | - | 标题 |
| options | List<TDropdownItemOption>? | const [] | 选项数据 |
| onChanged | ValueChanged<T?>? | - | 值改变时触发（V1.0: 由 `onChange` 改名） |
| onConfirm | ValueChanged<T?>? | - | 点击确认时触发 |
| onReset | VoidCallback? | - | 点击重置时触发 |
| multiple | bool? | false | 是否多选 |
| disabled | bool? | false | 是否禁用（项级禁用，数据字段 KEEP） |
| controller | TDropdownItemController? | - | 下拉菜单控制器 |
| builder | TDropdownItemContentBuilder? | - | 完全自定义展示内容 |
| maxHeight | double? | - | 内容最大高度 |
| minHeight | double? | - | 内容最小高度 |
| optionsColumns | int? | 1 | 选项分栏（1-3） |
| arrowColor | Color? | - | 自定义箭头颜色 |
| arrowIcon | IconData? | - | 自定义箭头图标 |
| tabBarAlign | MainAxisAlignment? | - | label 与 arrowIcon 的对齐方式 |
| tabBarFlex | int? | 1 | 该 item 在 menu 上的宽度占比，仅在 `isScrollable` 为 false 时有效 |
| tabBarWidth | double? | - | 该 item 在 menu 上的宽度，仅在 `isScrollable` 为 true 时有效 |
| key | Key? | - | 组件标识 |

#### 静态成员

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| operateHeight | double | - | - |


### TDropdownItemOption

选项数据。

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| value | String | - | 选项值 |
| label | String | - | 选项标题 |
| selected | bool | false | 是否选中 |
| disabled | bool? | false | 是否禁用 |
| group | String? | - | 分组，相同的为一组 |
| selectedColor | Color? | - | 选中颜色 |
| disabledColor | Color? | - | 禁用颜色 |


### TDropdownItemController

下拉菜单控制器，支持命令式重置/更新选项。


### TDropdownMenuDirection

菜单展开方向。

#### 枚举值

| 名称 | 说明 |
| --- | --- |
| down | 向下 |
| up | 向上 |
| auto | 根据内容高度动态展示方向 |


### TDropdownThemeData

#### 简介
TDropdownMenu 组件级 ThemeExtension，控制子树的默认下拉菜单样式。通过 Theme 子树注入，实例字段优先于 Theme Extension。

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| width | double? | - | 菜单栏宽度 |
| height | double? | - | 菜单栏高度 |
| decoration | BoxDecoration? | - | 菜单栏装饰 |
| arrowIcon | Widget? | - | 箭头图标 |
| arrowColor | Color? | - | 箭头颜色 |
| tabBarAlign | TextAlign? | - | 标签栏对齐 |
| duration | Duration? | - | 动画时长 |
| isScrollable | bool? | - | 是否可滚动 |


### TDropdownItemContentBuilder

#### 类型定义

```dart
typedef TDropdownItemContentBuilder = Widget Function(BuildContext context, _TDropdownItemState itemState, TDropdownPopup? popupState);
```


### TDropdownItemOptionsCallback

#### 类型定义

```dart
typedef TDropdownItemOptionsCallback = void Function(List<TDropdownItemOption>? options);
```


### TDropdownItemBuilder

#### 简介
下拉菜单构建器

#### 类型定义

```dart
typedef TDropdownItemBuilder = List<TDropdownItem> Function(BuildContext context);
```


### LabelBuilder

#### 简介
自定义标签内容

#### 类型定义

```dart
typedef LabelBuilder = Widget Function(BuildContext context, String label, bool isOpened, int index);
```
