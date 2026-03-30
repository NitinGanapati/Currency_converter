import 'dart:async';

import 'package:currency_converter/components/Calculator.dart';
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

  var openB = 0;
  bool showCursor = true;
  final ScrollController _scrollController = ScrollController();

  late Timer _timer;
  var closeB = 0;
  int points = 0;
  late String finalValue;
  String expression = '';
  var no1Controller = TextEditingController();
  var no2Controller = TextEditingController();
  var resultController = TextEditingController();

  int precedence(String op) {
    if (op == "*" || op == "/") return 2;
    if (op == "+" || op == "-") return 1;
    return 0;
  }

  bool isOperators(String ch) {
    return ch == "+" || ch == "-" || ch == "*" || ch == "/";
  }

  String isOperatorsstr(String ch) {
    String a = "";
    if (ch == "*" || ch == "/") {
      a = ch;
    }
    return a;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        showCursor = !showCursor;
      });
    });
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
    var numArray = [
      "C",
      "(",
      ")",
      "CLR",
      7,
      8,
      9,
      "/",
      4,
      5,
      6,
      "*",
      1,
      2,
      3,
      "-",
      0,
      ".",
      "=",
      "+",
    ];

    return Container(
      height: 595,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          // TextField(
          //   controller: no2Controller,
          //   readOnly: true,
          //   textAlign: TextAlign.right,
          //   style: const TextStyle(
          //     fontSize: 20,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.white,
          //   ),
          //   decoration: const InputDecoration(
          //     border: InputBorder.none,
          //     contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          //   ),
          // ),
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
          SizedBox(height: 8),
          TextFormField(
            key: const Key('usd'),
            readOnly: true,
            controller: no2Controller,
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Enter your amount',
              hintStyle: TextStyle(color: Colors.grey),
            ),
            // keyboardType: TextInputType.number,
          ),
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
                      String cleanValue = no2Controller.text
                          .replaceAll(',', '')
                          .replaceAll('(', '');

                      print(cleanValue + "Hi");
                      double? parsedValue = double.tryParse(cleanValue);
                      if (parsedValue == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Press = first to evaluate the expression',
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      }
                      isCalculated = true;
                      divoperation =
                          widget.rates[dropdownToValue] /
                          widget.rates[dropdownValue];
                      result = parsedValue * divoperation;
                      print("Nitnaa {$result}");
                    });
                  },
                  child: Text("Convert"),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Container(
            child: Center(
              child: isCalculated
                  ? Text(
                      '${formatIndian(result)} ${dropdownToValue ?? ''}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : Text(
                      "0.0",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
          ),
          SizedBox(height: 50),
          Expanded(
            child: Container(
              color: Colors.transparent,
              child: Column(
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: TextField(
                        //     controller: no1Controller,
                        //     readOnly: true,
                        //     textAlign: TextAlign.right,
                        //     style: const TextStyle(
                        //       fontSize: 24,
                        //       fontWeight: FontWeight.bold,
                        //       color: Colors.white,
                        //     ),
                        //     decoration: const InputDecoration(
                        //       border: InputBorder.none,
                        //         contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        //     ),
                        //   )
                        //   ,
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(22.0),
                        //   // child: TextField(
                        //   //   controller: no2Controller,
                        //   //   readOnly: true,
                        //   //   maxLines: 1,
                        //   //   enableInteractiveSelection: true,
                        //   //   scrollPhysics: const BouncingScrollPhysics(),
                        //   //   scrollController: ScrollController(),
                        //   //   textAlign: TextAlign.right,
                        //   //   style: const TextStyle(
                        //   //     fontSize: 32,
                        //   //     fontWeight: FontWeight.bold,
                        //   //     color: Colors.white,
                        //   //   ),
                        //   //   decoration: const InputDecoration(
                        //   //     border: InputBorder.none,
                        //   //     contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        //   //   ),
                        //   // )
                        //   child: TextField(
                        //     controller: no2Controller,
                        //     readOnly: true,
                        //     textAlign: TextAlign.right,
                        //     style: const TextStyle(
                        //       fontSize: 40,
                        //       fontWeight: FontWeight.bold,
                        //       color: Colors.white,
                        //     ),
                        //     decoration: const InputDecoration(
                        //       border: InputBorder.none,
                        //       contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        //     ),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(22.0),
                        //   child: SingleChildScrollView(
                        //     controller: _scrollController,
                        //     scrollDirection: Axis.horizontal,
                        //     reverse: true,   // IMPORTANT
                        //     child: Text(
                        //       expression,
                        //       textAlign: TextAlign.right,
                        //       style: const TextStyle(
                        //         fontSize: 42,
                        //         fontWeight: FontWeight.bold,
                        //         color: Colors.white,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Expanded(
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: numArray.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  childAspectRatio: 1.2,
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 4,
                                ),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ClipOval(
                                  child: Material(
                                    color: Colors.blue,
                                    shape: const CircleBorder(),
                                    child: InkWell(
                                      splashColor: Colors.green,
                                      customBorder: CircleBorder(),
                                      onTap: () {
                                        // no2Controller.text = expression;
                                        // print(no2Controller.text);
                                        setState(() {
                                          // print(no2Controller.text);
                                          if (numArray[index] == 'C') {
                                            expression = '';
                                            isCalculated = false;
                                            no1Controller.clear();
                                            no2Controller.clear();
                                          } else if (numArray[index] == "CLR") {
                                            String currentText =
                                                no2Controller.text;
                                            // print(currentText);
                                            if (currentText.isNotEmpty) {
                                              currentText = currentText
                                                  .substring(
                                                    0,
                                                    currentText.length - 1,
                                                  );
                                            }

                                            expression = currentText.toString();

                                            no2Controller.text = expression;
                                          } else if (numArray[index] == '=') {
                                            // String m = Calculator.Calculation(expression);
                                            Calculator ca = Calculator();

                                            // if(closeB>openB){
                                            //   while(closeB>openB && expression.endsWith(")")){
                                            //     expression = expression.substring(0,expression.length-1);
                                            //     closeB--;
                                            //   }
                                            // }
                                            // print(openB);
                                            // print(closeB);

                                            while (openB > closeB) {
                                              expression += ")";
                                              closeB++;
                                            }

                                            holderClass hm = holderClass();
                                            List<String> ak = hm.splitter(
                                              expression,
                                            );
                                            var objak = ak.join(" ");
                                            print(objak);
                                            // var box = Hive.box('Nitin');
                                            // box.add({
                                            //   'value' : objak
                                            // });
                                            bool isDuplicate = true;
                                            // for (int i = 0; i < box.length; i++) {
                                            //   isDuplicate = true;
                                            //   var data = box.getAt(i);
                                            //   if(data['value']==objak){
                                            //     isDuplicate=false;
                                            //   }
                                            //
                                            //
                                            // }
                                            // if(isDuplicate){
                                            //   box.add({
                                            //     'value' : objak
                                            //   });
                                            // }

                                            String a = ca.Calculation(
                                              expression,
                                            );
                                            // print(a.toString());

                                            no1Controller.text = a.toString();

                                            finalValue = a
                                                .toString()
                                                .replaceAll(',', '')
                                                .replaceAll('(', '');



                                            if(finalValue.endsWith('.')){
                                              finalValue = finalValue.substring(0,finalValue.length-1);
                                            }



                                            // if(no2Controller.text[no2Controller.text.length-1]=='.'){
                                            //   finalValue = no2Controller.text.substring(0,no2Controller.text.length-2);
                                            //   // print(finalValue + "Hello");
                                            // }

                                            no2Controller.text = finalValue;

                                            expression = finalValue;



                                            print(expression + "Namaste neet");
                                            // box.put({
                                            //
                                            // })

                                            points = 0;
                                            openB = 0;
                                            closeB = 0;
                                          }
                                          // else if (numArray[index] == '+') {
                                          //   expression += '+';
                                          // }
                                          // else if (numArray[index] == '-') {
                                          //   expression += '-';
                                          // }
                                          // else if (numArray[index] == 'x') {
                                          //   expression += '*';
                                          // }
                                          // else if (numArray[index] == "/") {
                                          //   expression += '/';
                                          //   print(numArray[index].toString());
                                          // }
                                          else if (isOperators(
                                            numArray[index].toString(),
                                          )) {
                                            if (numArray[index] == '-' &&
                                                expression.isEmpty) {
                                              expression += numArray[index]
                                                  .toString();
                                              no2Controller.text = expression;
                                              return;
                                            }
                                            if (expression.isEmpty) {
                                              return;
                                            }
                                            String prevChar =
                                                expression[expression.length -
                                                    1];
                                            String currentChar = numArray[index]
                                                .toString();

                                            if (isOperators(currentChar) &&
                                                prevChar == "(") {
                                              return;
                                            }

                                            // print(prevChar);
                                            if (isOperators(prevChar) &&
                                                isOperators(currentChar) &&
                                                currentChar != '-') {
                                              return;
                                            }
                                            // if(isOperators(prevChar) && (prevChar!="*" && prevChar=="-" && prevChar=="+")){
                                            //   return;
                                            // }
                                            // if(isOperators(prevChar) && (prevChar!="*" && prevChar=="/" && currentChar=="/")){
                                            //   return;
                                            // }
                                            //
                                            // if(isOperators(prevChar) && (prevChar!="/" && prevChar=="*" && currentChar=="/")){
                                            //   return;
                                            // }
                                            // if(isOperators(prevChar) && (prevChar!="*" && prevChar=="/" && currentChar=="*")){
                                            //   return;
                                            // }
                                            expression += numArray[index]
                                                .toString();
                                            points = 0;
                                          } else if (numArray[index] == "(") {
                                            setState(() {
                                              openB++;
                                              expression += numArray[index]
                                                  .toString();
                                              // print(openB);
                                            });
                                            points = 0;

                                            // if(closeB>openB){
                                            //   return;
                                            // }
                                            //
                                            // // print(openB);
                                            // setState(() {
                                            //   openB++;
                                            //   closeB++;
                                            // });
                                            // print(openB);
                                          } else if (numArray[index] == ")") {
                                            if (closeB < openB) {
                                              setState(() {
                                                closeB++;
                                                expression += numArray[index]
                                                    .toString();
                                                // print(closeB);
                                              });
                                            } else {
                                              return;
                                            }
                                          } else if (numArray[index] == ".") {
                                            setState(() {
                                              if (expression.isEmpty) {
                                                expression += "0.";
                                                points = 1;
                                              }
                                              if (points == 0) {
                                                expression += ".";
                                                points++;
                                              }
                                              // }
                                              // else{
                                              //   return;
                                              // }
                                            });
                                          } else {
                                            expression += numArray[index]
                                                .toString();
                                          }
                                          // IndianDigit a = IndianDigit();
                                          // no2Controller.text = a.indianVal(expression);
                                          no2Controller.text = expression;
                                          // setState(() {
                                          //
                                          // });
                                        });
                                      },

                                      // else if(isOperators(numArray[index].toString())){
                                      //     String op = numArray[index].toString();
                                      //
                                      //     if(expression.isEmpty){
                                      //       return;
                                      //     }
                                      //
                                      //     String lastChar = expression[expression.length-1];
                                      //
                                      //     if(isOperators(lastChar)){
                                      //       return;
                                      //     }
                                      //
                                      // }
                                      child: Center(
                                        child: Text(
                                          numArray[index].toString(),
                                          style: const TextStyle(
                                            color: Colors.white, // IMPORTANT
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ElevatedButton(onPressed: ()  async{
                  //   Navigator.push(context,MaterialPageRoute(builder: (context)=>History()));
                  //
                  // }, child: Icon(Icons.add)),
                  // Expanded(
                  //   child: GridView.builder(
                  //       physics: const NeverScrollableScrollPhysics(),
                  //       itemCount: numArray.length,
                  //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //           crossAxisCount: 4,
                  //           childAspectRatio: 1.2,
                  //           crossAxisSpacing: 4,mainAxisSpacing: 4),
                  //       itemBuilder: (context,index){
                  //     return Padding(
                  //         padding: const EdgeInsets.all(4.0),
                  //         child:ClipOval(
                  //             child: Material(
                  //               color: Colors.blue,
                  //               shape: const CircleBorder(),
                  //               child: InkWell(
                  //                 splashColor: Colors.green,
                  //                 customBorder: CircleBorder(),
                  //                 onTap: (){
                  //                   // no2Controller.text = expression;
                  //                   // print(no2Controller.text);
                  //                   setState(() {
                  //                     // print(no2Controller.text);
                  //                     if (numArray[index] == 'C') {
                  //                       expression = '';
                  //                       no1Controller.clear();
                  //                       no2Controller.clear();
                  //                     }
                  //                     else if(numArray[index] == "CLR"){
                  //                       String currentText = no2Controller.text;
                  //                       // print(currentText);
                  //                       if(currentText.isNotEmpty){
                  //                         currentText=currentText.substring(0,currentText.length-1);
                  //                       }
                  //
                  //                       expression=currentText.toString();
                  //                       no2Controller.text = expression;
                  //
                  //                     }
                  //                     else if (numArray[index] == '=') {
                  //                       // String m = Calculator.Calculation(expression);
                  //                       Calculator ca = Calculator();
                  //
                  //                       // if(closeB>openB){
                  //                       //   while(closeB>openB && expression.endsWith(")")){
                  //                       //     expression = expression.substring(0,expression.length-1);
                  //                       //     closeB--;
                  //                       //   }
                  //                       // }
                  //                       // print(openB);
                  //                       // print(closeB);
                  //
                  //                       while(openB>closeB){
                  //                         expression+=")";
                  //                         closeB++;
                  //                       }
                  //
                  //                       holderClass hm = holderClass();
                  //                       List<String> ak = hm.splitter(expression);
                  //                       var objak = ak.join(" ");
                  //                       print(objak);
                  //                       // var box = Hive.box('Nitin');
                  //                       // box.add({
                  //                       //   'value' : objak
                  //                       // });
                  //                       bool isDuplicate = true;
                  //                       // for (int i = 0; i < box.length; i++) {
                  //                       //   isDuplicate = true;
                  //                       //   var data = box.getAt(i);
                  //                       //   if(data['value']==objak){
                  //                       //     isDuplicate=false;
                  //                       //   }
                  //                       //
                  //                       //
                  //                       // }
                  //                       // if(isDuplicate){
                  //                       //   box.add({
                  //                       //     'value' : objak
                  //                       //   });
                  //                       // }
                  //
                  //                       String a = ca.Calculation(expression);
                  //                       // print(a.toString());
                  //
                  //
                  //
                  //
                  //                       no1Controller.text = a.toString();
                  //                       // box.put({
                  //                       //
                  //                       // })
                  //
                  //                       points=0;
                  //                       openB=0;
                  //                       closeB=0;
                  //                     }
                  //                     // else if (numArray[index] == '+') {
                  //                     //   expression += '+';
                  //                     // }
                  //                     // else if (numArray[index] == '-') {
                  //                     //   expression += '-';
                  //                     // }
                  //                     // else if (numArray[index] == 'x') {
                  //                     //   expression += '*';
                  //                     // }
                  //                     // else if (numArray[index] == "/") {
                  //                     //   expression += '/';
                  //                     //   print(numArray[index].toString());
                  //                     // }
                  //                     else if(isOperators(numArray[index].toString())){
                  //                       if(numArray[index]=='-' && expression.isEmpty){
                  //                         expression+=numArray[index].toString();
                  //                         no2Controller.text = expression;
                  //                         return;
                  //                       }
                  //                       if(expression.isEmpty){
                  //                         return;
                  //                       }
                  //                       String prevChar = expression[expression.length-1];
                  //                       String currentChar = numArray[index].toString();
                  //
                  //                       if(isOperators(currentChar) && prevChar=="("){
                  //                         return;
                  //                       }
                  //
                  //
                  //                       // print(prevChar);
                  //                       if(isOperators(prevChar) && isOperators(currentChar) && currentChar!='-'){
                  //                         return;
                  //                       }
                  //                       // if(isOperators(prevChar) && (prevChar!="*" && prevChar=="-" && prevChar=="+")){
                  //                       //   return;
                  //                       // }
                  //                       // if(isOperators(prevChar) && (prevChar!="*" && prevChar=="/" && currentChar=="/")){
                  //                       //   return;
                  //                       // }
                  //                       //
                  //                       // if(isOperators(prevChar) && (prevChar!="/" && prevChar=="*" && currentChar=="/")){
                  //                       //   return;
                  //                       // }
                  //                       // if(isOperators(prevChar) && (prevChar!="*" && prevChar=="/" && currentChar=="*")){
                  //                       //   return;
                  //                       // }
                  //                       expression+=numArray[index].toString();
                  //                       points=0;
                  //                     }
                  //                     else if(numArray[index] =="(") {
                  //                       setState(() {
                  //                         openB++;
                  //                         expression += numArray[index].toString();
                  //                         // print(openB);
                  //                       });
                  //                       points=0;
                  //
                  //                       // if(closeB>openB){
                  //                       //   return;
                  //                       // }
                  //                       //
                  //                       // // print(openB);
                  //                       // setState(() {
                  //                       //   openB++;
                  //                       //   closeB++;
                  //                       // });
                  //                       // print(openB);
                  //
                  //                     }
                  //                     else if(numArray[index]==")"){
                  //                       if(closeB<openB){
                  //                         setState(() {
                  //                           closeB++;
                  //                           expression += numArray[index].toString();
                  //                           // print(closeB);
                  //                         });
                  //                       }
                  //                       else{
                  //                         return;
                  //                       }
                  //                     }
                  //                     else if(numArray[index]=="."){
                  //                       setState(() {
                  //
                  //                         if(expression.isEmpty){
                  //                           expression+="0.";
                  //                           points=1;
                  //                         }
                  //                         if(points==0) {
                  //                           expression += ".";
                  //                           points++;
                  //                         }
                  //                         // }
                  //                         // else{
                  //                         //   return;
                  //                         // }
                  //
                  //
                  //                       });
                  //
                  //                     }
                  //
                  //                     else{
                  //                       expression+=numArray[index].toString();
                  //                     }
                  //                     // IndianDigit a = IndianDigit();
                  //                     // no2Controller.text = a.indianVal(expression);
                  //                     no2Controller.text = expression;
                  //                     // setState(() {
                  //                     //
                  //                     // });
                  //                   }
                  //                   );}
                  //
                  //
                  //                 // else if(isOperators(numArray[index].toString())){
                  //                 //     String op = numArray[index].toString();
                  //                 //
                  //                 //     if(expression.isEmpty){
                  //                 //       return;
                  //                 //     }
                  //                 //
                  //                 //     String lastChar = expression[expression.length-1];
                  //                 //
                  //                 //     if(isOperators(lastChar)){
                  //                 //       return;
                  //                 //     }
                  //                 //
                  //                 // }
                  //                 ,
                  //                 child: Center(
                  //                   child: Text(
                  //                     numArray[index].toString(),
                  //                     style: const TextStyle(
                  //                       color: Colors.white,   // IMPORTANT
                  //                       fontSize: 24,
                  //                       fontWeight: FontWeight.bold,
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),)
                  //         )
                  //     );
                  //
                  //   }),
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatIndian(double value) {
    String numStr = value.toStringAsFixed(2);
    List<String> parts = numStr.split('.');
    String number = parts[0];
    String decimals = parts[1];

    bool isNegative = number.startsWith('-');
    if (isNegative) number = number.substring(1);

    String formatted = '';
    if (number.length > 3) {
      String last3 = number.substring(number.length - 3);
      String remaining = number.substring(0, number.length - 3);

      List<String> groups = [];
      int i = remaining.length;
      while (i > 0) {
        int start = (i - 2 < 0) ? 0 : i - 2;
        groups.insert(0, remaining.substring(start, i));
        i -= 2;
      }
      formatted = groups.join(',') + ',' + last3;
    } else {
      formatted = number;
    }

    if (isNegative) formatted = '-' + formatted;
    return formatted + '.' + decimals;
  }
}
