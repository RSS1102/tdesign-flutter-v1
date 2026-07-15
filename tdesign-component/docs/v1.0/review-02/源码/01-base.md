# 基础组件待继续处理问题

## 核实口径

- 本文只记录对照 v1.0 设计口径后，当前源码中仍实际存在的问题。
- `tdesign-component/docs/v1.0/components/01-base/*` 只作为目标口径，不作为被 review 对象。
- 已核实不再作为问题：`TTextConfiguration.updateShouldNotify` 已监听 `globalFontFamily`；`TIcons` 已迁移到 `tdesign_icons: ^0.0.4` 外部包；`TButtonStyle` / `TButtonType` / `TButtonTheme` / `TButtonEvent` / `TButtonStatus` 在 button 源码中未发现残留公开实现。

## P1 必修问题

### 1. `TButton` 渐变路径绕开 `ElevatedButton`，P0 `style` 覆盖不完整

定位：

- `tdesign-component/lib/src/components/button/t_button.dart:103-121`
- `tdesign-component/lib/src/components/button/t_button.dart:166-219`
- `tdesign-component/lib/src/components/button/t_button_theme_data.dart:45-59`
- `tdesign-component/docs/v1.0/components/01-base/button.md:213-244`

证据：

- `TButtonThemeData.gradient` 存在时，`TButton.build` 进入自绘渐变分支，不再使用 `ElevatedButton`。
- 渐变分支只从 `resolvedStyle` 读取 `foregroundColor`，但 padding、shape、minimumSize、side、overlay/elevation 等 ButtonStyle 语义由分支内私有逻辑重新计算。
- v1.0 设计口径要求 P0 `ButtonStyle? style` 覆盖 resolve 结果，`gradient` 是 Theme 字段而非替代整套按钮行为的独立实现路径。

影响：

- 用户传入 P0 `style` 时，在非渐变路径可完整进入 `ElevatedButton(style: resolvedStyle)`，但在渐变路径只会部分生效。
- Theme 中启用 `gradient` 后，同一个 `TButton` 的样式优先级和 Material 行为不再一致，容易出现 P0 覆盖不完整、行为覆盖遗漏的问题。

建议：

- 保留渐变装饰层，但尽量复用同一份 `resolvedStyle` 的尺寸、shape、padding、foreground、overlay 等结果。
- 若渐变必须绕开 `ElevatedButton`，需要明确把 P0 `style` 支持范围补齐。
- 避免让 `gradient` 分支成为一套与常规按钮分叉的独立按钮实现。

### 2. `TStepper` 的 `disabled` 语义没有完全收敛，文本输入与图标按钮的禁用条件不一致

定位：

- `tdesign-component/lib/src/components/stepper/t_stepper.dart:37-60`
- `tdesign-component/lib/src/components/stepper/t_stepper.dart:102-104`
- `tdesign-component/lib/src/components/stepper/t_stepper.dart:275-405`

证据：

- `TStepper` 公共参数里暴露了 `disabled`、`disableInput`、`onChanged` 三个开关。
- `_isDisabled` 只由 `widget.onChanged == null` 决定，没有把 `widget.disabled` 纳入统一禁用判定。
- 左右图标按钮的 `disabled` 只看 `widget.disabled || _controller._value <= widget.min/max`，而中间 `TextField.enabled` 只看 `!_isDisabled && !widget.disableInput`。

影响：

- `disabled == true` 但 `onChanged != null` 时，组件会出现“图标按钮禁用、输入框仍可编辑”的半禁用状态。
- 对外暴露的 `disabled` 参数不再是完整禁用总开关，API 语义和实际交互不一致。

建议：

- 统一收敛 `disabled`、`disableInput`、`onChanged == null` 的判定路径，避免出现一部分控件可交互、一部分控件禁用的混合状态。
- 如果 `disabled` 是主禁用入口，应让图标按钮、输入框、文本样式和事件都同步受控。

### 3. `TRate` 的 `disabled` 参数未进入主交互分支，实际禁用语义仍由 `onChanged` 决定

定位：

- `tdesign-component/lib/src/components/rate/t_rate.dart:20-54`
- `tdesign-component/lib/src/components/rate/t_rate.dart:109-111`
- `tdesign-component/lib/src/components/rate/t_rate.dart:208-230`
- `tdesign-component/lib/src/components/rate/t_rate.dart:290-355`

证据：

- `TRate` 公开参数里有 `disabled`，但 `_TRateState` 的 `_isDisabled` 只判断 `widget.onChanged == null`。
- 所有点击、拖动、抬手分支都只检查 `_isDisabled`，没有再合并 `widget.disabled`。
- `disabled` 只作为公共 API 存在，没有参与主交互逻辑，也没有驱动视觉状态切换。

影响：

- 传入 `disabled: true` 但保留 `onChanged` 时，评分仍可响应点击和拖动。
- 对外的 `disabled` 参数更像“挂在 API 上但没真正生效”的死语义，和组件实际行为不一致。

建议：

- 将 `disabled` 纳入主交互判定，与 `onChanged == null` 一起收敛成统一禁用总开关。
- 若保留 `onChanged == null` 作为禁用约定，也要明确让 `disabled` 真正生效，避免 API 口径和实现分叉。

## P2 建议彻底收口

### 4. `TFontLoaderWidget.fontFamilyLoaded` 是 dead state

定位：

- `tdesign-component/lib/src/components/text/t_font_loader.dart:61`
- `tdesign-component/lib/src/components/text/t_font_loader.dart:97`

证据：

- `fontFamilyLoaded` 在 State 中声明，并在 `loadFont()` 末尾赋值为 `true`。
- 该字段没有参与 `build`、分支判断、对外回调或加载状态展示。

影响：

- 运行影响较小，但属于重构未清理干净的状态字段。
- 后续维护者会误以为该字段控制渲染或加载状态。

建议：

- 如果不需要加载态分支，删除该字段。
- 如果需要表达字体加载完成状态，应通过 `setState` 后参与渲染或语义逻辑。
