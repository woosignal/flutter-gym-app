import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class NyTabbedLayout extends StatefulWidget {
  NyTabbedLayout({
    super.key,
    required this.tabs,
    required this.widgets,
    this.indexSelected = 0,
    this.selectedTabStyle =
        const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
    this.unselectedTabStyle = const TextStyle(color: Colors.grey),
  });

  final List<String> tabs;
  final List<Widget> widgets;
  final int indexSelected;
  final TextStyle selectedTabStyle;
  final TextStyle unselectedTabStyle;

  @override
  _NyTabbedLayoutState createState() =>
      _NyTabbedLayoutState(indexSelected: indexSelected);
}

class _NyTabbedLayoutState extends NyState<NyTabbedLayout> {
  _NyTabbedLayoutState({int indexSelected = 0})
      : _indexSelected = indexSelected;

  int _indexSelected;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[200]!,
                blurRadius: 4,
                offset: Offset(0, 1), // Shadow position
              ),
            ],
          ),
          height: 50,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: widget.tabs.map((tab) {
              bool isSelected =
                  widget.tabs.indexWhere((element) => element == tab) ==
                      _indexSelected;
              return Expanded(
                child: InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(tab,
                        style: isSelected
                            ? widget.selectedTabStyle
                            : widget.unselectedTabStyle,
                        textAlign: TextAlign.center),
                  ),
                  onTap: () {
                    List<String> values = widget.tabs;
                    setState(() {
                      _indexSelected = values.indexOf(tab);
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: NySwitch(
            indexSelected: _indexSelected,
            widgets: widget.widgets,
          ),
        ),
      ],
    );
  }
}

class NyTabbedLayoutTwo extends StatefulWidget {
  NyTabbedLayoutTwo({
    super.key,
    required this.tabs,
    required this.widgets,
    this.indexSelected = 0,
    this.selectedTabStyle =
        const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
    this.unselectedTabStyle = const TextStyle(color: Colors.grey),
  });

  final List<String> tabs;
  final List<Widget> widgets;
  final int indexSelected;
  final TextStyle selectedTabStyle;
  final TextStyle unselectedTabStyle;

  @override
  _NyTabbedLayoutTwoState createState() =>
      _NyTabbedLayoutTwoState(indexSelected: indexSelected);
}

class _NyTabbedLayoutTwoState extends NyState<NyTabbedLayoutTwo> {
  _NyTabbedLayoutTwoState({int indexSelected = 0})
      : _indexSelected = indexSelected;

  int _indexSelected;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[200]!,
                width: 1.0,
              ),
            ),
          ),
          height: 50,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: widget.tabs.map((tab) {
              bool isSelected =
                  widget.tabs.indexWhere((element) => element == tab) ==
                      _indexSelected;
              return Expanded(
                child: InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(tab,
                        style: isSelected
                            ? widget.selectedTabStyle
                            : widget.unselectedTabStyle,
                        textAlign: TextAlign.center),
                  ),
                  onTap: () {
                    List<String> values = widget.tabs;
                    setState(() {
                      _indexSelected = values.indexOf(tab);
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),
        NySwitch(
          indexSelected: _indexSelected,
          widgets: widget.widgets,
        ),
      ],
    );
  }
}
