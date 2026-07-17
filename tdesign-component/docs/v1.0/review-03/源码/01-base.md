# 基础类组件 review-03

## 结论

- 本轮按 `review-02` 方案继续收口，已修复本批次确认的问题。

## 已处理

- `TButton` 渐变分支现在复用 `resolvedStyle` 的背景色解析结果，不再单独读取 `widget.style` 背景色。
- `TFontLoaderWidget` 取消 dead state，加载完成态现在直接参与 `isInFontLoader` 解析，避免状态字段和渲染路径脱节。

## 说明

- 这项对应 `review-02` 中按钮渐变路径和 P0 `ButtonStyle` 覆盖不完全的问题。
- 当前渐变按钮仍保留自绘装饰层，但样式来源已重新收敛到同一条 resolve 链。
