import 'package:currency_converter/functions/fetchrates.dart';
import 'package:flutter/material.dart';

import '../models/ratesModelFromJson.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  

  
  @override
  State<Home> createState() => _HomeState();


}

class _HomeState extends State<Home> {


  late Future<RatesModel> result;

  @override
  void initState() {
    result = fetchRates();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    var h= MediaQuery.of(context).size.height;
    var w= MediaQuery.of(context).size.width;


    late Future<Map> allCurrency;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: const Text("Currency Converter",style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),

      body: Container(
        height: h,
        width: w,
        padding: EdgeInsets.only(top: 65,left: 15,right: 15),
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/backgroundpic.jpg'),
            fit: BoxFit.cover
          )
        ),
        child:
          SingleChildScrollView(
            child: Form(
              key: _formKey, child: FutureBuilder<RatesModel>(
              future: result,
              builder: (context,snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if(!snapshot.hasData){
                  return const Text("No Data present");
                }
                return Center(
                  child: Text(snapshot.data!.rates.toString(),style: TextStyle(fontSize: 20,color: Colors.white),)
                );
              },
            ),
            ),
          )
      ),
    );
  }
}
