import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../base/example_widget.dart';

class TImageViewerPage extends StatefulWidget {
  const TImageViewerPage({Key? key}) : super(key: key);

  @override
  State<TImageViewerPage> createState() => _TImageViewerPageState();
}

class _TImageViewerPageState extends State<TImageViewerPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: 'ImageViewer 图片预览',
      desc: '点击图片可全屏预览',
      exampleCodeGroup: 'image-viewer',
      children: [
        ExampleModule(title: '基础用法', children: [
          ExampleItem(desc: '预览单张图片', builder: _buildSingle),
          ExampleItem(desc: '预览多张图片', builder: _buildMultiple),
        ]),
      ],
    );
  }

  Widget _buildSingle(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TImageViewer.showImageViewer(
          context: context,
          images: ['https://tdesign.gtimg.com/site/avatar.jpg'],
          closeBtn: true,
        );
      },
      child: const TImage(
        src: 'https://tdesign.gtimg.com/site/avatar.jpg',
        variant: TImageVariant.roundedSquare,
      ),
    );
  }

  Widget _buildMultiple(BuildContext context) {
    final images = [
      'https://tdesign.gtimg.com/site/avatar.jpg',
      'https://tdesign.gtimg.com/site/avatar.jpg',
    ];
    return Wrap(
      spacing: 8,
      children: images.asMap().entries.map((entry) {
        return GestureDetector(
          onTap: () {
            TImageViewer.showImageViewer(
              context: context,
              images: images,
              defaultIndex: entry.key,
              showIndex: true,
            );
          },
          child: TImage(
            src: entry.value,
            variant: TImageVariant.roundedSquare,
          ),
        );
      }).toList(),
    );
  }
}
