# Review-03 待修问题整理

## 记录口径

- 本轮基于 `review-02` 问题清单继续整理。
- 用户明确列出的项目均按“尚未修复”记录，不在本文件中推定已修。
- `review-02` 中未进入本轮延续清单的问题，先按“已修复或本轮不继续跟踪”归档，后续如复现再重新开启。

## 从 review-02 延续的待修问题

### P0 输入框唤起卡顿

涉及组件：

- `TInput`
- `TTextarea`

问题：

- Android 侧唤起系统输入框/输入法时仍有明显卡顿。
- `review-02` 已记录 `TInput` demo 生命周期和重建面过大的风险，本轮需要把 `textarea` 系列一并纳入排查。

修复方向：

- 检查 `TextEditingController` / `FocusNode` 的创建、监听、解绑和释放。
- 降低 demo 输入过程中的整页 `setState` 重建范围。
- 对 `TInput` 与 `TTextarea` 做同口径真机复测，确认唤起输入法、连续输入、清除按钮和计数字段不卡顿。

### P0 Calendar cell 状态异常

涉及组件：

- `TCalendar`
- `TCalendarCell`

问题：

- `calendar` 的 cell 选中态和未选中态表现仍有问题。
- `review-02` 已记录自定义单元格/副标题没有沿用默认状态表达，本轮继续跟进实际选中/未选中的视觉和交互状态。

修复方向：

- 对照默认 `TCalendarCell` 的 selected / unselected / today / disabled / range 状态。
- 自定义 cell demo 不应覆盖掉组件标准态表达，除非明确标注为业务自定义渲染。
- 修复后补充选中、取消选中、区间态和自定义 cell 的人工验收记录。

### P1 TabBar demo 命名

涉及组件：

- `TTabBar`
- `TBottomTabBar`

问题：

- `TabBar` 的 demo 名称应该为 `TabBar`，不应展示为 `BottomTabBar`。
- 该问题和源码实现/导出命名有关，不能只改 demo 文案后结束。

修复方向：

- 区分 `TabBar` 选项卡和 `BottomTabBar` 底部标签栏两个组件入口。
- 检查配置、路由、文档标题、demo 标题和源码导出命名是否一致。
- 保留 `BottomTabBar` 作为底部标签栏入口，避免和 `TabBar` 混淆。

### P1 Indexes 右侧索引文字未居中

涉及组件：

- `TIndexes`
- `TIndexesList`

问题：

- `indexes` 的右侧索引图标/文字没有居中。
- `review-02` 已记录自定义索引缺少布局约束，本轮继续按实际居中问题修复。

修复方向：

- 默认索引项应保证触控区域和视觉内容居中。
- 自定义 `builderIndex` 示例应提供固定宽高和居中布局，或组件层统一包裹居中约束。
- 修复后复测普通索引、胶囊索引、自定义索引三类状态。

### P1 SideBar 切页用法不可点击

涉及组件：

- `TSideBar`
- `TSideBarItem`

问题：

- `sideBar` 的切页用法不能点击操作。
- `review-02` 已记录 sidebar 子页面存在 controller 生命周期隐患，本轮重点转为“切页交互不可用”。

修复方向：

- 检查 demo 中 `TSideBarController`、`PageController`、`onSelected` / 点击回调的联动。
- 确认点击侧边栏项后页面内容能同步切换。
- 补齐相关 controller 的 `dispose()`，避免切页复测中出现泄漏或白屏。

### P1 Popup 文字包裹方式

涉及组件：

- `TPopup`

问题：

- `popup` 的文字应该用 `Popup` 包裹。
- `review-02` 已记录 popup demo 文字使用方式不统一，本轮按新的包裹口径继续修正。

修复方向：

- 复核 `TPopup` demo 的标题、正文、按钮文案和触发文案。
- 按组件预期的 `Popup` 包裹方式修复示例，避免直接裸用不符合规范的文字节点。
- 修复后确认主题字号、颜色和弹层布局表现一致。

## Review-03 新增归并问题

### P1 Tag 和 SelectTag 应归为同一个组件

涉及组件：

- `TTag`
- `TSelectTag`

问题：

- `tag` 和 `SelectTag` 是同一个组件族，应统一作为一个组件处理。
- 文档、demo、review 和后续验收不要拆成两个独立组件口径。

修复方向：

- 检查 demo 入口、文档目录和组件说明是否重复拆分。
- 统一记录为 `Tag`，在同一组件页下区分普通标签与可选标签能力。

### P1 Cell 和 CellGroup 应归为同一个组件

涉及组件：

- `TCell`
- `TCellGroup`

问题：

- `Cell` 和 `CellGroup` 是同一个组件族，应统一作为一个组件处理。
- 后续修复、文档和验收应避免重复拆分口径。

修复方向：

- 检查 demo 入口、文档目录和组件说明是否重复拆分。
- 统一记录为 `Cell`，在同一组件页下说明单元格与单元格组能力。

## Review-02 对照：本轮未继续跟踪的问题

以下问题来自 `review-02`，未被用户列入本轮“尚未修复”清单；先按已修复或本轮不继续跟踪归档：

- 基础 demo：`TFab` 未绑定事件、`TLink` 部分示例未绑定事件。
- 输入 demo / 源码：`TStepper` 禁用态、`TRate` 禁用态、`TInput` controller 渲染同步、`TSearchBar` listener、`TForm` listener、`TCheckboxGroupController` 解绑、`TSlider` / `TRangeSlider` clamp、`TUpload` files 同步。
- 导航 demo / 源码：`TBackTop` 自然滚动召唤、`TNavBar` 标题溢出、`Tabs` controller 生命周期、`BottomTabBar` 布局崩溃、`TDrawer` 默认 drawerTop / footer 事件、`TTabBarIndicator` 空安全、`TDrawer` 公开面、`TSideBarController.closeLoading` 旧命名、`TBackTop` listener 重绑、`TBottomTabBar` popup 边界。
- 展示 demo / 源码：`TBadge` demo 裁剪/卡死、`TTable` 操作列溢出、`TBadge` maxCount / message 同步、`TTable` 排序修改外部 data、`TSkeleton` mounted / Flexible 根节点。
- 反馈源码：`TToast` timer、`TToast.dismissLoading()` 语义、`TMessage` marquee controller、`TNoticeBar` 垂直跑马灯强转、`TSwipeCell` controller 生命周期。

