#!/bin/bash

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

# 基础
# button
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/button" --name TButton,TButtonThemeData,TButtonResolve --folder-name button --output "$PARENT_DIR/example/assets/api/" --only-api
# divider
flutter pub run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/divider/t_divider.dart" --name TDivider --folder-name divider --output "$PARENT_DIR/example/assets/api/" --only-api
# fab
flutter pub run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/fab/t_fab.dart" --name TFab --folder-name fab --output "$PARENT_DIR/example/assets/api/" --only-api
# icon
# TIcons 图标清单由 tdesign_icons 包维护，组件库仅生成 TIcon/TIconThemeData API
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/icon" --name TIcon,TIconThemeData --folder-name icon --output "$PARENT_DIR/example/assets/api/" --only-api
# link
flutter pub run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/link/t_link.dart" --name TLink --folder-name link --output "$PARENT_DIR/example/assets/api/" --only-api
# text
flutter pub run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/text/t_text.dart" --name TText,TTextSpan,TTextConfiguration --folder-name text --output "$PARENT_DIR/example/assets/api/" --only-api


# 导航
# back_top
flutter pub run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/backtop/t_backtop.dart" --name TBackTop --folder-name back-top --output "$PARENT_DIR/example/assets/api/" --only-api
# drawer
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/drawer" --name TDrawer,TDrawerItem --folder-name drawer --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# indexes
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/indexes" --name TIndexes,TIndexesAnchor,TIndexesList --folder-name indexes --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# navbar
flutter pub run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/navbar/t_nav_bar.dart" --name TNavBar,TNavBarItem, --folder-name navbar --output "$PARENT_DIR/example/assets/api/" --only-api
# sidebar
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/sidebar" --name TSideBar,TSideBarItem, --folder-name side-bar --output "$PARENT_DIR/example/assets/api/" --only-api
# steps
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/steps" --name TSteps,TStepsItemData --folder-name steps --output "$PARENT_DIR/example/assets/api/" --only-api
# tabbar
flutter pub run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/tabbar/t_tab_bar.dart" --name TTabBar,TTabBarBadgeConfig,TTabBarItemConfig,TTabBarPopUpBtnConfig,TTabBarPopUpShapeConfig,TTabBarMenuItem --folder-name tab-bar --output "$PARENT_DIR/example/assets/api/" --only-api
# tabs
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/tabs" --name TTabsBar,TTab,TTabsBarView --folder-name tabs --output "$PARENT_DIR/example/assets/api/" --only-api


# 输入
# calendar
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/calendar" --name TCalendar,TCalendarCellModel,TCalendarSubtitleContext,TCalendarThemeData --folder-name calendar --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# cascader
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/cascader" --name TCascader,TCascaderOption,TCascaderVariant,TCascaderThemeData --folder-name cascader --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments

# checkbox
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/checkbox" --name TCheckbox,TCheckboxGroup --folder-name checkbox --output "$PARENT_DIR/example/assets/api/" --only-api
# picker
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/picker" --name TPicker,TPickerOption,TPickerValue,TPickerColumns,TPickerLinked,TPickerThemeData --folder-name picker --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# date-time-picker
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/date_time_picker" --name TDateTimePicker,DateTimePickerMode,TDateTimePickerValue,DateTimePickerSteps,DateMode,TimeMode,DateTimeColumn,DateTimePickerRenderLabel --folder-name date-time-picker --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# form
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/form" --name TForm,TFormState,TFormController,TFormField,TFormItem,TFormLayout --folder-name form --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# input
flutter pub run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/input/t_input.dart" --name TInput, TInputSpacer --folder-name input --output "$PARENT_DIR/example/assets/api/" --only-api
# radio
flutter pub run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/radio/t_radio.dart" --name TRadioVariant,TRadio,TRadioGroup --folder-name radio --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# rate
flutter pub run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/rate/t_rate.dart" --name TRate --folder-name rate --output "$PARENT_DIR/example/assets/api/" --only-api
# search
flutter pub run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/search/t_search_bar.dart" --name TSearchBar --folder-name search --output "$PARENT_DIR/example/assets/api/" --only-api
# slider
flutter pub run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/slider/t_slider.dart" --name TSlider,TRangeSlider,TSliderThemeData --folder-name slider --output "$PARENT_DIR/example/assets/api/" --only-api
# stepper
flutter pub run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/stepper/t_stepper.dart" --name TStepper --folder-name stepper --output "$PARENT_DIR/example/assets/api/" --only-api
# switch
flutter pub run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/switch/t_switch.dart" --name TSwitch --folder-name switch --output "$PARENT_DIR/example/assets/api/" --only-api
# textarea
flutter pub run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/textarea/t_textarea.dart" --name TTextarea --folder-name textarea --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# tree_select
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/tree" --name TTreeSelect,TTreeSelectOption,TTreeSelectThemeData --folder-name tree-select --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments

# upload
flutter pub run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/upload/t_upload.dart" --name TUpload --folder-name upload --output "$PARENT_DIR/example/assets/api/" --only-api


# 数据展示
# avatar
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/avatar" --name TAvatar,TAvatarGroup,TAvatarThemeData,TAvatarSize,TAvatarVariant --folder-name avatar --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# badge
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/badge" --name TBadge,TBadgeThemeData --folder-name badge --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# cell
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/cell" --name TCell,TCellGroup,TCellStyle --folder-name cell --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# timeCounter
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/time_counter" --name TTimeCounter,TTimeCounterController,TTimeCounterThemeData,TTimeCounterDirection,TTimeCounterSize,TTimeCounterVariant --folder-name time-counter --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# collapse
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/collapse" --name TCollapse,TCollapsePanel,TCollapseMode,TCollapseVariant,TCollapseThemeData --folder-name collapse --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments

# empty
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/empty" --name TEmpty,TEmptyThemeData,TEmptyVariant --folder-name empty --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# footer
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/footer" --name TFooter,TFooterThemeData,TFooterVariant --folder-name footer --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments

# grid
# image
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/image" --name TImage,TImageThemeData --folder-name image --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# imageViewer
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/image_viewer" --name TImageViewer,TImageViewerItemBuilder,TImageViewerThemeData --folder-name image-viewer --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# progress
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/progress" --name TProgress,TProgressThemeData --folder-name progress --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# result
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/result" --name TResult,TResultThemeData,TResultVariant --folder-name result --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# skeleton
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/skeleton" --name TSkeleton,TSkeletonAnimation,TSkeletonVariant,TSkeletonBlockShape,TSkeletonRowColStyle,TSkeletonRowCol,TSkeletonRowColObjStyle,TSkeletonRowColObj,TSkeletonThemeData --folder-name skeleton --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments

# sticky
# swiper
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/swiper" --name TSwiper,TSwiperPaginationVariant,TSwiperPageEffect,TSwiperThemeData --folder-name swiper --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# table
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/table" --name TTable,TTableColumn,TTableColumnFixed,TTableColumnAlign,TTableSelectionMode,TTableSortDirection,TTableSort,TTableThemeData --folder-name table --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# tag
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/tag" --name TTag,TSelectTag,TTagThemeData,TTagSize,TTagShape,TTagColorScheme --folder-name tag --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments



# 反馈
# action_sheet
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/action_sheet" --name TActionSheetItem,TActionSheet --folder-name action-sheet --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# dialog
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/dialog" --name TAlertDialog,TConfirmDialog,TDialogButtonOptions,TDialogButtonStyle,TDialogScaffold,TDialogTitle,TDialogContent,TDialogInfoWidget,HorizontalNormalButtons,HorizontalTextButtons,TDialogButton,TDialogImagePosition,TImageDialog,TInputDialog --folder-name dialog --output "$PARENT_DIR/example/assets/api/" --only-api
# dropdown_menu
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/dropdown_menu" --name TDropdownMenu,TDropdownMenuDirection,TDropdownItem,TDropdownItemOption,TDropdownItemController --folder-name dropdown-menu --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# loading
flutter pub run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/loading/t_loading.dart" --name TLoading --folder-name loading --output "$PARENT_DIR/example/assets/api/" --only-api
# message
flutter pub run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/message/t_message.dart" --name TMessage,MessageTheme,MessageMarquee,MessageLink --folder-name message --output "$PARENT_DIR/example/assets/api/" --only-api
# noticeBar
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/notice_bar" --name TNoticeBar,TNoticeBarStyle --folder-name notice-bar --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# overlay
# popover
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/popover" --name TPopover,TPopoverWidget --folder-name popover --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# popup
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/popup" --name TPopup,TPopupOptions,TPopupHandle,TPopupPlacement,TPopupTrigger --folder-name popup --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# refresh
flutter pub run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/refresh/t_refresh_header.dart" --name TRefreshHeader --folder-name pull-down-refresh --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# swipecell
flutter pub run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/swipe_cell" --name TSwipeAction,TSwipeAutoClose,TSwipeCell,TSwipePanel --folder-name swipe-cell --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# toast
flutter pub run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/toast/t_toast.dart" --name TToast --folder-name toast --output "$PARENT_DIR/example/assets/api/" --only-api


# 其他
# theme
flutter pub run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/theme/t_theme.dart" --name TTheme,TThemeData --folder-name theme --output "$PARENT_DIR/example/assets/api/" --only-api
# radius
