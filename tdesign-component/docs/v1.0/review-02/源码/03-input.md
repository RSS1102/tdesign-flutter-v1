# 输入类组件待继续处理问题

## 核实口径

- 本文只记录对照 v1.0 设计口径后，当前源码中仍实际存在的问题。
- `tdesign-component/docs/v1.0/components/03-input/*` 只作为目标口径，不作为被 review 对象。

## P1 必修问题

### 1. `TStepper` 的 `disabled` 语义没有完全收敛，文本输入与图标按钮的禁用条件不一致

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

### 2. `TRate` 的 `disabled` 参数未进入主交互分支，实际禁用语义仍由 `onChanged` 决定

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

