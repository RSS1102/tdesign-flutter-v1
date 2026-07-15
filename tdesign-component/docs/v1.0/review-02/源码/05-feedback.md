# 反馈类组件待继续处理问题

## 核实口径

- 本文只记录对照 v1.0 重构目标后，当前源码中仍实际存在的问题。
- `tdesign-component/docs/v1.0/components/05-feedback/*` 不作为本次判断依据；当前组件文档尚未更新时，以实际源码实现为准。
- 本轮忽略注释、测试用例和 demo 问题，只记录源码架构或实现错误。

## P1 必修问题

### 1. `TToast` 的延迟移除 timer 没有正确挂回实例，取消时无法完整取消销毁任务

定位：

- `tdesign-component/lib/src/components/toast/t_toast.dart:23-38`
- `tdesign-component/lib/src/components/toast/t_toast.dart:349-371`

证据：

- `_ToastInstance.cancel()` 会尝试取消 `timer` 和 `disposeTimer`。
- `_showOverlay()` 先声明局部变量 `Timer? disposeTimer`，随后立即用当前值创建 `_ToastInstance`。
- 自动关闭时，`timer` 回调内部才执行 `disposeTimer = Timer(...)`。
- 这个新创建的 `disposeTimer` 只写回局部变量，没有同步到 `_toastInstances[toastId]` 里已经创建好的 `_ToastInstance`。

影响：

- Toast 进入自动关闭的 200ms 延迟移除阶段后，外部再调用 `dismissToast()` / `dismissAll()` 不能取消这条延迟移除任务。
- 已手动 remove 的 `OverlayEntry` 仍可能被延迟任务再次 remove，存在重复移除或状态不一致风险。
- `_ToastInstance.disposeTimer` 字段看起来具备取消能力，但实际不会拿到后续创建的 timer，生命周期管理不闭环。

建议：

- 将 `disposeTimer` 的创建和保存收敛到 `_ToastInstance` 内部，或在创建延迟 timer 后更新 map 中实例字段。
- 避免对同一个 `OverlayEntry` 多路径重复 `remove()`；取消路径和自动关闭路径应共享同一套状态机。
- 如果需要淡出阶段，应显式区分 showing / dismissing / disposed 三态。

### 2. `TToast.dismissLoading()` 会关闭所有默认生成 id 的 Toast，语义过宽

定位：

- `tdesign-component/lib/src/components/toast/t_toast.dart:46-47`
- `tdesign-component/lib/src/components/toast/t_toast.dart:52-69`
- `tdesign-component/lib/src/components/toast/t_toast.dart:184-280`
- `tdesign-component/lib/src/components/toast/t_toast.dart:299-310`

证据：

- 默认 id 统一由 `_generateToastId()` 生成，格式都是 `toast_${_instanceCounter++}`。
- `showText()`、`showIconText()`、`showSuccess()`、`showWarning()`、`showFail()`、`showLoading()`、`showLoadingWithoutText()` 都可能使用同一类 `toast_` 前缀 id。
- `dismissLoading()` 通过 `entry.key.startsWith('toast_')` 收集目标，然后逐个 `dismissToast(id)`。
- 该筛选条件没有识别 Toast 类型，实际会关闭所有默认 id 的 Toast，而不只是 loading Toast。

影响：

- 业务调用 `dismissLoading()` 期望只关闭加载提示时，普通文本 Toast、成功/失败 Toast 也可能被一起关闭。
- 如果用户未显式传入自定义 `toastId`，几乎所有 Toast 都会被误认为 loading。
- API 名称和实际行为不一致，属于反馈类组件的全局状态管理错误。

建议：

- `_ToastInstance` 应记录 Toast 类型，例如 text / iconText / loading / loadingWithoutText。
- `dismissLoading()` 只筛选 loading 类型实例，不依赖 id 前缀。
- 若 v1.0 不需要旧式 `dismissLoading()`，应彻底删除该兼容入口，改为让调用方保存 `showLoading()` 返回的 id 并调用 `dismissToast(id)`。

### 3. `TMessage` marquee 路径重复创建动画控制器，并在 build 中反复注册延迟任务

定位：

- `tdesign-component/lib/src/components/message/t_message.dart:143-169`
- `tdesign-component/lib/src/components/message/t_message.dart:197-207`
- `tdesign-component/lib/src/components/message/t_message.dart:229-255`
- `tdesign-component/lib/src/components/message/t_message.dart:171-177`

证据：

- `initState()` 先创建一次 `AnimationController(vsync: this)`。
- 当 `widget.marquee != null` 时，又重新给 `animationController` 赋值为新的 `AnimationController`，第一次创建的 controller 没有 dispose。
- `getText()` 在 build 过程中，如果 `marquee.delay > 0`，会执行 `Future.delayed(..., startAnimation)`。
- build 可能被多次触发，因此同一个 Message 会注册多条延迟启动任务。
- `dispose()` 只 dispose 当前 `animationController`，无法清理前面被覆盖的 controller，也无法取消 build 中创建的 delayed 任务。

影响：

- marquee 模式下存在动画 controller 泄漏。
- 多次 build 后，可能出现多个 delayed 回调同时调用 `startAnimation()`，造成重复 setState 或状态抖动。
- Message 是反馈类临时浮层组件，生命周期短，未取消的异步任务更容易在关闭后继续触发。

建议：

- 只创建一次动画 controller，根据 marquee 配置设置 duration。
- 不要在 build 中注册 `Future.delayed`；延迟启动应放在 init/update 生命周期中，并可取消。
- 在 `dispose()` 中取消所有 pending delayed 任务，或使用可取消的 `Timer` 字段。

### 4. `TNoticeBar` 垂直跑马灯强转 `List<String>`，但构造器允许传 `String`

定位：

- `tdesign-component/lib/src/components/notice_bar/t_notice_bar.dart:10-20`
- `tdesign-component/lib/src/components/notice_bar/t_notice_bar.dart:58-67`
- `tdesign-component/lib/src/components/notice_bar/t_notice_bar.dart:253-293`

证据：

- 构造器 assert 允许 `content == null || content is String || content is List<String>`。
- `initState()` 将 `widget.content` 原样赋给 `_content`。
- 当 `Theme` 中开启 marquee 且 `direction == Axis.vertical` 时，`_contentWidget()` 直接执行 `var content = _content as List<String>`。
- 如果用户传入的是合法的 `String`，该路径会在运行时发生类型转换错误。

影响：

- `TNoticeBar(content: 'xxx', direction: Axis.vertical)` 是构造器允许的输入，但在垂直 marquee 下会崩溃。
- API 入参校验和内部渲染分支不一致，属于明确的源码实现错误。

建议：

- 垂直滚动模式应在构造/解析阶段要求 `List<String>`，或将单个 `String` 自动转换为单元素列表。
- 类型分支应在进入 `_step()` / `_contentWidget()` 前完成统一归一化，避免渲染中强转。
- 对不支持的组合应主动 assert 或降级为横向/静态展示。

### 5. `TSwipeCell` 对 controller 的生命周期和所有权处理错误

定位：

- `tdesign-component/lib/src/components/swipe_cell/t_swipe_cell.dart:108-124`
- `tdesign-component/lib/src/components/swipe_cell/t_swipe_cell.dart:144-154`
- `tdesign-component/lib/src/components/swipe_cell/t_swipe_cell.dart:157-164`

证据：

- `controller` 字段声明为 `late final SlidableController controller`。
- `initState()` 中给 `controller` 赋值为外部 `widget.controller` 或内部创建的 `SlidableController(this)`。
- `didUpdateWidget()` 在 `oldWidget.controller != widget.controller` 时再次给 `controller = ...` 赋值；由于字段是 `late final`，第二次赋值会触发 late final 重复赋值错误。
- `dispose()` 无条件执行 `controller.dispose()`，即使该 controller 是外部传入的。

影响：

- 父组件运行期切换 `controller` 时，组件会因 late final 重复赋值崩溃。
- 外部传入的 `SlidableController` 会被组件 dispose，调用方如果复用或自行管理该 controller，会遇到被提前释放的问题。
- controller 所有权不清晰，和 Flutter 常见“外部 controller 由外部 dispose，内部 controller 由组件 dispose”的约定不一致。

建议：

- 将 `controller` 拆为内部字段，并记录 `_ownsController`。
- 外部 controller 切换时，解绑旧 controller listener；仅当旧 controller 为内部创建时才 dispose。
- 内部创建 controller 时由组件 dispose；外部传入 controller 时只解绑 listener，不 dispose。
