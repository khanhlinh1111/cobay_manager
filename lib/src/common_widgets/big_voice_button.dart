import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_theme.dart';

class BigVoiceButton extends StatefulWidget {
  final VoidCallback onRecordStart;
  final VoidCallback onRecordStop;
  final bool isListening;

  const BigVoiceButton({
    super.key,
    required this.onRecordStart,
    required this.onRecordStop,
    this.isListening = false,
  });

  @override
  State<BigVoiceButton> createState() => _BigVoiceButtonState();
}

class _BigVoiceButtonState extends State<BigVoiceButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.isListening) {
          widget.onRecordStop();
        } else {
          widget.onRecordStart();
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isListening ? _scaleAnimation.value : 1.0,
            child: Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: widget.isListening ? AppTheme.primaryRed : AppTheme.primaryGreen,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (widget.isListening ? AppTheme.primaryRed : AppTheme.primaryGreen).withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                widget.isListening ? Icons.stop : Icons.mic,
                color: Colors.white,
                size: 40.sp,
              ),
            ),
          );
        },
      ),
    );
  }
}
