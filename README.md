# tabbed_scaffold

A `Scaffold`-like widget tailored for tab-bar navigation.

## Installation

See [instructions](https://pub.dev/packages/tabbed_scaffold#-installing-tab-) on how to install.

## Usage

### The Old Way

When creating a `Scaffold` that uses a `BottomNavigationBar`, it's not
uncommon to end up with code like this:

```dart
final List<AppBar> _appBars = [
  AppBar(
    title: const Text('Tab 1'),
    actions: [/* Actions */],
    // More properties
  ),
  AppBar(
    title: const Text('Tab 2'),
    actions: [/* Actions */],
    // More properties
  ),
  // more AppBars
];

final List<Widget> _bodies = [
  TabBody1(),
  TabBody2(),
  // more Widgets
];

final List<BottomNavigationBarItem> _bottomNavigationBarItems = [
  BottomNavigationBarItem(
    title: const Text('Tab 1'),
    icon: Icon(Icons.tab1),
  ),
  BottomNavigationBarItem(
    title: const Text('Tab 2'),
    icon: Icon(Icons.tab2),
  ),
  /* More */ // more BottomNavigationBarItems
];

int _currentIndex = 0;

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: _appBars[_currentIndex],
    body: _bodies[_currentIndex],
    /* More */
    bottomNavigationBar: BottomNavigationBar(
      items: _bottomNavigationBarItems,
      currentIndex: _currentIndex,
      onTap: onTabPressed,
    )
    /* More */
  );
}

void onTabPressed(int index) {
  setState(() {
    _currentIndex = index;
  });
}
```

In this pattern, UI elements are grouped by type - i.e. app bars, bodies,
bottom navigation bar items, etc. This can be hard to understand and read
because what makes up a single "tab" is spread across multiple data
structures. Additionally, there is a good amount of boilerplate code:
  - the bare minimum `onTap` necessary to switch between tabs,
  - the repetition of tab titles in both the `AppBar` and
     `BottomNavigationBarItem`,
  - the manual use of _currentIndex to switch UI components between tabs
  - manual class instantiations for widgets (AppBar, BottomNavBarItem,)

### The New Way

`TabbedScaffold` aims to reorganize your code so that UI components are
grouped by their tab, not their type, and reduce the amount of code you
need to write for a tab-bar navigation layout.

The above code can be re-written in the `TabbedScaffold` pattern as follows:

```dart
List<ScaffoldTab> _tabs = [
  ScaffoldTab(
    title: const Text('Queue'),
    body: TabBody1()
    bottomNavigationBarItemIcon: Icon(Icons.tab1),
  ),
  ScaffoldTab(
    title: const Text('Activity'),
    body: Container(color: Colors.green,),
    bottomNavigationBarItemIcon: Icon(Icons.tab2),
  ),
  // more ScaffoldTabs
];

@override
Widget build(BuildContext context) {
  return TabbedScaffold(
    tabs: _tabs,
  );
}
```
`TabbedScaffold` takes a list of `ScaffoldTab` instances. Additionally, it
optionally takes any properties normally passed to a `Scaffold`
constructor (these can be thought of property templates).

When determining how to build the `Scaffold` for a specific tab,
`TabbedScaffold` first looks at the specific properties in the `ScaffoldTab`
instance for that tab. For any properties not defined in the
`ScaffoldTab`, it looks for any templates passed to the `TabbedScaffold` and
applies the properties found there. If no template is passed for a specific
category, `TabbedScaffold` uses a bare instance of that property as a
template.

This allows you to specify properties that should be the same across all
tabs (for example, AppBar.leading = null) without having to specify as such
in each `ScaffoldTab`.

Here is an example of using `AppBar` and `BottomNavigationBar` templates
with `TabbedScaffold` :

```dart
TabbedScaffold(
  tabs: _tabs,
  appBar: AppBar( // Applies this to every tab. Gets overridden by any
                  // properties set in _tabs[i]
    leading: null,
    automaticallyImplyLeading: false,
  ),
  bottomNavigationBar: BottomNavigationBar(
    onTap: (index) => { // Do something },
  ),
)
```