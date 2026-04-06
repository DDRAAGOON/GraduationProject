import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    required this.body,
    this.actions,
    this.showBack = true,
    this.showAppBarDivider = false,
    this.centerTitle,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final Widget body;
  final List<Widget>? actions;
  final bool showBack;
  final bool showAppBarDivider;
  final bool? centerTitle;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    final showLeading = showBack && canPop;
    final hasActions = actions != null && actions!.isNotEmpty;
    final hasTitle = title != null || titleWidget != null;
    final safeBottomNavigationBar = bottomNavigationBar == null
        ? null
        : SafeArea(
            top: false,
            left: false,
            right: false,
            bottom: true,
            child: bottomNavigationBar!,
          );

    final hasBottomNav = safeBottomNavigationBar != null;
    return Scaffold(
      appBar: (!hasTitle && !showLeading && !hasActions)
          ? null
          : AppBar(
              automaticallyImplyLeading: showLeading,
              leading: showLeading ? null : leading,
              centerTitle: centerTitle,
              title: titleWidget ?? (title == null ? null : Text(title!)),
              actions: actions,
              bottom: showAppBarDivider
                  ? PreferredSize(
                      preferredSize: const Size.fromHeight(1),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: Theme.of(
                          context,
                        ).dividerColor.withValues(alpha: 0.2),
                      ),
                    )
                  : null,
            ),
      body: SafeArea(
        bottom: !hasBottomNav,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxBodyWidth = constraints.maxWidth < 1200
                ? constraints.maxWidth
                : 1200.0;
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxBodyWidth),
                child: body,
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: safeBottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
