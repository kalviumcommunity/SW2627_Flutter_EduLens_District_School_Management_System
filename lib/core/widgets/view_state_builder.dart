import 'package:flutter/material.dart';

import '../state/view_state.dart';
import 'state_message.dart';

/// Renders a [ViewState]: the four non-ready states through the shared
/// [StateMessage], and the ready state through [builder].
class ViewStateBuilder<T> extends StatelessWidget {
  /// What to render.
  final ViewState<T> state;

  /// Builds the screen's real content once data has arrived.
  final Widget Function(BuildContext context, T data) builder;

  /// Offered on the error state. Omit it and no Retry button is shown.
  final VoidCallback? onRetry;

  /// Optional replacements for the empty state's default wording.
  final String? emptyTitle;
  final String? emptyMessage;

  /// Optional action widget to render in the empty state (e.g. an "Add" button).
  final Widget? emptyAction;

  const ViewStateBuilder({
    super.key,
    required this.state,
    required this.builder,
    this.onRetry,
    this.emptyTitle,
    this.emptyMessage,
    this.emptyAction,
  });

  @override
  Widget build(BuildContext context) {
    switch (state.status) {
      case ViewStatus.loading:
        return const StateMessage(type: StateMessageType.loading);

      case ViewStatus.ready:
        return builder(context, state.data as T);

      case ViewStatus.empty:
        return StateMessage(
          type: StateMessageType.empty,
          title: emptyTitle,
          message: emptyMessage ?? state.message,
          action: emptyAction,
        );

      case ViewStatus.error:
        return StateMessage(
          type: StateMessageType.error,
          message: state.message,
          onRetry: onRetry,
        );

      case ViewStatus.unauthorized:
        return StateMessage(
          type: StateMessageType.unauthorized,
          message: state.message,
        );
    }
  }
}
