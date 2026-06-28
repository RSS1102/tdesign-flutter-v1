# TIcon — v1.0 升级指南

> T2 纯展示组件升级 | S2 交付 | 2026-06-27

---

## 1. 变更概览

| 类别 | 0.2.x | v1.0 | 影响 |
|------|--------|------|------|
| 图标数据 | 内嵌 `t_icons.dart`（4256 行）+ `t_icons.ttf`（358 KB） | **`tdesign_icons: ^0.0.4`** 外部资源包 | 删除旧文件 |
| Widget | 无（仅 `Icon(TIcons.xxx)` 直接使用） | **`TIcon(TIcons.xxx)`** 薄包装 | 新增组件 |
| Theme | 无组件级 Theme | **`TIconThemeData`**（size + color） | 新增能力 |
| 图标映射 | `TIcons.all`（`Map<String, _TIconsData>`） | **`TIcons.allIconsMap`**（`Map<String, IconData>`） | API 改名 |
| 图标名访问 | `item.name`（`_TIconsData` 属性） | `allIconsMap.key` | 访问方式变更 |
| 字体注册 | 本库内注册 `fontFamily: 'TIcons'` | `tdesign_icons` 包自注册 | 透明 |
| Flutter SDK | `>=3.16.0` | **`>=3.32.0`** | 提升下限 |

---

## 2. 迁移清单

### 2.1 TIcons.all → allIconsMap

```dart
// ❌ 0.2.x
final icons = TIcons.all.values;
TIcons.all.forEach((key, value) {
  print(value.name); // _TIconsData.name
});

// ✅ v1.0
final icons = TIcons.allIconsMap.values;
TIcons.allIconsMap.forEach((key, value) {
  print(key); // String 键名
});
```

### 2.2 推荐使用 TIcon Widget

```dart
// ❌ 0.2.x：直接使用 Material Icon
Icon(TIcons.home_filled, size: 24, color: Colors.blue)

// ✅ v1.0：使用 TDesign TIcon（支持 Theme 注入）
TIcon(TIcons.home_filled, size: 24, color: Colors.blue)

// 通过名称引用
TIcon.fromName('home_filled')
```

### 2.3 子树级默认样式

```dart
// ✅ 旧方式：逐个组件设置
Icon(TIcons.home, size: 20, color: Colors.grey)
Icon(TIcons.setting, size: 20, color: Colors.grey)
// ... 每一处都要设置

// ✅ 新方式：Theme 子树统一控制
Theme(
  data: Theme.of(context).copyWith(
    extensions: [
      ...Theme.of(context).extensions.values,
      const TIconThemeData(size: 20, color: Colors.grey),
    ],
  ),
  child: Column(children: [
    TIcon(TIcons.home),               // 自动继承 size: 20, color: grey
    TIcon(TIcons.setting, size: 24),  // 构造器 size 优先
  ]),
)
```

### 2.4 全局注入

```dart
MaterialApp(
  theme: ThemeData(
    extensions: const [
      TIconThemeData(size: 16, color: Colors.black87),
    ],
  ),
)
```

---

## 3. 内部引用兼容

v1.0 通过 barrel re-export 保证 `TIcons.xxx` 常量零破坏：

```
tdesign_flutter.dart
  └── export 'package:tdesign_icons/tdesign_icons.dart' show TIcons;
```

**兼容性验证**：

| 检查项 | 结果 |
|--------|------|
| 32 个内部文件 `TIcons.xxx` 引用 | ✅ 全部通过 barrel 获取，零改动 |
| `_TIconsData` 私有类依赖 | ✅ 无任何外部文件依赖 |
| deep import（`../icon/t_icons.dart`） | ✅ 3 处已修正为 `package:tdesign_icons/tdesign_icons.dart` |

---

## 4. 优先级链

```
构造器参数 (size / color)
  > TIconThemeData (子树注入)
    > IconTheme (Material 系统回退)
```

---

## 5. 文件清单

| 文件 | 操作 |
|------|------|
| `lib/src/components/icon/t_icon.dart` | 🆕 新建（TIcon Widget） |
| `lib/src/components/icon/t_icon_theme_data.dart` | 🆕 新建（ThemeExtension） |
| `lib/src/components/icon/t_icons.dart` | ❌ 删除（迁移到 tdesign_icons） |
| `assets/tdesign/t_icons.ttf` | ❌ 删除（迁移到 tdesign_icons） |
| `pubspec.yaml` | ✏️ 添加依赖、删除字体注册、提升 Flutter 下限 |
| `lib/tdesign_flutter.dart` | ✏️ export 改为 barrel re-export |
| `lib/src/components/dropdown_menu/t_dropdown_menu.dart` | ✏️ deep import 改为 package import |
| `lib/src/components/drawer/t_drawer.dart` | ✏️ 移除冗余 deep import |
| `lib/src/components/popup/t_popup.dart` | ✏️ deep import 改为 package import |
| `example/lib/page/t_icon_page.dart` | ✏️ `TIcons.all` → `allIconsMap` |
| `example/lib/config.dart` | ✏️ 入口标「Icon 图标 (V1.0)」 |
| `example/assets/api/icon_api.md` | ✏️ 新增 TIcon / TIconThemeData 说明 |
| `test/components/icon/t_icon_test.dart` | 🆕 新建（11 个测试） |

---

## 6. 快速验证

```bash
# 运行测试
flutter test test/components/icon/t_icon_test.dart

# 全库编译检查
dart analyze lib/
```

预期：**11 tests passed**。
