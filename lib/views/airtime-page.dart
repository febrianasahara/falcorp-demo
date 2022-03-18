// ignore_for_file: unnecessary_const, prefer_const_literals_to_create_immutables, non_constant_identifier_names, use_key_in_widget_constructors

import 'dart:convert';

import 'package:airtime_purchase_app/models/data/service_provider.dart';
import 'package:airtime_purchase_app/models/menu_response.dart';
import 'package:airtime_purchase_app/models/purchase/custom_amount_item.dart';
import 'package:airtime_purchase_app/models/purchase/fixed_amount_item.dart';
import 'package:airtime_purchase_app/models/purchase/pre_defined_amount.dart';
import 'package:airtime_purchase_app/models/purchase/product.dart';
import 'package:airtime_purchase_app/models/purchase/purchase_types.dart';
import 'package:airtime_purchase_app/theme/palette.dart';
import 'package:flutter/material.dart';

enum PageStates { topup, voucher }

enum ActionStates {
  typeSelection, // initial/default,
  networkSelection,
  amountSelection,
  customAmountSelection,
  customerPhoneSelection,
  purchaseSummary,
  purchaseComplete
}

class AirtimePage extends StatefulWidget {
  final MenuResponse data;
  const AirtimePage({required this.data});

  @override
  AirtimePageState createState() => AirtimePageState();
}

class AirtimePageState extends State<AirtimePage> {
  final TextStyle titleTextStyle = const TextStyle(
      color: Colors.white70, fontSize: 22, fontWeight: FontWeight.bold);
  final TextStyle _itemTextStyle = const TextStyle(
      color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700);
  final TextStyle _buttonTextStyle = const TextStyle(
      color: Colors.black38, fontSize: 16, fontWeight: FontWeight.w700);

  bool busy = false;

  // state variabls
  ActionStates currentAction = ActionStates.typeSelection;
  late PageStates currentUseCase = PageStates.voucher;
  bool typeSelected = false;
  bool networkSelected = false;
  bool amountSelected = false;
  bool canPurchase = false;

  // app variables
  late FixedAmountItem selectedAmount = FixedAmountItem(amountInCents: 0);
  late CustomAmountItem selectedCustomAmount =
      CustomAmountItem(maxAmountInCents: 0, minAmountInCents: 0);
  late PurchaseType selectedAction = PurchaseType(name: '-');
  late ServiceProvider selectedProvider = ServiceProvider(name: '-');
  late CustomAmountItem topupCustomAmount;
  late Product selectedProduct;
  int selectedAmountInCents = 0;
  int selectedProductSKU = -1;
  late MenuResponse menuData;

  // user interaction events
  onTypeSelected(PurchaseType type) {
    currentUseCase = PageStates.voucher;
    if (type.id == 2) {
      currentUseCase =
          PageStates.topup; // required for custom amounts and cell logic
    }

    setState(() {
      typeSelected = true;
      selectedAction = type;
      // next step || ussd action
      currentAction = ActionStates.networkSelection;
    });
  }

  onProviderSelected(ServiceProvider provider) {
    setState(() {
      // get products offered for selection and change state
      selectedProduct = _getProductOfferingForProvider(provider);
      topupCustomAmount = selectedProduct.preDefinedAmount!.customAmountItem!;
      networkSelected = true;
      selectedProvider = provider;
      // next step || ussd action
      currentAction = ActionStates.amountSelection;
    });
  }

  onAmountSelected(int amountInCents, int sku) {
    setState(() {
      // set amount

      selectedAmountInCents = amountInCents;
      selectedProductSKU = sku;
      amountSelected = true;
      // next step || ussd action
      if (currentUseCase == PageStates.topup) {
        // show customer cell
        currentAction = ActionStates.customerPhoneSelection;
      } else {
        // show summary
        currentAction = ActionStates.purchaseSummary;
      }
    });
  }

  @override
  void initState() {
    menuData = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(menuData.data!.menuInfo!.name!),
      ),
      body: Stack(
        children: [
          Hero(
              tag: 'bg-transition',
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Palette.primaryDark,
                ),
              )),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _purchaseTypeButton(
                  menuData.data!.purchaseTypeSection!.purchaseTypes!),
              typeSelected ? _networkTypeButton() : const SizedBox(),
              networkSelected ? _amountSelectionButton() : const SizedBox(),
            ],
          )
        ],
      ),
    );
  }

  Widget _purchaseTypeButton(List<PurchaseType> types) {
    var size = MediaQuery.of(context).size;
    final double itemWidth = size.width / 2;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
              height: 60,
              child: Material(
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          currentAction = ActionStates.typeSelection;
                          amountSelected = false;
                          networkSelected = false;
                          typeSelected = false;
                        });
                      },
                      child: SizedBox(
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                menuData.data!.purchaseTypeSection!.title!,
                                style: _buttonTextStyle,
                              ),
                            )),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                selectedAction.name!,
                                textAlign: TextAlign.right,
                                style: _buttonTextStyle,
                              ),
                            ))
                          ],
                        ),
                      )))),
          currentAction == ActionStates.typeSelection
              ? SizedBox(
                  height: 260,
                  width: double.infinity,
                  child: GridView.builder(
                      itemCount: types.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: (itemWidth / 130)),
                      itemBuilder: (context, index) {
                        var item = menuData
                            .data!.purchaseTypeSection!.purchaseTypes![index];
                        Widget displayChild;
                        switch (item.displayType) {
                          case 1: //text
                            displayChild = Align(
                              alignment: Alignment.center,
                              child: Text(
                                types[index].name!,
                                textAlign: TextAlign.center,
                                style: _itemTextStyle,
                              ),
                            );
                            break;
                          case 2: // image
                          default: //text
                            displayChild = Align(
                              alignment: Alignment.center,
                              child: Text(
                                types[index].name!,
                                textAlign: TextAlign.center,
                                style: _itemTextStyle,
                              ),
                            );
                            break;
                        }

                        return SizedBox(
                          height: 130,
                          child: Material(
                            child: InkWell(
                              onTap: () {
                                onTypeSelected(types[index]);
                              },
                              child: displayChild,
                            ),
                          ),
                        );
                      }))
              : const SizedBox()
        ],
      ),
    );
  }

  Widget _networkTypeButton() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 60,
            child: Material(
              child: InkWell(
                onTap: () {
                  setState(() {
                    currentAction = ActionStates.networkSelection;
                    amountSelected = false;
                    networkSelected = false;
                    typeSelected = true;
                    selectedProvider = ServiceProvider(name: '-');
                  });
                },
                child: SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          menuData.data!.providerSection!.title!,
                          style: _buttonTextStyle,
                        ),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          selectedProvider.name!,
                          textAlign: TextAlign.right,
                          style: _buttonTextStyle,
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            ),
          ),
          currentAction == ActionStates.networkSelection
              ? SizedBox(
                  height: 260,
                  width: double.infinity,
                  child: GridView.builder(
                      itemCount: menuData
                          .data!.providerSection!.serviceProviders!.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        var item = menuData
                            .data!.providerSection!.serviceProviders![index];
                        return SizedBox(
                          height: 80,
                          child: Material(
                            color: selectedProvider.id == item.id
                                ? Palette.primaryLight.shade300
                                : Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                onProviderSelected(item);
                              },
                              child: Align(
                                alignment: Alignment.center,
                                child: Center(
                                  child: SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: Image(
                                      image: AssetImage(
                                          'assets/icons/${item.icon!.defaultIconName!}.png'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }))
              : const SizedBox()
        ],
      ),
    );
  }

  Widget _amountSelectionButton() {
    var availableFixedAmounts =
        selectedProduct.preDefinedAmount!.fixedAmountItems!;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Amount',
                    style: _buttonTextStyle,
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    _getFormattedAmountFromCents(selectedAmountInCents),
                    textAlign: TextAlign.right,
                    style: _buttonTextStyle,
                  ),
                ))
              ],
            ),
          ),
          currentAction == ActionStates.amountSelection
              ? SingleChildScrollView(
                  child: SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: GridView.builder(
                          itemCount: availableFixedAmounts.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, childAspectRatio: 2),
                          itemBuilder: (context, index) {
                            var amt = availableFixedAmounts[index];
                            return SizedBox(
                              height: 30,
                              child: Material(
                                child: InkWell(
                                  onTap: () {
                                    onAmountSelected(
                                        amt.amountInCents!, amt.sku!);
                                  },
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Center(
                                      child: Text(
                                        _getFormattedAmountFromCents(
                                            availableFixedAmounts[index]
                                                .amountInCents!),
                                        style: _itemTextStyle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          })),
                )
              : const SizedBox(),
          _getCustomAmountButton()
        ],
      ),
    );
  }

  Widget _getCustomAmountButton() {
    switch (currentUseCase) {
      case PageStates.topup:
        return SizedBox(
          height: 60,
          child: Material(
            child: InkWell(
              child: Center(
                child: Text(
                  selectedProduct
                          .preDefinedAmount?.customAmountItem?.description ??
                      'Select Own Amount',
                  style: _itemTextStyle,
                ),
              ),
            ),
          ),
        );
      default:
        return Container();
    }
  }

  String _getFormattedAmountFromCents(int amountInCents) {
    if (amountInCents <= 0) {
      return '-';
    } else {
      return '${menuData.data!.menuInfo!.currency!.symbol}${(amountInCents / 1000).round().toString()}';
    }
  }

  Product _getProductOfferingForProvider(ServiceProvider provider) {
    Product providerOffering = Product();
    for (var product in menuData.data!.products!) {
      if (product.providerId! == provider.id) {
        providerOffering = product;
        print(
            'FOUND PRODUCT: ${json.encode(product.preDefinedAmount!.fixedAmountItems!)}');
        break;
      }
    }
    return providerOffering;
  }
}
