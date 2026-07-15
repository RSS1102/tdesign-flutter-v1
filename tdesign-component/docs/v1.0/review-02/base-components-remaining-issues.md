# 基础组件待继续处理问题

## 核实口径

- 本文只记录对照 v1.0 设计口径后，当前源码中仍实际存在的问题。
- `tdesign-component/docs/v1.0/components/01-base/*` 只作为目标口径，不作为被 review 对象。
- 已核实不再作为问题：`TTextConfiguration.updateShouldNotify` 已监听 `globalFontFamily`；`TIcons` 已迁移到 `tdesign_icons: ^0.0.4` 外部包；`TButtonStyle` / `TButtonType` / `TButtonTheme` / `TButtonEvent` / `TButtonStatus` 在 button 源码中未发现残留公开实现。

## P1 必修问题

### 1. `TButton` 渐变路径绕开 `ElevatedButton`，P0 `style` 覆盖不完整

定位：

- `tdesign-component/lib/src/components/button/t_button.dart:103-121`
- `tdesign-component/lib/src/components/button/t_button.dart:166-219`
- `tdesign-component/lib/src/components/button/t_button_theme_data.dart:45-59`
- `tdesign-component/docs/v1.0/components/01-base/button.md:213-244`

证据：

- `TButtonThemeData.gradient` 存在时，`TButton.build` 进入自绘渐变分支，不再使用 `ElevatedButton`。
- 渐变分支只从 `resolvedStyle` 读取 `foregroundColor`，但 padding、shape、minimumSize、side、overlay/elevation 等 ButtonStyle 语义由分支内私有逻辑重新计算。
- v1.0 设计口径要求 P0 `ButtonStyle? style` 覆盖 resolve 结果，`gradient` 是 Theme 字段而非替代整套按钮行为的独立实现路径。

影响：

- 用户传入 P0 `style` 时，在非渐变路径可完整进入 `ElevatedButton(style: resolvedStyle)`，但在渐变路径只会部分生效。
- Theme 中启用 `gradient` 后，同一个 `TButton` 的样式优先级和 Material 行为不再一致，容易出现 P0 覆盖不完整、行为覆盖遗漏的问题。

建议：

- 保留渐变装饰层，但尽量复用同一份 `resolvedStyle` 的尺寸、shape、padding、foreground、overlay 等结果。
- 若渐变必须绕开 `ElevatedButton`，需要明确把 P0 `style` 支持范围补齐。
- 避免让 `gradient` 分支成为一套与常规按钮分叉的独立按钮实现。

## P2 建议彻底收口

### 2. `TFontLoaderWidget.fontFamilyLoaded` 是 dead state

定位：

- `tdesign-component/lib/src/components/text/t_font_loader.dart:61`
- `tdesign-component/lib/src/components/text/t_font_loader.dart:97`

证据：

- `fontFamilyLoaded` 在 State 中声明，并在 `loadFont()` 末尾赋值为 `true`。
- 该字段没有参与 `build`、分支判断、对外回调或加载状态展示。

影响：

- 运行影响较小，但属于重构未清理干净的状态字段。
- 后续维护者会误以为该字段控制渲染或加载状态。

建议：

- 如果不需要加载态分支，删除该字段。
- 如果需要表达字体加载完成状态，应通过 `setState` 后参与渲染或语义逻辑。
