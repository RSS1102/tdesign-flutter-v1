# TLink — v1.0 定稿

> Sprint **S2** | 控制类 **A** | Material: InkWell+Text
> 源码：`lib/src/components/link` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 动作控件薄包装（内部按 `uri` 与回调选择触发路径） |
| Material | InkWell+Text |
| Theme | `TLinkThemeData` |
| 禁用 | 回调为 `null` 时禁用 |
| L4 | 构造器 L4 → `TLinkThemeData` |

## 控制方案

`onPressed`；**不提供** `onTap` / `value`。禁用：回调 `null`。


---

## 1. API

### 构造器与类型

| 符号 | 说明 |
| --- | --- |
| `TLink` | 链接 Widget |
| `TLinkVariant` | 链接形态（basic / underline / icon） |
| `TLinkSize` | 尺寸 |
| `TLinkColorScheme` | 语义色方案；与 Button `colorScheme` 同口径，不是 ThemeData 改名 |
| `uri` | 跳转 URI |
| `prefixIcon` / `suffixIcon` | 链式图标 |
| `TLinkThemeData` | L4 默认样式 |

### export

- `TLink`
- `TLinkVariant`
- `TLinkSize`
- `TLinkColorScheme`
- `TLinkThemeData`


---

## 2. Theme

`TLinkThemeData` · Material: **InkWell+Text** · [theme.md](../foundation/theme.md)

### TLinkThemeData 字段

| 字段 | 类型 | 管什么 | 默认 |
| --- | --- | --- | --- |
| `defaultVariant` | `TLinkVariant` | 未传构造器 `variant` 时的默认形态 | `basic` |
| `defaultSize` | `TLinkSize` | 未传构造器 `size` 时的默认尺寸 | `medium` |
| `defaultColorScheme` | `TLinkColorScheme` | 未传构造器 `colorScheme` 时的默认语义色 | `primary` |
| `fontSize` | `double` | 链接文本字号 | `fontLinkMedium.size` |
| `iconSize` | `double` | 图标链接的图标尺寸 | 按 `size` 推导 |
| `leftGapWithIcon` / `rightGapWithIcon` | `double` | 图标与文本间距 | 按 `size` 推导 |

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `foregroundColor` / `overlayColor` | Material **`TextButtonTheme`** / InkWell | 链接色与水波纹 |
| `variant` | TDesign 构造器 L1（非 Material） | `TLinkVariant`；默认由 `TLinkThemeData.defaultVariant` 提供 |
| `size` | TDesign 构造器 L1（非 Material） | `TLinkSize`；默认由 `TLinkThemeData.defaultSize` 提供 |
| `colorScheme` | TDesign 构造器 L1（非 Material） | 唯一常规颜色入口；默认由 `TLinkThemeData.defaultColorScheme` 提供 |
| `fontSize` / `iconSize` / `prefixIcon` / `suffixIcon` / 间距 | TDesign 扩展 | 链式图标布局 |
| `uri` | TDesign 扩展（可选） | 默认链接色/下划线策略 |

### colorScheme 与禁用态

`colorScheme` 承接旧版 `TDLinkStyle` 的语义色职责（primary / default / danger / warning / success），不是 ThemeData 改名。Link 不提供单独 `color` 构造器或 `TLinkThemeData.color` 覆盖；全局换色应修改底层 Token。禁用态不继续表达语义色，统一使用 `context.tTheme.textDisabledColor`，与 Button 等基础组件的禁用文本口径一致。
