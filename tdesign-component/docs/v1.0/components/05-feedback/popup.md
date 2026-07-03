# TPopup — v1.0 定稿

> Sprint **S4** | 控制类 **E** | Material: `PopupRoute` + Navigator
> 源码：`lib/src/components/popup` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Overlay / Route；**仅**命令式 `show` |
| Material | `PopupRoute` + Navigator |
| Theme | `TPopupThemeData` |
| 禁用 | 浮层 无 Widget 级 disabled / enable |
| L4 | 构造器 L4 → `TPopupThemeData` |

## 控制方案

**仅**命令式 `TPopup.show()` → `TPopupHandle`；`handle.close()` 关闭。对齐 Material `Navigator` + `PopupRoute` / `showModalBottomSheet`。**不提供** Widget 级 `visible` / `onVisibleChange` 声明式显隐。无 Widget 级 `disabled`。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| TPopup | E 类 show 入口 |
| TPopup.show | 打开浮层 |
| TPopupOptions | 单次参数见组件 |
| TPopupHandle | 生命周期句柄 |
| TPopupPlacement | 五向 + center |
| TPopupTrigger | 关闭来源 |
| TPopupBottomInset 等 | 方向 inset |
| TPopupThemeData | L4 默认 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| 零散构造器 L4 | TPopupThemeData | L4 → Theme |

### 废弃

| 符号 | 原因 |
| --- | --- |
| `defaultVisible` / Widget `visible` + `onVisibleChange` | 移出；仅 `TPopup.show` + `TPopupHandle` |
| Widget 级 `disabled` | E 类无容器禁用 |
| 错误文档项 `context`→Theme | `BuildContext` 为 `show` 首参，不进 Theme |

### 新增

_无_

### show API（`TPopup.show`）

| 参数 | 层级 | v1.0 | 说明 |
| --- | --- | --- | --- |
| `context` | E 首参 | **保留** | `BuildContext` |
| `options` | L2–L3 | **保留** | `TPopupOptions` 命名工厂 bottom/center/… |
| `child` | L2 | **保留** | 浮层内容 |
| `placement` | L1 | **保留** | `TPopupPlacement` |
| `onVisibleChange` / `onClose` | L3 | **保留** | **show 生命周期通知**（非声明式持态） |
| `closeOnOverlayClick` | L3 | **保留** | 对齐 `barrierDismissible` |
| `height` / `width` / `inset` | L1/L4 | **保留实例** | 方向相关尺寸 |
| `overlayColor` / `animationDuration` / `animationCurve` | L4 | → Theme | 蒙层**色**与过渡动效（**非** `showOverlay` 开关） |
| `closeOnOverlayClick` / `showOverlay` | L3 | **保留** `TPopupOptions` / show | 浮层策略；**不进 Theme** |
| header/cancel/confirm builder | L2 | **保留** | bottom/center 操作区 |

### L4 迁入 `TPopupThemeData`

| 0.2.x 来源 | Theme 字段 | Material 对照 |
| --- | --- | --- |
| `overlayColor` | `barrierColor` | `ModalRoute` |
| `animationDuration` | `transitionDuration` | Route |
| `animationCurve` | `reverseTransitionDuration` 同曲线或独立 | Route 曲线 |
| 默认 header 文案/样式 | `headerStyle` / `cancelText` / `confirmText` | TDesign 扩展 |
| 圆角 | `panelRadius` | BottomSheet 近似 |
| `useSafeArea` | — | **不进 Theme** → `TPopupOptions` L3（见 §3） |

### export

- **保留**：`TPopup`、`TPopup.show`、`TPopupOptions`、`TPopupHandle`、`TPopupPlacement`、`TPopupTrigger`、inset 类型、`TPopupThemeData`、builder typedef
- **移出**：`_PopupNavigatorRoute` 等 `_*` 内部实现（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. TPopup 业务壳约定 {#2-tpopup-业务壳约定}

基于 `TPopup.show` 的**业务组件**（侧滑抽屉、ActionSheet 等），v1.0 统一：

| 规则 | 说明 |
|------|------|
| `show` 返回值 | `T{Xxx}Handle`（**不**对外暴露 `TPopupHandle`） |
| 关闭 | **`handle.close()`** 为唯一推荐入口 |
| 查询 | `handle.isShowing`（业务壳暴露；底座 `TPopupHandle` 另有 `open()`） |
| 回调 | `onClose` / `onClosed` 保留，**不替代** Handle |
| 非 `Future` | 生命周期用 Handle + 回调；**不要求**调用方 `await` |
| 蒙层行为 L3 | `showOverlay` / `closeOnOverlayClick` 留在**单次 show/构造器**；**不进 Theme**（归类 → [theme.md §2.1](../foundation/theme.md#21-themedata-字段归类v10-裁决)） |

### 适用组件

| 组件 | 打开 | 返回 | 文档 |
|------|------|------|------|
| **TPopup**（底座） | `TPopup.show` | `TPopupHandle` | 本文 §1 |
| **TDrawer** | `TDrawer(...).show()` | `TDrawerHandle` | [drawer.md](../02-navigation/drawer.md) |
| **TActionSheet** | `showList/Grid/GroupActionSheet` | `TActionSheetHandle` | [action-sheet.md](./action-sheet.md) |

### 与 Flutter / TDialog 分工

| 模型 | 适用 | 说明 |
|------|------|------|
| **Handle** | TPopup 系（上表） | TDesign 浮层栈约定；对齐 `TPopupHandle` 语义 |
| **`Future<T?>`** | `TDialog` / `TPopover` | 对齐 `showDialog`；需 `await` 结果 |

> 业务壳 **不** 透传 `TPopupOptions`；L4 蒙层**色/动画**走 `TPopupThemeData`，内容区走各组件 `T{Xxx}ThemeData`。`showOverlay` / `closeOnOverlayClick` 为 L3 行为，随单次打开传入。

**示例（三组件同一心智）**：

```dart
// 底座
final popup = TPopup.show(context, options: TPopupOptions.bottom(child: panel));

// Drawer
final drawer = TDrawer(context, items: [...]).show();

// ActionSheet
final sheet = TActionSheet.showListActionSheet(context, items: [...]);

popup.close();
drawer.close();
sheet.close();
```

---

## 3. Theme {#3-theme}

`TPopupThemeData` · 字段归类 → [theme.md §2.1](../foundation/theme.md#21-themedata-字段归类v10-裁决) · Material: **`PopupRoute` + Navigator**

### `TPopupThemeData` 字段（样式）

| 字段 | 类别 | 说明 |
|------|------|------|
| `overlayColor` | 色 | 蒙层色；对齐 `ModalRoute.barrierColor` |
| `animationDuration` | 动效 | 入/出过渡时长 |
| `animationCurve` | 动效 | 入/出曲线 |
| `panelRadius` | 圆角 | 面板圆角默认 |

> **不进 Theme**：`showOverlay` · `closeOnOverlayClick` · `useSafeArea`（单次 `TPopupOptions` / show L3）。

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `Navigator.push` / `PopupRoute` | Material **Route** | `TPopup.show` 实现基础 |
| `barrierColor` / `transitionDuration` | Material **`ModalRoute`** | → `overlayColor` / `animationDuration` / `animationCurve` |
| `useRootNavigator` | Material **`showDialog`** 等同名参数 | `show` 可选参数 |
| `child` | Material **Route 内容** | 实例 KEEP |
| `placement`（五向 + center） | **TDesign 扩展** | Material 仅 bottom/center 有标准 API |
| `headerBuilder` / cancel / confirm / close 槽位 | **TDesign 扩展** | bottom/center 操作区 |
| `TPopupThemeData` 默认 L4 | TDesign 扩展 | 子树 mergeExtension |
