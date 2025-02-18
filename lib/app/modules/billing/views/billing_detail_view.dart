import 'package:mytrb/app/modules/billing/controllers/billing_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart'; // Import untuk Clipboard

class BillingDetailView extends GetView<BillingController> {
  const BillingDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rincian Pembayaran'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'No. Regis: ${controller.billingDetail.value?.noRegis ?? ''}',
                    style: const TextStyle(fontSize: 16)),
                Align(
                  alignment: Alignment.topRight,
                  child: Text(controller.billingDetail.value?.tglDaftar ?? '',
                      style: const TextStyle(fontSize: 14)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(controller.billingDetail.value?.namaDiklat ?? '',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Periode', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(controller.billingDetail.value?.periode ?? '',
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('No. Billing Pembayaran',
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(controller.billingDetail.value?.noBilling ?? '',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(
                        text: controller.billingDetail.value?.noBilling ?? ''));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No. Billing berhasil disalin!'),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.copy,
                    size: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Total Pembayaran', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(controller.billingDetail.value?.totalBayar ?? '',
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Tanggal Pembayaran', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(controller.billingDetail.value?.tglBayar ?? '',
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Status Pembayaran', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 5),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: controller.billingDetail.value?.flagBayar == '1'
                        ? Colors.green
                        : Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    controller.billingDetail.value?.statusBayar ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Bagian untuk menampilkan tombol berdasarkan kondisi link_cetak_kartu dan link_cetak_invoice
            Column(
              children: [
                if (controller.billingDetail.value?.linkCetakInvoice == null)
                  buildButton(
                    'Cara Pembayaran',
                    () => controller.fetchWebViewInvoice(
                        controller.billingDetail.value!.linkCetakInvoice),
                  ),
                // if (controller.billingDetail.value?.linkCetakKartu == null)
                //   buildButton(
                //     'Cetak Invoice',
                //     () => controller.fetchWebViewInvoice(
                //         controller.billingDetail.value!.linkCetakInvoice),
                //   ),
                // if (controller.billingDetail.value?.linkCetakInvoice != null &&
                //     controller.billingDetail.value?.linkCetakKartu != null)
                //   Column(
                //     children: [
                //       buildButton(
                //         'Cetak Kartu',
                //         () => controller.fetchWebViewCard(
                //             controller.billingDetail.value!.linkCetakKartu),
                //       ),
                //       const SizedBox(height: 10),
                //       buildButton(
                //         'Cetak Invoice',
                //         () => controller.fetchWebViewInvoice(
                //             controller.billingDetail.value!.linkCetakInvoice),
                //       ),
                //     ],
                //   ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String title, VoidCallback onPressed) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(0),
        ),
        onPressed: onPressed,
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF002171),
                Color(0xFF1565C0),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            constraints: const BoxConstraints(minWidth: 180, minHeight: 40),
            alignment: Alignment.center,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
