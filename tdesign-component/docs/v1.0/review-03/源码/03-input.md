# 输入类组件 review-03

## 结论

- 本轮按 `review-02` 方案继续收口，已修复本批次确认的问题。
- 这里记录的是已落地的实现修复，不再重复 `review-02` 中的旧问题。

## 已处理

- `TFormItem` 改为显式绑定 / 解绑 `FormItemNotifier`，销毁时不再 dispose 外部 notifier。
- `TStepper` 的 `eventController` 改为可取消订阅，避免销毁后仍持有旧 `State` 回调。
- `TStepper` 的 `controller` / `value` 变更现在会同步回内部状态，不再停留在初始绑定值。
- `TForm` / `TFormItem` 现在复制表单数据快照再回写，避免把外部传入的 map 直接当内部状态修改。
- `TRate` 重新补齐 `disabled` 字段，并把禁用判定、overlay 展示和 tip 尺寸回调都收进 mounted 安全路径。

## 说明

- 该项对应 `review-02` 中的表单项生命周期问题。
- 当前实现已改为命名 listener + 生命周期解绑，避免外部共享 notifier 被误释放。
- `TStepper` 这一项属于补充发现的生命周期残留，已收敛为 `initState` / `didUpdateWidget` 绑定、`dispose` 取消订阅。
- `TStepper` 现在同时处理 controller 切换、外部 value 更新和 state 解绑，避免旧值滞留在输入框里。
- `TForm` / `TFormItem` 这一项属于数据所有权残留，当前内部表单快照与外部 `data` 已解除引用共享。
