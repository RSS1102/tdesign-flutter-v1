# TBottomTabBar — v1.0 定稿

> Sprint **S3** | 控制类 **A** | Material: 自绘 Container
> 源码：`lib/src/components/tabbar` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 自绘 Container + GestureDetector |
| Material | 自绘（非 Material Widget 薄包装） |
| Theme | `TBottomTabBarThemeData` |
| 禁用 | tab 级 `onTap: null`（A 类） |
| L4 | 构造器 L4 → `TBottomTabBarThemeData` |

## 控制方案

控制类 **A**：`TBottomTabBarTabConfig.onTap`；`null` = 禁用该 tab。选中态由 `value` / `currentIndex` 控制。**不提供**统一 `disabled`。

→ [controlled.md](../../foundation/controlled.md)


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| TBottomTabBar | 底部标签栏主组件 |
| TBottomTabBarTabConfig | 单个 tab 配置 |
| BadgeConfig | 徽标配置 |
| TBottomTabBarPopUpBtnConfig | 展开面板弹窗配置 |
| TBottomTabBarPopUpShapeConfig | 弹窗 UI 配置 |
| PopUpMenuItem | 弹窗菜单项 |
| basicType | 基本样式（text / iconText / icon / expansionPanel） |
| componentType | 选项样式（normal / label） |
| outlineType | 轮廓样式（filled / capsule） |
| navigationTabs | tabs 配置列表 |
| value | 选中的 index（v1.0 新增，优先级高于 currentIndex） |
| currentIndex | 选中的 index（v1.0 推荐使用 value） |
| indicatorAnimation | 指示器动画类型（none / linear / elastic） |
| animationDuration | 动画时长 |
| animationCurve | 动画曲线 |
| needInkWell | 是否需要水波纹效果 |
| useSafeArea / placeholder | 安全区域 |
| useVerticalDivider / dividerHeight / dividerThickness / dividerColor | 竖线分隔 |
| showTopBorder / topBorder | 上边线 |
| selectedBgColor / unselectedBgColor / backgroundColor | 背景颜色 |
| centerDistance | icon 与文本间距 |
| barHeight | tab 高度 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| currentIndex | value | v1.0 新增 value，优先级更高 |
| 各 L4 样式参数 | TBottomTabBarThemeData | L4 → Theme |

### 新增

| 符号 | 说明 |
| --- | --- |
| TBottomTabBarThemeData | L4 默认样式 |
| value | v1.0 选中 index（优先于 currentIndex） |
| indicatorAnimation | 指示器动画（none / linear / elastic） |
| animationDuration / animationCurve | 动画时长与曲线 |

### 废弃

| 符号 | 原因 |
| --- | --- |
| themeData 构造器参数 | 不暴露 themeData，通过 Theme 子树注入 |

### export

- **保留**：`TBottomTabBar`、`TBottomTabBarThemeData`、`TBottomTabBarTabConfig`、`BadgeConfig`、`TBottomTabBarPopUpBtnConfig`、`TBottomTabBarPopUpShapeConfig`、`PopUpMenuItem`、各枚举


---

## 2. Theme

`TBottomTabBarThemeData` · Material: **自绘** · [theme.md](../foundation/theme.md)

### TBottomTabBarThemeData 字段

| 字段 | 类型 | 管什么 | 默认 |
| --- | --- | --- | --- |
| `barHeight` | `double?` | 默认高度 | 56 |
| `selectedBgColor` | `Color?` | 默认选中背景色 | brandLightColor |
| `unselectedBgColor` | `Color?` | 默认未选中背景色 | - |
| `backgroundColor` | `Color?` | 默认背景色 | bgColorContainer |
| `centerDistance` | `double?` | 默认 icon 与文本间距 | 0 |
| `useVerticalDivider` | `bool?` | 默认竖线分隔 | false |
| `dividerHeight` | `double?` | 默认分割线高度 | 32 |
| `dividerThickness` | `double?` | 默认分割线厚度 | 0.5 |
| `dividerColor` | `Color?` | 默认分割线颜色 | componentStrokeColor |
| `showTopBorder` | `bool?` | 默认展示上边线 | true |
| `topBorder` | `BorderSide?` | 默认上边线样式 | - |
| `needInkWell` | `bool?` | 默认水波纹效果 | false |
| `animationDuration` | `Duration?` | 默认动画时长 | 300ms |
| `animationCurve` | `Curve?` | 默认动画曲线 | easeInOutCubic |
