import 'package:flutter/material.dart';

/// Controller for [ExpandableSearchBarPlus].
///
/// Allows you to expand, collapse, or toggle the search bar manually.
///
/// Example:
/// ```dart
/// final controller = ExpandableSearchBarPlusController();
///
/// controller.expand(); // Open
/// controller.collapse(); // Close
/// controller.toggle(); // Toggle
/// bool open = controller.isExpanded; // Get current state
/// ```
class ExpandableSearchBarPlusController extends ChangeNotifier {
  bool _isExpanded = false;

  /// Returns whether the search bar is currently expanded.
  bool get isExpanded => _isExpanded;

  /// Expands the search bar if not already expanded.
  void expand() {
    if (!_isExpanded) {
      _isExpanded = true;
      notifyListeners();
    }
  }

  /// Collapses the search bar if expanded.
  void collapse() {
    if (_isExpanded) {
      _isExpanded = false;
      notifyListeners();
    }
  }

  /// Toggles between expanded and collapsed states.
  void toggle() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }

  /// Updates the current state (used internally by the widget).
  void updateInternalState(bool value) {
    if (_isExpanded != value) {
      _isExpanded = value;
      notifyListeners();
    }
  }
}
