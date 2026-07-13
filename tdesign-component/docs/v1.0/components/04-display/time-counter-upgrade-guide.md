# TTimeCounter v1.0 升级指南

> 从 0.2.x 迁移到 v1.0 · **自绘**（Timer 实现）· 控制类 **E**
> 基于 [time-counter.md](./time-counter.md) · [theme.md](../../foundation/theme.md) · [api.md](../../foundation/api.md)

---

## 1. 变更总览

| 维度 | 0.2.x | v1.0 |
|------|-------|------|
| **回调** | `onChange` | ✏️ `onChanged` |
| **样式** | 构造器 `style` / `millisecond` / `splitWithUnit` / `theme` | 📦 迁入 `TTimeCounterThemeData` |
| **参数可空** | `millisecond` / `size` / `splitWithUnit` / `theme` 非空 | ✨ 改为可空，支持 P1 三级回退 |
| **ThemeExtension** | — | ✨ 新增 `TTimeCounterThemeData` |
| **P1 读取** | 未读取 ThemeExtension | ✨ `didChangeDependencies` 中 `widget.field ?? theme?.field ?? hardDefault` |

---

## 2. 逐项代码替换

### 2.1 构造器参数对照

| 0.2.x 参数 | v1.0 参数 | 迁移方式 |
|------------|----------|---------|
| `onChange` | ✏️ `onChanged` | 改名 |
| `millisecond: true` | 📦 `TTimeCounterThemeData.millisecond` | 迁入 Theme；构造器改为可空回退 |
| `splitWithUnit: true` | 📦 `TTimeCounterThemeData.splitWithUnit` | 迁入 Theme；构造器改为可空回退 |
| `theme: TTimeCounterTheme.xxx` | 📦 `TTimeCounterThemeData.theme` | 迁入 Theme；构造器改为可空回退 |
| `size: TTimeCounterSize.xxx` | 构造器保留（可空） | 改为可空，回退 Theme |
| `style: TTimeCounterStyle(...)` | 构造器保留（可空） | 改为可空，回退 Theme |
| `time` | 不变 | — |
| `format` | 不变 | — |
| `content` | 不变 | — |
| `autoStart` | 不变 | — |
| `direction` | 不变 | — |
| `controller` | 不变 | — |
| `onFinish` | 不变 | — |

### 2.2 完整示例

```dart
// === 0.2.x ===
TTimeCounter(
  time: 60000,
  format: 'HH:mm:ss',
  millisecond: true,
  splitWithUnit: false,
  size: TTimeCounterSize.medium,
  theme: TTimeCounterTheme.defaultTheme,
  onChange: (time) { ... },
  onFinish: () { ... },
),

// === v1.0（构造器参数 + Theme 子树注入） ===
Theme(
  data: Theme.of(context).mergeExtension(
    const TTimeCounterThemeData(
      millisecond: true,
      splitWithUnit: false,
    ),
  ),
  child: TTimeCounter(
    time: 60000,
    format: 'HH:mm:ss',
    // size / theme / millisecond / splitWithUnit 由 Theme 回退
    onChanged: (time) { ... },
    onFinish: () { ... },
  ),
),
```

---

## 3. Theme 注入方式

```dart
// 子树注入
Theme(
  data: Theme.of(context).mergeExtension(
    const TTimeCounterThemeData(
      millisecond: true,
      splitWithUnit: true,
    ),
  ),
  child: TTimeCounter(time: 60000),
);

// 全局注入
MaterialApp(
  theme: ThemeData(
    extensions: [
      const TTimeCounterThemeData(millisecond: false),
    ],
  ),
  ...
)
```

### P1 优先级链

```
构造器参数（widget.field）
  > TTimeCounterThemeData（theme?.field）
    > 内置默认值（hardDefault）
```

`didChangeDependencies` 中实现三级回退：
```dart
final tTheme = Theme.of(context).extension<TTimeCounterThemeData>();
final effectiveSize = widget.size ?? tTheme?.size ?? TTimeCounterSize.medium;
_effectiveMillisecond = widget.millisecond ?? tTheme?.millisecond ?? false;
_effectiveSplitWithUnit = widget.splitWithUnit ?? tTheme?.splitWithUnit ?? false;
```

---

## 4. Export 变更

| 符号 | v1.0 是否 export | 说明 |
|------|-----------------|------|
| `TTimeCounter` | ✅ 保留 | Widget |
| `TTimeCounterController` | ✅ 保留 | 命令式控制器 |
| `TTimeCounterDirection` | ✅ 保留 | 计时方向枚举 |
| `TTimeCounterThemeData` | ✅ 保留 | ThemeExtension |
| `TTimeCounterStyle` | 🚫 移出 | 内部样式类，不 export |

---

## 5. 后续修复（2026-07-05）

### P1 ThemeExtension 读取补全

**问题**：`TTimeCounterThemeData` 已定义但 `didChangeDependencies` 中未读取，构造器可空参数无回退链。

**修复**：
- `millisecond` / `size` / `splitWithUnit` / `theme` 构造器参数改为可空
- `didChangeDependencies` 新增 P1 读取：`widget.field ?? theme?.field ?? hardDefault`
- `t_time_counter_style.dart` 中 `TThemeData.defaultData().numberFontFamily` 修复为 `context.tTheme.numberFontFamily`

---

## 6. 升级检查清单

- [ ] `onChange` → `onChanged`
- [ ] `millisecond` / `splitWithUnit` / `theme` / `size` 改为可空（回退 Theme）
- [ ] `didChangeDependencies` 中 P1 读取 `TTimeCounterThemeData`
- [ ] `TTimeCounterStyle` 不在 export 中
- [ ] `numberFontFamily` 读取 `context.tTheme` 而非 `TThemeData.defaultData()`
- [ ] 更新 Example 页面 + API 文档
