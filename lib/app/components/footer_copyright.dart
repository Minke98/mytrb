import 'package:flutter/material.dart';

class FooterCopyright extends StatelessWidget {
  const FooterCopyright({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const int yearOld = 2025; // Tahun awal
    final int year = DateTime.now().year; // Tahun saat ini
    const String companyName = 'TRSea - TechnoLabs'; // Nama perusahaan

    // Logika kondisi
    final String copyrightText = (yearOld == year)
        ? '$year © $companyName. All rights reserved'
        : '$yearOld - $year © $companyName. All rights reserved';

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 8),
      alignment: Alignment.center,
      child: Text(
        copyrightText,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
