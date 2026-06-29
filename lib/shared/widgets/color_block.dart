import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/enums/bead_color.dart';
import '../../models/block_model.dart';
import 'game_ui_components.dart';

class ColorBlock extends StatefulWidget {
  const ColorBlock({
    super.key,
    required this.block,
    required this.onTap,
  });

  final BlockModel block;
  final VoidCallback onTap;

  @override
  State<ColorBlock> createState() => _ColorBlockState();
}

class _ColorBlockState extends State<ColorBlock>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.96,
      upperBound: 1.0,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.block.isBroken) return const SizedBox.shrink();

    final c = widget.block.color;

    return GestureDetector(
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _pulse,
        child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                c.color.withValues(alpha: 0.95),
                c.darkColor.withValues(alpha: 0.85),
              ],
            ),
            border: Border.all(color: c.darkColor, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: c.darkColor.withValues(alpha: 0.45),
                blurRadius: 0,
                offset: const Offset(0, 5),
              ),
              BoxShadow(
                color: c.color.withValues(alpha: 0.35),
                blurRadius: 10,
                spreadRadius: -2,
              ),
            ],
          ),
          child: Stack(
            children: [
              ...List.generate(
                min(widget.block.beadCount, 8),
                (i) => Positioned(
                  left: 8 + (i % 3) * 14.0,
                  top: 18 + (i ~/ 3) * 12.0,
                  child: BeadSphere(color: c, size: 10),
                ),
              ),
              Positioned(
                top: 5,
                left: 8,
                right: 8,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${widget.block.beadCount}',
                    style: TextStyle(
                      color: c.darkColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
