import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum SettingsCardType { toggle, textWithIcon }

class SettingsCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final SettingsCardType type;

  // Toggle mode
  final bool? initialValue;
  final ValueChanged<bool>? onToggle;

  // Text with icon mode
  final String? text;
  final IconData? trailingIcon;
  final VoidCallback? onTap;

  const SettingsCard({
    super.key,
    required this.icon,
    required this.label,
    required this.type,
    this.initialValue,
    this.onToggle,
    this.text,
    this.trailingIcon,
    this.onTap,
  });

  @override
  State<SettingsCard> createState() => _SettingsCardState();
}

class _SettingsCardState extends State<SettingsCard> {
  late bool isOn;

  @override
  void initState() {
    super.initState();
    isOn = widget.initialValue ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 56), // Equal height
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white, // background color
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Row(
        children: [
          Icon(widget.icon, size: 24, color: Color(0xFF6A11CB)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.label,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Mode Handling
          if (widget.type == SettingsCardType.toggle)
            Switch.adaptive(
              value: isOn,
              activeColor: Color(0xFF6A11CB),
              onChanged: (value) {
                setState(() {
                  isOn = value;
                });
                widget.onToggle?.call(value);
              },
            )
          else if (widget.type == SettingsCardType.textWithIcon)
            InkWell(
              onTap: widget.onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.text ?? '',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(widget.trailingIcon ?? Icons.arrow_drop_down),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
