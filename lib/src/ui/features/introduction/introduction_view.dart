import 'package:flutter/material.dart';
import 'package:party_planner/src/ui/features/register_form/view/register_view.dart';
import 'package:party_planner/src/ui/widgets/typography/btn.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<IntroductionContent> _contents = [
    IntroductionContent(
      title: "Find Your Party",
      description:
          "Connect with fellow adventurers and find the perfect group for your next campaign.",
      image: "assets/find_a_team.png",
      backgroundColor: Color(0xffdff9fa).withAlpha((255.0 * 0.6).round()),
    ),
    IntroductionContent(
      title: "Personalize your Experience",
      description:
          "Complete setting up your profile. That way you will be able to find matching game events.",
      image: "assets/customize.png",
      backgroundColor: Color(0xffdff9fa).withAlpha((255.0 * 0.6).round()),
    ),
    IntroductionContent(
      title: "Schedule with Ease",
      description:
          "No more scheduling headaches! Use our voting system to find the perfect time for everyone.",
      image: "assets/schedule.png",
      backgroundColor: Color(0xffdff9fa).withAlpha((255.0 * 0.6).round()),
    ),
    IntroductionContent(
      title: "User stats",
      description:
          "Obtain an overview of the past participation activities of your friends and others to ensure their dedication.",
      image: "assets/stats.png",
      backgroundColor: Color(0xffdff9fa).withAlpha((255.0 * 0.6).round()),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: _contents.length,
            itemBuilder: (context, index) {
              return IntroductionView(content: _contents[index]);
            },
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _contents.length,
                    (index) => buildDot(index),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentPage > 0)
                        TextBtn(
                          text: Text(
                            "BACK",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        )
                      else
                        const SizedBox(width: 80),
                      GradientPrimaryBtn(
                        text: Text(
                          "NEXT",
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: Colors.white),
                        ),
                        onPressed: () {
                          if (_currentPage == _contents.length - 1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterView(),
                              ),
                            );
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot(int index) {
    return Container(
      height: 10,
      width: _currentPage == index ? 25 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: _currentPage == index ? Color(0xff012840) : Colors.grey,
      ),
    );
  }
}

class IntroductionContent {
  final String title;
  final String description;
  final String image;
  final Color backgroundColor;

  IntroductionContent({
    required this.title,
    required this.description,
    required this.image,
    required this.backgroundColor,
  });
}

class IntroductionView extends StatelessWidget {
  final IntroductionContent content;

  const IntroductionView({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: content.backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Image.asset(
              content.image,
              height: 300,
            ),
          ),
          // const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                Text(
                  content.title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff012840),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  content.description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xff012840),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
