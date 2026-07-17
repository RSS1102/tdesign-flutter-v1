# 反馈类组件 review-03

## 结论

- 本轮按 `review-02` 方案继续收口，已修复本批次确认的问题。

## 已处理

- `TMessage` 的手动关闭和超时关闭统一走 overlay 回收，不再残留空壳实例。
- `TNoticeBar` 横向 marquee 补齐销毁保护，避免组件卸载后继续驱动滚动控制器。
- `TNoticeBar` 在内容、方向或静态行数变化后会重启 marquee，避免沿用旧滚动状态。

## 说明

- `TMessage` 现在由同一套 dismiss 逻辑处理手动关闭与超时关闭。
- `TNoticeBar` 的 timer 回调已补 `mounted` / controller 存活判断，并在配置变化时重启。
