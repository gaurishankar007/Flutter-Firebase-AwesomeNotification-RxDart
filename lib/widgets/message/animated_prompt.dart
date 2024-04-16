import 'package:flutter/material.dart';

class AnimatedPromptWidget extends StatefulWidget {
  final String title;
  final String subTitle;
  final Icon icon;
  final Color iconContainerColor;

  const AnimatedPromptWidget({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.iconContainerColor,
  });

  @override
  State<AnimatedPromptWidget> createState() => _AnimatedPromptWidgetState();
}

class _AnimatedPromptWidgetState extends State<AnimatedPromptWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> iconScaleAnimation;
  late Animation<double> containerScaleAnimation;
  late Animation<Offset> containerOffsetAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    containerOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -.25),
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );

    iconScaleAnimation = Tween<double>(
      begin: 7,
      end: 6,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );

    containerScaleAnimation = Tween<double>(
      begin: 2,
      end: .4,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.bounceOut,
      ),
    );

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              spreadRadius: 3,
              blurRadius: 6,
            ),
          ],
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 100,
            minHeight: 100,
            maxWidth: MediaQuery.of(context).size.width * .5,
            maxHeight: MediaQuery.of(context).size.height * .20,
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.subTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(.7),
                      ),
                    ),
                  ],
                ),
              ),
              // Fills the available space
              Positioned.fill(
                child: SlideTransition(
                  position: containerOffsetAnimation,
                  child: ScaleTransition(
                    scale: containerScaleAnimation,
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.iconContainerColor,
                        shape: BoxShape.circle,
                      ),
                      child: ScaleTransition(
                        scale: iconScaleAnimation,
                        child: widget.icon,
                      ),
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
