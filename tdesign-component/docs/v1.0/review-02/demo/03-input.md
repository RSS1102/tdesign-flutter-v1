# 输入类组件 Demo 问题

## 诊断口径

- 本文只记录 demo 实测暴露的问题、源码定位、初步根因和是否建议进入 review。
- 相关组件的源码 review 仍保留在 `../源码/` 下的同类文件中。

### 1. `TInput` demo 在 Android 上唤起输入法卡顿，验证码示例右侧内容溢出

定位：

- `tdesign-component/example/lib/page/t_input_page.dart:18-41`
- `tdesign-component/example/lib/page/t_input_page.dart:487-515`
- `tdesign-component/example/lib/page/t_input_page.dart:522-560`

证据：

- 页面在 `initState` 一次性创建了 30 个 `TextEditingController`，但 `dispose()` 里只取消了 `_timer`，没有释放这些 controller。
- 组件类型、状态、样式与测试区块都大量通过 `onChanged: (text) { setState(() {}); }` 驱动整页重建，输入过程中会反复刷新整个 `ExamplePage`。
- 验证码示例的 `rightBtn` 直接把 `Row`、`Container(width: 0.5)` 和 `Image.network(...)` 塞进输入框右侧，没有给图片明确尺寸，也没有为右侧区域做收敛约束。

诊断：

- 输入法卡顿更像是 demo 级生命周期和重建面过大叠加出来的体验问题，而不是 `TInput` 单点输入逻辑错误。
- 验证码示例的右侧内容溢出是 demo 布局问题，右侧插槽没有固定尺寸，`Image.network` 在窄宽度下容易把输入框撑爆。

Review 建议：

- 需要进入 demo review，优先处理。
- `TInputPage` 里创建的 `TextEditingController` 应统一释放。
- 输入示例里只保留必要的 `setState` 范围，避免每次输入都重建整页。
- 验证码示例右侧图片应显式约束宽高，右侧按钮区也应收窄成稳定尺寸。

### 1.1 `TTextarea` demo 也需要纳入唤起输入法卡顿排查

定位：

- `tdesign-component/example/lib/config.dart:203`
- `tdesign-component/example/lib/page/t_textarea_page.dart`
- `tdesign-component/lib/src/components/textarea/t_textarea.dart`

证据：

- `Textarea 多行输入 (V1.0)` 是输入类独立 demo 入口，和 `Input 输入框 (V1.0)` 同属输入框系列。
- `TTextarea` 与 `TInput` 共用输入类主题与输入视图能力，用户实测反馈的“input，textarea 系列的唤起输入框卡顿”不应只记录到 `TInput`。
- `review-02` 原文只明确记录了 `TInput` 页面，遗漏了 `textarea` 系列需要同口径复测。

诊断：

- 这是 review 记录覆盖不完整问题。
- `TTextarea` 需要和 `TInput` 一起按真机输入法唤起、连续输入、焦点切换、清除/计数刷新做体验复核。

Review 建议：

- 需要补入 demo review，并和 `TInput` 卡顿问题一起处理。
- 排查 `TTextareaPage` 是否存在过度 `setState`、controller / focusNode 生命周期、输入视图重建范围过大的问题。
- 修复后分别记录 `TInput` 与 `TTextarea` 的 Android 真机复测结果。

### 2. `TStepper` demo 的禁用态展示与组件语义不一致，且 `disabled` 不能完全封住输入

定位：

- `tdesign-component/example/lib/page/t_stepper_page.dart:34-37`
- `tdesign-component/example/lib/page/t_stepper_page.dart:68-79`
- `tdesign-component/lib/src/components/stepper/t_stepper.dart:103-104`
- `tdesign-component/lib/src/components/stepper/t_stepper.dart:275-405`

证据：

- demo 里的“禁用状态”示例并没有传 `disabled: true`，只是再次渲染了三个正常 `TStepper`。
- 组件内部 `_isDisabled` 只看 `widget.onChanged == null`，并没有把 `widget.disabled` 纳入输入框可编辑性的总开关。
- `TextField.enabled` 使用的是 `!_isDisabled && !widget.disableInput`，所以当 `disabled=true` 但 `onChanged` 仍然存在时，输入框仍可能保留可编辑交互。

诊断：

- demo 的“禁用状态”并没有真正展示禁用态，是明显的示例缺失。
- 组件实现也没有把 `disabled` 作为完整禁用总开关收敛掉，导致图标按钮与文本输入的禁用语义不完全一致。

Review 建议：

- 需要进入源码 review，同时修正 demo。
- demo 里必须补出真正的 `disabled` 示例，不要拿正常态重复冒充禁用态。
- 组件内部应把 `disabled` 和 `onChanged == null` 的语义统一收敛，避免出现半禁用状态。

### 3. `TRate` demo 只展示了隐式禁用态，没有单独的禁用状态示例

定位：

- `tdesign-component/example/lib/page/t_rate_page.dart:39-42`
- `tdesign-component/example/lib/page/t_rate_page.dart:95-109`
- `tdesign-component/lib/src/components/rate/t_rate.dart:109-111`
- `tdesign-component/lib/src/components/rate/t_rate.dart:208-230`

证据：

- `TRatePage` 的“组件状态”区域没有单独传 `disabled: true` 的示例。
- 页面里多处直接使用 `TRate(value: 3)`，而 `TRate` 的禁用判断却是 `_isDisabled => widget.onChanged == null`。
- 这意味着 demo 当前看到的“完全不可操作”主要来自没传 `onChanged`，不是专门演示 `disabled` 参数。

诊断：

- 当前 demo 只把 `onChanged == null` 这一隐式禁用态展示出来了，没有把 `disabled` 参数单独讲清楚。
- 组件本身的可交互判断也偏向“回调存在即可操作”，`disabled` 更像视觉辅助参数，而不是完整的交互总开关。

Review 建议：

- 需要进入 demo review。
- 增加单独的 `disabled` 示例，区分“无回调禁用”和“显式禁用”两种语义。
- 若 v1.0 设计要求 `disabled` 作为主禁用入口，组件实现也应同步收敛。

### 4. `TCalendar` demo 自定义单元格和副标题没有沿用组件默认状态表达，选中/未选中观感偏离规范

定位：

- `tdesign-component/example/lib/page/t_calendar_page.dart:712-787`
- `tdesign-component/example/lib/page/t_calendar_page.dart:816-851`
- `tdesign-component/lib/src/components/calendar/t_calendar.dart:23-52`
- `tdesign-component/lib/src/components/calendar/t_calendar_cell.dart:169-219`

证据：

- `TCalendar` 组件内部已经明确维护 `DateSelectType`，并通过 `TCalendarCell` 的默认渲染表达 selected / empty / disabled / range 等态。
- demo 的 `_buildCustomDayCell` 直接重绘了“今天 / 已选 / 默认”三种状态，内部使用的是原生 `Text`，没有继续沿用 `TCalendarCell` 的默认字号、选中容器和副标题排版。
- `_buildPriceSubtitle` 也用原生 `Text` 拼副标题，视觉上更像业务自绘，而不是组件规范示例。

诊断：

- 日历组件本身的选中状态逻辑是存在的，问题更集中在 demo 自定义 cell 过度重绘后，状态表现不再贴近 v1.0 规范。
- 现在的示例更像“业务自定义样式演示”，而不是“组件标准态演示”。

Review 建议：

- 需要进入 demo review。
- 自定义单元格示例应保留一组基于默认态的对照，不要把 selected / unselected / today 全部改造成完全不同的视觉语言。
- 若要展示整格自定义，建议明确标注这是自定义渲染，不代表默认规范态。
