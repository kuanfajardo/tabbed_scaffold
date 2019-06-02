import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:copier/copier.dart';

/// A representation of a tab to be used with [TabbedScaffold].
///
/// Takes a title, as well as any number of optional properties that normally
/// would be passed to a [Scaffold] constructor. Any properties that are not
/// specified will be filled in by [TabbedScaffold]. If you wish to specify
/// the same property for ALL tabs, use the template feature of
/// [TabbedScaffold]. Any property specified in [ScaffoldTab] will override
/// any property in its [TabbedScaffold].
///
/// In addition to the normal [Scaffold] properties, [ScaffoldTab] also
/// exposes convenience properties. These properties expose commonly-used
/// sub-properties, such as BottomNavigationBarItem.icon as
/// bottomNavigationBarItemIcon.
class ScaffoldTab {
  ScaffoldTab({
    Key key,
    // Custom
    @required this.title,

    // Typical Scaffold parameters
    this.appBar,
    this.body,
    BottomNavigationBarItem bottomNavigationBarItem,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,

    // Custom convenience properties
    this.bottomNavigationBarItemIcon,
    this.bottomNavigationBarItemTitle,
  }) :
        this.bottomNavigationBarItem = BottomNavigationBarItem( // TODO: Copier
            icon: bottomNavigationBarItemIcon ?? bottomNavigationBarItem.icon,
            title: bottomNavigationBarItemTitle ?? bottomNavigationBarItem != null ?
            bottomNavigationBarItem.title : title
        );

  final Widget title;

  // Typical Scaffold parameters
  final PreferredSizeWidget appBar; // TODO: Expose convenient options
  final Widget body;
  final Widget floatingActionButton;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final FloatingActionButtonAnimator floatingActionButtonAnimator;
  final List<Widget> persistentFooterButtons;
  final Widget drawer;
  final Widget endDrawer;
  final Color backgroundColor;
  final Widget bottomNavigationBar;
  final Widget bottomSheet;
  final bool resizeToAvoidBottomInset;
  final bool primary;
  final DragStartBehavior drawerDragStartBehavior;
  final bool extendBody;

  // Custom
  final BottomNavigationBarItem bottomNavigationBarItem;
  final Widget bottomNavigationBarItemIcon;
  final Widget bottomNavigationBarItemTitle;
}

/// A [Scaffold]-like widget tailored for tab-bar navigation.
///
/// When creating a [Scaffold] that uses a [BottomNavigationBar], it's not
/// uncommon to end up with code like this:
///
/// ```dart
/// final List<AppBar> _appBars = [
///   AppBar(
///     title: const Text('Tab 1'),
///     actions: [...],
///     ...
///   ),
///   AppBar(
///     title: const Text('Tab 2'),
///     actions: [...],
///     ...
///   ),
///   ... // more AppBars
/// ];
///
/// final List<Widget> _bodies = [
///   TabBody1(),
///   TabBody2(),
///   ... // more Widgets
/// ];
///
/// final List<BottomNavigationBarItem> _bottomNavigationBarItems = [
///   BottomNavigationBarItem(
///     title: const Text('Tab 1'),
///     icon: Icon(Icons.tab1),
///   ),
///   BottomNavigationBarItem(
///     title: const Text('Tab 2'),
///     icon: Icon(Icons.tab2),
///   ),
///   ... // more BottomNavigationBarItems
/// ];
///
/// int _currentIndex = 0;
///
/// @override
/// Widget build(BuildContext context) {
///   return Scaffold(
///     appBar: _appBars[_currentIndex],
///     body: _bodies[_currentIndex],
///     ...
///     bottomNavigationBar: BottomNavigationBar(
///       items: _bottomNavigationBarItems,
///       currentIndex: _currentIndex,
///       onTap: onTabPressed,
///     )
///     ...
///   );
/// }
///
/// void onTabPressed(int index) {
///   setState(() {
///     _currentIndex = index;
///   });
/// }
/// ```
///
/// In this pattern, UI elements are grouped by type - i.e. app bars, bodies,
/// bottom navigation bar items, etc. This can be hard to understand and read
/// because what makes up a single "tab" is spread across multiple data
/// structures. Additionally, there is a good amount of boilerplate code:
///   - the bare minimum `onTap` necessary to switch between tabs,
///   - the repetition of tab titles in both the `AppBar` and
///      `BottomNavigationBarItem`,
///   - the manual use of _currentIndex to switch UI components between tabs
///   - manual class instantiations for widgets (AppBar, BottomNavBarItem,)
///
/// [TabbedScaffold] aims to reorganize your code so that UI components are
/// grouped by their tab, not their type, and reduce the amount of code you
/// need to write for a tab-bar navigation layout.
///
/// The above code can be re-written in the [TabbedScaffold] pattern as follows:
///
/// ```dart
/// List<ScaffoldTab> _tabs = [
///   ScaffoldTab(
///     title: const Text('Queue'),
///     body: TabBody1()
///     bottomNavigationBarItemIcon: Icon(Icons.tab1),
///   ),
///   ScaffoldTab(
///     title: const Text('Activity'),
///     body: Container(color: Colors.green,),
///     bottomNavigationBarItemIcon: Icon(Icons.tab2),
///   ),
///   ... // more ScaffoldTabs
/// ];
///
/// @override
/// Widget build(BuildContext context) {
///   return TabbedScaffold(
///     tabs: _tabs,
///   );
/// }
/// ```
/// [TabbedScaffold] takes a list of [ScaffoldTab] instances. Additionally, it
/// optionally takes any properties normally passed to a [Scaffold]
/// constructor (these can be thought of property templates).
///
/// When determining how to build the [Scaffold] for a specific tab,
/// [TabbedScaffold] first looks at the specific properties in the [ScaffoldTab]
/// instance for that tab. For any properties not defined in the
/// [ScaffoldTab], it looks for any templates passed to the [TabbedScaffold] and
/// applies the properties found there. If no template is passed for a specific
/// category, [TabbedScaffold] uses a bare instance of that property as a
/// template.
///
/// This allows you to specify properties that should be the same across all
/// tabs (for example, AppBar.leading = null) without having to specify as such
/// in each [ScaffoldTab].
///
/// Here is an example of using [AppBar] and [BottomNavigationBar] templates
/// with [TabbedScaffold] :
///
/// ```dart
/// TabbedScaffold(
///   tabs: _tabs,
///   appBar: AppBar( // Applies this to every tab. Gets overridden by any
///                   // properties set in _tabs[i]
///     leading: null,
///     automaticallyImplyLeading: false,
///   ),
///   bottomNavigationBar: BottomNavigationBar(
///     onTap: (index) => { // Do something },
///   ),
/// )
/// ```
class TabbedScaffold extends StatefulWidget {
  final List<ScaffoldTab> tabs;

  // Templates
  final AppBar appBar;
  final Widget floatingActionButton;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final FloatingActionButtonAnimator floatingActionButtonAnimator;
  final List<Widget> persistentFooterButtons;
  final Widget drawer;
  final Widget endDrawer;
  final Color backgroundColor;
  final Widget bottomNavigationBar;
  final Widget bottomSheet;
  final bool resizeToAvoidBottomInset;
  final bool primary;
  final DragStartBehavior drawerDragStartBehavior;
  final bool extendBody;

  TabbedScaffold({
    @required this.tabs,
    // Templates
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.resizeToAvoidBottomInset,
    this.primary,
    this.drawerDragStartBehavior,
    this.extendBody,
  });

  @override
  _TabbedScaffoldState createState() => _TabbedScaffoldState(
    tabs: this.tabs,
    appBar: this.appBar,
    floatingActionButton: this.floatingActionButton,
    floatingActionButtonLocation: this
        .floatingActionButtonLocation,
    floatingActionButtonAnimator: this
        .floatingActionButtonAnimator,
    persistentFooterButtons: this.persistentFooterButtons,
    drawer: this.drawer,
    endDrawer: this.endDrawer,
    backgroundColor: this.backgroundColor,
    bottomNavigationBar: this.bottomNavigationBar,
    bottomSheet: this.bottomSheet,
    resizeToAvoidBottomInset: this.resizeToAvoidBottomInset,
    primary: this.primary,
    drawerDragStartBehavior: this.drawerDragStartBehavior,
    extendBody: this.extendBody,
  );
}

class _TabbedScaffoldState extends State<TabbedScaffold> {
  final List<ScaffoldTab> tabs;

  // Templates
  final AppBar appBar;
  final Widget floatingActionButton; // TODO: Specific class
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final FloatingActionButtonAnimator floatingActionButtonAnimator;
  final List<Widget> persistentFooterButtons;
  final Widget drawer; // TODO: Specific class
  final Widget endDrawer; // TODO: Specific class
  final Color backgroundColor;
  final Widget bottomNavigationBar; // TODO: Specific class
  final Widget bottomSheet;
  final bool resizeToAvoidBottomInset;
  final bool primary;
  final DragStartBehavior drawerDragStartBehavior;
  final bool extendBody;

  // For switching tabs
  int _currentIndex;

  _TabbedScaffoldState({
    @required this.tabs,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.resizeToAvoidBottomInset,
    this.primary,
    this.drawerDragStartBehavior,
    this.extendBody,
  });

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    ScaffoldTab _currentTab = this.tabs[_currentIndex];

    // Merge specific tab with templates on per-property basis.
    // There are 2 types of merging:
    //
    // (1) Coarse (Simple) - If property (i.e. bottomSheet) is defined in
    //      _currentTab (i.e. _currentTab.bottomSheet), use it. If not, use
    //      the template (i.e. this .bottomSheet)for that property. (If no
    //      template, property is null.)
    //
    // (2) Fine (Complex)  - For each sub-property of the property (i.e.
    //      appBar.leading): if it's defined in _currentTab.{property}, use
    //      it. If not, use template.{property}. (If no template,
    //      sub-property is null.)
    return Scaffold(
      // No Merging
      body: _currentTab.body,

      // Coarse (Simple)
      floatingActionButtonLocation: _currentTab.floatingActionButtonLocation
          ?? this.floatingActionButtonLocation,
      floatingActionButtonAnimator: _currentTab.floatingActionButtonAnimator
          ?? this.floatingActionButtonAnimator,
      persistentFooterButtons: _currentTab.persistentFooterButtons ??
          this.persistentFooterButtons,
      bottomSheet: _currentTab.bottomSheet ?? this.bottomSheet,
      backgroundColor: _currentTab.backgroundColor ?? this.backgroundColor,
      resizeToAvoidBottomInset: _currentTab.resizeToAvoidBottomInset ??
          this.resizeToAvoidBottomInset,
      primary: _currentTab.primary ?? this.primary,
      drawer: _currentTab.drawer ?? this.drawer,
      endDrawer: _currentTab.endDrawer ?? this.endDrawer,
      drawerDragStartBehavior: _currentTab.drawerDragStartBehavior ??
          this.drawerDragStartBehavior,
      extendBody: _currentTab.extendBody ?? this.extendBody,

      // Fine (Complex)
      appBar: appBarCopier.copy(this.appBar).resolve(),
      bottomNavigationBar: bottomNavigationBarCopier
          .copy(this.bottomNavigationBar)
          .copy(_currentTab.bottomNavigationBar)
          .copyWithAndResolve(
        items: this.tabs.map((tab) => tab.bottomNavigationBarItem).toList(),
        currentIndex: _currentIndex,
        onTap: this.onTabPressed,
      ),
      // floatingActionButtonCopier
      //     .copy(this.floatingActionButton)
      //     .copy(_currentTab.floatingActionButton)
      //     .resolve()s
      // ,
    );
  }

  /// Default callback for pressing on tab - just switches visible tab.
  // TODO: Support additional callback functions.
  void onTabPressed(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
