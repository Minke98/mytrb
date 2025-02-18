import 'package:mytrb/app/modules/billing/controllers/billing_controller.dart';
import 'package:mytrb/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BillingView extends GetView<BillingController> {
  const BillingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tagihan Pembayaran'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(
        () {
          if (controller.billingList.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada tagihan pembayaran.',
                style: TextStyle(fontSize: 16),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: controller.billingList.length,
              itemBuilder: (context, index) {
                final billing = controller.billingList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    color: billing.flagBayar == '1'
                        ? Colors.blue[50]
                        : Colors.yellow[50],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('No. Regis: ${billing.noRegis}',
                                  style: const TextStyle(fontSize: 14)),
                              Align(
                                alignment: Alignment.topRight,
                                child: Text(billing.tglDaftar ?? '',
                                    style: const TextStyle(fontSize: 14)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(billing.namaDiklat ?? '',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(billing.periode ?? '',
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('No. Billing Pembayaran',
                                      style: TextStyle(fontSize: 16)),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(billing.noBilling ?? '',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          Clipboard.setData(ClipboardData(
                                              text: billing.noBilling ?? ''));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'No. Billing berhasil disalin!'),
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
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text('Status Pembayaran',
                                      style: TextStyle(fontSize: 16)),
                                  const SizedBox(height: 5),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: billing.flagBayar == '1'
                                          ? Colors.green
                                          : Colors.red,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      billing.statusBayar ?? '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (billing.flagBayar == '1')
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF002171),
                                        Color(0xFF1565C0),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await controller.fetchBillingDetail(
                                          billing.ucPendaftaran);
                                      controller.fetchWebViewInvoice(controller
                                          .billingDetail
                                          .value
                                          ?.linkCetakInvoice);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                    ),
                                    child: const Text('Cetak Invoice'),
                                  ),
                                ),
                              const SizedBox(width: 8),
                              Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF002171),
                                      Color(0xFF1565C0),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await controller.fetchBillingDetail(
                                        billing.ucPendaftaran);
                                    Get.toNamed(
                                      Routes.BILLING_DETAIL,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                  ),
                                  child: const Text('Detail'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
