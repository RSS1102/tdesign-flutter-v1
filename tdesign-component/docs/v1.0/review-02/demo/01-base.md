# 基础类组件 Demo 问题

## 诊断口径

- 本文只记录 demo 实测暴露的问题、源码定位、初步根因和是否建议进入 review。
- 相关组件的源码 review 仍保留在 `../源码/` 下的同类文件中。
- 验证：已对相关 demo 文件执行定向 `flutter analyze`，结果为 `No issues found`。因此以下问题主要是 demo 交互、布局、状态管理或运行时体验问题，不是 Dart 静态编译错误。

### 1. `TFab` demo 未绑定事件，示例整体呈禁用态

定位：

- `tdesign-component/example/lib/page/t_fab_page.dart:93-170`

证据：

- 多个 `TFab` 示例均使用 `const TFab(...)`，没有传入 `onPressed`。
- `TFab` 按 v1.0 A 类禁用约定，`onPressed == null` 时呈禁用态。

诊断：

- 这是 demo 配置问题，不是 `TFab` 组件本身错误。
- 当前 demo 的目标是展示类型、配色、尺寸、拖拽，但因为未传 `onPressed`，用户看到的是“全部禁用”的视觉状态，无法正确观察正常态。

Review 建议：

- 需要进入 demo review。
- 所有非“禁用状态”示例应传入空操作或可见反馈回调，例如 `onPressed: () {}` 或 toast/log。
- 如需展示禁用态，应单独增加“禁用状态”示例，而不是让全部示例隐式禁用。

### 2. `TLink` 部分示例未绑定事件，意外呈禁用态

定位：

- `tdesign-component/example/lib/page/t_link_page.dart:67-81`
- `tdesign-component/example/lib/page/t_link_page.dart:149-157`
- `tdesign-component/example/lib/page/t_link_page.dart:174-184`

证据：

- `_buildLinksWithVariant` 创建的基础、下划线、图标链接没有传 `onPressed`。
- `_buildLinkWithColorScheme` 和 `_buildLinkWithSize` 已传 `onPressed`，只有显式 `disabled: true` 时才置空。

诊断：

- 这是 demo 配置不一致问题。
- `TLink` 的禁用语义是 `onPressed == null`，因此组件类型区域的示例会被误展示为禁用态，而颜色/尺寸区域是正常态。

Review 建议：

- 需要进入 demo review。
- `_buildLinksWithVariant` 中的正常链接应补 `onPressed`。
- “禁用状态”示例继续保留 `onPressed: null`。
