import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:stripe_app/comman_Textfield.dart';
import 'package:stripe_app/home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Stripe'),
        centerTitle: true,
      ),
      body: controller.hasDonated.value
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Thanks for your ${controller.amount.text} ${controller.selectedCurrency} donation",
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  const Text(
                    "We appreciate your support",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: Obx(
                        ()=> ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent.shade400),
                        child: const Text(
                          "Donate again",
                          style: TextStyle(
                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        onPressed: () {
                          controller.hasDonated.value = false;
                          controller.amount.clear();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  const Text(
                    "Support us your donations",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: CommonTextfield(
                            title: 'Any amount you like',
                            hint: 'Donation Amount',
                            isNumber: true,
                            controller: controller.amount,
                            formkey: controller.formKey),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      DropdownMenu<String>(
                        inputDecorationTheme: InputDecorationTheme(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 20),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        initialSelection: controller.currencyList.first,
                        onSelected: (String? value) {
                          controller.selectedCurrency.value = value!;
                        },
                        dropdownMenuEntries: controller.currencyList
                            .map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(
                            label: value,
                            value: value,
                          );
                        }).toList(),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CommonTextfield(
                    formkey: controller.formKey1,
                    title: "Name",
                    hint: "Ex. John Doe",
                    controller: controller.name,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CommonTextfield(
                    formkey: controller.formKey2,
                    title: "Address Line",
                    hint: "Ex. 123 Main St",
                    controller: controller.address,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 5,
                          child: CommonTextfield(
                            formkey: controller.formKey3,
                            title: "City",
                            hint: "Ex. New Delhi",
                            controller: controller.city,
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          flex: 5,
                          child: CommonTextfield(
                            formkey: controller.formKey4,
                            title: "State (Short code)",
                            hint: "Ex. DL for Delhi",
                            controller: controller.state,
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 5,
                          child: CommonTextfield(
                            formkey: controller.formKey5,
                            title: "Country (Short Code)",
                            hint: "Ex. IN for India",
                            controller: controller.country,
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          flex: 5,
                          child: CommonTextfield(
                            formkey: controller.formKey6,
                            title: "Pincode",
                            hint: "Ex. 123456",
                            controller: controller.pinCode,
                            isNumber: true,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .1,
                  ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () async {
                        if (controller.formKey.currentState!.validate() &&
                            controller.formKey1.currentState!.validate() &&
                            controller.formKey2.currentState!.validate() &&
                            controller.formKey3.currentState!.validate() &&
                            controller.formKey4.currentState!.validate() &&
                            controller.formKey5.currentState!.validate() &&
                            controller.formKey6.currentState!.validate()) {
                          await controller.initPaymentSheet();
                          try {
                            await Stripe.instance.presentPaymentSheet();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                "Payment Done",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.green,
                            ));
                            controller.hasDonated.value = true;
                            controller.name.clear();
                            controller.address.clear();
                            controller.city.clear();
                            controller.state.clear();
                            controller.country.clear();
                            controller.pinCode.clear();
                          } catch (e) {
                            print("payment sheet failed");
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                "Payment Failed",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.redAccent,
                            ));
                          }
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.blueAccent.shade400,
                        child: const Text(
                          "Procced to Pay",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
