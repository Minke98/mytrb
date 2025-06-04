import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/modules/faq/controllers/faq_controller.dart';

class FaqView extends GetView<FaqController> {
  const FaqView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("FAQ")),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: controller.faqs.length,
                itemBuilder: (context, index) {
                  final item = controller.faqs[index];
                  return Column(
                    children: [
                      FaqItem(item: item),
                      const SizedBox(height: 6),
                    ],
                  );
                },
              ),
      ),
    );
  }
}

class FaqItem extends StatelessWidget {
  const FaqItem({super.key, required this.item});
  final Map item;

  @override
  Widget build(BuildContext context) {
    final isVisible = false.obs;

    return Card(
      color: Colors.white,
      child: InkWell(
        onTap: () => isVisible.value = !isVisible.value,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['question'],
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Obx(() => isVisible.value
                  ? Text(
                      item['answer'],
                      style: const TextStyle(color: Colors.black, fontSize: 13),
                    )
                  : const SizedBox()),
              Align(
                alignment: Alignment.topRight,
                child: Obx(() => Icon(
                    isVisible.value ? Icons.expand_less : Icons.expand_more)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
