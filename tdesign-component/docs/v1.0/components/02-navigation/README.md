# 导航

> 与 [官网 · 导航](https://tdesign.tencent.com/flutter/overview) 对齐。  
> 返回 [v1.0 文档索引](../../README.md)

## 文档组织

| 类型 | 规则 | 数量 |
|---|---|---|
| **定稿** | 一官网入口一文件，可编辑 | 8 篇 |
| **废弃** | 被合并的旧组件各保留一文件，文件名加 `-废弃`，仅跳转 | 4 篇 |
| **升级指南** | `*-upgrade-guide.md`，不改动 | 8 篇 |

Tab 系 S3 优先；TDrawer 官网归导航类、实现排 S4。

## 官网对照（定稿）

| 定稿文档 | Dart 类 | 官网页 |
|---|---|---|
| [tab-bar.md](./tab-bar.md) | `TBottomTabBar` | [TabBar 标签栏](https://tdesign.tencent.com/flutter/components/tab-bar) |
| [tabs.md](./tabs.md) | `TTab` · `TTabBar` · `TTabBarView` | [Tabs 选项卡](https://tdesign.tencent.com/flutter/components/tabs) |
| [backtop.md](./backtop.md) | `TBackTop` | BackTop |
| [navbar.md](./navbar.md) | `TNavBar` | Navbar |
| [steps.md](./steps.md) | `TSteps` | Steps |
| [drawer.md](./drawer.md) | `TDrawer` | Drawer |
| [indexes.md](./indexes.md) | `TIndexes` | Indexes |
| [sidebar.md](./sidebar.md) | `TSideBar` | SideBar |

## 废弃（一组件一文件，勿编辑）

| 废弃文件 | 组件 | 合并为 |
|---|---|---|
| [tab-废弃.md](./tab-废弃.md) | `TTab` | [tabs.md](./tabs.md) |
| [tab-bar-废弃-ttabbar.md](./tab-bar-废弃-ttabbar.md) | `TTabBar` | [tabs.md](./tabs.md) |
| [tab-bar-view-废弃.md](./tab-bar-view-废弃.md) | `TTabBarView` | [tabs.md](./tabs.md) |
| [bottom-tab-bar-废弃.md](./bottom-tab-bar-废弃.md) | `TBottomTabBar` | [tab-bar.md](./tab-bar.md) |

## 组件清单

> `[ ]` = v1.0 代码未落地 · `[x]` = 已实现 · 控制类 / Tier 见各定稿 md 文首

| 实现 | 组件 | 定稿 | Sprint |
|---|---|---|---|
| [ ] | TBottomTabBar | [tab-bar.md](./tab-bar.md) | S3 |
| [ ] | TTab / TTabBar / TTabBarView | [tabs.md](./tabs.md) | S3 |
| [ ] | TBackTop | [backtop.md](./backtop.md) | S3 |
| [ ] | TNavBar | [navbar.md](./navbar.md) | S3 |
| [ ] | TSteps | [steps.md](./steps.md) | S3 |
| [ ] | TDrawer | [drawer.md](./drawer.md) | S4 |
| [ ] | TIndexes | [indexes.md](./indexes.md) | S3 |
| [ ] | TSideBar | [sidebar.md](./sidebar.md) | S3 |
