import 'dart:math';

import 'package:flutter/material.dart';
import 'package:roam_and_rate/presentation/widgets/common/trip_cards.dart';

class SwipeableStack extends StatefulWidget {
  final List<TripCards> cards;

  const SwipeableStack({super.key, required this.cards});

  @override
  State<SwipeableStack> createState() => _SwipeableStackState();
}

class _SwipeableStackState extends State<SwipeableStack>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  List<Widget> _cardStack = [];
  bool _isAnimating = false;
  int _currentIndex = 0;

  // Stack configuration - show more cards and increase spacing
  final double _cardOffset = 12.0; // Increased offset between cards
  final double _scaleStep = 0.04; // Reduced scale step for better visibility

  @override
  void initState() {
    super.initState();
    _cardStack = List.from(widget.cards);

    _animationController = AnimationController(
      duration: Duration(milliseconds: 350),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.08).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _swipeNext() {
    if (_isAnimating || _cardStack.isEmpty) return;

    setState(() {
      _isAnimating = true;
    });

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(1.2, -0.1),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward().then((_) {
      setState(() {
        final firstCard = _cardStack.removeAt(0);
        _cardStack.add(firstCard);
        _currentIndex = (_currentIndex + 1) % widget.cards.length;
        _isAnimating = false;
      });
      _animationController.reset();
    });
  }

  void _swipePrevious() {
    if (_isAnimating || _cardStack.isEmpty) return;

    setState(() {
      _isAnimating = true;
    });

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-1.2, -0.1),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward().then((_) {
      setState(() {
        final lastCard = _cardStack.removeLast();
        _cardStack.insert(0, lastCard);
        _currentIndex =
            (_currentIndex - 1 + widget.cards.length) % widget.cards.length;
        _isAnimating = false;
      });
      _animationController.reset();
    });
  }

  Widget _buildCard(int index, Widget card) {
    final isTopCard = index == 0;

    // Calculate positioning for ALL cards in stack (not just first 3)
    final leftOffset = index * _cardOffset;
    final topOffset = index * (_cardOffset * 0.6);
    final scale = 1.0 - (index * _scaleStep);
    final opacity = index == 0 ? 1.0 : (1.0 - (index * 0.15)).clamp(0.3, 1.0);

    Widget cardWidget = Opacity(
      opacity: opacity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: Offset(0, index * 1.5 + 2),
            ),
          ],
        ),
        child: ClipRRect(borderRadius: BorderRadius.circular(16), child: card),
      ),
    );

    if (isTopCard) {
      cardWidget = AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              _slideAnimation.value.dx * MediaQuery.of(context).size.width,
              _slideAnimation.value.dy * 50,
            ),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle:
                    _rotationAnimation.value *
                    (_slideAnimation.value.dx > 0 ? 1 : -1),
                child: GestureDetector(
                  onPanEnd: (details) {
                    if (_isAnimating) return;

                    final velocity = details.velocity.pixelsPerSecond.dx;
                    if (velocity > 300) {
                      _swipeNext();
                    } else if (velocity < -300) {
                      _swipePrevious();
                    }
                  },
                  onTap: _swipeNext,
                  child: child,
                ),
              ),
            ),
          );
        },
        child: cardWidget,
      );
    }

    return Positioned(
      left: leftOffset,
      top: topOffset,
      right: leftOffset,
      child: Transform.scale(scale: scale, child: cardWidget),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculate container height based on number of cards
    final stackHeight = 200 + (_cardStack.length * _cardOffset * 0.6);

    return Container(
      height: stackHeight,
      margin: EdgeInsets.all(20),
      child: Stack(
        children: [
          // Render ALL cards from back to front (reverse order for proper stacking)
          for (int i = _cardStack.length - 1; i >= 0; i--)
            _buildCard(i, _cardStack[i]),

          // Position indicators at the bottom
          Positioned(
            bottom: -40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.cards.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 3),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        index == _currentIndex
                            ? Colors.blue
                            : Colors.grey.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
