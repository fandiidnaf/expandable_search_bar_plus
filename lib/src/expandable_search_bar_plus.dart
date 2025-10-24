import 'package:flutter/material.dart';
import 'expandable_search_bar_plus_controller.dart';
import 'round_search_icon.dart';

/// A modern and customizable expandable search bar widget.
///
/// This widget animates smoothly between a circular icon and an expanded
/// text input field. It’s designed to be **mobile-friendly**, and works
/// on **web and desktop** if `supportMouse` is enabled.
class ExpandableSearchBarPlus extends StatefulWidget {
  const ExpandableSearchBarPlus({
    super.key,
    this.hintText,
    required this.controller,
    this.barController,
    this.onTap,
    this.onChanged,
    this.width = 240,
    this.iconSize = 45,
    this.gutter = 16,
    this.radius = 30,
    this.animationDuration = const Duration(milliseconds: 400),
    this.animationCurve = Curves.fastOutSlowIn,
    this.textFieldAnimationDuration = const Duration(milliseconds: 200),
    this.textFieldAnimationCurve = Curves.easeInOut,
    this.iconBoxShadow,
    this.iconColor = const Color(0xff47E10C),
    this.iconBackgroundColor = const Color(0xff353535),
    this.boxShadow = const [
      BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
    ],
    this.backgroundColor = const Color(0xff101010),
    this.textStyle = const TextStyle(color: Colors.white, fontSize: 16),
    this.hintStyle = const TextStyle(color: Colors.grey, fontSize: 16),
    this.supportMouse = false,
    this.icon = const Icon(Icons.search_rounded),
  });

  /// Called when the search icon is tapped.
  /// Returns `true` if expanded, otherwise `false`.
  final void Function(bool isExpanded)? onTap;

  /// Called whenever the user changes the text inside the TextField.
  final ValueChanged<String>? onChanged;

  /// Hint text inside the TextField.
  final String? hintText;

  /// The controller for the TextField.
  final TextEditingController controller;

  /// The controller for the SearchBar
  ///
  /// use this if you want to programmatically control the search bar state
  final ExpandableSearchBarPlusController? barController;

  /// Width of the expanded search bar.
  final double width;

  /// Diameter of the search icon container.
  final double iconSize;

  /// Extra space between the icon and the end of the text field.
  final double gutter;

  /// Corner radius for the entire bar.
  final double radius;

  /// Duration for the main expansion animation.
  final Duration animationDuration;

  /// Curve for the expansion animation.
  final Curve animationCurve;

  /// Duration for text field width animation.
  final Duration textFieldAnimationDuration;

  /// Curve for text field width animation.
  final Curve textFieldAnimationCurve;

  /// Custom box shadow for the search icon.
  final List<BoxShadow>? iconBoxShadow;

  /// Color of the search icon.
  final Color iconColor;

  /// Background color of the circular search icon.
  final Color iconBackgroundColor;

  /// Background color for the expanded bar.
  final Color backgroundColor;

  /// Box shadow of the expanded bar.
  final List<BoxShadow>? boxShadow;

  /// Text style for the input.
  final TextStyle textStyle;

  /// Hint text style.
  final TextStyle hintStyle;

  /// Whether to support hover expand/collapse for web/desktop.
  final bool supportMouse;

  /// The icon widget displayed inside the circle (can be replaced).
  final Widget icon;

  @override
  State<ExpandableSearchBarPlus> createState() =>
      _ExpandableSearchBarPlusState();
}

class _ExpandableSearchBarPlusState extends State<ExpandableSearchBarPlus> {
  bool _isExpanded = false;
  late final FocusNode _focusNode;
  ExpandableSearchBarPlusController? _controller;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_handleFocusChange);

    // initialize internal or external controller
    _controller = widget.barController ?? ExpandableSearchBarPlusController();

    // listen to external changes
    _controller!.addListener(() {
      if (mounted) {
        setState(() {
          _isExpanded = _controller!.isExpanded;
          if (_isExpanded) {
            _focusNode.requestFocus();
          } else {
            _focusNode.unfocus();
          }
        });
      }
    });
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus && widget.controller.text.isEmpty) {
      _updateExpanded(false);
    }
  }

  void _updateExpanded(bool value) {
    if (_isExpanded != value) {
      setState(() => _isExpanded = value);
      _controller?.updateInternalState(value);
      widget.onTap?.call(value);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _toggle() => _updateExpanded(!_isExpanded);

  @override
  Widget build(BuildContext context) {
    final double barWidth = _isExpanded
        ? widget.width + widget.gutter
        : widget.iconSize;

    final double textFieldWidth = _isExpanded
        ? widget.width - widget.iconSize * 0.8
        : 0.0;

    final Widget content = AnimatedContainer(
      width: barWidth,
      duration: widget.animationDuration,
      curve: widget.animationCurve,
      padding: _isExpanded ? const EdgeInsets.only(left: 16) : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.radius),
        boxShadow: widget.boxShadow,
      ),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: widget.textFieldAnimationDuration,
            curve: widget.textFieldAnimationCurve,
            width: textFieldWidth,
            height: widget.iconSize,
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              onChanged: widget.onChanged,
              style: widget.textStyle,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: widget.hintStyle,
                border: InputBorder.none,
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: InkWell(
              onTap: _toggle,
              borderRadius: BorderRadius.circular(widget.radius),
              child: RoundSearchIcon(
                width: widget.iconSize,
                backgroundColor: widget.iconBackgroundColor,
                iconColor: widget.iconColor,
                boxShadow: widget.iconBoxShadow,
                icon: widget.icon,
              ),
            ),
          ),
        ],
      ),
    );

    if (!widget.supportMouse) return content;

    return MouseRegion(
      onEnter: (_) => _updateExpanded(true),
      onExit: (_) {
        if (widget.controller.text.isEmpty) _updateExpanded(false);
      },
      child: content,
    );
  }
}
