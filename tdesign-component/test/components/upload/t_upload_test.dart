import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TUpload V1.0 Widget 测试
///
/// 覆盖：
/// - 基础渲染（空文件列表、带文件列表）
/// - TUploadVariant 枚举（roundedSquare/circle）
/// - TUploadFileStatus 枚举（success/loading/error/retry）
/// - TUploadMediaType 枚举
/// - 禁用状态（onChanged=null）
/// - multiple/single 模式
/// - max 数量限制
/// - width/height 参数
/// - wrapSpacing/wrapRunSpacing/wrapAlignment 参数
/// - onPressed/onUploadTap 回调
/// - Theme 覆盖
/// - 删除按钮
/// - 边界场景
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child, {TUploadThemeData? uploadTheme}) {
    final themeExtensions = <ThemeExtension>[
      TThemeData.defaultData(),
      if (uploadTheme != null) uploadTheme,
    ];
    return MaterialApp(
      theme: ThemeData(extensions: themeExtensions),
      home: Scaffold(body: child),
    );
  }

  // 构造测试文件
  TUploadFile buildFile({
    int key = 1,
    String? remotePath = 'https://example.com/test.png',
    TUploadFileStatus status = TUploadFileStatus.success,
    bool canDelete = true,
    int? progress,
    String loadingText = 'Loading...',
    String retryText = 'Re-Upload',
    String errorText = 'Error',
  }) {
    return TUploadFile(
      key: key,
      remotePath: remotePath,
      status: status,
      canDelete: canDelete,
      progress: progress,
      loadingText: loadingText,
      retryText: retryText,
      errorText: errorText,
    );
  }

  // ============================================================
  // 基础渲染
  // ============================================================
  group('TUpload 基础渲染', () {
    testWidgets('空文件列表渲染上传按钮', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: const [],
          onChanged: (files, type) {},
        ),
      ));
      expect(find.byType(TUpload), findsOneWidget);
      // 应有 add 图标
      expect(find.byIcon(TIcons.add), findsOneWidget);
    });

    testWidgets('带文件列表渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: [buildFile(key: 1), buildFile(key: 2, remotePath: 'https://example.com/test2.png')],
          onChanged: (files, type) {},
        ),
      ));
      await tester.pump();
      expect(find.byType(TUpload), findsOneWidget);
      // 2 个文件 + 1 个上传按钮
      expect(find.byType(TImage), findsNWidgets(2));
    });

    testWidgets('单文件渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: [buildFile(key: 1)],
          onChanged: (files, type) {},
        ),
      ));
      await tester.pump();
      expect(find.byType(TImage), findsOneWidget);
    });
  });

  // ============================================================
  // TUploadVariant 枚举
  // ============================================================
  group('TUploadVariant 枚举', () {
    testWidgets('type=roundedSquare 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: const [],
          type: TUploadVariant.roundedSquare,
          onChanged: (files, type) {},
        ),
      ));
      expect(find.byType(TUpload), findsOneWidget);
    });

    testWidgets('type=circle 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: const [],
          type: TUploadVariant.circle,
          onChanged: (files, type) {},
        ),
      ));
      expect(find.byType(TUpload), findsOneWidget);
    });

    testWidgets('type=circle 时上传按钮为圆形', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: const [],
          type: TUploadVariant.circle,
          onChanged: (files, type) {},
        ),
      ));
      // 验证有 BoxDecoration shape=circle
      final boxes = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(TUpload),
          matching: find.byType(Container),
        ),
      );
      final hasCircle = boxes.any((c) =>
          c.decoration is BoxDecoration &&
          (c.decoration as BoxDecoration).shape == BoxShape.circle);
      expect(hasCircle, isTrue);
    });
  });

  // ============================================================
  // TUploadFileStatus 枚举
  // ============================================================
  group('TUploadFileStatus 枚举', () {
    testWidgets('status=loading 渲染遮罩和进度', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: [buildFile(key: 1, status: TUploadFileStatus.loading, progress: 50)],
          onChanged: (files, type) {},
        ),
      ));
      await tester.pump();
      // 进度文本
      expect(find.text('50%'), findsOneWidget);
    });

    testWidgets('status=loading 无 progress 显示 loadingText', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: [buildFile(key: 1, status: TUploadFileStatus.loading, loadingText: '上传中...')],
          onChanged: (files, type) {},
        ),
      ));
      await tester.pump();
      expect(find.text('上传中...'), findsOneWidget);
    });

    testWidgets('status=error 渲染错误图标和文本', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: [buildFile(key: 1, status: TUploadFileStatus.error, errorText: '上传失败')],
          onChanged: (files, type) {},
        ),
      ));
      await tester.pump();
      expect(find.text('上传失败'), findsOneWidget);
      expect(find.byIcon(TIcons.close_circle), findsOneWidget);
    });

    testWidgets('status=retry 渲染重试图标和文本', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: [buildFile(key: 1, status: TUploadFileStatus.retry, retryText: '重试')],
          onChanged: (files, type) {},
        ),
      ));
      await tester.pump();
      expect(find.text('重试'), findsOneWidget);
      expect(find.byIcon(TIcons.refresh), findsOneWidget);
    });

    testWidgets('status=success 不显示遮罩', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: [buildFile(key: 1, status: TUploadFileStatus.success)],
          onChanged: (files, type) {},
        ),
      ));
      await tester.pump();
      // success 状态不显示错误图标
      expect(find.byIcon(TIcons.close_circle), findsNothing);
      expect(find.byIcon(TIcons.refresh), findsNothing);
    });
  });

  // ============================================================
  // 禁用状态
  // ============================================================
  group('TUpload 禁用状态', () {
    testWidgets('onChanged=null 时禁用上传', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TUpload(files: []),
      ));
      expect(find.byType(TUpload), findsOneWidget);
      // 点击上传按钮不应崩溃
      await tester.tap(find.byIcon(TIcons.add), warnIfMissed: false);
      await tester.pump();
      // 无 onChanged 回调，不会触发选择器
    });

    testWidgets('onUploadTap 回调被调用', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: const [],
          onUploadTap: () => tapped = true,
          onChanged: (files, type) {},
        ),
      ));
      await tester.tap(find.byIcon(TIcons.add));
      await tester.pump();
      expect(tapped, isTrue);
    });
  });

  // ============================================================
  // 数量限制与多选
  // ============================================================
  group('TUpload 数量限制与多选', () {
    testWidgets('multiple=true max=3 时显示上传按钮', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: [buildFile(key: 1), buildFile(key: 2)],
          multiple: true,
          max: 3,
          onChanged: (files, type) {},
        ),
      ));
      await tester.pump();
      // 2 个文件 < 3，应显示上传按钮
      expect(find.byIcon(TIcons.add), findsOneWidget);
    });

    testWidgets('multiple=true 达到 max 时不显示上传按钮', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: [buildFile(key: 1), buildFile(key: 2), buildFile(key: 3)],
          multiple: true,
          max: 3,
          onChanged: (files, type) {},
        ),
      ));
      await tester.pump();
      // 已达上限，不显示上传按钮
      expect(find.byIcon(TIcons.add), findsNothing);
    });

    testWidgets('single 模式有文件时不显示上传按钮', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: [buildFile(key: 1)],
          multiple: false,
          onChanged: (files, type) {},
        ),
      ));
      await tester.pump();
      expect(find.byIcon(TIcons.add), findsNothing);
    });

    testWidgets('初始文件数超过 max 触发 onMaxLimitReached', (tester) async {
      var maxReached = false;
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: [buildFile(key: 1), buildFile(key: 2), buildFile(key: 3)],
          multiple: true,
          max: 2,
          onMaxLimitReached: () => maxReached = true,
          onChanged: (files, type) {},
        ),
      ));
      await tester.pump();
      expect(maxReached, isTrue);
    });
  });

  // ============================================================
  // 布局参数
  // ============================================================
  group('TUpload 布局参数', () {
    testWidgets('width/height 参数生效', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: const [],
          width: 100,
          height: 100,
          onChanged: (files, type) {},
        ),
      ));
      final containers = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(TUpload),
          matching: find.byType(Container),
        ),
      );
      final hasCustomSize = containers.any((c) => c.constraints?.maxWidth == 100);
      expect(hasCustomSize, isTrue);
    });

    testWidgets('wrapSpacing/wrapRunSpacing/wrapAlignment 参数', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: [buildFile(key: 1), buildFile(key: 2)],
          wrapSpacing: 12,
          wrapRunSpacing: 20,
          wrapAlignment: WrapAlignment.center,
          onChanged: (files, type) {},
        ),
      ));
      await tester.pump();
      final wrap = tester.widget<Wrap>(
        find.descendant(
          of: find.byType(TUpload),
          matching: find.byType(Wrap),
        ),
      );
      expect(wrap.spacing, 12);
      expect(wrap.runSpacing, 20);
      expect(wrap.alignment, WrapAlignment.center);
    });
  });

  // ============================================================
  // 删除与回调
  // ============================================================
  group('TUpload 删除与回调', () {
    testWidgets('点击删除按钮触发 onChanged remove', (tester) async {
      List<TUploadFile>? changedFiles;
      TUploadAction? changedType;
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: [buildFile(key: 1)],
          onChanged: (files, type) {
            changedFiles = files;
            changedType = type;
          },
        ),
      ));
      await tester.pump();
      // 删除按钮在 Positioned 中，用 at(0) 找到第一个 close 图标
      final closeIcons = find.byIcon(TIcons.close);
      // 找到 size=16 的删除按钮图标
      final deleteIcon = find.descendant(
        of: find.byType(Positioned),
        matching: closeIcons,
      );
      await tester.tap(deleteIcon.first);
      await tester.pump();
      expect(changedType, TUploadAction.remove);
      expect(changedFiles, isNotNull);
    });

    testWidgets('canDelete=false 时不显示删除按钮', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: [buildFile(key: 1, canDelete: false)],
          onChanged: (files, type) {},
        ),
      ));
      await tester.pump();
      // canDelete=false 时 Positioned 中不应有 close 图标
      final deleteIcon = find.descendant(
        of: find.byType(Positioned),
        matching: find.byIcon(TIcons.close),
      );
      expect(deleteIcon, findsNothing);
    });

    testWidgets('onPressed 点击图片触发', (tester) async {
      int? pressedKey;
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: [buildFile(key: 1)],
          onPressed: (key) => pressedKey = key,
          onChanged: (files, type) {},
        ),
      ));
      await tester.pump();
      // 点击图片
      await tester.tap(find.byType(TImage));
      await tester.pump();
      expect(pressedKey, 1);
    });
  });

  // ============================================================
  // Theme 覆盖
  // ============================================================
  group('TUpload Theme 覆盖', () {
    testWidgets('TUploadThemeData 注入不崩溃', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: const [],
          onChanged: (files, type) {},
        ),
        uploadTheme: const TUploadThemeData(
          variant: TUploadVariant.circle,
          width: 120,
          height: 120,
          wrapSpacing: 10,
          wrapRunSpacing: 10,
          wrapAlignment: WrapAlignment.center,
        ),
      ));
      expect(find.byType(TUpload), findsOneWidget);
    });
  });

  // ============================================================
  // TUploadFile 数据模型
  // ============================================================
  group('TUploadFile 数据模型', () {
    test('TUploadFile 默认值', () {
      final file = TUploadFile(key: 1);
      expect(file.key, 1);
      expect(file.remotePath, isNull);
      expect(file.assetPath, isNull);
      expect(file.file, isNull);
      expect(file.status, TUploadFileStatus.success);
      expect(file.canDelete, isTrue);
      expect(file.progress, isNull);
      expect(file.loadingText, 'Loading...');
      expect(file.retryText, 'Re-Upload');
      expect(file.errorText, 'Error');
    });

    test('TUploadFile 完整构造', () {
      final file = TUploadFile(
        key: 5,
        remotePath: 'https://example.com/a.png',
        assetPath: '/local/a.png',
        progress: 80,
        status: TUploadFileStatus.loading,
        loadingText: '加载中',
        retryText: '重试',
        errorText: '错误',
        canDelete: false,
      );
      expect(file.key, 5);
      expect(file.remotePath, 'https://example.com/a.png');
      expect(file.assetPath, '/local/a.png');
      expect(file.progress, 80);
      expect(file.status, TUploadFileStatus.loading);
      expect(file.loadingText, '加载中');
      expect(file.retryText, '重试');
      expect(file.errorText, '错误');
      expect(file.canDelete, isFalse);
    });
  });

  // ============================================================
  // 枚举完整性
  // ============================================================
  group('TUpload 枚举完整性', () {
    test('TUploadVariant 有两个值', () {
      expect(TUploadVariant.values.length, 2);
      expect(TUploadVariant.values, contains(TUploadVariant.roundedSquare));
      expect(TUploadVariant.values, contains(TUploadVariant.circle));
    });

    test('TUploadMediaType 有两个值', () {
      expect(TUploadMediaType.values.length, 2);
      expect(TUploadMediaType.values, contains(TUploadMediaType.image));
      expect(TUploadMediaType.values, contains(TUploadMediaType.video));
    });

    test('TUploadFileStatus 有四个值', () {
      expect(TUploadFileStatus.values.length, 4);
      expect(TUploadFileStatus.values, contains(TUploadFileStatus.success));
      expect(TUploadFileStatus.values, contains(TUploadFileStatus.loading));
      expect(TUploadFileStatus.values, contains(TUploadFileStatus.error));
      expect(TUploadFileStatus.values, contains(TUploadFileStatus.retry));
    });

    test('TUploadAction 有三个值', () {
      expect(TUploadAction.values.length, 3);
      expect(TUploadAction.values, contains(TUploadAction.add));
      expect(TUploadAction.values, contains(TUploadAction.remove));
      expect(TUploadAction.values, contains(TUploadAction.replace));
    });

    test('TUploadValidatorError 有两个值', () {
      expect(TUploadValidatorError.values.length, 2);
      expect(TUploadValidatorError.values, contains(TUploadValidatorError.overSize));
      expect(TUploadValidatorError.values, contains(TUploadValidatorError.overQuantity));
    });
  });

  group('TUpload 初始校验与替换', () {
    testWidgets('初始文件数超过 max 且提供 onValidate 时回调', (tester) async {
      TUploadValidatorError? error;
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: [
            buildFile(key: 1),
            buildFile(key: 2),
            buildFile(key: 3),
          ],
          max: 1,
          onValidate: (e) => error = e,
          onChanged: (files, type) {},
        ),
      ));
      await tester.pumpAndSettle();
      expect(error, TUploadValidatorError.overQuantity);
    });

    testWidgets('enabledReplaceType 点击图片触发选择器替换流程', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: [buildFile(key: 1)],
          enabledReplaceType: true,
          onChanged: (files, type) {},
        ),
      ));
      await tester.pump();
      await tester.tap(find.byType(TImage));
      // 测试环境下 ImagePicker 无原生实现，选择器返回空，进入 replaceMedia 提前返回分支
      await tester.pumpAndSettle();
      expect(find.byType(TUpload), findsOneWidget);
    });
  });

  // ============================================================
  // 资源选择（mock ImagePicker 方法通道）
  // ============================================================
  const _pickerChannel = MethodChannel('plugins.flutter.io/image_picker');
  const _testImagePath = 'test/components/upload/_tmp_upload_img.png';

  void setPickerMock({
    String? singlePath,
    List<String>? multiPaths,
    bool empty = false,
    bool throwPlatform = false,
    bool throwGeneric = false,
  }) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_pickerChannel, (MethodCall call) async {
      if (throwPlatform) {
        throw PlatformException(code: 'ERR', message: 'mock');
      }
      if (throwGeneric) {
        throw Exception('boom');
      }
      if (call.method == 'pickImage' || call.method == 'pickVideo') {
        if (empty) {
          return null;
        }
        return singlePath;
      }
      if (call.method == 'pickMultiImage') {
        if (empty) {
          return <String>[];
        }
        return multiPaths;
      }
      return null;
    });
  }

  void clearPickerMock() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_pickerChannel, null);
  }

  group('TUpload 资源选择（mock ImagePicker）', () {
    setUp(() {
      // 创建临时图片文件，供 sizeLimit 校验读取大小
      File(_testImagePath).writeAsBytesSync(Uint8List(2048));
    });

    tearDown(() {
      clearPickerMock();
      try {
        File(_testImagePath).deleteSync();
      } catch (_) {}
    });

    testWidgets('点击上传按钮选择单图并触发 onChanged add', (tester) async {
      List<TUploadFile>? added;
      TUploadAction? action;
      setPickerMock(singlePath: _testImagePath);
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: const [],
          onChanged: (files, type) {
            added = files;
            action = type;
          },
        ),
      ));
      await tester.tap(find.byIcon(TIcons.add));
      await tester.pumpAndSettle();
      expect(added, isNotNull);
      expect(action, TUploadAction.add);
    });

    testWidgets('multiple=true 选择多图触发 onChanged add', (tester) async {
      List<TUploadFile>? added;
      setPickerMock(multiPaths: [_testImagePath, _testImagePath]);
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: const [],
          multiple: true,
          max: 5,
          onChanged: (files, type) => added = files,
        ),
      ));
      await tester.tap(find.byIcon(TIcons.add));
      await tester.pumpAndSettle();
      expect(added?.length, 2);
    });

    testWidgets('sizeLimit 超限触发 onValidate overSize', (tester) async {
      TUploadValidatorError? error;
      setPickerMock(singlePath: _testImagePath);
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: const [],
          sizeLimit: 1, // KB，2KB 文件超限
          onValidate: (e) => error = e,
          onChanged: (files, type) {},
        ),
      ));
      // sizeLimit 校验会真实读取磁盘文件大小，需在 runAsync 中允许真实 I/O 完成
      await tester.runAsync(() async {
        await tester.tap(find.byIcon(TIcons.add));
        await tester.pump();
        await Future<void>.delayed(const Duration(milliseconds: 100));
      });
      await tester.pump();
      expect(error, TUploadValidatorError.overSize);
    });

    testWidgets('sizeLimit 未超限正常添加', (tester) async {
      List<TUploadFile>? added;
      setPickerMock(singlePath: _testImagePath);
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: const [],
          sizeLimit: 10, // KB，2KB 文件未超限
          onValidate: (e) {},
          onChanged: (files, type) => added = files,
        ),
      ));
      await tester.runAsync(() async {
        await tester.tap(find.byIcon(TIcons.add));
        await tester.pump();
        await Future<void>.delayed(const Duration(milliseconds: 100));
      });
      await tester.pump();
      expect(added, isNotNull);
    });

    testWidgets('multiple 超过 max 触发 onMaxLimitReached', (tester) async {
      var reached = false;
      setPickerMock(multiPaths: [_testImagePath, _testImagePath]);
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: const [],
          multiple: true,
          max: 1,
          onMaxLimitReached: () => reached = true,
          onChanged: (files, type) {},
        ),
      ));
      await tester.tap(find.byIcon(TIcons.add));
      await tester.pumpAndSettle();
      expect(reached, isTrue);
    });

    testWidgets('multiple 超过 max 且无 onMaxLimitReached 时回调 onValidate overQuantity', (tester) async {
      TUploadValidatorError? error;
      setPickerMock(multiPaths: [_testImagePath, _testImagePath]);
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: const [],
          multiple: true,
          max: 1,
          onValidate: (e) => error = e,
          onChanged: (files, type) {},
        ),
      ));
      await tester.tap(find.byIcon(TIcons.add));
      await tester.pumpAndSettle();
      expect(error, TUploadValidatorError.overQuantity);
    });

    testWidgets('mediaType 为空直接返回空', (tester) async {
      List<TUploadFile>? added;
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: const [],
          mediaType: const [],
          onChanged: (files, type) => added = files,
        ),
      ));
      await tester.tap(find.byIcon(TIcons.add));
      await tester.pumpAndSettle();
      // getMediaFromPicker 返回空，extractImageList 因 files 为空提前返回
      expect(added, isNull);
    });

    testWidgets('mediaType=video 走 pickVideo 分支', (tester) async {
      List<TUploadFile>? added;
      setPickerMock(singlePath: _testImagePath);
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: const [],
          mediaType: const [TUploadMediaType.video],
          onChanged: (files, type) => added = files,
        ),
      ));
      await tester.tap(find.byIcon(TIcons.add));
      await tester.pumpAndSettle();
      expect(added, isNotNull);
    });

    testWidgets('ImagePicker 抛 PlatformException 触发 onError', (tester) async {
      Object? err;
      setPickerMock(throwPlatform: true);
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: const [],
          onError: (e) => err = e,
          onChanged: (files, type) {},
        ),
      ));
      await tester.tap(find.byIcon(TIcons.add));
      await tester.pumpAndSettle();
      expect(err, isNotNull);
    });

    testWidgets('ImagePicker 抛普通异常触发 onError', (tester) async {
      Object? err;
      setPickerMock(throwGeneric: true);
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: const [],
          onError: (e) => err = e,
          onChanged: (files, type) {},
        ),
      ));
      await tester.tap(find.byIcon(TIcons.add));
      await tester.pumpAndSettle();
      expect(err, isNotNull);
    });

    testWidgets('enabledReplaceType 点击图片替换成功触发 onChanged replace', (tester) async {
      TUploadAction? action;
      setPickerMock(singlePath: _testImagePath);
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: [buildFile(key: 1)],
          enabledReplaceType: true,
          onChanged: (files, type) => action = type,
        ),
      ));
      await tester.pump();
      await tester.tap(find.byType(TImage));
      await tester.pumpAndSettle();
      expect(action, TUploadAction.replace);
    });

    testWidgets('enabledReplaceType 选择为空时 replaceMedia 提前返回', (tester) async {
      setPickerMock(empty: true);
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: [buildFile(key: 1)],
          enabledReplaceType: true,
          onChanged: (files, type) {},
        ),
      ));
      await tester.pump();
      await tester.tap(find.byType(TImage));
      await tester.pumpAndSettle();
      expect(find.byType(TUpload), findsOneWidget);
    });

    testWidgets('type=circle 时删除按钮为圆形装饰', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: [buildFile(key: 1, canDelete: true)],
          type: TUploadVariant.circle,
          onChanged: (files, type) {},
        ),
      ));
      await tester.pump();
      final containers = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(TUpload),
          matching: find.byType(Container),
        ),
      );
      final hasCircle = containers.any((c) =>
          c.decoration is BoxDecoration &&
          (c.decoration as BoxDecoration).shape == BoxShape.circle);
      expect(hasCircle, isTrue);
    });

    testWidgets('type=circle 加载态遮罩为圆形', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TUpload(
          files: [buildFile(key: 1, status: TUploadFileStatus.loading, progress: 30)],
          type: TUploadVariant.circle,
          onChanged: (files, type) {},
        ),
      ));
      await tester.pump();
      final containers = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(TUpload),
          matching: find.byType(Container),
        ),
      );
      final hasCircle = containers.any((c) =>
          c.decoration is BoxDecoration &&
          (c.decoration as BoxDecoration).shape == BoxShape.circle);
      expect(hasCircle, isTrue);
    });
  });
}
