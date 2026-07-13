# TSwiper v1.0 升级指南

> 从 0.2.x 迁移到 v1.0 · **T1 包装 PageView** · 控制类 **B**
> 基于 [swiper.md](./swiper.md) · [theme.md](../../foundation/theme.md) · [api.md](../../foundation/api.md)

---

## 1. 变更总览

| 维度 | 0.2.x | v1.0 |
|------|-------|------|
| **当前页** | `index` | ✏️ `value: int`（B 类受控） |
| **回调** | `onIndexChanged` | ✏️ `onChanged: ValueChanged<int>?` |
| **控制器** | `TSwiperController` | 🗑️ 移除（`value` + `onChanged` 单轨） |
| **指示器** | `SwiperPagination` / `TSwiperDotsPagination` / `TFractionPagination` / `TSwiperArrowPagination` | ✏️ `pagination: TSwiperPaginationVariant` |
| **切换效果** | `transformer` / `TPageTransformer` | ✏️ `pageEffect: TSwiperPageEffect` |
| **依赖** | `flutter_swiper_null_safety` | 🗑️ 移除（内部 `PageView`） |
| **L4 样式** | `pagination.margin` / `dotsColor` / `dotsActiveColor` / `autoplayDelay` 等 | 📦 迁入 `TSwiperThemeData` |
| **ThemeExtension** | — | ✨ 新增 `TSwiperThemeData` |

---

## 2. 逐项代码替换

### 2.1 枚举改名/新增

| 删（0.2.x） | 增（v1.0） |
|----|----|
| `SwiperPagination` / `TSwiperDotsPagination` / `TFractionPagination` / `TSwiperArrowPagination` | `enum TSwiperPaginationVariant { none, dots, dotsBar, fraction, controls }` |
| `TPageTransformer` | `enum TSwiperPageEffect { none, cardMargin, scaleAndFade }` |
| `TSwiperController` | 🗑️ 移除 |

### 2.2 构造器参数对照

| 0.2.x 参数 | v1.0 参数 | 迁移方式 |
|------------|----------|---------|
| `index: 0` | ✏️ `value: 0` | B 类受控 |
| `onIndexChanged: (i) {}` | ✏️ `onChanged: (i) {}` | 改名 |
| `SwiperPagination()` | ✏️ `pagination: TSwiperPaginationVariant.dots` | 枚举化 |
| `pagination.alignment` | ✏️ `paginationAlignment: AlignmentGeometry` | 改名 |
| `transformer` / `TPageTransformer.xxx` | ✏️ `pageEffect: TSwiperPageEffect.xxx` | 枚举化 |
| `scale` (Swiper 构造器) | ✏️ `pageEffect: TSwiperPageEffect.scaleAndFade` | 并入效果 |
| `TSwiperController` | 🗑️ 移除 | `value` + `onChanged` 单轨 |
| `pagination.margin` | 📦 `TSwiperThemeData.paginationMargin` | 迁入 Theme |
| `TSwiperDotsPagination.activeColor` | 📦 `TSwiperThemeData.dotsActiveColor` | 迁入 Theme |
| `TSwiperDotsPagination.inactiveColor` | 📦 `TSwiperThemeData.dotsInactiveColor` | 迁入 Theme |
| `TSwiperDotsPagination.size` | 📦 `TSwiperThemeData.dotsSize` | 迁入 Theme |
| `TFractionPagination.*` | 📦 `TSwiperThemeData.fractionStyle` | 迁入 Theme |
| `autoplayDelay` | 📦 `TSwiperThemeData.autoplayInterval` | 迁入 Theme |
| `children` / `itemBuilder` / `itemCount` | 不变 | — |
| `loop` / `autoplay` | 不变 | — |
| `physics` / `pageSnapping` / `padEnds` / `clipBehavior` / `reverse` | 不变 | Material 同名 KEEP |

### 2.3 完整示例

```dart
// === 0.2.x ===
Swiper(
  index: _currentIndex,
  onIndexChanged: (i) {
    setState(() => _currentIndex = i);
  },
  itemCount: 3,
  itemBuilder: (ctx, i) => Image.network(images[i]),
  autoplay: true,
  autoplayDelay: 3000,
  pagination: SwiperPagination(
    alignment: Alignment.bottomCenter,
    builder: DotSwiperPaginationBuilder(),
  ),
  controller: _swiperController,
);

// === v1.0 ===
Theme(
  data: Theme.of(context).mergeExtension(
    const TSwiperThemeData(autoplayInterval: Duration(milliseconds: 3000)),
  ),
  child: TSwiper(
    value: _currentIndex,
    onChanged: (i) {
      setState(() => _currentIndex = i);
    },
    itemCount: 3,
    itemBuilder: (ctx, i) => Image.network(images[i]),
    autoplay: true,
    pagination: TSwiperPaginationVariant.dots,
    paginationAlignment: Alignment.bottomCenter,
  ),
);
```

---

## 3. Theme 注入方式

```dart
// 子树注入
Theme(
  data: Theme.of(context).mergeExtension(
    const TSwiperThemeData(
      dotsActiveColor: Colors.blue,
      dotsInactiveColor: Colors.grey,
      dotsSize: 8,
      paginationMargin: EdgeInsets.only(bottom: 16),
    ),
  ),
  child: TSwiper(
    value: 0,
    itemCount: 3,
    itemBuilder: (ctx, i) => Container(color: Colors.red),
  ),
);

// 全局注入
MaterialApp(
  theme: ThemeData(extensions: [const TSwiperThemeData()]),
  ...
)
```

### 优先级链

```
构造器参数（children / itemBuilder / itemCount / value / onChanged / loop / autoplay / pagination / paginationAlignment / pageEffect / physics 等）
  > TSwiperThemeData（paginationMargin / dotsActiveColor / dotsInactiveColor / dotsSize / fractionStyle / autoplayInterval）
    > Material PageView
      > Token
```

---

## 4. Export 变更

| 符号 | v1.0 是否 export | 说明 |
|------|-----------------|------|
| `TSwiper` | ✅ 保留 | Widget |
| `TSwiperPaginationVariant` | ✅ 保留 | 指示器枚举 |
| `TSwiperPageEffect` | ✅ 保留 | 切换效果枚举 |
| `TSwiperThemeData` | ✅ 保留 | ThemeExtension |
| `TSwiperController` | 🚫 移出 | 已移除（value + onChanged） |
| `TSwiperPagination` 等 | 🚫 移出 | 已枚举化 |
| `TPageTransformer` | 🚫 移出 | 已枚举化 |
| `flutter_swiper_null_safety` | 🚫 移除依赖 | 内部 PageView |

---

## 5. 升级检查清单

- [ ] `index` → `value: int`
- [ ] `onIndexChanged` → `onChanged`
- [ ] `SwiperPagination` / `TSwiperDotsPagination` 等 → `pagination: TSwiperPaginationVariant.xxx`
- [ ] `pagination.alignment` → `paginationAlignment`
- [ ] `transformer` / `TPageTransformer` → `pageEffect: TSwiperPageEffect.xxx`
- [ ] `TSwiperController` → `value` + `onChanged` 单轨
- [ ] `autoplayDelay` → `TSwiperThemeData.autoplayInterval`
- [ ] dots 色/尺寸 → `TSwiperThemeData`
- [ ] 移除 `flutter_swiper_null_safety` 依赖
- [ ] `TSwiperController` / `TSwiperPagination` / `TPageTransformer` 不在 export 中
- [ ] 更新 Example 页面 + API 文档
