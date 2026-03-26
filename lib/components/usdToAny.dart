import 'package:flutter/material.dart';

class usdToAny extends StatefulWidget {
  final rates;
  final Map currencies;
  const usdToAny({super.key, required this.rates, required this.currencies});

  @override
  State<usdToAny> createState() => _usdToAnyState();


}

class _usdToAnyState extends State<usdToAny> {



  TextEditingController usdController = TextEditingController();
  String? dropdownValue = 'USD';
  String? dropdownToValue = 'INR';
  double result = 0.0;
  double divoperation = 0.0;

  bool isCalculated = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        dropdownValue = widget.currencies.keys.first;
        dropdownToValue = widget.currencies.keys.last;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return Card(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              child: const Text(
                'Currency Converter for You',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              key: const Key('usd'),
              controller: usdController,
              cursorColor: Colors.white,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Enter USD',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    menuMaxHeight: 500,
                    dropdownColor: Colors.grey.shade900,
                    value: dropdownValue,
                    style: const TextStyle(color: Colors.white),
                    icon: const Icon(
                      Icons.arrow_drop_down_rounded,
                      color: Colors.white,
                    ),
                    iconSize: 24,
                    elevation: 16,
                    isExpanded: true,
                    items: widget.currencies.keys
                        .toList()
                        .cast<String>()
                        .toSet()
                        .map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        })
                        .toList(),

                    onChanged: (String? value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: DropdownButton<String>(
                    menuMaxHeight: 500,
                    dropdownColor: Colors.grey.shade900,
                    value: dropdownToValue,
                    style: const TextStyle(color: Colors.white),
                    icon: const Icon(
                      Icons.arrow_drop_down_rounded,
                      color: Colors.white,
                    ),
                    iconSize: 24,
                    elevation: 16,
                    isExpanded: true,
                    items: widget.currencies.keys
                        .toList()
                        .cast<String>()
                        .toSet()
                        .map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        })
                        .toList(),

                    onChanged: (String? value) {
                      setState(() {
                        dropdownToValue = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isCalculated = true;
                        divoperation =
                            widget.rates[dropdownToValue] /
                            widget.rates[dropdownValue];
                        // result = double.parse(widget.) * widget.rates[dropdownToValue];
                        result =
                            double.parse(usdController.text) * divoperation;
                        print("Nitnaa {$result}");
                      });
                    },
                    child: Text("Convert"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 35),
            Container(
              child: Center(
                child: isCalculated ?
                    Text(
                      '${result.toStringAsFixed(2)} ${dropdownToValue ?? ''}',
                      style: TextStyle(color: Colors.white),

                    ) :
                Text(
                  "0.0",
                  style: TextStyle(color: Colors.white),



              ),
            ),
            )
          ],
        ),
      ),
    );
  }
}
