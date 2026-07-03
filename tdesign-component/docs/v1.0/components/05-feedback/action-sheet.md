# TActionSheet — v1.0 定稿

> Sprint **S4** | 控制类 **E** | Material: TPopup 组合
> 源码：`lib/src/components/action-sheet` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Overlay / Route；命令式 `show` 为主 |
| Material | `TPopup.show` + BottomSheet 视觉 |
| Theme | `TActionSheetThemeData` |
| 禁用 | 浮层无 Widget 级禁用；项级 `TActionSheetItem.disabled` KEEP |
| L4 | 布局/面板样式 → **`TActionSheetThemeData`**；蒙层**色/动画** → **`TPopupThemeData`** |

## 控制方案

**仅**命令式 `showListActionSheet` / `showGridActionSheet` / `showGroupActionSheet` → `TActionSheetHandle`（对齐 [Popup §2 业务壳](./popup.md#2-tpopup-业务壳约定) · [controlled.md §4](../../foundation/controlled.md#e-类)）。**不提供** Widget `visible` 声明式。无 Widget 级 `disabled`。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| showListActionSheet | 列表型命令式 show → `TActionSheetHandle` |
| showGridActionSheet | 宫格型命令式 show → `TActionSheetHandle` |
| showGroupActionSheet | 分组型命令式 show → `TActionSheetHandle` |
| TActionSheetHandle | 生命周期句柄；`close()` · `isShowing` |
| TActionSheetItem | 选项数据（`label` / `icon` / `badge` / `group`） |
| TActionSheetItem.disabled | 项级禁用（数据字段） |
| TActionSheetAlign | center / left / right |
| onCancel / onClose | 取消与关闭回调 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| TActionSheetTheme | variant | list / grid / group；三族 show 固定 variant |
| items | child | 命名对齐 v1.0（show 参数仍传 `List<TActionSheetItem>`） |
| description | subtitle | 列表/宫格副标题 |
| onSelected | onChanged | E 类选中回调 |
| TActionSheetItemCallback | TActionSheetOnChanged | 类型改名 |
| align / cancelText / count / rows | TActionSheetThemeData | 样式 / 布局默认 → Theme |
| itemHeight / itemMinWidth | TActionSheetThemeData | 宽高 → Theme |
| showCancel / scrollable / showPagination / useSafeArea | show* L3 | 能力 / 策略 → **不进 Theme** |

### 废弃

| 符号 | 原因 |
| --- | --- |
| TActionSheetItemCallback | → `TActionSheetOnChanged` |
| `TActionSheet(context, …)` 构造器主路径 | 改用三族 static show |
| `visible`（构造器自动 show） | 删除 → 三族 `show*` |

### 新增

| 符号 | 说明 |
| --- | --- |
| TActionSheetThemeData | L4 列表/宫格/分组默认布局 |
| TActionSheetOnChanged | `void Function(TActionSheetItem item, int index)?` |
| **TActionSheetHandle** | `show*` 返回值；包装内部 `TPopupHandle` |

### 命令式用法

三族 `show*` 均返回 **`TActionSheetHandle`**；关闭统一 **`handle.close()`**。内部 `TPopup.show` + `TPopupOptions.bottom`，**不透传** `TPopupHandle`。

```dart
final handle = TActionSheet.showListActionSheet(
  context,
  items: [
    TActionSheetItem(label: '拍照'),
    TActionSheetItem(label: '从相册选择'),
  ],
  onChanged: (item, index) {
    debugPrint('选中: ${item.label}');
    handle.close(); // 是否点项即关由业务定
  },
  onClose: () => debugPrint('面板已关'),
);

handle.close();
```

### show API（三族 static）

**公共参数**（list / grid / group 均适用）：

| 参数 | 层级 | v1.0 | 说明 |
| --- | --- | --- | --- |
| `context` | E 首参 | **保留** | `BuildContext` |
| `items`（→ `child`） | L2 | **保留** | `List<TActionSheetItem>` |
| `onChanged` | L3 | **改名** | 原 `onSelected` |
| `onCancel` / `onClose` | L3 | **保留** | 取消/关闭 |
| `align` | L1 | **保留** | `TActionSheetAlign`；Theme 可提供 `defaultAlign` |
| `showCancel` | L3 | **保留** | 是否显示取消钮；**不进 Theme** |
| `cancelText` | L1/L4 | **保留** / → Theme | 取消钮文案样式默认 |
| `showOverlay` / `closeOnOverlayClick` | L3 | **保留** | 蒙层行为；**不进 Theme** |
| `useSafeArea` | L3 | **保留** | 布局策略；**不进 Theme** |
| **返回值** | — | **`TActionSheetHandle`** | `close()` · `isShowing` |

**`showListActionSheet` 专有**：

| 参数 | 层级 | v1.0 | 说明 |
| --- | --- | --- | --- |
| `subtitle` | L2 | **改名** | 原 `description` |

**`showGridActionSheet` 专有**：

| 参数 | 层级 | v1.0 | 说明 |
| --- | --- | --- | --- |
| `subtitle` | L2 | **改名** | 原 `description` |
| `count` / `rows` | L4 | → Theme | 宫格列数/行数**布局默认** |
| `itemHeight` / `itemMinWidth` | L4 | → Theme | 宫格单元尺寸 |
| `scrollable` / `showPagination` | L3 | **保留** | 宫格能力；**不进 Theme** |

**`showGroupActionSheet` 专有**：

| 参数 | 层级 | v1.0 | 说明 |
| --- | --- | --- | --- |
| `itemHeight` / `itemMinWidth` | L4 | → Theme | 分组行高/最小宽 |
| `TActionSheetItem.group` | L2 数据 | **保留** | 分组 key；缺省则项不展示 |

实现壳：`TPopup.show` + `TPopupOptions.bottom`（见 [popup.md §2](./popup.md#2-tpopup-业务壳约定)）。

#### `TActionSheetHandle`

| 成员 | 说明 |
|------|------|
| `close()` | 关闭本次面板；已关时无副作用 |
| `isShowing` | 本次面板是否仍在展示 |

### L4 迁入 `TActionSheetThemeData`（样式）

| 0.2.x 来源 | Theme 字段 | 类别 |
| --- | --- | --- |
| `cancelText` | `cancelText` | 文案 |
| `align` 默认 | `defaultAlign` | 布局 |
| `itemHeight` / `itemMinWidth` | `itemHeight` / `itemMinWidth` | 宽高 |
| `count` / `rows` | `gridCount` / `gridRows` | 宫格布局默认 |
| 容器圆角 | `panelRadius` | 圆角 |
| 蒙层色 / 动效 | — | **`TPopupThemeData`** |

**不进 Theme（show* L3）**：`showCancel` · `scrollable` · `showPagination` · `useSafeArea` · `showOverlay` · `closeOnOverlayClick`

### export

- **保留**：`showListActionSheet`、`showGridActionSheet`、`showGroupActionSheet`、`TActionSheetHandle`、`TActionSheetItem`、`TActionSheetAlign`、`TActionSheetOnChanged`、`TActionSheetThemeData`
- **移出**：`TActionSheetTheme`（enum 改名 `variant` 或内聚 Theme）、`TActionSheetItemCallback`、`TActionSheetList/Grid/Group` 内部 Widget（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme {#2-theme}

`TActionSheetThemeData` · 字段归类 → [theme.md §2.1](../foundation/theme.md#21-themedata-字段归类v10-裁决) · Material: **TPopup + BottomSheet**

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `child`（items）/ `subtitle` | **单次 show L2** | 选项与副标题 |
| `onChanged` / `onCancel` / `onClose` | **单次 show L3** | 选中与关闭 |
| `showOverlay` / `closeOnOverlayClick` / `useSafeArea` | **单次 show L3** | 浮层策略；**不进 Theme** |
| `showCancel` / `scrollable` / `showPagination` | **单次 show L3** | 能力开关；**不进 Theme** |
| 三族 `show*` | **E 类首参** | 返回 `TActionSheetHandle` |
| `TActionSheetItem.disabled` | **数据项** | 灰显且不触发 `onChanged` |
| `itemHeight` / `count` / `rows` / `panelRadius` / `cancelText` | **`TActionSheetThemeData`** | 样式与布局默认 |
| 蒙层色 / `duration` / `curve` | **`TPopupThemeData`** | 过渡动效 |
