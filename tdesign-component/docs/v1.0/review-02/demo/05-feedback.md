# 反馈类组件 Demo 问题

## 诊断口径

- 本文只记录 demo 实测暴露的问题、源码定位、初步根因和是否建议进入 review。
- 相关组件的源码 review 仍保留在 `../源码/` 下的同类文件中。

### 1. `TPopup` demo 仍使用原生 `Text`，未统一切到 `TText`，主题文字表现不一致

定位：

- `tdesign-component/example/lib/page/t_popup_page.dart:29-149`
- `tdesign-component/lib/src/components/popup/t_popup.dart:34-85`

证据：

- demo 的按钮文案、标题文案、内容文案都直接使用了原生 `Text`。
- `TPopup` 组件本身已经是以 `TText` 为默认文字组件入口的弹层实现。

诊断：

- 这是 demo 的文字组件使用不统一问题，不是 Popup 核心逻辑错误。
- 直接用 `Text` 会让弹层示例和组件主题的字号、颜色、字体族表现不完全一致，影响 v1.0 文档对齐。

Review 建议：

- 需要进入 demo review。
- 示例中的标题、正文、按钮文案统一改用 `TText`，让弹层示例和主题体系保持一致。

