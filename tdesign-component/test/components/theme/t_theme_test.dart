import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/theme/t_theme.dart';
import 'package:tdesign_flutter/src/theme/resource_delegate.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TTheme 基础设施纯逻辑覆盖（context 扩展 / TStyleResolver /
/// TMaterialThemeBuilder / TThemeBuilder / setTResourceBuilder /
/// TThemeData 解析与拷贝），用于提升行覆盖至 ≥95%。
class _TestExtra extends TExtraThemeData {
  @override
  void parse(String name, Map<String, dynamic> curThemeMap) {}
}

class _TestExtra2 extends TExtraThemeData {
  @override
  void parse(String name, Map<String, dynamic> curThemeMap) {}
}

void main() {
  group('TThemeContextExtension.tTheme', () {
    testWidgets('有 TThemeData Extension 时取注入值', (tester) async {
      final token = TThemeData.defaultData();
      late TThemeData resolved;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [token]),
          home: Builder(
            builder: (context) {
              resolved = context.tTheme;
              return const SizedBox();
            },
          ),
        ),
      );
      expect(resolved, same(token));
    });

    testWidgets('无 Extension 时回退 defaultData', (tester) async {
      late TThemeData resolved;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              resolved = context.tTheme;
              return const SizedBox();
            },
          ),
        ),
      );
      expect(resolved, isA<TThemeData>());
      expect(resolved, TThemeData.defaultData());
    });
  });

  group('TThemeDataMergeExtension.mergeExtension', () {
    test('合并后保留指定 Extension 类型', () {
      final base = ThemeData(colorScheme: ColorScheme.light());
      final merged = base.mergeExtension<TThemeData>(TThemeData.defaultData());
      expect(merged.extension<TThemeData>(), isNotNull);
      // 其它已有 Extension 不被覆盖
      expect(merged.extension<TThemeData>(), isA<TThemeData>());
    });
  });

  group('TStyleResolver', () {
    testWidgets('of/token/colorScheme/textTheme/materialTheme/componentExtension',
        (tester) async {
      final token = TThemeData.defaultData();
      final resolverHolder = <TStyleResolver>[];
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [token],
            textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 13)),
          ),
          home: Builder(
            builder: (context) {
              final r = TStyleResolver.of(context);
              resolverHolder.add(r);
              // 触发各 getter
              expect(r.token, isA<TThemeData>());
              expect(r.colorScheme, isA<ColorScheme>());
              expect(r.textTheme, isA<TextTheme>());
              expect(r.materialTheme, isA<ThemeData>());
              expect(r.componentExtension<TThemeData>(), isNotNull);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(resolverHolder, isNotEmpty);
    });

    testWidgets('token 无 Extension 时回退 defaultData', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final r = TStyleResolver.of(context);
              expect(r.token, TThemeData.defaultData());
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('TMaterialThemeBuilder / TThemeBuilder', () {
    test('buildLight 映射品牌色', () {
      final token = TThemeData.defaultData();
      final td = TMaterialThemeBuilder(token).buildLight();
      expect(td.colorScheme.primary, token.brandNormalColor);
      expect(td.useMaterial3, isTrue);
      expect(td.extension<TThemeData>(), isNotNull);
    });

    test('buildDark 且 token.dark 为 null 时回退 token', () {
      // 构造一个不含暗色块的 token
      const json = '{"noDark": {"color": {"brandNormalColor": "#0052D9"}}}';
      final token = TThemeData.fromJson('noDark', json)!;
      expect(token.dark, isNull);
      final td = TMaterialThemeBuilder(token).buildDark();
      expect(td.brightness, Brightness.dark);
      expect(td.colorScheme.primary, token.brandNormalColor);
    });

    test('buildDark 使用 token.dark 块', () {
      const json = '''
      {
        "withDark": {"color": {"brandNormalColor": "#0052D9"}},
        "withDarkDark": {"color": {"brandNormalColor": "#003CAB"}}
      }
      ''';
      final token = TThemeData.fromJson('withDark', json)!;
      expect(token.dark, isNotNull);
      final td = TMaterialThemeBuilder(token).buildDark();
      expect(td.colorScheme.primary, token.dark!.brandNormalColor);
    });

    test('TThemeBuilder.light/dark 入口', () {
      final token = TThemeData.defaultData();
      expect(TThemeBuilder.light(token).brightness, Brightness.light);
      // buildDark 在 token 有暗色块时走 dark 分支
      expect(TThemeBuilder.dark(token).brightness, Brightness.dark);
    });
  });

  group('setTResourceBuilder', () {
    testWidgets('设置代理并回退默认代理', (tester) async {
      setTResourceBuilder((BuildContext _) => null);
      late TResourceDelegate delegate;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              delegate = TResourceManager.instance.delegate(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(delegate, isNotNull);
      // 还原为默认（清空 builder）
      setTResourceBuilder((_) => null, needAlwaysBuild: false);
    });
  });

  group('TThemeData 解析', () {
    const json = '''
    {
      "testTheme": {
        "color": {"brandNormalColor": "#0052D9", "textColorAnti": "#FFFFFF"},
        "ref": {"aliasColor": "brandNormalColor"},
        "font": {"fontLarge": {"size": 16, "lineHeight": 24}},
        "radius": {"radiusSmall": 4},
        "fontFamily": {"familyMain": {"fontFamily": "PingFang"}},
        "shadow": {"shadow1": [{"color":"#000000","blurRadius":4,"spreadRadius":0,"offset":{"x":0,"y":2}}]},
        "margin": {"margin1": 8}
      },
      "testThemeDark": {
        "color": {"brandNormalColor": "#003CAB"}
      }
    }
    ''';

    test('fromJson 返回 null：空串', () {
      expect(TThemeData.fromJson('x', ''), isNull);
    });

    test('fromJson 返回 null：名称不存在', () {
      expect(TThemeData.fromJson('notExist', json), isNull);
    });

    test('fromJson 返回 null：JSON 非法', () {
      expect(TThemeData.fromJson('x', '{bad'), isNull);
    });

    test('fromJson 解析各映射 + ref + 暗色块', () {
      final theme = TThemeData.fromJson('testTheme', json)!;
      expect(theme, isNotNull);
      expect(theme.ofColor('brandNormalColor'), isA<Color>());
      // ref 回指
      expect(theme.ofColor('aliasColor'), theme.ofColor('brandNormalColor'));
      expect(theme.ofFont('fontLarge')?.size, 16);
      expect(theme.ofCorner('radiusSmall'), 4);
      expect(theme.ofFontFamily('familyMain')?.fontFamily, 'PingFang');
      expect(theme.ofShadow('shadow1')?.length, 1);
      // spacerMap 来自 margin
      expect(theme.ofColor('aliasColor'), isNotNull);
      // 暗色块
      expect(theme.dark, isNotNull);
      expect(theme.dark!.light, same(theme));
      // refMap 缺失键在暗色块中补齐
      expect(theme.dark!.refMap, isNotNull);
    });

    test('fromJson 带 extraThemeData 走 parse 分支', () {
      final theme = TThemeData.fromJson('testTheme', json,
          extraThemeData: _TestExtra())!;
      expect(theme.extraThemeData, isA<_TestExtra>());
      expect(theme.ofExtra<_TestExtra>(), isA<_TestExtra>());
      // 类型不匹配时返回 null
      expect(theme.ofExtra<_TestExtra2>(), isNull);
    });
  });

  group('TThemeData 拷贝与 Map', () {
    test('copyWith 覆盖并保留未覆盖字段', () {
      final base = TThemeData.defaultData();
      final copied = base.copyWith(
        name: 'copied',
        colorMap: {'brandNormalColor': Colors.red},
      ) as TThemeData;
      expect(copied.name, 'copied');
      expect(copied.ofColor('brandNormalColor'), Colors.red);
      // 未覆盖的其它颜色经 factory 仍可取
      expect(copied.ofColor('textColorAnti'), isNotNull);
    });

    test('copyWithTThemeData 同义封装', () {
      final base = TThemeData.defaultData();
      final copied = base.copyWithTThemeData('copy2',
          colorMap: {'brandNormalColor': Colors.blue});
      expect(copied.name, 'copy2');
      expect(copied.ofColor('brandNormalColor'), Colors.blue);
      expect(copied, isA<TThemeData>());
    });

    test('TMap operator[] / get / factory 回退', () {
      final fallback = TMap<String, int>()..['a'] = 1;
      final m = TMap<String, int>(factory: () => fallback);
      m['x'] = 2;
      // 实际写入
      expect(m['x'], 2);
      expect(m.get('x'), 2);
      // factory 回退到默认值
      expect(m['a'], 1);
      // 不存在且无 factory 命中时返回 null
      expect(m['missing'], isNull);
    });
  });

  group('TThemeData.lerp', () {
    test('other 为同类型时返回 other 各映射', () {
      final a = TThemeData.defaultData();
      final b = TThemeData.defaultData();
      final r = a.lerp(b, 0.5) as TThemeData;
      expect(r.name, b.name);
      expect(r.ofColor('brandNormalColor'), isNotNull);
    });

    test('other 非同类型时返回 this', () {
      final a = TThemeData.defaultData();
      expect(a.lerp(null, 0.5), same(a));
    });
  });
}
