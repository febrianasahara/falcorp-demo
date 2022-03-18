// ignore_for_file: unnecessary_const, prefer_const_literals_to_create_immutables, non_constant_identifier_names, use_key_in_widget_constructors

import 'dart:convert';

import 'package:airtime_purchase_app/models/data/service_provider.dart';
import 'package:airtime_purchase_app/models/menu_response.dart';
import 'package:airtime_purchase_app/models/purchase/custom_amount_item.dart';
import 'package:airtime_purchase_app/models/purchase/fixed_amount_item.dart';
import 'package:airtime_purchase_app/models/purchase/product.dart';
import 'package:airtime_purchase_app/models/purchase/purchase_types.dart';
import 'package:airtime_purchase_app/models/ui/available-done-actions.dart';
import 'package:airtime_purchase_app/models/ui/available_input_fields.dart';
import 'package:airtime_purchase_app/theme/palette.dart';
import 'package:airtime_purchase_app/views/pin-utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

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
  final TextStyle _titleTextStyle = const TextStyle(
      color: Colors.white70, fontSize: 22, fontWeight: FontWeight.w700);

  final TextStyle _itemTextStyle = const TextStyle(
      color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600);
  final TextStyle _buttonTextStyle = const TextStyle(
      color: Colors.black38, fontSize: 16, fontWeight: FontWeight.w500);
  final TextEditingController _customAountController = TextEditingController();
  final TextEditingController _msidnController = TextEditingController();
  late FocusNode amountFocusNode;
  late FocusNode phoneFocusNode;

  bool busy = false;
  bool showDetail = true;

  // state variabls
  ActionStates currentAction = ActionStates.typeSelection;
  late PageStates currentUseCase = PageStates.voucher;
  bool typeSelected = false;
  bool networkSelected = false;
  bool amountSelected = false;
  bool addedToQuickSell = false;

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
  double balance = 3012.29;
  late String _generatedAirtimePIN;
  final PinUtility pinGenerator = new PinUtility();
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
    int type = 1;
    if (currentUseCase == PageStates.topup) {
      type = 2;
    }
    for (var prod in menuData.data!.products!) {
      if (prod.providerId == selectedProvider.id &&
          prod.purchaseTypeId == type) {
        selectedProduct = prod;
        break;
      }
    }
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

  onPhoneNumberSubmitted(String phone) {
    setState(() {
      currentAction = ActionStates.purchaseSummary;
    });
  }

  _showCustomAmountSheet(String title) {
    amountFocusNode.requestFocus();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black87,
          alignment: Alignment.center,
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  AppBar(
                    centerTitle: false,
                    title: Text(
                      title,
                      style: _titleTextStyle,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: TextFormField(
                        controller: _customAountController,
                        cursorColor: Colors.grey.shade200,
                        focusNode: amountFocusNode,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                        keyboardType: TextInputType.number,
                        onSaved: (v) {
                          onAmountSelected(
                              int.parse(v!) * 1000, topupCustomAmount.sku!);
                          Navigator.of(context).pop();
                        },
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                            hintStyle: TextStyle(
                                color: Colors.white54,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                            hintText: "R0"),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            onAmountSelected(
                                int.parse(_customAountController.text) * 1000,
                                topupCustomAmount.sku!);
                            Navigator.of(context).pop();
                          },
                          child: Text('SUBMIT'),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  _showPhoneNumberSheet() {
    phoneFocusNode.requestFocus();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black87,
          alignment: Alignment.center,
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  AppBar(
                    centerTitle: false,
                    title: Text(
                      'Enter Cellphone Number',
                      style: _titleTextStyle,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: TextFormField(
                        controller: _msidnController,
                        cursorColor: Colors.grey.shade200,
                        focusNode: phoneFocusNode,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                        keyboardType: TextInputType.number,
                        onSaved: (v) {
                          try {
                            onPhoneNumberSubmitted(v!);
                          } catch (e) {
                            if (kDebugMode) {
                              print(e.toString());
                            }
                          }
                        },
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                            hintStyle: TextStyle(
                                color: Colors.white54,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                            hintText: "0656897833"),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            onPhoneNumberSubmitted(_msidnController.text);
                            Navigator.of(context).pop();
                          },
                          child: Text('SUBMIT'),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  _onSaleComplete() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return _saleCompleteView();
      },
    );
  }

  @override
  void initState() {
    menuData = widget.data;
    amountFocusNode = FocusNode();
    phoneFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: const Color(0xff1fc65a),
        centerTitle: true,
        title: Text(
          menuData.data!.menuInfo!.name!,
          style: _titleTextStyle,
        ),
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                '${menuData.data!.menuInfo!.currency!.symbol!}${balance.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white70),
              ),
            ),
          ),
        ],
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
          _content(),
          _actionButton()
        ],
      ),
    );
  }

  //main views
  Widget _content() {
    if (currentAction == ActionStates.purchaseSummary) {
      return _summaryView();
    } else {
      return _actionView();
    }
  }

  Widget _actionView() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _purchaseTypeButton(menuData.data!.purchaseTypeSection!.purchaseTypes!),
        typeSelected ? _networkTypeButton() : const SizedBox(),
        networkSelected ? _amountSelectionButton() : const SizedBox(),
        (amountSelected && currentUseCase == PageStates.topup)
            ? _msisdnButton()
            : const SizedBox(),
      ],
    );
  }

  Widget _summaryView() {
    var size = MediaQuery.of(context).size;
    final double itemWidth = size.width / 2;

    return ClipPath(
        clipper: MovieTicketClipper(),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  height: 60,
                  child: Center(
                    child: Text(
                      'SUMMARY',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w900),
                    ),
                  )),
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
              ),
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
              currentUseCase == PageStates.topup
                  ? SizedBox(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              selectedProduct.purchaseTypeId == 2
                                  ? _getInputFieldForAction(selectedProduct
                                          .extraFields!.first.inputFieldId!)
                                      .name!
                                  : '',
                              style: _buttonTextStyle,
                            ),
                          )),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              _msidnController.text,
                              textAlign: TextAlign.right,
                              style: _buttonTextStyle,
                            ),
                          ))
                        ],
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 32,
              )
            ],
          ),
        ));
  }

  // widget elements
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
          currentAction == ActionStates.amountSelection
              ? _getCustomAmountButton()
              : Container()
        ],
      ),
    );
  }

  Widget _msisdnButton() {
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
                  _showPhoneNumberSheet();
                },
                child: SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          selectedProduct.purchaseTypeId == 2
                              ? _getInputFieldForAction(selectedProduct
                                      .extraFields!.first.inputFieldId!)
                                  .name!
                              : '',
                          style: _buttonTextStyle,
                        ),
                      )),
                      const Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.chevron_right),
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            ),
          ),
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
              onTap: () {
                _showCustomAmountSheet(selectedProduct
                        .preDefinedAmount?.customAmountItem?.description ??
                    'Select Own Amount');
              },
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

  Widget _actionButton() {
    AvailableDoneActions action =
        _getDoneAction(selectedAction.doneActionId ?? 1);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: 70,
          child: AnimatedOpacity(
              opacity:
                  currentAction == ActionStates.purchaseSummary ? 1.0 : 0.2,
              duration: const Duration(milliseconds: 500),
              child: Material(
                color: Colors.black,
                child: InkWell(
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          action.name!,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: SizedBox(
                            height: 25,
                            width: 25,
                            child: Image.asset(
                                'assets/icons/double-chevron.png',
                                height: 25,
                                width: 25),
                          ),
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    if (currentAction == ActionStates.purchaseSummary) {
                      // click enabled - call API
                      _onSaleComplete();
                    }
                  },
                ),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              )),
        ),
      ),
    );
  }

  Widget _saleCompleteView() {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      color: const Color(0xff88d000),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Divider(
                  height: 60,
                ),
                Card(
                  child: SizedBox(
                      height: 60,
                      child: Center(
                        child: Text(
                          _getDoneAction(selectedAction.id!)
                              .completeScreenTitle!,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w900),
                        ),
                      )),
                ),
                Card(
                    child: Column(
                  children: [
                    // get payment result ui
                    ExpansionPanelList(
                      animationDuration: Duration(milliseconds: 1000),
                      children: [_purchaseResult()],
                      expansionCallback: (panelIndex, isExpanded) {
                        
                        setState(() {
                          showDetail = isExpanded;
                        });
                      },
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey.shade200,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'Your Sale',
                              style: _buttonTextStyle,
                            ),
                          )),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              '${selectedProvider.name!} ${selectedAction.name!}',
                              textAlign: TextAlign.right,
                              style: _buttonTextStyle,
                            ),
                          ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'Total',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          )),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              _getFormattedAmountFromCents(
                                  selectedAmountInCents),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                )),
                Card(
                  child: Column(
                    children: [
                      Divider(
                        height: 1,
                        color: Colors.grey.shade600,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.receipt,
                          size: 25,
                          color: Colors.black87,
                        ),
                        title: Text(
                          'ADD TO QUICK SELL',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        trailing: SizedBox(
                          height: 50,
                          width: 50,
                          child: CupertinoSwitch(
                            value: addedToQuickSell,
                            onChanged: (v) {},
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Card(
                  child: ListTile(
                    onTap: () {
                      resetUI();
                      Navigator.of(context).pop();
                    },
                    leading: Icon(
                      Icons.repeat,
                      size: 25,
                      color: Colors.black87,
                    ),
                    title: Text(
                      'SELL AGAIN',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    trailing: SizedBox(
                      height: 50,
                      width: 50,
                      child: Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.print,
                      size: 25,
                      color: Colors.black87,
                    ),
                    title: Text(
                      'REPRINT',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    trailing: SizedBox(
                      height: 50,
                      width: 50,
                      child: Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.share,
                      size: 25,
                      color: Colors.black87,
                    ),
                    title: Text(
                      'SHARE',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    trailing: SizedBox(
                      height: 50,
                      width: 50,
                      child: Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 30, top: 60),
              child: SizedBox(
                height: 50,
                width: 50,
                child: Material(
                  color: Colors.black,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  child: InkWell(
                      onTap: () {
                        resetUI();
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.close_fullscreen,
                        color: Colors.white,
                      )),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  ExpansionPanel _purchaseResult() {
    if (currentUseCase == PageStates.topup) {
      showDetail = false;
      return ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Cellphone Number',
                      style: _buttonTextStyle,
                    ),
                  )),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      _msidnController.text,
                      textAlign: TextAlign.right,
                      style: _buttonTextStyle,
                    ),
                  ))
                ],
              ),
            );
          },
          body: ListTile(
            title:
                Text('Add to Contacts', style: TextStyle(color: Colors.white)),
            tileColor: Colors.green,
          ),
          isExpanded: false,
          canTapOnHeader: false,
          backgroundColor: Colors.white);
    }
 
    showDetail = true;
 
    return ExpansionPanel(
        headerBuilder: (context, isExpanded) {
          return SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'PIN',
                    style: _buttonTextStyle,
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    pinGenerator.getRandomPIN(),
                    textAlign: TextAlign.right,
                    style: _buttonTextStyle,
                  ),
                ))
              ],
            ),
          );
        },
        body: Container(height: 100,child:ListTile(
          title: Text('Some test', style: TextStyle(color: Colors.white)),
          tileColor: Colors.white,
        )),
        isExpanded: showDetail,
        canTapOnHeader: true,
        
        backgroundColor: Colors.white);
  }

  // utility fuctions
  String _getFormattedAmountFromCents(int amountInCents) {
    if (amountInCents <= 0) {
      return '-';
    } else {
      return '${menuData.data!.menuInfo!.currency!.symbol}${(amountInCents / 1000).round().toString()}';
    }
  }

  Product _getProductOfferingForProvider(ServiceProvider provider) {
    Product providerOffering = Product();
    if (currentAction == PageStates.topup) {
      for (var product in menuData.data!.products!) {
        if (product.providerId! == provider.id && product.purchaseTypeId == 2) {
          providerOffering = product;
          print(
              'FOUND PRODUCT: ${json.encode(product.preDefinedAmount!.fixedAmountItems!)}');
          break;
        }
      }
    } else {
      for (var product in menuData.data!.products!) {
        if (product.providerId! == provider.id && product.purchaseTypeId == 1) {
          providerOffering = product;
          print(
              'FOUND PRODUCT: ${json.encode(product.preDefinedAmount!.fixedAmountItems!)}');
          break;
        }
      }
    }
    return providerOffering;
  }

  AvailableInputFields _getInputFieldForAction(int i) {
    var fields = menuData.data!.availableInputFields!;
    var selectedField = fields[0];
    for (var f in fields) {
      if (f.id == i) {
        selectedField = f;
        break;
      }
    }
    return selectedField;
  }

  AvailableDoneActions _getDoneAction(int i) {
    var actions = menuData.data!.availableDoneActions!;
    var selectedAction = actions[0];
    for (var f in actions) {
      if (f.id == i) {
        selectedAction = f;
        break;
      }
    }
    return selectedAction;
  }

  resetUI() {
    setState(() {
      currentAction = ActionStates.typeSelection;
      currentUseCase = PageStates.voucher;
      typeSelected = false;
      networkSelected = false;
      amountSelected = false;
      selectedAmount = FixedAmountItem(amountInCents: 0);
      selectedCustomAmount =
          CustomAmountItem(maxAmountInCents: 0, minAmountInCents: 0);
      selectedAction = PurchaseType(name: '-');
      selectedProvider = ServiceProvider(name: '-');
      topupCustomAmount;
      selectedProduct;
      selectedAmountInCents = 0;
      selectedProductSKU = -1;
    });
  }
}
