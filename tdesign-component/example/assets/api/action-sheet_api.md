## API
### TActionSheet

#### 静态方法

##### TActionSheet.showListActionSheet

显示列表型动作面板。

返回类型：`void`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 上下文（E 类首参） |
| items | List<TActionSheetItem> | - | 选项列表 |
| align | TActionSheetAlign | TActionSheetAlign.center | 对齐方式 |
| subtitle | String? | - | 副标题（原 `description`，V1.0 改名） |
| cancelText | String? | - | 取消按钮文案 |
| showCancel | bool | true | 是否显示取消按钮 |
| showOverlay | bool | true | 是否显示蒙层 |
| closeOnOverlayClick | bool | true | 点击蒙层是否关闭 |
| onCancel | VoidCallback? | - | 取消回调 |
| onChanged | TActionSheetOnChanged? | - | 选中回调（原 `onSelected`，V1.0 改名） |
| onClose | VoidCallback? | - | 关闭回调 |
| useSafeArea | bool | true | 是否避让安全区 |


##### TActionSheet.showGridActionSheet

显示宫格型动作面板。

返回类型：`void`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 上下文 |
| items | List<TActionSheetItem> | - | 选项列表 |
| align | TActionSheetAlign | TActionSheetAlign.center | 对齐方式 |
| subtitle | String? | - | 副标题 |
| cancelText | String? | - | 取消按钮文案 |
| showCancel | bool | true | 是否显示取消按钮 |
| showOverlay | bool | true | 是否显示蒙层 |
| closeOnOverlayClick | bool | true | 点击蒙层是否关闭 |
| count | int | 8 | 每页显示项目数 |
| rows | int | 2 | 显示行数 |
| itemHeight | double | 96.0 | 项目行高 |
| itemMinWidth | double | 80.0 | 项目最小宽度 |
| scrollable | bool | false | 是否可横向滚动 |
| showPagination | bool | false | 是否显示分页 |
| onCancel | VoidCallback? | - | 取消回调 |
| onChanged | TActionSheetOnChanged? | - | 选中回调 |
| onClose | VoidCallback? | - | 关闭回调 |
| useSafeArea | bool | true | 是否避让安全区 |


##### TActionSheet.showGroupActionSheet

显示分组型动作面板。

返回类型：`void`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 上下文 |
| items | List<TActionSheetItem> | - | 选项列表（按 `group` 分组） |
| align | TActionSheetAlign | TActionSheetAlign.left | 对齐方式 |
| cancelText | String? | - | 取消按钮文案 |
| showCancel | bool | true | 是否显示取消按钮 |
| showOverlay | bool | true | 是否显示蒙层 |
| closeOnOverlayClick | bool | true | 点击蒙层是否关闭 |
| itemHeight | double | 96.0 | 项目行高 |
| itemMinWidth | double | 80.0 | 项目最小宽度 |
| onCancel | VoidCallback? | - | 取消回调 |
| onChanged | TActionSheetOnChanged? | - | 选中回调 |
| onClose | VoidCallback? | - | 关闭回调 |
| useSafeArea | bool | true | 是否避让安全区 |


#### 默认构造方法

声明式构造（辅路径）；推荐使用三族 static show。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 上下文 |
| align | TActionSheetAlign | TActionSheetAlign.center | 对齐方式 |
| cancelText | String? | - | 取消按钮文案 |
| count | int | 8 | 每页显示项目数 |
| rows | int | 2 | 显示行数 |
| itemHeight | double | 96.0 | 项目行高 |
| itemMinWidth | double | 80.0 | 项目最小宽度 |
| subtitle | String? | - | 副标题 |
| items | List<TActionSheetItem> | - | 选项列表 |
| showCancel | bool | true | 是否显示取消按钮 |
| showOverlay | bool | true | 是否显示蒙层 |
| closeOnOverlayClick | bool | true | 点击蒙层是否关闭 |
| theme | TActionSheetTheme | TActionSheetTheme.list | 面板类型（list/grid/group） |
| visible | bool | false | 是否立即显示 |
| showPagination | bool | false | 是否显示分页 |
| scrollable | bool | false | 是否可横向滚动 |
| onCancel | VoidCallback? | - | 取消回调 |
| onClose | VoidCallback? | - | 关闭回调 |
| onChanged | TActionSheetOnChanged? | - | 选中回调 |
| useSafeArea | bool | true | 是否避让安全区 |


### TActionSheetItem

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| label | String | - | 选项标题 |
| icon | IconData? | - | 图标 |
| badge | String? | - | 徽标 |
| group | String? | - | 分组 key（仅 group 类型生效） |
| disabled | bool | false | 项级禁用（数据字段） |


### TActionSheetAlign

#### 枚举值

| 名称 | 说明 |
| --- | --- |
| center | 居中 |
| left | 左对齐 |
| right | 右对齐 |


### TActionSheetTheme

面板类型枚举（list/grid/group）。

#### 枚举值

| 名称 | 说明 |
| --- | --- |
| list | 列表型 |
| grid | 宫格型 |
| group | 分组型 |


### TActionSheetOnChanged

#### 类型定义

```dart
typedef TActionSheetOnChanged = void Function(TActionSheetItem item, int index);
```


### TActionSheetThemeData

#### 简介
TActionSheet 组件级 ThemeExtension，控制子树的默认动作面板样式。通过 Theme 子树注入，实例 show 参数优先于 Theme Extension。

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| cancelText | String? | - | 取消按钮文案默认 |
| showCancelButton | bool? | - | 是否显示取消按钮默认 |
| defaultAlign | TActionSheetAlign? | - | 默认对齐方式 |
| itemHeight | double? | - | 项目行高默认 |
| itemMinWidth | double? | - | 项目最小宽度默认 |
| count | int? | - | 宫格列数默认 |
| rows | int? | - | 宫格行数默认 |
| showPagination | bool? | - | 是否显示分页默认 |
| scrollable | bool? | - | 是否可滚动默认 |
| barrierDismissible | bool? | - | 点击蒙层是否关闭默认 |
| barrierColor | Color? | - | 蒙层颜色 |
| panelRadius | double? | - | 面板圆角 |
| useSafeArea | bool? | - | 是否避让安全区默认 |
