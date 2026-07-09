# TDesign Flutter V1.0 组件自动化验收报告

> 生成时间: 2026-07-09T15:42:00.881374
> 验收标准: [component-acceptance-standard.md](../../docs/v1.0/guide/component-acceptance-standard.md)
> 组件总数: 56

## 汇总

| 指标 | 值 |
|------|----|
| 检查项总数 | 14 |
| 通过 | 13 |
| 失败 | 1 |
| 通过率 | 92.9% |
| 总体结论 | ❌ **有未通过项** |

## 详细结果

### 档1-静态核查

| 检查项 | 结果 | 明细 |
|--------|------|------|
| 构造器 themeData: 参数 | ✅ | 未发现 themeData: 构造器参数 |
| copyWith(extensions: 禁用 | ✅ | 未发现 copyWith(extensions: 使用 |
| TTheme.of( 残留 | ✅ | 未发现 TTheme.of( 残留 |
| build 内 Colors. 硬编码（非白名单） | ✅ | 未发现非白名单 Colors. 硬编码 |

### 项C-export收敛

| 检查项 | 结果 | 明细 |
|--------|------|------|
| *Style 不 export | ✅ | export 中未发现 *Style 符号 |

### 项F-resolve单入口

| 检查项 | 结果 | 明细 |
|--------|------|------|
| resolve 文件存在 + build 无内联色值 | ✅ | 6 个 resolve 组件全部通过 |

### 项B-禁用写法

| 检查项 | 结果 | 明细 |
|--------|------|------|
| A/B/C 类不暴露 disabled 构造器 | ✅ | A/B/C 类组件均未暴露 disabled 构造器 |

### 项A-Demo注册

| 检查项 | 结果 | 明细 |
|--------|------|------|
| config.dart 注册 + V1.0 标记 + page 文件 | ✅ | 56 个组件全部注册且标 V1.0 |

### 核心4-文档注释

| 检查项 | 结果 | 明细 |
|--------|------|------|
| 主 Widget 类有 /// 中文注释 | ✅ | 56 个组件主 Widget 均有 /// 注释 |

### 测试-文件存在

| 检查项 | 结果 | 明细 |
|--------|------|------|
| 每组件有测试文件 | ✅ | 56 个组件均有测试文件 |

### 核心3-覆盖率

| 检查项 | 结果 | 明细 |
|--------|------|------|
| 每组件行覆盖率 ≥ 95% | ❌ | 52 个组件低于 95%:<br>TButton: 85.3% (249/292)<br>TDivider: 94.4% (84/89)<br>TFab: 50.9% (85/167)<br>TLink: 85.6% (113/132)<br>TText: 71.4% (207/290)<br>TBackTop: 93.1% (134/144)<br>TIndexes: 59.4% (314/529)<br>TSideBar: 87.1% (242/278)<br>TSteps: 87.1% (209/240)<br>TBottomTabBar: 60.3% (278/461)<br>TTabBar: 64.8% (553/853)<br>TCalendar: 88.2% (570/646)<br>TMultiCascader: 0.0% (0/371)<br>TCheckbox: 32.6% (114/350)<br>TDateTimePicker: 88.0% (603/685)<br>TForm: 49.1% (184/375)<br>TInput: 85.2% (548/643)<br>TPicker: 89.6% (493/550)<br>TRadio: 0.0% (0/148)<br>TRate: 68.6% (214/312)<br>TSearchBar: 0.0% (0/137)<br>TSlider: 45.8% (433/946)<br>TStepper: 0.0% (0/233)<br>TSwitch: 64.1% (211/329)<br>TTreeSelect: 0.0% (0/236)<br>TUpload: 0.0% (0/195)<br>TAvatar: 0.0% (0/252)<br>TBadge: 15.0% (25/167)<br>TCell: 74.7% (195/261)<br>TCollapse: 0.6% (1/177)<br>TEmpty: 59.5% (25/42)<br>TFooter: 0.0% (0/57)<br>TImage: 0.0% (0/269)<br>TImageViewer: 0.0% (0/159)<br>TProgress: 0.0% (0/349)<br>TResult: 0.0% (0/45)<br>TSkeleton: 7.4% (10/136)<br>TSwiper: 3.4% (4/117)<br>TTable: 0.0% (0/408)<br>TTag: 26.4% (47/178)<br>TTimeCounter: 0.0% (0/245)<br>TActionSheet: 0.0% (0/421)<br>TDialog: 52.3% (125/239)<br>TDropdownMenu: 0.0% (0/529)<br>TLoading: 69.9% (172/246)<br>TMessage: 0.0% (0/201)<br>TNoticeBar: 0.4% (1/234)<br>TPopover: 0.0% (0/272)<br>TPopup: 91.4% (522/571)<br>TRefreshHeader: 0.0% (0/111)<br>TSwipeCell: 1.3% (3/227)<br>TToast: 46.4% (90/194) |

### 项E-analyze

| 检查项 | 结果 | 明细 |
|--------|------|------|
| dart analyze 零 ERROR | ✅ | dart analyze 零 ERROR |

### 项E-Golden

| 检查项 | 结果 | 明细 |
|--------|------|------|
| P0 组件 Golden 基线 | ✅ | 3 个 P0 组件（TButton/TSlider/TTabBar）均有 golden 测试 + 基线 |

### 项D-API文档一致

| 检查项 | 结果 | 明细 |
|--------|------|------|
| 生成 API vs 设计文档 §1 参数一致 | ✅ | 56 个组件 API 文档与 §1 参数一致 |

## 验收标准映射

| 验收文档条目 | 对应检查项 | 结果 |
|-------------|-----------|------|
| **核心1** API 实现 + 样式不回退 | 档1 静态核查 + 项F resolve 单入口 | ✅ 通过 |
| **核心2** Theme 覆盖（两层注入 + 优先级） | 档1 静态核查 + 档2 Widget 测试 | ✅ 通过 |
| **核心3** 测试覆盖率 ≥ 95% | 覆盖率解析 | ❌ 未通过 |
| **核心4** 文档注释 | /// 注释检查 | ✅ 通过 |
| **项A** Demo 注册 | config.dart + page 文件 | ✅ 通过 |
| **项B** 禁用写法 | A/B/C 类不暴露 disabled | ✅ 通过 |
| **项C** export 收敛 | *Style 不 export | ✅ 通过 |
| **项D** API 文档一致 | 生成 API vs §1 | ✅ 通过 |
| **项E** CI 双端 + Golden | analyze + Golden + 测试文件 | ✅ 通过 |
| **项F** resolve 单入口 | build 无内联色值 | ✅ 通过 |
| **项G** Web 验收 | flutter build web | 见 CI |

## 说明

- **项G（Web 验收）** 和 **双端真机验证** 需在 CI 中执行，本脚本不覆盖。
- **档2 Widget 测试**（Token 读取 + 优先级覆盖）见 `test/acceptance/theme_acceptance_test.dart`。
- **档3 真机/Web 目测** 需人工执行，不在自动化范围内。
