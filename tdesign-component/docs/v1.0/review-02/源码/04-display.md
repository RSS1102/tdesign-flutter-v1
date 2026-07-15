# 展示类组件待继续处理问题

## 核实口径

- 本文只记录对照 v1.0 设计口径后，当前源码中仍实际存在的问题。
- `tdesign-component/docs/v1.0/components/04-display/*` 只作为目标口径，不作为被 review 对象。

## P1 必修问题

### 1. `TBadge` 默认 message / square / bubble 展示的可见性与尺寸收口不完整

定位：

- `tdesign-component/lib/src/components/badge/t_badge.dart:69-219`

证据：

- `message`、`square`、`bubble` 三种可见态都走 `Visibility(visible: visible, child: ...)`。
- `visible` 由 `showZero` 和 `value` 解析结果共同决定，但 `count`、`maxCount`、Theme `message` 的优先级对外并不直观。
- `square` / `message` / `bubble` 的尺寸、padding、文本样式分散在多个私有方法里，公开 API 看不到统一收口点。

影响：

- 当 `count` 传入 `0`、空串或超上限时，展示结果依赖多个私有分支，语义不够直接。
- 当前源码更像“多种 badge 外观的集合”，而不是一套清晰的可见性/尺寸规则。

建议：

- 收敛 `visible`、`count`、`showZero`、`maxCount` 的优先级说明，并把默认尺寸与 padding 规则集中到一个位置。
- 若某些 variant 本身就是固定展示态，应减少依赖 `Visibility` 的隐式分支。

### 2. `TTable` 表格单元格布局对窄宽场景的收口不足

定位：

- `tdesign-component/lib/src/components/table/t_table.dart:19-230`

证据：

- 表格头和数据单元格在没有宽度时直接使用 `Expanded(flex: 1, ...)`。
- `_getCellText` 在 `ellipsis == false` 时使用 `TextOverflow.visible`，而单元格容器没有统一的最小宽度收口。
- `footerWidget` 直接追加到 `Column`，没有单独的固定布局壳。

影响：

- 窄屏或固定列组合下，单元格内容很容易超出预期宽度。
- 表格布局在不同示例里呈现不稳定，操作列、长文本、固定列混用时尤其明显。

建议：

- 统一收敛列宽、溢出、省略和固定列场景的布局契约。
- 对操作列、长文本列和 footer 提供更明确的默认约束。

