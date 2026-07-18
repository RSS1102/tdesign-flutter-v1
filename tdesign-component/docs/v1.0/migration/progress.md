# v1.0 迁移进展

> 本文件记录分批迁移到 `tdesign-flutter` 主仓的阶段状态。状态仅表示当前 v1 仓库内准备程度，不等同于主仓 PR 已合入。

## 状态说明

| 状态 | 含义 |
| --- | --- |
| Not Started | 尚未进入迁移准备 |
| In Progress | 已开始实现或验收，但仍有待修复项 |
| Ready for PR | v1 仓库内已具备提交主仓 PR 的基本条件 |
| In PR | 已提交主仓 PR，等待 review |
| Merged | 已合入主仓 |
| Blocked | 被外部依赖或未解决争议阻塞 |

## 阶段进展

| 阶段 | 范围 | 当前状态 | 最近验证 / 备注 |
| --- | --- | --- | --- |
| PR 0 | 重构基础设施、验收约束、迁移说明 | Ready for PR | 本目录已新增迁移方案；仍需按主仓 CI 情况确认最终脚本入口 |
| PR 1 | Foundation / Theme / Token | Ready for PR | `TThemeBuilder.light/dark` 已接入 M3 `ThemeData`、Material 子主题、全局组件 `ThemeExtension`；已通过专用 ThemeData barrel 隔离包总出口依赖；定向测试和 analyze 已通过 |
| PR 2 | `text` / `divider` / `icon` | Ready for PR | 已纳入 01-base 定向测试和 analyze；仍建议在提交前复跑单组件 docs validate |
| PR 3 | `button` / `link` | Ready for PR | 已纳入 01-base 定向测试和 analyze；`button` 单文件覆盖率仍低于 95%，但 01-base 总覆盖率已达标 |
| PR 4 | `fab` | Ready for PR | FAB 定向测试 68 个通过；FAB analyze 0 issues；tools FAB validate `ERROR=0, WARN=0` |
| PR 5 | 02-input / Form 基础能力 | Not Started | 等 01-base 主仓迁移路线稳定后推进 |
| PR 6 | Overlay / Popup / Feedback 基础设施 | Not Started | 建议在 input 基础能力后推进 |
| PR 7 | Display / Navigation 中低风险组件 | Not Started | 可按依赖低风险组件继续拆分 |
| PR 8+ | picker/date-picker/dropdown/select/table/upload 等复杂组件 | Not Started | 建议单组件或三段式 PR |
| Final PR | export、索引、CI、全量验收收口 | Not Started | 等主要组件迁移完成后执行 |

## 当前 01-base 验收快照

最近一次 v1 仓库验证结果：

| 验收项 | 结果 |
| --- | --- |
| FAB 定向测试 | 通过，68 个测试 |
| FAB 定向 analyze | 0 issues |
| Foundation / Theme 定向测试 | 通过 |
| Foundation / Theme 定向 analyze | 0 issues |
| Foundation PR 边界 | `TThemeBuilder` 不反向依赖 `tdesign_flutter.dart` 总出口；当前组件 ThemeData 默认定义均已注入 |
| 01-base 定向测试 + coverage | 通过 |
| 01-base 源码总覆盖率 | 95.60% (890/931) |
| 01-base 定向 analyze | 0 issues |
| FAB tools validate | `ERROR=0, WARN=0` |

## 当前剩余风险

| 风险 | 影响 | 建议处理 |
| --- | --- | --- |
| `lib/src/components/button/t_button.dart` 单文件覆盖率约 74.53% | 若主仓要求每个文件都达到 95%，PR 3 会被拦截 | 在 PR 3 前补充 Button widget 行为测试，或明确覆盖率口径为组件域总覆盖率 |
| `lib/src/components/text/t_font_loader.dart` 单文件覆盖率约 92.31% | 若主仓要求每个文件 95%，PR 2 可能需要补测 | 补充 font loader 异常/回退路径测试 |
| 全量组件 ThemeExtension 已由 `TThemeBuilder` 默认注入 | 让全局 Theme 可控，但部分后续组件尚未完成迁移复查 | 后续组件 PR 继续按各自文档验证字段分类和默认值 |
| 主仓 CI 与 v1 本地命令可能不完全一致 | 本地 Ready for PR 不一定等同主仓 CI 通过 | PR 0 明确主仓 CI 适配清单 |

## 下一步建议

1. 先开 PR 0，提交迁移约束、验收口径和文档索引。
2. 再开 PR 2 或 PR 1，取决于主仓是否需要先合 foundation。
3. `button/link` 与 `fab` 分开提交，避免交互 resolve 和拖拽定位逻辑混在一个 review 中。
4. 如果主仓要求“每文件 95% 覆盖率”，先补 `t_button.dart` 和 `t_font_loader.dart`，再提交对应 PR。
