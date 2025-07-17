import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  String text;
  VoidCallback? onPressed;
  bool isLoading;
  Color? backgroundColor;
  Color? textColor;
  bool isOutlined = false;
  IconData? icon;
  int delay;
  CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.isOutlined = false,
    this.icon,
    this.delay = 0,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> _slideAnimation;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
    );

    _slideController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, 0.3),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: _slideController,
              curve: Interval(widget.delay * 0.1, 1.0, curve: Curves.easeOut),
            ),
          ),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _slideController,
                curve: Interval(widget.delay * 0.1, 1.0, curve: Curves.easeOut),
              ),
            ),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              decoration: BoxDecoration(
                boxShadow:
                    widget.onPressed != null
                        ? [
                          BoxShadow(
                            color: (widget.backgroundColor ?? Colors.blue)
                                .withOpacity(0.3),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ]
                        : [],
                borderRadius: BorderRadius.circular(15),
              ),
              child:
                  widget.isOutlined
                      ? OutlinedButton.icon(
                        onPressed: widget.onPressed,
                        icon:
                            widget.icon != null
                                ? Icon(widget.icon, size: 20)
                                : SizedBox.shrink(),
                        label: Text(
                          widget.text,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          side: BorderSide(color: Colors.blue, width: 2),
                        ),
                      )
                      : ElevatedButton(
                        onPressed: widget.onPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              widget.backgroundColor ?? Colors.blue,
                          foregroundColor: widget.textColor ?? Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                        child:
                            widget.isLoading
                                ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                                : Text(
                                  widget.text,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
            ),
          ),
        );
      },
    );
  }
}
