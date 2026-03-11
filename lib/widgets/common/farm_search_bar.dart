import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

class FarmSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool autofocus;
  final FocusNode? focusNode;

  const FarmSearchBar({
    super.key,
    this.controller,
    this.hintText = 'ค้นหาปุ๋ย อุปกรณ์ สารกำจัดศัตรูพืช...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.onTap,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
  });

  @override
  State<FarmSearchBar> createState() => _FarmSearchBarState();
}

class _FarmSearchBarState extends State<FarmSearchBar>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final AnimationController _animController;
  late final Animation<double> _borderAnim;

  bool _isFocused = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _borderAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _focusNode.addListener(_onFocusChange);
    _controller.addListener(_onTextChange);

    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
    if (_focusNode.hasFocus) {
      _animController.forward();
    } else {
      _animController.reverse();
    }
  }

  void _onTextChange() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _handleClear() {
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _controller.removeListener(_onTextChange);
    _animController.dispose();

    // Only dispose if we created them internally
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _borderAnim,
      builder: (context, child) {
        return Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withOpacity(
                0.3 + (_borderAnim.value * 0.5),
              ),
              width: 1.5,
            ),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]
                : [],
          ),
          child: child,
        );
      },
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        readOnly: widget.readOnly,
        autofocus: widget.autofocus,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        onTap: widget.onTap,
        textAlignVertical: TextAlignVertical.center,
        style: GoogleFonts.sarabun(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: GoogleFonts.sarabun(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.6),
          ),
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 14,
          ),
          prefixIcon: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Icon(
              Icons.search_rounded,
              color: _isFocused
                  ? Colors.white
                  : Colors.white.withOpacity(0.7),
              size: 22,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 48,
            minHeight: 48,
          ),
          suffixIcon: _hasText
              ? GestureDetector(
                  onTap: _handleClear,
                  child: AnimatedOpacity(
                    opacity: _hasText ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 150),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                )
              : null,
          suffixIconConstraints: const BoxConstraints(
            minWidth: 44,
            minHeight: 44,
          ),
        ),
      ),
    );
  }
}

// ─── Static / Read-Only Search Bar (for HomeView tap-to-navigate) ─────────────

class StaticSearchBar extends StatelessWidget {
  final String hintText;
  final VoidCallback? onTap;

  const StaticSearchBar({
    super.key,
    this.hintText = 'ค้นหาปุ๋ย อุปกรณ์ สารกำจัดศัตรูพืช...',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            Icon(
              Icons.search_rounded,
              color: Colors.white.withOpacity(0.7),
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                hintText,
                style: GoogleFonts.sarabun(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.6),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              width: 1,
              color: Colors.white.withOpacity(0.3),
            ),
            Icon(
              Icons.tune_rounded,
              color: Colors.white.withOpacity(0.7),
              size: 20,
            ),
            const SizedBox(width: 14),
          ],
        ),
      ),
    );
  }
}
