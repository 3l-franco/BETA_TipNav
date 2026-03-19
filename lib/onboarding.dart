import 'package:flutter/material.dart';
import 'login.dart';

class SlideData {
  final String imagePath;
  final String title;
  final String body;

  SlideData({
    required this.imagePath,
    required this.title,
    required this.body,
  });
}

final List<SlideData> slides = [
  SlideData(
    imagePath: 'images/Slide1.png',
    title: 'Find Buildings\nEasily.',
    body: "Search any building and get instant results.\nJust type the name and we'll guide you there.",
  ),
  SlideData(
    imagePath: 'images/Slide2.png',
    title: 'Get Directions\nin Real-Time.',
    body: 'Guidance across campus.\nFollow directions as you move.',
  ),
  SlideData(
    imagePath: 'images/Slide3.png',
    title: 'Search Rooms, Offices,\nand Buildings.',
    body: 'Quickly find classrooms, offices, and buildings\nacross campus with fast, accurate search.',
  ),
];

// Start page ng onboarding

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentSlide = 0;

  final PageController pageController = PageController();

  void goToNextSlide() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void skipToLast() {
    pageController.animateToPage(
      slides.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLastSlide = currentSlide == slides.length - 1;

    return Scaffold(
      body: Stack(
        children: [

          PageView.builder(
            controller: pageController,
            itemCount: slides.length,
            onPageChanged: (index) {

              setState(() {
                currentSlide = index;
              });
            },
            itemBuilder: (context, index) {
              return Stack(
                children: [

                 // Page 1
                  Positioned.fill(
                    child: Image.asset(
                      slides[index].imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),

                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: .25),
                            Colors.black.withValues(alpha: .10),
                            Colors.black.withValues(alpha: .55),
                            Colors.black.withValues(alpha: .92),
                          ],
                          stops: const [0.0, 0.35, 0.65, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // Title text
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.25,
                    left: 28,
                    right: 28,
                    child: Text(
                      slides[index].title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                  ),

                ],
              );
            },
          ),

          if (!isLastSlide)
            Positioned(
              top: 54,
              right: 24,
              child: GestureDetector(
                onTap: skipToLast,
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Dot indicators
                  Row(
                    children: List.generate(slides.length, (index) {
                      bool isActive = index == currentSlide;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 8),
                        width: isActive ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFFE8B84B)   // gold when active
                              : Colors.white.withValues(alpha: .35),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 14),


                  Text(
                    slides[currentSlide].body,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: .75),
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () {
                      if (isLastSlide) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                        );
                      } else {
                        goToNextSlide();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFE8B84B),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        isLastSlide ? 'GET STARTED ›' : 'NEXT ›',
                        style: const TextStyle(
                          color: Color(0xFFE8B84B),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}