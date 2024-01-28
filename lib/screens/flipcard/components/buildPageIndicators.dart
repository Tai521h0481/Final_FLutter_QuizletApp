import 'package:flutter/material.dart';

List<Widget> buildPageIndicators(int currentPage, int pageCount) {
    List<Widget> list = [];
    int start = currentPage - 2;
    int end = currentPage + 2;

    if (start < 0) {
      end -= start;
      start = 0;
    }
    if (end > pageCount - 1) {
      start -= (end - (pageCount - 1));
      end = pageCount - 1;
    }

    for (int i = start; i <= end; i++) {
      list.add(buildIndicator(i == currentPage));
    }
    return list;
  }

  Widget buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 6,
      width: isActive ? 20 : 6,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }