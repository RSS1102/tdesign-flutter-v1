# 输入类组件待继续处理问题

## 核实口径

- 本文只记录对照 v1.0 设计口径后，当前源码中仍实际存在的问题。
- `tdesign-component/docs/v1.0/components/03-input/*` 只作为目标口径，不作为被 review 对象。

## 已处理

- `TCheckboxGroupController` 已从当前方案中移除，Checkbox / Radio 改为严格受控组合体方案。

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

### 3. `TInput` 依赖外部 `controller.text` 渲染清除按钮和计数，但没有监听 controller 变化

定位：

- `tdesign-component/lib/src/components/input/t_input.dart:484-509`
- `tdesign-component/lib/src/components/input/t_input.dart:678-697`
- `tdesign-component/lib/src/components/input/t_input.dart:819-827`

证据：

- `TInput` 是 `StatelessWidget`，没有对外部 `TextEditingController` 注册 listener。
- 普通布局和双行布局都直接通过 `controller!.text.isNotEmpty` 判断清除按钮是否可见。
- 长文本布局的计数字段直接读取 `${controller?.text.length}/${maxLength}`。
- 清除默认逻辑只执行 `controller?.text = ''`，没有触发组件自身刷新；外部业务直接修改 `controller.text` 时，组件也没有内部刷新入口。

影响：

- 外部通过 controller 改值后，清除按钮显隐、长文本计数等 UI 可能停留在上一次 build 的状态。
- 同一个输入框的文本内容和附属 UI 状态可能不同步，尤其在验证码、清空、表单重置等场景更容易暴露。

建议：

- 将 `TInput` 改为有状态实现，监听外部 controller；controller 变更时刷新依赖文本内容的附属 UI。
- 若内部创建 controller，也需要在生命周期内统一管理创建、切换和释放。
- 清除行为应使用 `controller.clear()` 并确保触发 UI 刷新和必要的 `onChanged('')` 语义。

### 4. `TSearchBar` 持续追加 controller / focusNode listener，未做解绑和 dispose

定位：

- `tdesign-component/lib/src/components/search/t_search_bar.dart:108-129`
- `tdesign-component/lib/src/components/search/t_search_bar.dart:132-145`
- `tdesign-component/lib/src/components/search/t_search_bar.dart:227-240`

证据：

- `initState` 中给内部 `controller` 或外部 `widget.controller` 注册匿名 listener，但没有保存 listener 引用。
- `_updateFocusNode()` 每次执行都会给当前 `focusNode` 注册新的匿名 listener。
- `didUpdateWidget` 无条件调用 `_updateFocusNode()`，导致父组件重建或 `focusNode` 切换时继续叠加 listener。
- 当前 State 未实现 `dispose()`，内部创建的 `TextEditingController`、默认 `FocusNode` 以及已注册 listener 都没有释放或解绑。

影响：

- 多次 rebuild 后，同一次焦点变化可能触发多次 `setState`。
- 外部 controller / focusNode 被切换或页面销毁后，旧 listener 仍可能持有 State 闭包，存在重复回调、内存泄漏和销毁后回调风险。
- SearchBar 是输入类高频组件，这类生命周期问题会放大 Android 输入法唤起、页面切换和列表复用场景下的卡顿风险。

建议：

- 将 controller listener 和 focusNode listener 拆成命名方法，保存并在 `dispose` / `didUpdateWidget` 中成对解绑。
- 区分内部创建与外部传入的 controller / focusNode，只 dispose 组件内部创建的对象。
- `didUpdateWidget` 只在 controller 或 focusNode 实例变化时重绑，不应每次 rebuild 追加 listener。

### 5. `TForm` 的 `controller` listener 未移除，State 销毁后仍可能被持有

定位：

- `tdesign-component/lib/src/components/form/t_form.dart:110-122`
- `tdesign-component/lib/src/components/form/t_form.dart:125-147`
- `tdesign-component/lib/src/components/form/t_form.dart:162-190`

证据：

- `initState` 中通过匿名闭包给 `widget.controller` 注册 listener。
- 源码中未见 `dispose()`，也没有在 `didUpdateWidget` 中处理 controller 实例变更。
- listener 闭包直接调用 `onSubmit()` / `onReset()`，内部会访问 State 字段并可能触发 `setState`。

影响：

- 表单组件销毁后，如果外部继续持有同一个 `FormController` 并调用 `submit()` / `reset()`，旧 State 仍可能被 listener 闭包引用。
- controller 切换时，旧 controller 的 listener 不会解除，新 controller 也不会按生命周期重新绑定。
- 这会造成内存泄漏、重复提交/重置，甚至销毁后触发 State 逻辑的风险。

建议：

- 使用命名 listener，并在 `dispose()` 中从当前 controller 移除。
- 在 `didUpdateWidget` 中处理 controller 变更：先解绑旧 controller，再绑定新 controller。
- 提交和重置前增加 `mounted` / controller 来源校验，避免销毁后继续驱动 State。

### 6. `TSlider` / `TRangeSlider` 没有把 `value` clamp 到 Theme min/max，默认范围存在直接冲突

定位：

- `tdesign-component/lib/src/components/slider/t_slider.dart:64-74`
- `tdesign-component/lib/src/components/slider/t_slider.dart:154-170`
- `tdesign-component/lib/src/components/slider/t_slider.dart:240-253`
- `tdesign-component/lib/src/components/slider/t_slider.dart:394-410`
- `tdesign-component/lib/src/components/slider/t_slider_theme.dart:74-83`

证据：

- `TSliderState.initState()` / `didUpdateWidget()` 直接把 `widget.value` 赋给内部 `value`，没有根据 Theme `min/max` 做 clamp。
- `TRangeSliderState.initState()` / `didUpdateWidget()` 直接把 `widget.value` 赋给 `rangeValues`。
- `Slider` / `RangeSlider` 最终使用 Theme 中的 `min` / `max`。
- `TSliderThemeData` 默认 `min = 0.0`、`max = 1.0`，但 `TRangeSliderState.rangeValues` 默认写成 `RangeValues(0, 100)`；外部若按旧 0-100 习惯传值，在默认 Theme 下会超出 Flutter `RangeSlider` 的合法范围。

影响：

- 当 `value` 或 `RangeValues` 超出 Theme min/max 时，Flutter 原生 `Slider` / `RangeSlider` 会触发断言或渲染异常。
- Theme 改变 min/max 后，组件内部值不会自动归一化，旧值可能变成非法值。
- `TRangeSlider` 默认内部值与默认 Theme 范围不一致，属于源码默认值自相矛盾。

建议：

- 在 build 前基于有效 `min/max` 统一 clamp 单值和区间值。
- `TRangeSlider` 默认值应与默认 Theme 范围一致，或由构造器显式要求调用方传合法值并 assert。
- 当 Theme min/max 变化时，应重新校正内部值，并避免触发非法 RangeValues。

### 7. `TUpload` 只在 `initState` 读取 `files`，且直接持有外部列表引用

定位：

- `tdesign-component/lib/src/components/upload/t_upload.dart:200-224`
- `tdesign-component/lib/src/components/upload/t_upload.dart:283-311`
- `tdesign-component/lib/src/components/upload/t_upload.dart:337-390`

证据：

- `_TUploadState.fileList` 在 `initState()` 中直接赋值为 `widget.files`。
- 组件没有实现 `didUpdateWidget()`，外部更新 `files` 后内部 `fileList` 不会同步。
- `canUpload`、数量校验、key 生成和渲染都基于内部 `fileList`。
- `fileList = widget.files` 是引用赋值，不是拷贝；内部后续若调整列表会影响外部传入对象。

影响：

- 上传组件对外看起来是由 `files` 控制展示，但实际只吃首次传入值；父组件通过 `onChanged` 更新 `files` 后，组件可能仍显示旧列表。
- `max` 数量判断和新增 key 生成会基于旧的 `fileList`，导致可上传状态、数量限制和新增 key 不准确。
- 数据所有权不清晰，容易在受控用法下出现 UI 与业务状态不同步。

建议：

- 将 `files` 作为受控数据源，build 和校验直接基于 `widget.files` 或在 `didUpdateWidget` 中同步内部快照。
- 如内部需要临时状态，应复制列表并明确何时与外部 `files` 对齐。
- `onChanged` 返回新增/删除/替换事件后，组件应依赖父级回写的 `files` 更新展示，而不是停留在初始 `fileList`。
