## 检测方案

以下命令均从仓库根目录进入 `tdesign-component` 后执行，除 Web build 外不需要切到 `example`。

### 1. 基础命令

| 目标             | 命令                                                                        | 通过标准                                |
| ---------------- | --------------------------------------------------------------------------- | --------------------------------------- |
| 静态分析         | `cd tdesign-component && flutter analyze`                                   | 退出码为 `0`                            |
| 全量测试与覆盖率 | `cd tdesign-component && flutter test --coverage`                           | 退出码为 `0`，生成 `coverage/lcov.info` |
| 自动验收         | `cd tdesign-component && dart run scripts/acceptance/acceptance_check.dart` | 报告无失败项，且结果与手动命令一致      |
| Web build        | `cd tdesign-component/example && flutter build web`                         | 退出码为 `0`，生成 `example/build/web`  |

`flutter analyze` 是 Flutter 项目的主静态分析命令，会在 Flutter SDK 语境下解析项目依赖、Flutter API、analysis 规则和组件代码。该命令用于提前发现类型错误、旧 API 调用、无效 import、lint 问题以及 example / test 中不符合当前 Flutter 工程环境的代码问题。

### 2. 单组件测试

```bash
cd tdesign-component
flutter test test/components/button/t_button_test.dart
flutter test test/components/button/t_button_golden_test.dart
```

补测试时优先覆盖：

- 控制类主路径：`onPressed`、`onChanged`、`controller`、`show()`。
- 禁用态：`onPressed: null`、`onChanged: null`、`enabled: false`、`readOnly: true`。
- Theme 子树覆盖：`Theme.of(context).mergeExtension(T{Xxx}ThemeData(...))`。
- 文档 §1 中声明的主要变体、尺寸、状态、边界值和公开 API 行为。

### 3. 覆盖率查看

```bash
cd tdesign-component
flutter test --coverage
ls coverage/lcov.info
```

如需 HTML 报告：

```bash
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

覆盖率为 `0.0%` 的组件优先处理，因为这通常表示测试文件存在但没有真正覆盖组件实现。

### 4. Golden 快照

执行当前 P0 Golden：

```bash
cd tdesign-component
flutter test test/components/button/t_button_golden_test.dart
flutter test test/components/slider/t_slider_golden_test.dart
flutter test test/components/tabbar/t_bottom_tab_bar_golden_test.dart
flutter test test/components/tabs/t_tabbar_golden_test.dart
```

查看失败产物：

```bash
find test/components -path '*failures*' -type f
```

| 文件                 | 含义                     |
| -------------------- | ------------------------ |
| `*_masterImage.png`  | 当前保存的 Golden 基准图 |
| `*_testImage.png`    | 本次测试实际渲染图       |
| `*_isolatedDiff.png` | 独立差异图               |
| `*_maskedDiff.png`   | 标记差异区域的差异图     |

若确认当前渲染符合 V1.0 文档和设计预期，再更新快照：

```bash
cd tdesign-component
flutter test --update-goldens test/components/button/t_button_golden_test.dart
flutter test --update-goldens test/components/slider/t_slider_golden_test.dart
flutter test --update-goldens test/components/tabbar/t_bottom_tab_bar_golden_test.dart
flutter test --update-goldens test/components/tabs/t_tabbar_golden_test.dart
```

更新后重新执行对应 Golden 测试，确认退出码为 `0`。

### 5. API 与导出边界

```bash
cd tdesign-component
rg -n "export 'src/components/.+show .*Style|export 'src/components/.+_style\\.dart|TButtonShape|TCheckboxStyle|TRadioStyle|TSearchBarStyle|TSideBarStyle|TInputCardStyle|TTimeCounterTheme" lib/tdesign_flutter.dart
```

检查重点：

- 公开 API 引用到的类型必须能从 `tdesign_flutter.dart` 稳定导入。
- 旧式 `*Style` 样式类不应作为公开 API 导出。
- 组件文档 §1、实际构造器、入口导出三者需要一致。

### 6. 建议检查顺序

1. 先跑 `dart analyze`，清理旧 API 和静态错误。
2. 审计 API / export，确认没有隐藏类型或旧 Style 泄漏。
3. 补单组件测试，优先处理 `0.0%` 和低覆盖率组件。
4. 跑 `flutter test --coverage`，确认整体测试和覆盖率。
5. 确认视觉后更新 V1.0 Golden 基线。
6. 跑自动验收脚本，确认报告与手动命令一致。
7. 在 `tdesign-component/example` 下跑 Web build。

### 7. 一键同步测试的命令

一键同步+覆盖率测试：bash /mnt/e/tdesign-flutter-v1/.codebuddy/run_sync_test.sh

仅同步文件：bash /mnt/e/tdesign-flutter-v1/.codebuddy/sync_to_wsl.sh

仅覆盖率测试：/home/dev/flutter/bin/flutter test --coverage

同步覆盖率测试结果并生成报告：bash /mnt/e/tdesign-flutter-v1/.codebuddy/sync_coverage.sh

### 1. 定义变量（简化后续命令）

SRC=/mnt/e/tdesign-flutter-v1/tdesign-component
DST=/home/dev/tdesign-flutter-v1/tdesign-component

### 2. 刷 DrvFS 缓存（关键！不刷可能读到旧文件）

find "$SRC/lib" "$SRC/test" -type f -exec touch {} +

### 3. 删除重建（把 Windows 的文件复制到 WSL）

rm -rf "$DST/lib" "$DST/test"
cp -r "$SRC/lib" "$DST/lib"
cp -r "$SRC/test" "$DST/test"
