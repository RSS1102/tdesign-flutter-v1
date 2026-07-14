## API
### TInput
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| additionInfo | String? | - | 错误提示信息 |
| additionInfoColor | Color? | - | 附加信息颜色 |
| autofocus | bool | false | 是否自动获取焦点 |
| backgroundColor | Color? | - | 输入框背景色 |
| cardStyleBottomText | String? | - | 卡片模式下方文字 |
| cardStyleTopText | String? | - | 卡片模式上方文字 |
| clearBtnColor | Color? | - | 清除按钮颜色 |
| clearIconSize | double? | - | 清除图标大小 |
| contentAlignment | TextAlign | TextAlign.start | 内容对齐方向 |
| contentPadding | EdgeInsetsGeometry? | - | 内边距 |
| contextMenuBuilder | EditableTextContextMenuBuilder? | - | 自定义上下文菜单构建器 |
| controller | TextEditingController? | - | controller |
| cursorColor | Color? | - | 游标颜色 |
| decoration | Decoration? | - | 自定义容器装饰（P0 逃逸舱） |
| enableInteractiveSelection | bool? | - | 是否启用交互式选择 |
| focusNode | FocusNode? | - | focusNode |
| hintText | String? | - | 提示文案 |
| hintTextStyle | TextStyle? | - | 提示文本样式 |
| inputAction | TextInputAction? | - | 键盘动作类型 |
| inputDecoration | InputDecoration? | - | 自定义输入框样式 |
| inputFormatters | List<TextInputFormatter>? | - | 输入格式化器 |
| inputType | TextInputType? | - | 键盘类型 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| label | String? | - | 左侧标签文案 |
| labelStyle | TextStyle? | - | 标签文本样式 |
| labelWidget | Widget? | - | label右侧组件，支持自定义 |
| layout | TInputLayout | TInputLayout.normal | 输入框布局形态 |
| leftInfoWidth | double? | - | 输入框左侧的宽度 |
| maxLength | int? | - | 最大字数限制 |
| maxLines | int? | 1 | 最大输入行数 |
| obscureText | bool | false | 是否隐藏输入的文字 |
| onBtnTap | GestureTapCallback? | - | 右侧按钮点击 |
| onChanged | ValueChanged<String>? | - | 输入文本变化时回调 |
| onClearTap | GestureTapCallback? | - | 右侧删除点击 |
| onEditingComplete | VoidCallback? | - | 点击键盘完成按钮时触发的回调 |
| onSubmitted | ValueChanged<String>? | - | 点击键盘完成按钮时触发的回调, 参数值为输入的内容 |
| onTapOutside | TapRegionCallback? | - | 点击输入框外部区域回调 |
| prefix | Widget? | - | 左侧图标 |
| readOnly | bool | false | 是否只读 |
| required | bool? | - | 是否必填标志（红色*） |
| rightBtn | Widget? | - | 右侧按钮 |
| selectionControls | TextSelectionControls? | - | 自定义选择控制器 |
| showBottomDivider | bool? | - | 是否展示底部分割线 |
| showClearButton | bool? | - | 是否显示清除按钮 |
| size | TInputSize | TInputSize.large | 输入框尺寸 |
| spacer | TInputSpacer? | - | 组件各模块间间距 |
| suffix | Widget? | - | 右侧自定义组件 |
| textAlign | TextAlign? | - | 文本对齐方向 |
| textInputBackgroundColor | Color? | - | 文本框背景色 |
| textStyle | TextStyle? | - | 文本样式 |
| width | double? | - | 输入框宽度 |
