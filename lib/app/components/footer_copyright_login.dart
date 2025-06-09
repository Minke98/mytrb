import 'package:flutter/material.dart';

class FooterCopyrightLogin extends StatelessWidget {
  const FooterCopyrightLogin({
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            copyrightText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ));
  }
}
