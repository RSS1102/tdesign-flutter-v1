# 展示类组件 review-03

## 结论

- 本轮按 `review-02` 方案继续收口，已修复本批次确认的问题。

## 已处理

- `TBadge` 改为单一 resolved 展示模型，`count` / `maxCount` / Theme `message` / `showZero` 的可见性与文本不再分散计算。
- `TUpload` 外部 `files` 更新改为内容比较同步，避免同一 list 实例原地修改后内部展示停留在旧快照。
- `TTable` 排序时同步重排选中状态，避免排序后勾选框和行数据错位。
- `TCell` hover 状态延迟切换补上 mounted 保护，避免销毁后继续触发 setState。
- `TTimeCounter` 的自动启动 post-frame 回调与 ticker 回调补上 mounted 保护，避免销毁后继续拉起计时器或回写状态。

## 说明

- 该项对应 `review-02` 中 Badge 的派生状态不同步问题。
- 当前实现已把最终展示文本、是否可见、紧凑尺寸判断收敛到同一条计算路径。
- `TUpload` 这一项对应受控列表同步残留，当前已不再依赖单纯引用变化。
- `TTable` 这一项对应排序/选择耦合问题，当前已改为同步重排内部选中快照。
- `TCell` 这一项对应列表项异步状态残留，当前延迟状态更新已避免销毁后回调。
