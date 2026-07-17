# 基础类 demo review-03

## 结论

- 本轮按 `review-02` 方案继续收口，已修复本批次确认的 demo 问题。

## 已处理

- 首页组件入口从 `TButton` 列表改回 `TCell` / `TCellGroup` 列表，和 develop 期望的目录布局保持一致。
- `ExamplePage` 顶部导航栏独立包裹 `SafeArea(bottom: false)`，正文区域使用 `SafeArea(top: false)`，避免详情页顶部交互贴到状态栏。

## 说明

- 这两个问题都属于 demo 结构问题，不改组件源码行为。
- 当前首页更接近组件目录页的 cell 语义，详情页顶部交互也不再直接贴近系统状态栏。
