import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomDropdownField extends StatefulWidget {
  final String? selectedValue;
  final List<String> items;
  final String labelText;
  final IconData prefixIcon;
  final Function(String?) onChanged;
  final String? Function(String?) validator;
  final int delay;

  const CustomDropdownField({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.labelText,
    required this.prefixIcon,
    required this.onChanged,
    required this.validator,
    this.delay = 0,
  });

  @override
  State<CustomDropdownField> createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField>
    with TickerProviderStateMixin {
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    Future.delayed(Duration(milliseconds: widget.delay * 100), () {
      if (mounted) {
        _slideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
      ),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
        ),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: widget.selectedValue,
            decoration: InputDecoration(
              labelText: widget.labelText,
              prefixIcon: Icon(widget.prefixIcon, color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.blue),
            elevation: 8,
            style: const TextStyle(color: Colors.black87, fontSize: 16),
            dropdownColor: Colors.white,
            items:
                widget.items.map((String country) {
                  return DropdownMenuItem<String>(
                    value: country,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          Text(
                            country,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
            onChanged: (String? newValue) {
              HapticFeedback.selectionClick();
              widget.onChanged(newValue);
            },
            validator: widget.validator,
            menuMaxHeight: 200,
          ),
        ),
      ),
    );
  }
}
