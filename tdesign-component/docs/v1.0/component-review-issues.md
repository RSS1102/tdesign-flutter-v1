# TDesign Flutter V1.0 组件重构 Review 问题归纳

## 结论

- 当前问题主要集中在 API / 文档 / 实现不一致。
- 入口导出边界仍有不符合 V1.0 公开面规则的风险。
- 部分组件测试覆盖率不足，部分 Golden 基线需要确认后更新。
- 本文只记录有问题的组件及问题。

## 01 基础组件

### TButton

- API 边界问题：`TButtonThemeData.shape` 使用 `TButtonShape`，但文档将 `TButtonShape` 标记为内部不导出，形成公开 Theme API 依赖隐藏类型的边界冲突；公开 API 依赖到的语义枚举应作为公开类型导出，同时修正文档表述。
- 导出问题：当前入口只导出 `TButtonThemeData`，未导出 `TButtonShape`。
- 测试问题：Golden 基线为 V1.0 分支新增，当前存在像素差异，应确认当前视觉后更新基线或修复实现。
- 覆盖率问题：`85.3%`，未达到 `95%`。

### TDivider

- 覆盖率问题：`94.4%`，未达到 `95%`。

### TFab

- API 类型问题：`draggable`、`magnet`、`TButtonProps` 等字段存在 `dynamic` 使用，类型约束偏弱。
- 覆盖率问题：`50.9%`，未达到 `95%`。

### TLink

- API 命名问题：V1.0 文档使用 `TLinkVariant`，当前实现使用 `TLinkType`。
- API 收敛问题：文档倾向将 `color`、`iconSize`、`fontSize`、`leftGapWithIcon`、`rightGapWithIcon` 收敛到 `TLinkThemeData`，当前实现仍暴露在构造器上。
- 覆盖率问题：`85.6%`，未达到 `95%`。

### TText

- API 收敛问题：当前仍保留较多旧式便捷参数，与 V1.0 API 收敛方向存在差距。
- 覆盖率问题：`71.4%`，未达到 `95%`。

## 02 导航组件

### TBackTop

- 覆盖率问题：`93.1%`，未达到 `95%`。

### TIndexes

- 覆盖率问题：`59.4%`，未达到 `95%`。

### TSideBar

- 导出问题：当前入口导出 `TSideBarStyle`，存在旧式 `*Style` 类型公开风险，需要确认是否符合 V1.0 公开面规则。
- 覆盖率问题：`87.1%`，未达到 `95%`。

### TSteps

- 覆盖率问题：`87.1%`，未达到 `95%`。

### TBottomTabBar

- 测试问题：Golden 基线为 V1.0 分支新增，当前存在像素差异，应确认当前视觉后更新基线或修复实现。
- 覆盖率问题：`60.3%`，未达到 `95%`。

### TTabBar / Tabs

- 测试问题：Golden 基线为 V1.0 分支新增，当前存在像素差异，应确认当前视觉后更新基线或修复实现。
- 覆盖率问题：`64.8%`，未达到 `95%`。

## 03 输入组件

### TCalendar

- 覆盖率问题：`88.2%`，未达到 `95%`。

### TMultiCascader

- 覆盖率问题：`0.0%`，测试文件未形成有效覆盖。

### TCheckbox

- 导出问题：当前入口导出 `TCheckboxStyle`，存在旧式 `*Style` 类型公开风险，需要确认是否符合 V1.0 公开面规则。
- 覆盖率问题：`32.6%`，未达到 `95%`。

### TDateTimePicker

- 覆盖率问题：`88.0%`，未达到 `95%`。

### TForm

- 覆盖率问题：`49.1%`，未达到 `95%`。

### TInput

- 导出问题：当前入口导出 `TInputCardStyle`，存在旧式 `*Style` 类型公开风险，需要确认是否符合 V1.0 公开面规则。
- 覆盖率问题：`85.2%`，未达到 `95%`。

### TPicker

- 覆盖率问题：`89.6%`，未达到 `95%`。

### TRadio

- 导出问题：当前入口导出 `TRadioStyle`，存在旧式 `*Style` 类型公开风险，需要确认是否符合 V1.0 公开面规则。
- 覆盖率问题：`0.0%`，测试文件未形成有效覆盖。

### TRate

- 覆盖率问题：`68.6%`，未达到 `95%`。

### TSearchBar

- 导出问题：当前入口导出 `TSearchBarStyle`，存在旧式 `*Style` 类型公开风险，需要确认是否符合 V1.0 公开面规则。
- 覆盖率问题：`0.0%`，测试文件未形成有效覆盖。

### TSlider

- 测试问题：Golden 基线为 V1.0 分支新增，当前存在像素差异，应确认当前视觉后更新基线或修复实现。
- 覆盖率问题：`45.8%`，未达到 `95%`。

### TStepper

- 覆盖率问题：`0.0%`，测试文件未形成有效覆盖。

### TSwitch

- 覆盖率问题：`64.1%`，未达到 `95%`。

### TTreeSelect

- 覆盖率问题：`0.0%`，测试文件未形成有效覆盖。

### TUpload

- 覆盖率问题：`0.0%`，测试文件未形成有效覆盖。

## 04 展示组件

### TAvatar

- 覆盖率问题：`0.0%`，测试文件未形成有效覆盖。

### TBadge

- 覆盖率问题：`15.0%`，未达到 `95%`。

### TCell

- 覆盖率问题：`74.7%`，未达到 `95%`。

### TCollapse

- 覆盖率问题：`0.6%`，未达到 `95%`。

### TEmpty

- 覆盖率问题：`59.5%`，未达到 `95%`。

### TFooter

- 覆盖率问题：`0.0%`，测试文件未形成有效覆盖。

### TImage

- 覆盖率问题：`0.0%`，测试文件未形成有效覆盖。

### TImageViewer

- 覆盖率问题：`0.0%`，测试文件未形成有效覆盖。

### TProgress

- 覆盖率问题：`0.0%`，测试文件未形成有效覆盖。

### TResult

- 覆盖率问题：`0.0%`，测试文件未形成有效覆盖。

### TSkeleton

- 覆盖率问题：`7.4%`，未达到 `95%`。

### TSwiper

- 覆盖率问题：`3.4%`，未达到 `95%`。

### TTable

- 覆盖率问题：`0.0%`，测试文件未形成有效覆盖。

### TTag

- 覆盖率问题：`26.4%`，未达到 `95%`。

### TTimeCounter

- 导出问题：当前入口导出 `TTimeCounterTheme`，存在旧式样式类型公开风险，需要确认是否符合 V1.0 公开面规则。
- 覆盖率问题：`0.0%`，测试文件未形成有效覆盖。

## 05 反馈组件

### TActionSheet

- 覆盖率问题：`0.0%`，测试文件未形成有效覆盖。

### TDialog

- 覆盖率问题：`52.3%`，未达到 `95%`。

### TDropdownMenu

- 覆盖率问题：`0.0%`，测试文件未形成有效覆盖。

### TLoading

- 覆盖率问题：`69.9%`，未达到 `95%`。

### TMessage

- 覆盖率问题：`0.0%`，测试文件未形成有效覆盖。

### TNoticeBar

- 覆盖率问题：`0.4%`，未达到 `95%`。

### TPopover

- 覆盖率问题：`0.0%`，测试文件未形成有效覆盖。

### TPopup

- 覆盖率问题：`91.4%`，未达到 `95%`。

### TRefreshHeader

- 覆盖率问题：`0.0%`，测试文件未形成有效覆盖。

### TSwipeCell

- 覆盖率问题：`1.3%`，未达到 `95%`。

### TToast

- 覆盖率问题：`46.4%`，未达到 `95%`。

## 公共问题

### Golden 基线

- 测试问题：Golden 基线是 V1.0 分支新增，不是 develop 历史基线；当前失败不直接等同于相对 develop 的视觉回归。
- 测试问题：新增 Golden 基线与当前实现渲染结果不一致，涉及 `TButton`、`TSlider`、`TBottomTabBar`、`TTabBar/Tabs`，需要确认当前视觉后更新基线或修复实现。

### Analyze / 验收脚本

- 测试问题：`dart analyze` 手动执行失败，但验收报告显示通过，验收脚本存在误报风险。

### Web Build

- 测试问题：Web build 在 `tdesign-component` 根目录失败，应在 `tdesign-component/example` 下执行。

### 覆盖率

- 覆盖率问题：覆盖率验收失败，`52` 个组件低于 `95%`，多个组件为 `0.0%`。

| 组件名 | 覆盖率 | 通过量 |
| --- | --- | --- |
| TButton | 85.3% | 249/292 |
| TDivider | 94.4% | 84/89 |
| TFab | 50.9% | 85/167 |
| TLink | 85.6% | 113/132 |
| TText | 71.4% | 207/290 |
| TBackTop | 93.1% | 134/144 |
| TIndexes | 59.4% | 314/529 |
| TSideBar | 87.1% | 242/278 |
| TSteps | 87.1% | 209/240 |
| TBottomTabBar | 60.3% | 278/461 |
| TTabBar | 64.8% | 553/853 |
| TCalendar | 88.2% | 570/646 |
| TMultiCascader | 0.0% | 0/371 |
| TCheckbox | 32.6% | 114/350 |
| TDateTimePicker | 88.0% | 603/685 |
| TForm | 49.1% | 184/375 |
| TInput | 85.2% | 548/643 |
| TPicker | 89.6% | 493/550 |
| TRadio | 0.0% | 0/148 |
| TRate | 68.6% | 214/312 |
| TSearchBar | 0.0% | 0/137 |
| TSlider | 45.8% | 433/946 |
| TStepper | 0.0% | 0/233 |
| TSwitch | 64.1% | 211/329 |
| TTreeSelect | 0.0% | 0/236 |
| TUpload | 0.0% | 0/195 |
| TAvatar | 0.0% | 0/252 |
| TBadge | 15.0% | 25/167 |
| TCell | 74.7% | 195/261 |
| TCollapse | 0.6% | 1/177 |
| TEmpty | 59.5% | 25/42 |
| TFooter | 0.0% | 0/57 |
| TImage | 0.0% | 0/269 |
| TImageViewer | 0.0% | 0/159 |
| TProgress | 0.0% | 0/349 |
| TResult | 0.0% | 0/45 |
| TSkeleton | 7.4% | 10/136 |
| TSwiper | 3.4% | 4/117 |
| TTable | 0.0% | 0/408 |
| TTag | 26.4% | 47/178 |
| TTimeCounter | 0.0% | 0/245 |
| TActionSheet | 0.0% | 0/421 |
| TDialog | 52.3% | 125/239 |
| TDropdownMenu | 0.0% | 0/529 |
| TLoading | 69.9% | 172/246 |
| TMessage | 0.0% | 0/201 |
| TNoticeBar | 0.4% | 1/234 |
| TPopover | 0.0% | 0/272 |
| TPopup | 91.4% | 522/571 |
| TRefreshHeader | 0.0% | 0/111 |
| TSwipeCell | 1.3% | 3/227 |
| TToast | 46.4% | 90/194 |

## 检测方案

以下命令均从仓库根目录进入 `tdesign-component` 后执行，除 Web build 外不需要切到 `example`。

### 1. 基础命令

| 目标 | 命令 | 通过标准 |
| --- | --- | --- |
| 静态分析 | `cd tdesign-component && flutter analyze` | 退出码为 `0` |
| 全量测试与覆盖率 | `cd tdesign-component && flutter test --coverage` | 退出码为 `0`，生成 `coverage/lcov.info` |
| 自动验收 | `cd tdesign-component && dart run scripts/acceptance/acceptance_check.dart` | 报告无失败项，且结果与手动命令一致 |
| Web build | `cd tdesign-component/example && flutter build web` | 退出码为 `0`，生成 `example/build/web` |

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

| 文件 | 含义 |
| --- | --- |
| `*_masterImage.png` | 当前保存的 Golden 基准图 |
| `*_testImage.png` | 本次测试实际渲染图 |
| `*_isolatedDiff.png` | 独立差异图 |
| `*_maskedDiff.png` | 标记差异区域的差异图 |

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
