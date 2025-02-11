import 'package:flutter/material.dart';
import 'package:url_check/core/dialog/model/dropdown_config.dart';

class DropdownDialogOverlay<T> extends StatefulWidget {
  final DropdownConfig<T> config;

  const DropdownDialogOverlay({
    super.key,
    required this.config,
  });

  @override
  State<DropdownDialogOverlay<T>> createState() => _DropdownDialogOverlayState<T>();
}

class _DropdownDialogOverlayState<T> extends State<DropdownDialogOverlay<T>> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  T? selectedValue;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.config.initialValue;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.config.title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            CompositedTransformTarget(
              link: _layerLink,
              child: InkWell(
                onTap: () {
                  if (_isOpen) {
                    _removeOverlay();
                  } else {
                    _showOverlay(context);
                  }
                  setState(() {
                    _isOpen = !_isOpen;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      if (selectedValue != null && widget.config.items.any((item) => item.value == selectedValue)) ...[
                        widget.config.items.firstWhere((item) => item.value == selectedValue).icon ?? const SizedBox(),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          selectedValue != null ? widget.config.items.firstWhere((item) => item.value == selectedValue).label : '선택해주세요',
                        ),
                      ),
                      Icon(
                        _isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.config.cancelText != null)
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(widget.config.cancelText!),
                  ),
                if (widget.config.confirmText != null) ...[
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(context, selectedValue),
                    child: Text(widget.config.confirmText!),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showOverlay(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final dialogPosition = renderBox.localToGlobal(Offset.zero);
    final screenSize = MediaQuery.of(context).size;

    // 다이얼로그 내부에서 사용할 수 있는 최대 높이 계산
    final maxHeight = screenSize.height - dialogPosition.dy - 150; // 버튼과 여백 고려

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width - 32, // 다이얼로그 패딩 고려
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 45), // 버튼 높이 + 간격
          child: Material(
            color: Colors.transparent,
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: maxHeight,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: widget.config.items.length,
                    itemBuilder: (context, index) {
                      final item = widget.config.items[index];
                      final isSelected = item.value == selectedValue;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedValue = item.value;
                            _removeOverlay();
                            _isOpen = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.grey.withOpacity(0.1) : null,
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              if (item.icon != null) ...[
                                item.icon!,
                                const SizedBox(width: 8),
                              ],
                              Expanded(
                                child: Text(item.label),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _controller.forward();
  }

  void _removeOverlay() {
    _controller.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }
}
