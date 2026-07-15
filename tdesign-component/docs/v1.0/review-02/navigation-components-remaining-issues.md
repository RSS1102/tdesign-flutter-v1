# 导航组件待继续处理问题

## 核实口径

- 本文只记录对照 v1.0 设计口径后，当前源码中仍实际存在的问题。
- `tdesign-component/docs/v1.0/components/02-navigation/*` 只作为目标口径，不作为被 review 对象。
- 已核实不再作为问题：`TIndexesAnchor` / `TIndexesList` 公开导出与 API 生成名单符合当前 v1.0 `indexes.md` 目标口径，不能再按“不应公开”记录为源码问题。

## P1 必修问题

### 1. `TTabBarIndicator` / `TTabBarVerticalIndicator` 仍有空安全风险

定位：

- `tdesign-component/lib/src/components/tabs/t_tab_bar.dart:220-254`
- `tdesign-component/lib/src/components/tabs/t_tab_bar.dart:275-305`

证据：

- `TTabBarIndicator.context` 是 `BuildContext?`，构造参数也是可选。
- `_TTabBarIndicatorPainter` 中使用 `decoration.context!.tTheme.brandNormalColor`。
- `TTabBarVerticalIndicator.context` 同样可空，但 `_TTabBarVerticalIndicatorPainter` 中也强解包 `decoration.context!`。

影响：

- 用户直接构造 `const TTabBarIndicator()`，且不传 `indicatorColor/context` 时，绘制阶段可能触发空指针。
- 垂直指示器没有 `indicatorColor` 兜底参数，风险更直接。

建议：

- 不要将 `BuildContext?` 作为 Decoration 的运行时必要依赖。
- 将颜色解析前移到 `TTabBar` 构建阶段，传入非空颜色；或让 `context` 必填；或给 painter 提供明确默认颜色兜底。

### 2. `Tabs` / `TabBar` v1.0 命名迁移仍未完成

定位：

- `tdesign-component/lib/src/components/tabs/t_tab_bar.dart:8-12`
- `tdesign-component/lib/src/components/tabs/t_tab_bar_view.dart:5-19`
- `tdesign-component/lib/src/components/tabs/t_tab_bar_theme_data.dart:7-31`
- `tdesign-component/lib/src/components/tabbar/t_bottom_tab_bar.dart:147-176`
- `tdesign-component/lib/src/components/tabbar/t_bottom_tab_bar_theme_data.dart:5-9`
- `tdesign-component/lib/tdesign_flutter.dart:158-169`
- `tdesign-component/demo_tool/all_build.sh:36-39`

证据：

- 页内 Tabs 目录仍实现并导出 `TTabBar`、`TTabBarView`、`TTabBarThemeData`、`TTabBarVariant`。
- 底部标签栏目录仍实现并导出 `TBottomTabBar`、`TBottomTabBarThemeData`。
- API 生成脚本仍用 `TBottomTabBar...` 生成 `tab-bar`，用 `TTabBar,TTab,TTabBarView` 生成 `tabs`。
- v1.0 目标命名应为：页内 Tabs 使用 `TTabsBar` / `TTabsBarView` / `TTabsBarThemeData`；底部标签栏使用 `TTabBar` / `TTabBarThemeData`。

影响：

- 当前源码公开 API 与 v1.0 目标 API 不一致，用户仍会看到旧的页内 `TTabBar` 和旧的底部 `TBottomTabBar`。
- 这不是 demo 入口拼写问题，而是源码类名、Theme 类型、barrel export、API 生成脚本都尚未完成迁移。
- 如果继续基于当前源码生成 API，会把旧命名固化到 v1.0 API 文档中。

建议：

- `tabs/`：将 `TTabBar` / `TTabBarView` / `TTabBarThemeData` / `TTabBarVariant` 收敛为 `TTabsBar` / `TTabsBarView` / `TTabsBarThemeData` / `TTabsBarVariant`。
- `tabbar/`：将 `TBottomTabBar` / `TBottomTabBarThemeData` / 相关 config 类型收敛为 `TTabBar` / `TTabBarThemeData` / `TTabBarItemConfig` 等 v1.0 命名。
- 同步更新 `tdesign_flutter.dart` export 和 `demo_tool/all_build.sh` 生成名单。
- 迁移期间如保留 deprecated 别名，也不应作为 v1.0 主 API 继续生成。

### 3. `TDrawer` 命令式 API 和公开面仍未收敛

定位：

- `tdesign-component/lib/src/components/drawer/t_drawer.dart:18-37`
- `tdesign-component/lib/src/components/drawer/t_drawer.dart:60-64`
- `tdesign-component/lib/src/components/drawer/t_drawer.dart:78-91`
- `tdesign-component/lib/src/components/drawer/t_drawer.dart:104-155`
- `tdesign-component/lib/src/components/drawer/t_drawer_widget.dart:13-15`
- `tdesign-component/lib/src/components/drawer/t_drawer_widget.dart:41-45`
- `tdesign-component/lib/src/components/drawer/t_drawer_widget.dart:101-104`
- `tdesign-component/lib/tdesign_flutter.dart:42-44`
- `tdesign-component/demo_tool/all_build.sh:26-27`

证据：

- `TDrawer.show()` 当前返回 `void`，只把 `TPopupHandle` 存在实例字段 `_drawerHandle` 中。
- 源码仍保留 `open()` / `close()` 实例方法，调用方需要持有 `TDrawer` 对象本身才能关闭，不是一次 `show()` 返回一次 handle 的清晰命令式模型。
- `title` 仍是 `String? title` + `Widget? titleWidget` 双路径，并继续透传给 `TDrawerWidget` / `TCellGroup`。
- 构造器仍暴露 `style`、`hover`、`backgroundColor`、`bordered`、`isShowLastBordered` 等样式参数，Theme 收敛不彻底。
- `TDrawerWidget` 仍通过 `tdesign_flutter.dart` 公开导出。
- API 生成脚本仍将 `TDrawerWidget` 放入 drawer 生成名单。

影响：

- Drawer 的公开 API 面仍偏 0.2.x，对 v1.0 重构后的调用模型不够明确。
- `open()` / `close()` 与 `show()` 并存，会让用户不清楚应该持有 `TDrawer` 对象还是持有本次打开返回的 handle。
- `String title` 与 `titleWidget` 双路径继续增加内容槽规则复杂度，也会影响公开 API 说明一致性。
- `TDrawerWidget` 如果只是内部拼装组件，公开导出会扩大用户可依赖面，后续收口成本更高。

建议：

- 将 `show()` 改为返回 `TDrawerHandle`，由 handle 提供 `close()` / `isShowing`。
- 删除 `open()` / `close()` 实例入口，收敛为 `TDrawer(context, ...).show()` 的唯一打开路径。
- 将 `title` 收敛为单一 `Widget? title` 内容槽，删除 `String? title` + `titleWidget` 双路径。
- 样式参数继续迁入 `TDrawerThemeData`，构造器只保留内容、行为、布局类参数。
- 若 `TDrawerWidget` 不是用户级组件，应从 public export 和 API 生成名单中移除。


### 4. `TIndexesList` 默认右侧索引项视觉/触控中心偏移

定位：

- `tdesign-component/lib/src/components/indexes/t_indexes_list.dart:76-85`
- `tdesign-component/lib/src/components/indexes/t_indexes_list.dart:138-165`

证据：

- 右侧索引栏整体通过 `Positioned(right: context.tTheme.spacer8)` 靠右放置。
- 默认索引项的文字虽然在 `_indexSize x _indexSize` 内容盒中 `Center`，但外层额外包了一层 `padding: EdgeInsets.only(left: context.tTheme.spacer8)`。
- 单侧 left padding 会让实际触控盒/视觉盒变成“左侧 8dp + 20x20 内容”，整体中心与文字中心不一致。

影响：

- 默认索引项由组件源码实现，不是 demo 自定义 builder 造成的问题。
- 在右侧靠边展示时，用户容易看到索引文字或选中圆点不在整体触控区域中心。

建议：

- 默认索引项应使用固定宽度、对称 padding 或统一 hit box，并在内部居中渲染文字。
- 不建议通过单侧 padding 扩大触控区；触控区和视觉中心应保持一致。
- 自定义 `builderIndex` 仍可由 demo/业务自己负责布局，但默认态需要由组件源码保证居中。


## P2 建议彻底收口

### 5. `TSideBarController.closeLoading` 仍保留兼容旧命名

定位：

- `tdesign-component/lib/src/components/sidebar/t_sidebar_controller.dart:60-63`

证据：

- `TSideBarController` 仍保留 `closeLoading(bool load, {bool needNotify = true})` 方法，并直接代理到 `setLoading`。
- 当前 v1.0 是完全重构阶段，不需要短期兼容旧 API。

影响：

- 与“彻底重构、收敛到 v1.0 唯一 API”的路线不一致。
- 用户会继续看到旧入口，增加 API 理解成本。

建议：

- 删除 `closeLoading`。
- 统一保留 `setLoading` 或 `loading` setter 作为唯一加载态控制入口。
- 同步更新导出和生成 API。

### 6. `TBackTop` listener 重绑逻辑仍有 Theme 边界

定位：

- `tdesign-component/lib/src/components/backtop/t_backtop.dart:77-92`
- `tdesign-component/lib/src/components/backtop/t_backtop.dart:115-126`

证据：

- `didChangeDependencies` 中调用 `_attachScrollListener()`，但 `_listenerAttached` 为 true 时直接返回。
- `didUpdateWidget` 只在 `controller` 或 `visibilityOffset` 变化时解绑重绑。
- 如果仅 Theme 中的 `defaultVisibilityOffset` 变化，当前逻辑不会重新绑定 listener，也不一定完整刷新显隐阈值状态。

影响：

- Theme 切换后是否立即更新显隐状态依赖后续滚动事件，不够完整。

建议：

- 在 `didChangeDependencies` 中检测有效阈值变化，并立即 `_updateVisibility`。
- 或将监听绑定与阈值刷新拆开：listener 只绑定 controller，阈值变化单独刷新状态。

### 7. `TBottomTabBar` popup 边界处理仍有硬编码偏移

定位：

- `tdesign-component/lib/src/components/tabbar/t_bottom_tab_bar.dart:1137-1150`

证据：

- 实现中仍有 `8`、`4`、`8.0` 等硬编码偏移，用于箭头间距、父级 padding 和视口安全边距。

影响：

- 当前不构成明显运行 bug。
- 但从源码整洁性和 v1.0 可维护性看，设计距离散落在实现中会增加后续误改成本。

建议：

- 抽出 `_kPopupButtonPadding`、`_kPopupArrowGap`、`_kPopupViewportPadding` 等私有常量。
