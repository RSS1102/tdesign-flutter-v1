# 展示类组件 Demo 问题

## 诊断口径

- 本文只记录 demo 实测暴露的问题、源码定位、初步根因和是否建议进入 review。
- 相关组件的源码 review 仍保留在 `../源码/` 下的同类文件中。

### 1. `TBadge` demo 页面滚动卡死，数字徽标在部分示例中被默认裁剪

定位：

- `tdesign-component/example/lib/page/t_badge_page.dart:20-121`
- `tdesign-component/example/lib/page/t_badge_page.dart:240-307`
- `tdesign-component/example/lib/page/t_badge_page.dart:311-467`
- `tdesign-component/lib/src/components/badge/t_badge.dart:181-219`

证据：

- `TBadgePage` 一页里塞了大量 `CodeWrapper + Stack + Positioned + Icon/TAvatar/TButton` 示例，滚动区本身就比普通组件页更重。
- 一部分自定义示例的 `Stack` 没有显式写 `clipBehavior: Clip.none`，而 `Stack` 默认会裁剪溢出内容。
- 徽标数字类示例中，badge 往往靠 `Positioned` 挂在父容器外侧，父容器又没有稳定的预留尺寸，容易出现“徽标被切掉”的视觉问题。

诊断：

- 数字徽标被裁剪是 demo 布局问题，核心原因是父容器没有给 badge 留出足够的外溢空间，同时部分 `Stack` 没有关闭裁剪。
- 页面滚动卡死目前还不能只凭源码把根因钉死，但从结构上看，重型示例过多、嵌套层级深、滚动时重建压力大，是最直接的风险来源。

Review 建议：

- 需要进入 demo review，优先拆轻页面。
- 所有 badge 溢出式示例统一显式加 `clipBehavior: Clip.none`，并给父容器预留稳定尺寸。
- 如滚动卡死可稳定复现，再进一步拆分 `CodeWrapper` 和大图标示例定位具体重建热点。

### 2. `TTable` demo 的操作列文字容易溢出，原因是单元格布局没有做收敛

定位：

- `tdesign-component/example/lib/page/t_table_page.dart:131-163`
- `tdesign-component/example/lib/page/t_table_page.dart:209-247`

证据：

- 操作列直接在 `Row(mainAxisAlignment: MainAxisAlignment.spaceBetween)` 里放两个 `TText`，没有给文本设置弹性宽度或省略策略。
- 表格列宽在多个示例里是固定值，操作列文字又是中文短词，但一旦表格整体宽度被压缩，`Row` 里的两个文本就会先抢空间。

诊断：

- 这是 demo 单元格布局没有收敛的问题，不是表格核心数据逻辑错误。
- 当前写法更像“能展示内容”，但不是“能稳定适配不同宽度”的表格操作列写法。

Review 建议：

- 需要进入 demo review。
- 操作列应改成固定宽度 + 居中排列，或者给文本加弹性与省略，避免在窄屏上直接溢出。

### 3. `Tag` 和 `SelectTag` demo 被拆成两个组件入口，review 口径需要归并

定位：

- `tdesign-component/example/lib/config.dart:312-313`
- `tdesign-component/example/lib/page/t_tag_page.dart`
- `tdesign-component/example/lib/page/t_select_tag_page.dart`
- `tdesign-component/lib/src/components/tag/t_tag.dart`
- `tdesign-component/lib/src/components/tag/t_select_tag.dart`

证据：

- 展示类配置中同时存在 `Tag 标签 (V1.0)` 与 `SelectTag 可选标签 (V1.0)` 两个入口。
- `TSelectTag` 基于 `TTag` 能力扩展可选状态，二者属于同一个标签组件族。
- 用户补充确认：`tag` 和 `SelectTag` 为同一个组件，不应在 review 和后续修复中作为两个独立组件拆分。

诊断：

- 这是 demo / review 组件归类口径问题。
- 拆成两个独立组件入口会导致文档、验收、问题归档和后续修复重复统计。

Review 建议：

- 需要进入 demo review。
- 后续统一按 `Tag` 组件族记录，在同一组件页或同一 review 条目下区分普通标签和可选标签能力。
- 如 demo 仍保留两个入口，需要在文案和文档中明确它们属于同一组件族，不作为两个独立组件验收。

### 4. `Cell` 和 `CellGroup` demo 被拆成两个组件入口，review 口径需要归并

定位：

- `tdesign-component/example/lib/config.dart:314-315`
- `tdesign-component/example/lib/page/t_cell_page.dart`
- `tdesign-component/example/lib/page/t_cell_group_page.dart`
- `tdesign-component/lib/src/components/cell/t_cell.dart`
- `tdesign-component/lib/src/components/cell/t_cell_group.dart`

证据：

- 展示类配置中同时存在 `Cell 单元格 (V1.0)` 与 `CellGroup 单元格组 (V1.0)` 两个入口。
- `TCellGroup` 是 `TCell` 的分组容器能力，二者属于同一个单元格组件族。
- 用户补充确认：`Cell` 和 `CellGroup` 为同一个组件，不应在 review 和后续修复中作为两个独立组件拆分。

诊断：

- 这是 demo / review 组件归类口径问题。
- 拆成两个独立组件入口会导致组件清单、文档页、验收范围和问题归档重复。

Review 建议：

- 需要进入 demo review。
- 后续统一按 `Cell` 组件族记录，在同一组件页或同一 review 条目下区分单元格和单元格组能力。
- 如 demo 仍保留两个入口，需要在文案和文档中明确它们属于同一组件族，不作为两个独立组件验收。
