# 反馈类组件 Demo 问题

## 诊断口径

- 本文只记录 demo 实测暴露的问题、源码定位、初步根因和是否建议进入 review。
- 相关组件的源码 review 仍保留在 `../源码/` 下的同类文件中。

### 1. `TPopup` demo 文字节点未按 Popup 包裹口径统一，主题文字表现不一致

定位：

- `tdesign-component/example/lib/page/t_popup_page.dart:29-149`
- `tdesign-component/lib/src/components/popup/t_popup.dart:34-85`

证据：

- demo 的按钮文案、标题文案、内容文案都直接使用了原生 `Text`。
- `TPopup` 组件本身已经是以 `TText` 为默认文字组件入口的弹层实现。
- 用户补充确认：popup 的文字应该按 Popup 包裹口径处理，不应在示例中裸放不符合规范的文字节点。

诊断：

- 这是 demo 的文字包裹和组件使用口径不统一问题，不是 Popup 核心逻辑错误。
- 直接用 `Text` 会让弹层示例和组件主题的字号、颜色、字体族表现不完全一致，影响 v1.0 文档对齐。

Review 建议：

- 需要进入 demo review。
- 示例中的标题、正文、按钮文案按 Popup 包裹口径统一处理；如内部文字组件仍需直接声明，应统一使用 `TText` 并保持主题体系一致。
