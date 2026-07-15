# Demo 实测问题诊断

## 诊断口径

- 范围：`feat/huihuixiaotx_20260713_ui_test` 分支中 01 基础组件、02 导航组件的 example demo。
- 目标：只记录 demo 实测暴露的问题、源码定位、初步根因和是否建议进入 review。
- 验证：已对相关 demo 文件执行定向 `flutter analyze`，结果为 `No issues found`。因此以下问题主要是 demo 交互、布局、状态管理或运行时体验问题，不是 Dart 静态编译错误。

## 基础组件 Demo

### 1. `TFab` demo 未绑定事件，示例整体呈禁用态

定位：

- `tdesign-component/example/lib/page/t_fab_page.dart:93-170`

证据：

- 多个 `TFab` 示例均使用 `const TFab(...)`，没有传入 `onPressed`。
- `TFab` 按 v1.0 A 类禁用约定，`onPressed == null` 时呈禁用态。

诊断：

- 这是 demo 配置问题，不是 `TFab` 组件本身错误。
- 当前 demo 的目标是展示类型、配色、尺寸、拖拽，但因为未传 `onPressed`，用户看到的是“全部禁用”的视觉状态，无法正确观察正常态。

Review 建议：

- 需要进入 demo review。
- 所有非“禁用状态”示例应传入空操作或可见反馈回调，例如 `onPressed: () {}` 或 toast/log。
- 如需展示禁用态，应单独增加“禁用状态”示例，而不是让全部示例隐式禁用。

### 2. `TLink` 部分示例未绑定事件，意外呈禁用态

定位：

- `tdesign-component/example/lib/page/t_link_page.dart:67-81`
- `tdesign-component/example/lib/page/t_link_page.dart:149-157`
- `tdesign-component/example/lib/page/t_link_page.dart:174-184`

证据：

- `_buildLinksWithVariant` 创建的基础、下划线、图标链接没有传 `onPressed`。
- `_buildLinkWithColorScheme` 和 `_buildLinkWithSize` 已传 `onPressed`，只有显式 `disabled: true` 时才置空。

诊断：

- 这是 demo 配置不一致问题。
- `TLink` 的禁用语义是 `onPressed == null`，因此组件类型区域的示例会被误展示为禁用态，而颜色/尺寸区域是正常态。

Review 建议：

- 需要进入 demo review。
- `_buildLinksWithVariant` 中的正常链接应补 `onPressed`。
- “禁用状态”示例继续保留 `onPressed: null`。

## 导航组件 Demo

### 3. `TBackTop` demo 无法通过滚动自然召唤组件

定位：

- `tdesign-component/example/lib/page/t_backtop_page.dart:43-78`
- `tdesign-component/example/lib/page/t_backtop_page.dart:81-114`
- `tdesign-component/example/lib/page/t_backtop_page.dart:131-153`

证据：

- `TBackTop` 绑定了 `ExamplePage.scrollController`，`visibilityOffset: 100`。
- 圆形示例只有一个按钮，页面内容高度不足，用户无法通过自然滚动达到阈值。
- 半圆形示例虽然生成 `getDemoBox`，但 `getDemoBox` 内多个 `Container` 只有 decoration，没有宽高或 child，实际不贡献可见内容高度。
- 当前主要依赖按钮点击时 `controller.jumpTo(500)`，不是通过用户滚动自然触发。

诊断：

- 这是 demo 内容高度不足问题。
- 组件本身是否可滚动显示无法通过当前 demo 自然验证。

Review 建议：

- 需要进入 demo review。
- demo 应提供足够高度的内容区，例如多段文本、固定高度占位块或列表。
- 按钮可作为辅助触发，但不能替代自然滚动验证。

### 4. `TNavBar` demo 标题尺寸示例存在文字溢出风险

定位：

- `tdesign-component/example/lib/page/t_navbar_page.dart:169-195`
- `tdesign-component/lib/src/components/navbar/t_nav_bar.dart:281-289`

证据：

- `_titleBelowNavbar` 中 `belowTitleWidget` 使用 `TText(titleText, font: Font(size: 28, lineHeight: 52))`。
- `TNavBar._getNavbarChild` 在有 `belowTitleWidget` 时使用 `Column(children: [Expanded(child: toolbar), belowTitleWidget])`。
- `TNavBar` 默认高度仍为 `48`，demo 未显式增大 `height`。

诊断：

- 这是 demo 参数和组件布局能力不匹配问题。
- 下方大字号标题需要更高的 NavBar 容器，否则容易在 48 高度内压缩或溢出。

Review 建议：

- 需要进入 demo review。
- `_titleBelowNavbar` 应设置合理 `height`，或调整 `belowTitleWidget` 字号/行高。
- 如该示例用于展示“大标题导航”，应明确这是多行/扩展高度场景。

### 5. `Tabs` demo 白屏 / 进入后卡死风险：大量 `TabController` 在 build 中创建且未释放

定位：

- `tdesign-component/example/lib/page/t_tabs_page.dart:84-89`
- `tdesign-component/example/lib/page/t_tabs_page.dart:168-225`
- `tdesign-component/example/lib/page/t_tabs_page.dart:254-318`

证据：

- `_tabController1` 至 `_tabController4` 在 `initState` 创建，但页面没有 `dispose` 释放。
- 多个 demo builder 在每次 build 时直接创建 `TabController(length: ..., vsync: this)`。
- `_buildItemWithContent` 也在局部创建 `tabController` 并传给 `TTabBar` / `TTabBarView`，没有生命周期管理。

诊断：

- 这是高优先级 demo 生命周期问题。
- 进入页面后滚动、主题切换、状态变化、CodeWrapper 重建都可能不断创建新的 ticker/controller，造成内存和 ticker 泄漏，最终表现为白屏、卡顿或卡死。

Review 建议：

- 需要进入 demo review，优先级高。
- 所有 `TabController` 应提升到 State 字段统一创建，并在 `dispose` 中释放。
- 对仅用于静态展示的示例，优先使用 `DefaultTabController` 包裹局部 demo，避免手动创建无释放 controller。
- TabBar 页面修复后再复测“十几秒后卡死”现象。

### 6. `BottomTabBar` demo 布局异常导致页面崩溃，且入口名称需要区分 `Tabs` 与 `BottomTabBar`

定位：

- `tdesign-component/example/lib/config.dart:229-237`
- `tdesign-component/example/lib/page/t_tabs_page.dart:95-98`
- `tdesign-component/example/lib/page/t_bottom_tab_bar_page.dart:41`
- `tdesign-component/example/lib/page/t_bottom_tab_bar_page.dart:597-628`

证据：

- 配置中 TabBar 所在页面入口文本是 `Tabs 选项卡 (V1.0)`，路由名是 `tabs`。
- `BottomTabBar` 独立入口文本是 `BottomTabBar 底部标签栏 (V1.0)`，路由名是 `bottomTabBar`。
- 当前源码未发现 `bootomTabBar` 拼写。
- `_setValueToTabBar` 示例返回 `SizedBox(child: Column(mainAxisSize: MainAxisSize.min, children: [Expanded(child: PageView(...)), TBottomTabBar(...)]))`。
- 该示例位于 `ExamplePage` 的滚动示例列表中，外层会给列表项不定高约束；在不定高列表项中使用 `Expanded(PageView)` 会导致子节点无法完成尺寸计算。
- 用户实测该异常发生在底部标签栏页面，而不是 Indexes 页面：
  - `package:flutter/src/rendering/object.dart:2741`：`!_debugDoingThisLayout` is not true。
  - `package:flutter/src/rendering/sliver_multi_box_adaptor.dart:638`：`child.hasSize` is not true。
- 该异常与滚动列表项中无明确高度的 `Expanded/PageView` 布局链路一致。

诊断：

- 从源码看，入口命名不是 `bootomTabBar` 拼写错误。
- 但组件命名上，`TTabBar` 被放在 `Tabs` 页面下，用户实测时可能会把页面入口与组件名混淆。
- 页面崩溃应归因于 `BottomTabBar` demo 的 `_setValueToTabBar` 布局写法；当前不应记录到 Indexes 或 Drawer。
- `PageView` 必须有明确高度；不能直接放在滚动列表项内的 `Expanded` 中，除非外层提供确定高度约束。

Review 建议：

- 需要进入 demo review，崩溃问题优先级高。
- `_setValueToTabBar` 应为 `PageView` 外层提供明确高度，例如 `SizedBox(height: 240, child: PageView(...))`，或把整个示例改为固定高度容器内的 `Column`。
- 避免在 `ExamplePage` 的滚动列表项中直接使用 `Expanded` / `Flexible` 包裹 `PageView`。
- 如果 v1.0 文档组件名统一叫 `TabBar`，入口文案建议改为 `TabBar 选项卡 (V1.0)` 或 `Tabs / TabBar 选项卡 (V1.0)`。
- 保留 `BottomTabBar` 作为底部标签栏入口，避免两者混淆。

### 7. `TDrawer` demo 默认示例不应全部传 `drawerTop`，底部操作按钮未绑定事件

定位：

- `tdesign-component/example/lib/page/t_drawer_page.dart:76-88`
- `tdesign-component/example/lib/page/t_drawer_page.dart:102-114`
- `tdesign-component/example/lib/page/t_drawer_page.dart:127-140`
- `tdesign-component/example/lib/page/t_drawer_page.dart:152-165`
- `tdesign-component/example/lib/page/t_drawer_page.dart:185-200`
- `tdesign-component/example/lib/page/t_drawer_page.dart:215-227`
- `tdesign-component/example/lib/page/t_drawer_page.dart:169-176`
- `tdesign-component/example/lib/page/t_drawer_page.dart:126-132`
- `tdesign-component/example/lib/page/t_drawer_page.dart:91-92`

证据：

- 多个 Drawer 示例都通过 `navBarkey.currentContext?.findRenderObject()` 获取 NavBar 高度，并传给 `drawerTop`。
- `drawerTop` 是顶部偏移能力，适合单独演示“避让顶部区域 / 指定顶部偏移”，不适合作为所有默认 Drawer 示例的共同写法。
- “带底部插槽样式”中的 footer `TButton` 没有 `onPressed`，因此按 A 类禁用规则呈禁用态。
- “带标题抽屉”示例已传 `title: '标题'`，所以顶部未到顶不应归因于 title 未渲染。
- “带标题抽屉”的按钮文案仍写为 `带图标抽屉`。
- 基础抽屉示例使用 `print(...)` 输出点击事件。

诊断：

- 顶部未到顶是 demo 主动传入 `drawerTop: renderBox?.size.height` 的结果，不是组件 title 未渲染，也不是 Drawer 默认展示位置本身的直接证据。
- 默认 Drawer 示例应展示不传 `drawerTop` 的常规效果；`drawerTop` 应拆成独立 demo，专门说明顶部偏移/避让场景。
- 底部操作按钮禁用是明确 demo 配置问题。

Review 建议：

- 需要进入 demo review。
- 将“基础抽屉”“带图标抽屉”“带标题抽屉”“带底部插槽样式”“自定义背景色”“使用 child 自定义内容”等默认示例中的 `drawerTop` 移除。
- 新增或保留一个单独示例，例如“指定顶部偏移抽屉”，只在该示例中传 `drawerTop`，用于展示避让 NavBar / SafeArea 的能力。
- footer 操作按钮应补 `onPressed`，或单独标记为禁用示例。
- 修正“带标题抽屉”按钮文案。
- 示例中的 `print(...)` 建议替换为统一反馈方式或删除。

### 8. `TIndexes` demo 不应默认传顶部 inset，自定义索引缺少布局约束

定位：

- `tdesign-component/example/lib/page/t_indexes_page.dart:151-165`
- `tdesign-component/example/lib/page/t_indexes_page.dart:184-198`
- `tdesign-component/example/lib/page/t_indexes_page.dart:218-232`
- `tdesign-component/example/lib/page/t_indexes_page.dart:232-241`

证据：

- 基础、胶囊、自定义索引三个 demo 都通过 `navBarkey.currentContext?.findRenderObject()` 获取 NavBar 高度，并传给 `TPopupRightInset(top: renderBox?.size.height ?? 0)`。
- 这和 Drawer demo 的 `drawerTop` 问题类似：顶部偏移适合单独演示，不适合成为默认索引示例的共同写法。
- 自定义索引 demo 的 `builderIndex` 直接返回 `TText('自定义 $index')`，没有固定宽高或居中约束。
- 用户提到的 `child.hasSize` / `!_debugDoingThisLayout` 崩溃已确认发生在底部标签栏页面，本条不记录该异常。

诊断：

- 默认 Indexes 示例应展示不传顶部 inset 的常规弹层效果；顶部避让应拆成独立 demo，专门说明 Popup inset / 顶部偏移能力。
- 自定义索引“不居中”是 demo builder 未提供布局约束，组件也没有对自定义 builder 做居中包裹。

Review 建议：

- 需要进入 demo review。
- 将基础、胶囊、自定义索引默认示例中的 `TPopupRightInset(top: renderBox?.size.height ?? 0)` 移除。
- 若需要展示顶部避让能力，应新增或保留一个单独示例，例如“指定顶部偏移索引”。
- 自定义 `builderIndex` 应返回固定宽高且居中的 widget，或明确 builder 负责完整布局。

### 9. `TSideBar` 进入 demo 白屏：入口路由未见缺失，但子页面存在生命周期隐患

定位：

- `tdesign-component/example/lib/config.dart:250-254`
- `tdesign-component/example/lib/config.dart:329-371`
- `tdesign-component/example/lib/page/sidebar/t_sidebar_page.dart:58-119`
- `tdesign-component/example/lib/page/sidebar/t_sidebar_page_pagination.dart:21`
- `tdesign-component/example/lib/page/sidebar/t_sidebar_page_custom.dart:21`

证据：

- 主入口 `sidebar` 已注册，主页面按钮也有 `onPressed` 跳转子路由。
- `sideBarExamplePage` 中子路由也已注册。
- `TSideBarPaginationPage` 和 `TSideBarCustomPage` 创建了 `PageController`，但未见 `dispose`。
- 源码层未发现“入口未注册”导致白屏的直接证据。

诊断：

- 当前白屏现象不能仅凭源码确认为入口配置问题。
- 已确认存在子页面 controller 生命周期缺口；是否就是白屏根因，需要配合真机 logcat/Flutter error overlay 复核。

Review 建议：

- 需要进入 demo review，标记为“需真机日志复核”。
- 先补齐 sidebar 子页面 `PageController.dispose()`。
- 若白屏仍复现，应抓取进入 `sidebar` 页面时的 Flutter exception / logcat，并再判断是否为布局约束或组件运行问题。

### 10. `TInput` demo 在 Android 上唤起输入法卡顿，验证码示例右侧内容溢出

定位：

- `tdesign-component/example/lib/page/t_input_page.dart:18-41`
- `tdesign-component/example/lib/page/t_input_page.dart:487-515`
- `tdesign-component/example/lib/page/t_input_page.dart:522-560`

证据：

- 页面在 `initState` 一次性创建了 30 个 `TextEditingController`，但 `dispose()` 里只取消了 `_timer`，没有释放这些 controller。
- 组件类型、状态、样式与测试区块都大量通过 `onChanged: (text) { setState(() {}); }` 驱动整页重建，输入过程中会反复刷新整个 `ExamplePage`。
- 验证码示例的 `rightBtn` 直接把 `Row`、`Container(width: 0.5)` 和 `Image.network(...)` 塞进输入框右侧，没有给图片明确尺寸，也没有为右侧区域做收敛约束。

诊断：

- 输入法卡顿更像是 demo 级生命周期和重建面过大叠加出来的体验问题，而不是 `TInput` 单点输入逻辑错误。
- 验证码示例的右侧内容溢出是 demo 布局问题，右侧插槽没有固定尺寸，`Image.network` 在窄宽度下容易把输入框撑爆。

Review 建议：

- 需要进入 demo review，优先处理。
- `TInputPage` 里创建的 `TextEditingController` 应统一释放。
- 输入示例里只保留必要的 `setState` 范围，避免每次输入都重建整页。
- 验证码示例右侧图片应显式约束宽高，右侧按钮区也应收窄成稳定尺寸。

### 11. `TStepper` demo 的禁用态展示与组件语义不一致，且 `disabled` 不能完全封住输入

定位：

- `tdesign-component/example/lib/page/t_stepper_page.dart:34-37`
- `tdesign-component/example/lib/page/t_stepper_page.dart:68-79`
- `tdesign-component/lib/src/components/stepper/t_stepper.dart:103-104`
- `tdesign-component/lib/src/components/stepper/t_stepper.dart:275-405`

证据：

- demo 里的“禁用状态”示例并没有传 `disabled: true`，只是再次渲染了三个正常 `TStepper`。
- 组件内部 `_isDisabled` 只看 `widget.onChanged == null`，并没有把 `widget.disabled` 纳入输入框可编辑性的总开关。
- `TextField.enabled` 使用的是 `!_isDisabled && !widget.disableInput`，所以当 `disabled=true` 但 `onChanged` 仍然存在时，输入框仍可能保留可编辑交互。

诊断：

- demo 的“禁用状态”并没有真正展示禁用态，是明显的示例缺失。
- 组件实现也没有把 `disabled` 作为完整禁用总开关收敛掉，导致图标按钮与文本输入的禁用语义不完全一致。

Review 建议：

- 需要进入源码 review，同时修正 demo。
- demo 里必须补出真正的 `disabled` 示例，不要拿正常态重复冒充禁用态。
- 组件内部应把 `disabled` 和 `onChanged == null` 的语义统一收敛，避免出现半禁用状态。

### 12. `TRate` demo 只展示了隐式禁用态，没有单独的禁用状态示例

定位：

- `tdesign-component/example/lib/page/t_rate_page.dart:39-42`
- `tdesign-component/example/lib/page/t_rate_page.dart:95-109`
- `tdesign-component/lib/src/components/rate/t_rate.dart:109-111`
- `tdesign-component/lib/src/components/rate/t_rate.dart:208-230`

证据：

- `TRatePage` 的“组件状态”区域没有单独传 `disabled: true` 的示例。
- 页面里多处直接使用 `TRate(value: 3)`，而 `TRate` 的禁用判断却是 `_isDisabled => widget.onChanged == null`。
- 这意味着 demo 当前看到的“完全不可操作”主要来自没传 `onChanged`，不是专门演示 `disabled` 参数。

诊断：

- 当前 demo 只把 `onChanged == null` 这一隐式禁用态展示出来了，没有把 `disabled` 参数单独讲清楚。
- 组件本身的可交互判断也偏向“回调存在即可操作”，`disabled` 更像视觉辅助参数，而不是完整的交互总开关。

Review 建议：

- 需要进入 demo review。
- 增加单独的 `disabled` 示例，区分“无回调禁用”和“显式禁用”两种语义。
- 若 v1.0 设计要求 `disabled` 作为主禁用入口，组件实现也应同步收敛。

### 13. `TCalendar` demo 自定义单元格和副标题没有沿用组件默认状态表达，选中/未选中观感偏离规范

定位：

- `tdesign-component/example/lib/page/t_calendar_page.dart:712-787`
- `tdesign-component/example/lib/page/t_calendar_page.dart:816-851`
- `tdesign-component/lib/src/components/calendar/t_calendar.dart:23-52`
- `tdesign-component/lib/src/components/calendar/t_calendar_cell.dart:169-219`

证据：

- `TCalendar` 组件内部已经明确维护 `DateSelectType`，并通过 `TCalendarCell` 的默认渲染表达 selected / empty / disabled / range 等态。
- demo 的 `_buildCustomDayCell` 直接重绘了“今天 / 已选 / 默认”三种状态，内部使用的是原生 `Text`，没有继续沿用 `TCalendarCell` 的默认字号、选中容器和副标题排版。
- `_buildPriceSubtitle` 也用原生 `Text` 拼副标题，视觉上更像业务自绘，而不是组件规范示例。

诊断：

- 日历组件本身的选中状态逻辑是存在的，问题更集中在 demo 自定义 cell 过度重绘后，状态表现不再贴近 v1.0 规范。
- 现在的示例更像“业务自定义样式演示”，而不是“组件标准态演示”。

Review 建议：

- 需要进入 demo review。
- 自定义单元格示例应保留一组基于默认态的对照，不要把 selected / unselected / today 全部改造成完全不同的视觉语言。
- 若要展示整格自定义，建议明确标注这是自定义渲染，不代表默认规范态。

### 14. `TPopup` demo 仍使用原生 `Text`，未统一切到 `TText`，主题文字表现不一致

定位：

- `tdesign-component/example/lib/page/t_popup_page.dart:29-149`
- `tdesign-component/lib/src/components/popup/t_popup.dart:34-85`

证据：

- demo 的按钮文案、标题文案、内容文案都直接使用了原生 `Text`。
- `TPopup` 组件本身已经是以 `TText` 为默认文字组件入口的弹层实现。

诊断：

- 这是 demo 的文字组件使用不统一问题，不是 Popup 核心逻辑错误。
- 直接用 `Text` 会让弹层示例和组件主题的字号、颜色、字体族表现不完全一致，影响 v1.0 文档对齐。

Review 建议：

- 需要进入 demo review。
- 示例中的标题、正文、按钮文案统一改用 `TText`，让弹层示例和主题体系保持一致。

### 15. `TBadge` demo 页面滚动卡死，数字徽标在部分示例中被默认裁剪

定位：

- `tdesign-component/example/lib/page/t_badge_page.dart:20-121`
- `tdesign-component/example/lib/page/t_badge_page.dart:240-307`
- `tdesign-component/example/lib/page/t_badge_page.dart:311-467`
- `tdesign-component/lib/src/components/badge/t_badge.dart:181-219`

证据：

- `TBadgePage` 一页里塞了大量 `CodeWrapper + Stack + Positioned + Icon/TAvatar/TButton` 示例，滚动区本身就比普通组件页更重。
- 一部分自定义示例的 `Stack` 没有显式写 `clipBehavior: Clip.none`，而 `Stack` 默认会裁剪溢出内容。
- 徽标数字类示例中，badge 往往靠 `Positioned` 挂在父容器外侧，父容器又没有稳定的预留尺寸，容易出现“徽标被切掉”的视觉问题。

诊断：

- 数字徽标被裁剪是 demo 布局问题，核心原因是父容器没有给 badge 留出足够的外溢空间，同时部分 `Stack` 没有关闭裁剪。
- 页面滚动卡死目前还不能只凭源码把根因钉死，但从结构上看，重型示例过多、嵌套层级深、滚动时重建压力大，是最直接的风险来源。

Review 建议：

- 需要进入 demo review，优先拆轻页面。
- 所有 badge 溢出式示例统一显式加 `clipBehavior: Clip.none`，并给父容器预留稳定尺寸。
- 如滚动卡死可稳定复现，再进一步拆分 `CodeWrapper` 和大图标示例定位具体重建热点。

### 16. `TTable` demo 的操作列文字容易溢出，原因是单元格布局没有做收敛

定位：

- `tdesign-component/example/lib/page/t_table_page.dart:131-163`
- `tdesign-component/example/lib/page/t_table_page.dart:209-247`

证据：

- 操作列直接在 `Row(mainAxisAlignment: MainAxisAlignment.spaceBetween)` 里放两个 `TText`，没有给文本设置弹性宽度或省略策略。
- 表格列宽在多个示例里是固定值，操作列文字又是中文短词，但一旦表格整体宽度被压缩，`Row` 里的两个文本就会先抢空间。

诊断：

- 这是 demo 单元格布局没有收敛的问题，不是表格核心数据逻辑错误。
- 当前写法更像“能展示内容”，但不是“能稳定适配不同宽度”的表格操作列写法。

Review 建议：

- 需要进入 demo review。
- 操作列应改成固定宽度 + 居中排列，或者给文本加弹性与省略，避免在窄屏上直接溢出。

## 其他验证记录

- 对以下 demo 文件执行定向 `flutter analyze`，未发现静态分析问题：
  - `t_fab_page.dart`
  - `t_link_page.dart`
  - `t_backtop_page.dart`
  - `t_navbar_page.dart`
  - `t_tabs_page.dart`
  - `t_bottom_tab_bar_page.dart`
  - `t_drawer_page.dart`
  - `t_indexes_page.dart`
  - `sidebar/t_sidebar_page.dart`
  - `sidebar/t_sidebar_page_anchor.dart`
  - `sidebar/t_sidebar_page_pagination.dart`
  - `sidebar/t_sidebar_page_custom.dart`
