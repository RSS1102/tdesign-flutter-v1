## API
### TImage
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| alignment | AlignmentGeometry | Alignment.center | - |
| errorBuilder | ImageErrorWidgetBuilder? | - | - |
| errorWidget | Widget? | - | 失败自定义提示 |
| filterQuality | FilterQuality | FilterQuality.low | - |
| fit | BoxFit? | - | 适配样式 |
| frameBuilder | ImageFrameBuilder? | - | 以下系统 Image 属性，释义请参考系统 `Image` 中注释 |
| imageFile | File? | - | 图片文件路径 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| loadingBuilder | ImageLoadingBuilder? | - | - |
| loadingWidget | Widget? | - | 加载自定义提示 |
| repeat | ImageRepeat | ImageRepeat.noRepeat | - |
| semanticLabel | String? | - | - |
| src | String? | - | 图片地址（网络 URL 或本地 asset 路径） |
| variant | TImageVariant | TImageVariant.roundedSquare | 图片形态 |
| width | double? | - | 自定义宽 |


### TImageVariant
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| clip | 裁剪 |
| fitHeight | 适应高 |
| fitWidth | 适应宽 |
| stretch | 拉伸 |
| square | 方形 |
| roundedSquare | 圆角方形 |
| circle | 圆形 |
