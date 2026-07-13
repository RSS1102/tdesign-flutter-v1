# TLink v1.0 升级指南

> 从 0.2.x 迁移到 v1.0 · **T1 薄包装**（InkWell+Text）

---

## 1. 变更总览

| 维度 | 0.2.x | v1.0 | 图例 |
|------|-------|------|:----:|
| 枚举 `TLinkStyle` | `primary/defaultStyle/danger/warning/success` | `TLinkColorScheme.primary/defaultTheme/danger/warning/success` | ✏️ |
| 参数 `type` | `TLinkType` | `variant` | ✏️ |
| 参数 `style` | `TLinkStyle` | `colorScheme` | ✏️ |
| 参数 `label` | `String`（必填） | `child`（`Widget?`） | ✏️ |
| 参数 `linkClick` | `LinkClick?` | `onPressed`（`VoidCallback?`） | ✏️ |
| 参数 `state` | `TLinkState.normal/active/disabled` | `onPressed: null`（禁用） | 🔀 |
| TLinkType 值 | `basic/withUnderline/withPrefixIcon/withSuffixIcon` | `basic/underline/icon` | ✏️ |
| `color`/`iconSize`/`fontSize`/间距 | 构造参数 | `TLinkThemeData` | 📦 |
| `TLinkState` 枚举 | `normal/active/disabled` | 废弃 | 🚫 |
| `LinkClick` typedef | `Function(Uri?)` | 废弃 | 🚫 |
| `TLinkThemeData` | — | ThemeExtension | ✨ |

---

## 2. 逐项代码替换

### 2.1 枚举改名

```dart
// ❌ 0.2.x
TLinkStyle.primary
TLinkStyle.defaultStyle

// ✅ v1.0
TLinkColorScheme.primary
TLinkColorScheme.defaultTheme
```

### 2.2 构造器参数对照表

| 0.2.x | v1.0 | 说明 |
|-------|------|------|
| `label: '链接'` | `child: Text('链接')` | String → Widget? |
| `type: TLinkType.basic` | `variant: TLinkType.basic` | 改名 |
| `style: TLinkStyle.primary` | `colorScheme: TLinkColorScheme.primary` | 改名 |
| `state: TLinkState.disabled` | `onPressed: null` | 废弃枚举 |
| `linkClick: (uri) {}` | `onPressed: () {}` | typedef 废弃 |
| `type: TLinkType.withUnderline` | `variant: TLinkType.underline` | 值改名 |
| `type: TLinkType.withPrefixIcon` | `variant: TLinkType.icon` | 合并为 icon |
| `type: TLinkType.withSuffixIcon` | `variant: TLinkType.icon` | 合并为 icon |
| `color: Colors.red` | `color: Colors.red` | 保留（优先于 colorScheme） |

### 2.3 TLinkType 值迁移

```dart
// ❌ 0.2.x                          // ✅ v1.0
TLinkType.basic                      TLinkType.basic
TLinkType.withUnderline              TLinkType.underline
TLinkType.withPrefixIcon             TLinkType.icon
TLinkType.withSuffixIcon             TLinkType.icon
```

> `withPrefixIcon` / `withSuffixIcon` 合并为 `icon`。通过 `prefixIcon` / `suffixIcon` 参数区分前后图标。

### 2.4 完整示例

```dart
// ❌ 0.2.x
TLink(
  label: '跳转链接',
  style: TLinkStyle.primary,
  type: TLinkType.withSuffixIcon,
  state: TLinkState.normal,
  size: TLinkSize.medium,
  color: Colors.blue,
  linkClick: (uri) {
    print('clicked $uri');
  },
)

// ✅ v1.0
TLink(
  child: Text('跳转链接'),
  colorScheme: TLinkColorScheme.primary,
  variant: TLinkType.icon,
  suffixIcon: Icon(TIcons.jump),
  size: TLinkSize.medium,
  color: Colors.blue,
  onPressed: () {
    print('clicked');
  },
)
```

### 2.5 从 label 到 child

```dart
// ❌ label: String
TLink(label: '点击这里')

// ✅ child: Widget?
// 纯文本
TLink(child: Text('点击这里'))

// 富文本
TLink(
  child: Text.rich(
    TextSpan(text: '同意', children: [
      TextSpan(text: '《服务协议》', style: TextStyle(fontWeight: FontWeight.bold)),
    ]),
  ),
)
```

### 2.6 禁用态

```dart
// ❌ 0.2.x
TLink(
  label: '禁用',
  state: TLinkState.disabled,
)

// ✅ v1.0
TLink(
  child: Text('禁用'),
  onPressed: null,  // onPressed 为 null 即禁用
)
```

---

## 3. Theme 注入方式

### 3.1 子树注入

```dart
Theme(
  data: Theme.of(context).copyWith(
    extensions: [
      const TLinkThemeData(
        defaultColorScheme: TLinkColorScheme.primary,
        defaultSize: TLinkSize.medium,
        fontSize: 16,
        iconSize: 18,
        leftGapWithIcon: 8,
        rightGapWithIcon: 8,
      ),
    ],
  ),
  child: TLink(child: Text('链接')),
)
```

### 3.2 全局注入

```dart
MaterialApp(
  theme: ThemeData(
    extensions: [
      const TLinkThemeData(
        defaultColorScheme: TLinkColorScheme.primary,
      ),
    ],
  ),
)
```

---

## 4. Resolve 优先级链

```
L1 构造器参数 (color / fontSize / iconSize / leftGap / rightGap)
  > TLinkThemeData (color / fontSize / iconSize / leftGapWithIcon / rightGapWithIcon)
    > Token 默认值 (按 size + colorScheme 计算)
```

**颜色映射**：

| colorScheme | 正常态 Token | 禁用态 Token |
|-------------|-------------|------------|
| `primary` | `brandNormalColor` | `brandDisabledColor` |
| `defaultTheme` | `textColorPrimary` | `textDisabledColor` |
| `danger` | `errorNormalColor` | `errorDisabledColor` |
| `warning` | `warningNormalColor` | `warningDisabledColor` |
| `success` | `successNormalColor` | `successDisabledColor` |

---

## 5. TLinkConfiguration

保留为 `InheritedWidget`，API 变更：

```dart
// ❌ 0.2.x
TLinkConfiguration(
  linkClick: (uri) { /* 统一跳转 */ },
  child: child,
)

// ✅ v1.0
TLinkConfiguration(
  onTapAll: (uri) { /* 统一跳转 */ },
  child: child,
)
```

---

## 6. Export 变更

| 符号 | v1.0 | 说明 |
|------|:----:|------|
| `TLink` | ✅ | 保留 |
| `TLinkType` | ✅ | 保留（值变更） |
| `TLinkSize` | ✅ | 保留 |
| `TLinkColorScheme` | ✅ | 新增（替代 TLinkStyle） |
| `TLinkThemeData` | ✅ | 新增 |
| `TLinkConfiguration` | ✅ | 保留 |
| `TLinkStyle` | ❌ | 废弃（替代：TLinkColorScheme） |
| `TLinkState` | ❌ | 废弃（替代：onPressed: null） |
| `LinkClick` | ❌ | 废弃（替代：VoidCallback?） |

---

## 7. 升级检查清单

- [ ] `TLinkStyle` → `TLinkColorScheme`（5 个枚举值）
- [ ] `type: TLinkType.xxx` → `variant: TLinkType.xxx`（值 4→3）
- [ ] `label: '...'` → `child: Text('...')`
- [ ] `linkClick: (uri) {}` → `onPressed: () {}`
- [ ] `state: TLinkState.disabled` → `onPressed: null`
- [ ] `style: TLinkStyle.xxx` → `colorScheme: TLinkColorScheme.xxx`
- [ ] `withUnderline` → `underline`，`withPrefixIcon/withSuffixIcon` → `icon`
- [ ] `TLinkConfiguration(linkClick:)` → `TLinkConfiguration(onTapAll:)`
- [ ] 确认 `lib/tdesign_flutter.dart` export 无旧符号
- [ ] 更新内部引用（message / footer 等）
- [ ] 更新示例页面 API 文档
