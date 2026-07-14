## API
### TTextarea
#### 简介
TTextarea 多行文本输入组件
基于 Material `TextField` 薄包装。
与 TInput 共用 `TInputThemeData`。
D 类禁用：`enabled: false` / `readOnly: true`。
推荐新代码使用 `TInput.multiline()`。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| additionInfo | String? | - | 错误提示信息 |
| additionInfoColor | Color? | - | 错误提示颜色 |
| allowInputOverMax | bool? | false | 超出后是否允许输入 |
| autofocus | bool? | false | 是否自动获取焦点 |
| autosize | bool? | - | 是否自动增高 |
| backgroundColor | Color? | - | 输入框背景色 |
| bordered | bool? | - | 是否显示外边框 |
| controller | TextEditingController? | - | controller |
| cursorColor | Color? | - | 游标颜色 |
| decoration | Decoration? | - | 输入框样式(包括标签) |
| focusNode | FocusNode? | - | focusNode |
| hintText | String? | - | 提示文案 |
| hintTextStyle | TextStyle? | - | 提示文本颜色 |
| indicator | bool? | false | 否显示文本计数器 |
| inputDecoration | InputDecoration? | - | 自定义输入框TextField组件样式 |
| inputFormatters | List<TextInputFormatter>? | - | 输入格式化器 |
| inputType | TextInputType? | - | 键盘类型 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| label | String? | - | 输入框标题 |
| labelIcon | Widget? | - | 输入框标题图标 |
| labelStyle | TextStyle? | - | 标签文本样式 |
| labelWidget | Widget? | - | label组件 |
| labelWidth | double? | - | 输入框标题宽度 |
| layout | TTextareaLayout? | TTextareaLayout.horizontal | 标题输入框布局方式 |
| margin | EdgeInsetsGeometry? | - | 外边距 |
| maxLength | int? | - | 最大字数 |
| maxLengthEnforcement | MaxLengthEnforcement? | - | 长度限制方式 |
| maxLines | int? | - | 最大行数 |
| minLines | int? | 4 | 最小行数 |
| onChanged | ValueChanged<String>? | - | 文本变更回调 |
| onEditingComplete | VoidCallback? | - | 点击键盘完成按钮 |
| onSubmitted | ValueChanged<String>? | - | 提交回调 |
| padding | EdgeInsetsGeometry? | - | 内边距 |
| readOnly | bool? | false | 是否只读 |
| required | bool? | - | 是否必填标志 |
| showBottomDivider | bool? | true | 边框外部下划线 |
| size | TInputSize? | - | 输入框尺寸 |
| textAlign | TextAlign? | - | 文字对齐方向 |
| textareaDecoration | Decoration? | - | 输入框样式(不包括标签) |
| textInputBackgroundColor | Color? | - | 文本框背景色 |
| textStyle | TextStyle? | - | 文本颜色 |
| width | double? | - | 输入框宽度 |


### TTextareaLayout
#### 简介
TTextarea 多行文本布局方式
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| vertical | - |
| horizontal | - |
