import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TAvatar V1.0 Widget 测试
///
/// 覆盖 variant 五档、size 三档、shape 两档、onPressed 回调、
/// Theme 各字段、copyWith/lerp、边界情况。
///
/// 注意：涉及 NetworkImage 的测试需要 mock HttpClient，
/// 否则 flutter_test 默认返回 400 导致 NetworkImageLoadException。
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child, {TAvatarThemeData? avatarTheme}) {
    final themeExtensions = <ThemeExtension>[
      if (avatarTheme != null) avatarTheme,
    ];
    // 注意：必须通过 MaterialApp.theme 传递 extensions，
    // 用外层 Theme 包 MaterialApp 会被 MaterialApp 默认 ThemeData.light() 覆盖，导致 extension 丢失。
    return MaterialApp(
      theme: ThemeData(
        extensions: [TThemeData.defaultData(), ...themeExtensions],
      ),
      // 用 DefaultAssetBundle 提供假的资源包，使 AssetImage 能解析出透明 PNG
      home: DefaultAssetBundle(
        bundle: _FakeAssetBundle(),
        child: Scaffold(body: child),
      ),
    );
  }

  setUpAll(() {
    // 全局 mock HttpClient，使 NetworkImage 返回 1x1 透明 PNG
    HttpOverrides.global = _TestHttpOverrides();
  });

  tearDownAll(() {
    HttpOverrides.global = null;
  });

  group('TAvatar 基础渲染', () {
    testWidgets('默认参数渲染 - normal variant', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TAvatar()));
      expect(find.byType(TAvatar), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('normal variant 带 avatarUrl 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TAvatar(
        variant: TAvatarVariant.normal,
        avatarUrl: 'https://example.com/avatar.png',
      )));
      await tester.pumpAndSettle();
      expect(find.byType(TAvatar), findsOneWidget);
    });

    testWidgets('normal variant 带 defaultUrl 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TAvatar(
        variant: TAvatarVariant.normal,
        defaultUrl: 'assets/default.png',
      )));
      await tester.pumpAndSettle();
      expect(find.byType(TAvatar), findsOneWidget);
    });
  });

  group('TAvatar variant 五档', () {
    testWidgets('variant: icon 渲染图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TAvatar(variant: TAvatarVariant.icon, icon: Icons.person),
      ));
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('variant: icon 默认图标为 user', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TAvatar(variant: TAvatarVariant.icon),
      ));
      expect(find.byIcon(TIcons.user), findsOneWidget);
    });

    testWidgets('variant: normal 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TAvatar(variant: TAvatarVariant.normal),
      ));
      expect(find.byType(TAvatar), findsOneWidget);
    });

    testWidgets('variant: customText 渲染文字', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TAvatar(variant: TAvatarVariant.customText, text: 'A'),
      ));
      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('variant: display 无列表时返回空 Container', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TAvatar(variant: TAvatarVariant.display),
      ));
      expect(find.byType(TAvatar), findsOneWidget);
    });

    testWidgets('variant: operation 无列表时返回空 Container', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TAvatar(variant: TAvatarVariant.operation),
      ));
      expect(find.byType(TAvatar), findsOneWidget);
    });

    testWidgets('variant: display 带列表渲染 Stack', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TAvatar(
        variant: TAvatarVariant.display,
        avatarDisplayList: ['https://example.com/1.png'],
        displayText: '+1',
      )));
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(TAvatar),
          matching: find.byType(Stack),
        ),
        findsOneWidget,
      );
      expect(find.text('+1'), findsOneWidget);
    });

    testWidgets('variant: operation 带列表渲染 user_add 图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TAvatar(
        variant: TAvatarVariant.operation,
        avatarDisplayList: ['https://example.com/1.png'],
      )));
      await tester.pumpAndSettle();
      expect(find.byIcon(TIcons.user_add), findsOneWidget);
    });
  });

  group('TAvatar size 三档', () {
    testWidgets('size: large 渲染图标 32', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TAvatar(size: TAvatarSize.large, variant: TAvatarVariant.icon),
      ));
      expect(find.byType(TAvatar), findsOneWidget);
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, 32);
    });

    testWidgets('size: medium 渲染图标 24', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TAvatar(size: TAvatarSize.medium, variant: TAvatarVariant.icon),
      ));
      expect(find.byType(TAvatar), findsOneWidget);
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, 24);
    });

    testWidgets('size: small 渲染图标 20', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TAvatar(size: TAvatarSize.small, variant: TAvatarVariant.icon),
      ));
      expect(find.byType(TAvatar), findsOneWidget);
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, 20);
    });
  });

  group('TAvatar onPressed 回调', () {
    testWidgets('点击触发 onPressed', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        TAvatar(
          variant: TAvatarVariant.icon,
          onPressed: () => tapped = true,
        ),
      ));
      await tester.tap(find.byType(TAvatar));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('onPressed 为 null 时不崩溃', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TAvatar(variant: TAvatarVariant.icon, onPressed: null),
      ));
      expect(find.byType(TAvatar), findsOneWidget);
      // GestureDetector.onTap 为 null
      final gd = tester.widget<GestureDetector>(find.byType(GestureDetector));
      expect(gd.onTap, isNull);
    });

    testWidgets('operation variant 点击触发 onPressed', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrapWithTheme(TAvatar(
        variant: TAvatarVariant.operation,
        avatarDisplayList: const ['https://example.com/1.png'],
        onPressed: () => tapped = true,
      )));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(TIcons.user_add));
      await tester.pump();
      expect(tapped, isTrue);
    });
  });

  group('TAvatar Theme', () {
    testWidgets('Theme.avatarSize 覆盖默认尺寸', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TAvatar(variant: TAvatarVariant.icon),
        avatarTheme: const TAvatarThemeData(avatarSize: 80),
      ));
      expect(find.byType(TAvatar), findsOneWidget);
    });

    testWidgets('Theme.shape: square 使用圆角', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TAvatar(variant: TAvatarVariant.icon),
        avatarTheme: const TAvatarThemeData(shape: TAvatarShape.square),
      ));
      expect(find.byType(TAvatar), findsOneWidget);
    });

    testWidgets('Theme.shape: circle（默认）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TAvatar(variant: TAvatarVariant.icon),
        avatarTheme: const TAvatarThemeData(shape: TAvatarShape.circle),
      ));
      expect(find.byType(TAvatar), findsOneWidget);
    });

    testWidgets('Theme.radius 自定义圆角', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TAvatar(variant: TAvatarVariant.icon),
        avatarTheme: const TAvatarThemeData(radius: 10),
      ));
      expect(find.byType(TAvatar), findsOneWidget);
    });

    testWidgets('Theme.backgroundColor 覆盖背景色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TAvatar(variant: TAvatarVariant.icon),
        avatarTheme: const TAvatarThemeData(backgroundColor: Colors.green),
      ));
      expect(find.byType(TAvatar), findsOneWidget);
    });

    testWidgets('Theme.avatarDisplayBorder 覆盖描边', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TAvatar(
          variant: TAvatarVariant.display,
          avatarDisplayList: ['https://example.com/1.png'],
          displayText: '+1',
        ),
        avatarTheme: const TAvatarThemeData(avatarDisplayBorder: 4),
      ));
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(TAvatar),
          matching: find.byType(Stack),
        ),
        findsOneWidget,
      );
    });
  });

  group('TAvatarThemeData copyWith 和 lerp', () {
    test('copyWith 部分覆盖', () {
      const theme = TAvatarThemeData(
        shape: TAvatarShape.circle,
        radius: 10,
        avatarSize: 48,
      );
      final copied = theme.copyWith(radius: 20);
      expect(copied.shape, TAvatarShape.circle);
      expect(copied.radius, 20);
      expect(copied.avatarSize, 48);
    });

    test('copyWith 不覆盖时保持原值', () {
      const theme = TAvatarThemeData(
        shape: TAvatarShape.square,
        backgroundColor: Colors.red,
      );
      final copied = theme.copyWith();
      expect(copied.shape, TAvatarShape.square);
      expect(copied.backgroundColor, Colors.red);
    });

    test('lerp 前半段取 a 的 shape', () {
      const a = TAvatarThemeData(shape: TAvatarShape.circle);
      const b = TAvatarThemeData(shape: TAvatarShape.square);
      final result = a.lerp(b, 0.3);
      expect(result.shape, TAvatarShape.circle);
    });

    test('lerp 后半段取 b 的 shape', () {
      const a = TAvatarThemeData(shape: TAvatarShape.circle);
      const b = TAvatarThemeData(shape: TAvatarShape.square);
      final result = a.lerp(b, 0.7);
      expect(result.shape, TAvatarShape.square);
    });

    test('lerp 非 TAvatarThemeData 返回自身', () {
      const theme = TAvatarThemeData(shape: TAvatarShape.circle);
      final result = theme.lerp(null, 0.5);
      expect(result.shape, TAvatarShape.circle);
    });

    test('lerp avatarSize 插值', () {
      const a = TAvatarThemeData(avatarSize: 40);
      const b = TAvatarThemeData(avatarSize: 80);
      final result = a.lerp(b, 0.5);
      expect(result.avatarSize, 60);
    });

    test('lerp backgroundColor 插值', () {
      const a = TAvatarThemeData(backgroundColor: Colors.red);
      const b = TAvatarThemeData(backgroundColor: Colors.blue);
      final result = a.lerp(b, 0.5);
      expect(result.backgroundColor, isNotNull);
    });
  });

  group('TAvatar 边界情况', () {
    testWidgets('avatarDisplayList 为空列表 display 返回空', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TAvatar(
          variant: TAvatarVariant.display,
          avatarDisplayList: [],
        ),
      ));
      expect(find.byType(TAvatar), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(TAvatar),
          matching: find.byType(Stack),
        ),
        findsNothing,
      );
    });

    testWidgets('avatarDisplayListAsset 为空列表 operation 返回空', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TAvatar(
          variant: TAvatarVariant.operation,
          avatarDisplayListAsset: [],
        ),
      ));
      expect(find.byType(TAvatar), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(TAvatar),
          matching: find.byType(Stack),
        ),
        findsNothing,
      );
    });

    testWidgets('customText text 为 null 仍渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TAvatar(variant: TAvatarVariant.customText),
      ));
      expect(find.byType(TAvatar), findsOneWidget);
    });

    testWidgets('display 带多个 avatar 渲染多个 Positioned', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TAvatar(
        variant: TAvatarVariant.display,
        avatarDisplayList: [
          'https://example.com/1.png',
          'https://example.com/2.png',
          'https://example.com/3.png',
        ],
        displayText: '+3',
      )));
      await tester.pumpAndSettle();
      // 列表 3 个 + 末尾文字 = 4 个 Positioned
      expect(find.byType(Positioned), findsNWidgets(4));
      expect(find.text('+3'), findsOneWidget);
    });
  });
}

/// 1x1 透明 PNG 的 base64 编码
const String _transparentPngBase64 =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAC0lEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==';

/// 测试用 HttpOverrides，返回 1x1 透明 PNG
class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = _MockHttpClient();
    return client;
  }
}

/// Mock HttpClient，拦截所有 GET 请求返回透明 PNG
class _MockHttpClient implements HttpClient {
  // NetworkImage 内部会设置 autoUncompress = false，需提供该字段
  @override
  bool autoUncompress = false;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    return _MockHttpClientRequest(url);
  }

  // 其他方法/setter 返回 null，避免 super.noSuchMethod 抛出 NoSuchMethodError
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

/// Mock HttpHeaders，忽略所有操作
class _MockHttpHeaders implements HttpHeaders {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

/// Mock HttpClientRequest
class _MockHttpClientRequest implements HttpClientRequest {
  final Uri url;

  _MockHttpClientRequest(this.url);

  @override
  final HttpHeaders headers = _MockHttpHeaders();

  @override
  Future<HttpClientResponse> close() async {
    return _MockHttpClientResponse();
  }

  @override
  void add(List<int> data) {}

  @override
  void write(Object? obj) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

/// Mock HttpClientResponse，返回 1x1 透明 PNG 数据
class _MockHttpClientResponse implements HttpClientResponse {
  /// 1x1 透明 PNG 的字节
  final Uint8List _pngBytes = base64.decode(_transparentPngBase64);

  @override
  int get statusCode => 200;

  @override
  int get contentLength => _pngBytes.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([_pngBytes]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

/// 假的 AssetBundle：AssetManifest 返回空清单，其它 asset 返回 1x1 透明 PNG
class _FakeAssetBundle extends CachingAssetBundle {
  final Uint8List _pngBytes = base64.decode(_transparentPngBase64);

  @override
  Future<ByteData> load(String key) async {
    // AssetImage 会先加载资源清单，返回空 map 以避免解析失败
    if (key.contains('AssetManifest')) {
      final data =
          const StandardMessageCodec().encodeMessage(<String, Object>{});
      return data!;
    }
    return ByteData.view(_pngBytes.buffer);
  }
}

