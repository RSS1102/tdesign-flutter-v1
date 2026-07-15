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

### 3. `TBadge` 只在 `count` 变化时更新 `badgeNum`，`maxCount` / Theme `message` 变化会导致显示状态不同步

定位：

- `tdesign-component/lib/src/components/badge/t_badge.dart:76-89`
- `tdesign-component/lib/src/components/badge/t_badge.dart:110-123`
- `tdesign-component/lib/src/components/badge/t_badge.dart:155-166`
- `tdesign-component/lib/src/components/badge/t_badge.dart:181-219`

证据：

- `badgeNum` 是 State 字段，只在 `initState()` 和 `didUpdateWidget()` 中 `oldWidget.count != widget.count` 时更新。
- `updateBadgeNum()` 内部会读取 `widget.maxCount`，但 `didUpdateWidget()` 没有在 `maxCount` 变化时重新计算。
- `value` 会优先取 Theme `message`，但 `message` 变化不会更新 `badgeNum`。
- `message` 形态使用 `badgeNum.length == 1` 判断圆形/胶囊尺寸，却用 `value` 渲染文本；当 `value` 来源从 `count` 切到 Theme `message` 时，尺寸判断和实际显示文本可能不是同一个来源。

影响：

- `count` 不变但 `maxCount` 变化时，超过上限的展示不会重新计算。
- Theme 动态切换 `message` 后，显示文本可能变化，但尺寸分支仍按旧 `badgeNum` 判断，容易出现裁剪或布局不匹配。
- `showZero` / `value` / `badgeNum` 三条路径没有统一状态源，导致 Badge 的可见性、内容和尺寸可能不同步。

建议：

- 不要把派生展示值长期缓存为独立 State，优先在 build 阶段基于 `count`、`maxCount`、Theme `message` 统一计算一个 resolved model。
- 若必须缓存，应在 `count`、`maxCount`、相关 Theme 字段变化时同步重算。
- `message` 形态的尺寸分支应基于最终展示文本，而不是旧的 `badgeNum`。

### 4. `TTable` 表头排序直接修改 `widget.data`，破坏外部数据源所有权

定位：

- `tdesign-component/lib/src/components/table/t_table.dart:407-426`
- `tdesign-component/lib/src/components/table/t_table.dart:491-495`
- `tdesign-component/lib/src/components/table/t_table.dart:505-520`

证据：

- 表头排序点击后，在 `setState` 中直接执行 `widget.data?.sort(...)`。
- `widget.data` 是外部传入的列表引用，组件内部没有复制成本地排序数据。
- `didUpdateWidget()` 每次都会 `_initCols()`，但没有维护一份组件内部排序后的数据快照。

影响：

- 父组件传入的数据列表会被 `TTable` 原地改写，外部状态、其他组件引用或缓存数据的顺序都会被同步污染。
- 这违反 Widget 输入应被视为不可变配置的基本分层，排序行为不应偷偷改变调用方持有的数据源。
- 外部重建时，如果父组件仍使用同一个 list 实例，排序状态和原始数据状态容易互相覆盖。

建议：

- 在组件内部维护排序后的派生列表，不直接修改 `widget.data`。
- 或将排序作为受控行为暴露给外部，由 `onSortChange` 通知业务侧更新数据。
- `_initCols()` 和选择态计算应基于当前展示数据快照，避免排序后选择状态与原始数据索引错位。

### 5. `TSkeleton` 延迟回调未检查 `mounted`，销毁后可能继续 `setState`

定位：

- `tdesign-component/lib/src/components/skeleton/t_skeleton.dart:139-169`
- `tdesign-component/lib/src/components/skeleton/t_skeleton.dart:266-270`

证据：

- `initState()` 中通过 `Future.delayed(Duration(milliseconds: widget.delay), () => setState(...))` 延迟关闭 `_isLoading`。
- 该 delayed 回调没有保存句柄，也没有在回调中检查 `mounted`。
- `dispose()` 只释放 `_controller`，无法取消 delayed 回调。

影响：

- 如果 `delay` 较长，组件在延迟结束前被移除，回调仍会执行 `setState`。
- 这会触发 Flutter 的 “setState() called after dispose()” 类运行时错误。
- Skeleton 常用于列表、条件渲染和页面切换场景，销毁前延迟回调很容易出现。

建议：

- delayed 回调内先检查 `mounted`。
- 或改为 `Timer` 字段并在 `dispose()` 中取消。
- 动画 listener 中的 `setState` 也应统一走 mounted 安全路径。

### 6. `TSkeleton` 在组件根部返回 `Flexible`，要求调用方必须处于 Flex 父级

定位：

- `tdesign-component/lib/src/components/skeleton/t_skeleton.dart:212-215`
- `tdesign-component/lib/src/components/skeleton/t_skeleton.dart:225-263`

证据：

- `_buildObj()` 中当 `TSkeletonRowColObj.flex != null` 时返回 `Flexible`。
- 单行多个对象场景直接返回根部 `Flexible(child: Row(...))`。
- 多行且任意对象存在 `flex` 时，也直接返回根部 `Flexible(child: Container(...))`。
- `Flexible` 只能作为 `Row` / `Column` / `Flex` 的直接子级使用，但 `TSkeleton` 是公开组件，调用方可以把它放在任意父容器中。

影响：

- `TSkeleton` 被直接放进 `Container`、`ListView`、`Padding` 等非 Flex 父级时，会触发 ParentDataWidget 使用错误。
- 组件内部把布局约束泄漏给调用方，公开组件不应要求用户知道内部何时会返回 `Flexible`。

建议：

- 不要在公开组件根部返回 `Flexible`。
- 内部行列布局需要弹性时，应只在内部 `Row` / `Column` 的 children 中使用 `Flexible`。
- 根节点可改为 `SizedBox`、`ConstrainedBox`、`Column` 或普通容器，并由内部布局自行处理 flex。
