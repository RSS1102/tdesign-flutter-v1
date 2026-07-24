# 导航类组件 review-03

## 结论

- 本轮按 `review-02` 方案继续收口，已修复本批次确认的问题。

## 已处理

- `TSideBarController` 删除旧的 `closeLoading` 兼容入口，加载态只保留 `setLoading` 作为唯一控制口径。
- `TDropdownItem` 延迟关闭前补上 mounted 保护，避免页面销毁后继续执行 `Navigator.maybePop`。
- `TMultiCascader` 首次滚动改成可取消 timer，避免 `didChangeDependencies` 重入后堆叠延迟任务。
- `TDropdownPanel` 展开后的 post-frame 布局回调补上 mounted 保护，避免销毁后继续读布局并触发 `setState`。
- `TIndexesList` 的 tip 隐藏 timer 补上 mounted 保护，避免页面退出后继续回写状态。
- `TTabsBarVerticalIndicator` 修正垂直指示器绘制坐标，避免把 `dx` / `width` 误用到纵轴。

## 说明

- 这项属于 `review-02` 中导航类控制器 API 收口残留。
- 当前实现不再保留旧命名的兼容层，避免 v1.0 阶段继续暴露歧义入口。
- `TDropdownItem` / `TMultiCascader` 这一组属于导航类异步生命周期残留，现已补上 mounted / cancel 保护。
