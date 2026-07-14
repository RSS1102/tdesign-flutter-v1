# 基础组件 Review 问题汇总

## Review 环境

- Flutter 运行版本：`3.32.0`（来源：仓库 `.fvmrc`）
- `pubspec.lock` SDK 下限：Dart `>=3.8.0 <4.0.0`，Flutter `>=3.32.0`
- `pubspec.yaml` SDK 约束：Dart `>=3.2.6 <4.0.0`，Flutter `>=3.16.0`

## 范围与结论

Review 范围：`TButton`、`TIcon`、`TFab`、`TDivider`、`TLink`、`TText`。

Review 结论：本轮按当前 v1.0 重构后的源码和生成 API 重新核对，只评价当前重构设计是否自洽，不按历史版本行为做兼容判断。已确认的问题集中在 `TFab` 类型与文档语义、Theme 子树注入写法、tools API 注释生成、API 生成脚本路径、`TFontLoader` 生命周期和少量覆盖率小文件。

## Tools 解析口径

本次“文档 / 注释问题”按 `tdesign_flutter_tools` 的 API 生成链路判断，而不是只看站点 README 成品。

- `tdesign-component/demo_tool/README.md:7-11` 要求成员变量注释使用 `///`，普通 `//` 不作为公开 API 文档来源。
- `tdesign-component/demo_tool/all_build.sh:8-23` 是基础组件 API 生成范围，覆盖 `button`、`divider`、`fab`、`icon`、`link`、`text`。
- tools 通过 analyzer AST 解析构造参数，并用同名字段 `///` 补齐类型和说明。
- `tdesign-component/example/assets/api/*_api.md` 中公开 API 表出现 `说明 = -` 时，应视为源码注释缺口或 tools 解析缺口，除非该字段被明确列为豁免项。
- 当前 v1.0 重构要求以源码注释作为 API 文档来源，因此公开类、构造参数、公开字段、公开方法参数需要能被 tools 追溯。

## 已复核确认的问题

### 1. `TFab.draggable` / `magnet` 源码类型过宽

定位：`tdesign-component/lib/src/components/fab/t_fab.dart:89-93`，`tdesign-component/lib/src/components/fab/t_fab_resolve.dart:33-45`，`tdesign-component/example/assets/api/fab_api.md:16-17`。

证据：源码字段类型是 `Object?`，解析逻辑只接受 `TFabDragAxis` / `true` 和 `TFabMagnet` / `true`，非法对象会被静默忽略；但生成 API 展示为 `bool | TFabDragAxis`、`bool | TFabMagnet`。这说明用户看到的是联合类型语义，源码实际没有编译期约束。

影响：调用方可传入任意对象且编译通过，运行时不报错也不生效，公开 API 与实现保护强度不一致。

建议：彻底移除公开 API 中的 `Object?` 联合类型模拟。将 `draggable` / `magnet` 改成明确类型参数或拆分参数，并在 `TFabResolve` 中只处理合法类型，避免非法值编译通过后运行时静默忽略。

### 2. `TFab.magnet: true` 注释与实现语义不一致

定位：`tdesign-component/lib/src/components/fab/t_fab.dart:92`，`tdesign-component/lib/src/components/fab/t_fab_resolve.dart:40-45`。

证据：字段注释写 `true（左右均可）`，但实现中 `magnet == true` 被转换为 `TFabMagnet.right`。

影响：用户按注释理解为左右自动吸附，实际固定右吸附；这是明确的文档/实现语义不一致。

建议：按 v1.0 设计确定唯一语义并同步实现、源码 `///`、生成 API 和测试。不要继续保留“`true` 可能表示右吸附，也可能表示左右均可”的模糊口径。

### 3. `TFabResolve.resolveButton` 仍手动重组 Theme extensions

定位：`tdesign-component/lib/src/components/fab/t_fab_resolve.dart:89-100`，`tdesign-component/example/lib/page/t_button_page.dart:295-304`，`tdesign-component/example/lib/page/t_icon_page.dart:106`，`tdesign-component/example/lib/page/t_text_page.dart:167`。

证据：`TFabResolve.resolveButton` 使用 `Theme.of(context).copyWith(extensions: [...])` 删除并重加 `TButtonThemeData`；部分 Example 页面也仍使用 `copyWith(extensions:)`。当前 v1.0 规范倾向使用 `Theme.of(context).mergeExtension(...)` 做子树级 Theme 注入。

影响：不同组件的 Theme 注入方式不统一，手动重组 extensions 更容易遗漏其他扩展或引入顺序问题。

建议：统一改为 `mergeExtension` 或同等 helper；`TFab` 内嵌 `TButton` 的 shape 覆盖也应使用同一 Theme 注入口径。

### 4. `TText` / `TTextSpan` 透传参数生成 API 说明缺口较多

定位：`tdesign-component/lib/src/components/text/t_text.dart:120-145`，`tdesign-component/example/assets/api/text_api.md:12`，`tdesign-component/example/assets/api/text_api.md:23-33`，`tdesign-component/example/assets/api/text_api.md:53-66`，`tdesign-component/example/assets/api/text_api.md:80-95`。

证据：源码用“以下系统 text 属性，释义请参考系统 Text 中注释”作为整体说明，但 `strutStyle`、`textAlign`、`textDirection`、`locale`、`softWrap`、`overflow`、`textScaleFactor`、`maxLines`、`semanticsLabel`、`textWidthBasis`、`textHeightBehavior`、`TTextSpan.children`、`recognizer` 等公开参数在生成 API 中说明为 `-`。

影响：这些参数已经成为 TDesign 公开 API，用户无法从生成文档判断它们是透传系统能力、TDesign 扩展能力，还是存在 v1.0 特殊语义。

建议：逐字段补 `///`，透传字段可写“透传至系统 Text/TextSpan 的 xxx 参数”；TDesign 自定义字段需要说明优先级、默认值和 Theme / configuration 的关系。

### 5. `TButtonResolve.resolve` 方法参数说明缺失

定位：`tdesign-component/lib/src/components/button/t_button_resolve.dart:12-23`，`tdesign-component/example/assets/api/button_api.md:41-57`。

证据：`TButtonResolve.resolve` 被 `all_build.sh` 纳入生成范围，方法说明存在，但 `variant`、`colorScheme`、`size`、`icon`、`iconPosition`、`theme`、`instanceStyle`、`context` 等参数生成说明均为 `-`。

影响：公开 API 文档无法说明该 resolver 是推荐扩展入口还是内部实现工具，也无法解释参数优先级链。

建议：按 v1.0 公开 API 边界做确定处理：若 `TButtonResolve` 是公开扩展能力，则补齐参数 `///` 并让 tools 正确生成；若它只是内部实现工具，则从 API 生成范围移除，不作为用户 API 暴露。

### 6. `icon` API 生成脚本仍指向已迁移的本地图标清单

定位：`tdesign-component/pubspec.yaml:15-16`，`tdesign-component/demo_tool/all_build.sh:17-18`，`tdesign-component/lib/tdesign_flutter.dart:1-2`，`tdesign-component/lib/src/components/icon/`。

证据：图标资源已经迁移到外部包 `tdesign_icons: ^0.0.4`；统一入口从 `package:tdesign_icons/tdesign_icons.dart` re-export `TIcons`。但 `all_build.sh` 仍从 `lib/src/components/icon/t_icons.dart` 生成 `TIcons` API，而当前本地 icon 目录只有 `t_icon.dart`、`t_icon_theme_data.dart`。

影响：重新生成基础 API 时 icon 生成命令会指向不存在的源码文件；现有 `icon_api.md` 如果仍包含 `TIcons` 静态字段清单，就是旧本地图标清单生成策略的残留，不应继续作为组件库 v1.0 API 生成结果。

建议：更新 `all_build.sh` 的 icon 生成方案：组件库内只生成 `TIcon` / `TIconThemeData` 等组件 API；`TIcons` 图标清单由 `tdesign_icons` 包维护和发布，不再从组件库本地源码生成，也不在当前基础组件 API 文档中生成逐字段清单。

### 7. `TFontLoader` 存在调试输出和异步 mounted 风险

定位：`tdesign-component/lib/src/components/text/t_font_loader.dart:30-32`，`tdesign-component/lib/src/components/text/t_font_loader.dart:65-76`。

证据：加载失败路径直接 `print`；`loadFont()` 异步完成后在 `setState(() {})` 前未检查 `mounted`。

影响：控制台噪音不符合组件库源码清洁度；组件卸载后异步回调可能触发状态更新。

建议：删除 `print` 或改为受控日志；`await` 后先判断 `mounted`；同时补充卸载过程中字体加载完成的测试。

### 8. 覆盖率小文件仍有低成本缺口

定位：`tdesign-component/coverage/lcov.info` 中 `lib/src/components/fab/t_fab_defaults.dart`、`lib/src/components/fab/t_fab_theme_data.dart`、`lib/src/components/icon/t_icon_theme_data.dart`。

证据：当前 lcov 快照显示 `t_fab_defaults.dart` 为 `LF:2 / LH:0`，`t_fab_theme_data.dart` 为 `LF:44 / LH:43`，`t_icon_theme_data.dart` 为 `LF:10 / LH:9`。

影响：这些文件体量小，遗漏通常来自默认值、`copyWith` / `lerp` 边界未覆盖；在 v1.0 Theme 重构中，ThemeData 小文件应尽量用低成本测试锁住。

建议：补 `TFabDefaults` 默认值、`TFabThemeData.lerp`、`TIconThemeData.lerp` 的边界测试。覆盖率数据来自当前仓库 lcov 快照，修复后应重新生成覆盖率再复查。

### 9. `TLinkConfiguration` 仍以旧全局跳转入口公开

定位：`tdesign-component/lib/src/components/link/t_link.dart:251-260`，`tdesign-component/example/assets/api/link_api.md:72-79`。

证据：源码注释写 `TLinkConfiguration` 是“保留 v0.2.x 兼容”，生成 API 仍把它作为 `InheritedWidget` 公开，提供 `onTapAll` 全局跳转回调。

影响：完全重构阶段不应继续把旧全局跳转入口作为公开 API 输出。该入口会让 v1.0 的跳转控制路线不清晰，也会让 tools 生成文档继续携带旧设计。

建议：从 v1.0 公开 API 和 tools 生成范围移除 `TLinkConfiguration`，统一到当前设计认可的实例级事件、resolver 或 Theme 控制方案；同步删除源码中的旧兼容注释。

## 单组件备注

| 组件 | Review 意见 | 已确认风险 |
| --- | --- | --- |
| `TButton` | 当前 v1.0 API 已以 `TButtonThemeData` / `TButtonResolve` 为主，旧 `TButtonStyle` 问题不再适用 | `TButtonResolve.resolve` 作为生成 API 时方法参数说明缺失；Example Theme 注入 helper 仍用 `copyWith(extensions:)` |
| `TIcon` | 组件本身已接入 `tdesign_icons` | API 生成脚本仍指向已不存在的 `t_icons.dart`；`TIcons` 清单应由 `tdesign_icons` 包维护，组件库只生成 `TIcon` / `TIconThemeData` API |
| `TFab` | 当前风险最高 | `Object?` 类型过宽；`magnet: true` 注释/实现不一致；内嵌 Button Theme 注入写法不统一；默认值覆盖率缺口 |
| `TDivider` | 本轮未发现需要保留的明确实现问题 | 后续主要按 tools 口径持续检查公开字段注释和 ThemeData 测试 |
| `TLink` | 当前点击热区已包住图标和文本整体 | 旧“图标点击区域”问题应删除；`TLinkConfiguration` 旧全局跳转入口应从 v1.0 公开 API 移除 |
| `TText` | 架构已收敛到 resolver/configuration | 大量系统透传参数缺少逐字段 `///`；`TFontLoader` 调试输出和异步 mounted 风险 |

## 建议修复顺序

1. 修 `TFab`：增加类型约束 / normalize，裁决 `magnet: true`，统一 Theme 注入写法。
2. 更新 `all_build.sh` 的 icon API 生成策略，移除本地 `TIcons` 清单生成，改为生成 `TIcon` / `TIconThemeData` 组件 API。
3. 按 tools 解析口径补齐 `TText` / `TTextSpan` / `TButtonResolve.resolve` 的公开 API 注释。
4. 清理 `TFontLoader` 的 `print` 和异步 mounted 风险。
5. 移除 `TLinkConfiguration` 旧全局跳转入口，并调整 API 生成范围。
6. 补 `TFabDefaults`、`TFabThemeData`、`TIconThemeData` 的低成本边界测试，并重新生成覆盖率。
7. 当前重构实现稳定后重新跑基础组件定向 `flutter test`、`flutter analyze`，并对生成 API 文档做 diff review。

## Review 意见

当前基础组件的问题不是大面积结构不可用，而是若干公开 API 口径与 v1.0 文档生成链路没有完全闭合。建议先处理 `TFab` 和 API 生成脚本这类会直接误导用户或阻断文档生成的问题，再补齐 tools 可解析的 `///` 注释和低成本测试。
