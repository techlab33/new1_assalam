import 'package:assalam/utils/constants/colors.dart';
import 'package:flutter/material.dart';


class ZakatCalculatorPage extends StatefulWidget {
  @override
  _ZakatCalculatorPageState createState() => _ZakatCalculatorPageState();
}

class _ZakatCalculatorPageState extends State<ZakatCalculatorPage> {
  TextEditingController cashController = TextEditingController();
  TextEditingController goldController = TextEditingController();
  TextEditingController silverController = TextEditingController();
  TextEditingController depositedController = TextEditingController();
  TextEditingController loansGivenController = TextEditingController();
  TextEditingController businessInvestmentsController = TextEditingController();
  TextEditingController sharesController = TextEditingController();
  TextEditingController savingCertificatesController = TextEditingController();
  TextEditingController pensionsController = TextEditingController();
  TextEditingController stockValueController = TextEditingController();
  TextEditingController borrowedMoneyController = TextEditingController();
  TextEditingController goodsOnCreditController = TextEditingController();
  TextEditingController wagesDueController = TextEditingController();
  TextEditingController taxesDueController = TextEditingController();
  TextEditingController rentDueController = TextEditingController();
  TextEditingController utilityBillsDueController = TextEditingController();

  double totalZakat = 0.0;

  void calculateZakat() {
    setState(() {
      double cash = double.tryParse(cashController.text) ?? 0.0;
      double gold = double.tryParse(goldController.text) ?? 0.0;
      double silver = double.tryParse(silverController.text) ?? 0.0;
      double deposited = double.tryParse(depositedController.text) ?? 0.0;
      double loansGiven = double.tryParse(loansGivenController.text) ?? 0.0;
      double businessInvestments = double.tryParse(businessInvestmentsController.text) ?? 0.0;
      double shares = double.tryParse(sharesController.text) ?? 0.0;
      double savingCertificates = double.tryParse(savingCertificatesController.text) ?? 0.0;
      double pensions = double.tryParse(pensionsController.text) ?? 0.0;
      double stockValue = double.tryParse(stockValueController.text) ?? 0.0;
      double borrowedMoney = double.tryParse(borrowedMoneyController.text) ?? 0.0;
      double goodsOnCredit = double.tryParse(goodsOnCreditController.text) ?? 0.0;
      double wagesDue = double.tryParse(wagesDueController.text) ?? 0.0;
      double taxesDue = double.tryParse(taxesDueController.text) ?? 0.0;
      double rentDue = double.tryParse(rentDueController.text) ?? 0.0;
      double utilityBillsDue = double.tryParse(utilityBillsDueController.text) ?? 0.0;

      totalZakat = cash * 0.025 + (gold >= 85 ? gold * 0.025 : 0) + (silver >= 595 ? silver * 0.025 : 0);
      totalZakat += deposited * 0.025;
      totalZakat += businessInvestments * 0.025;
      totalZakat += shares * 0.025;
      totalZakat += savingCertificates * 0.025;
      totalZakat += pensions * 0.025;
      totalZakat += stockValue * 0.025;
      totalZakat += taxesDue + rentDue + utilityBillsDue + wagesDue + goodsOnCredit + borrowedMoney;
      totalZakat -= loansGiven; // Deduct loans given from total Zakat
    });
  }

  Widget buildTextField(String labelText, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5)),borderSide: BorderSide(color: Color(
              0xF317B717),width: 1,strokeAlign: BorderSide.strokeAlignOutside)),
          labelText: labelText,
          hintText: labelText,
          hintStyle: TextStyle(fontSize: 12),
          labelStyle: TextStyle(fontSize: 12)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zakat Calculator',style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: TColors.primaryColor,
        actions: [
          TextButton(onPressed: () {
            cashController.clear();
            goldController.clear();
            silverController.clear();
            depositedController.clear();
            loansGivenController.clear();
            businessInvestmentsController.clear();
            sharesController.clear();
            savingCertificatesController.clear();
            pensionsController.clear();
            stockValueController.clear();
            borrowedMoneyController.clear();
            goodsOnCreditController.clear();
            wagesDueController.clear();
            taxesDueController.clear();
            rentDueController.clear();
            utilityBillsDueController.clear();
            totalZakat = 0;
          }, child: Text('Reset All', style: TextStyle(color: Colors.white),),),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 5.0),
              Row(
                children: [
                  Expanded(child: buildTextField('hand cash', cashController)),
                  SizedBox(width: 8.0),
                  Expanded(child: buildTextField('Gold(grams)', goldController)),
                  SizedBox(width: 8.0),
                  Expanded(child: buildTextField('Silver(grams)', silverController)),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(child: buildTextField('future deposited ', depositedController)),
                  SizedBox(width: 8.0),
                  Expanded(child: buildTextField('Loans given', loansGivenController)),
                  SizedBox(width: 8.0),
                  Expanded(child: buildTextField('Business investments', businessInvestmentsController)),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(child: buildTextField('Shares', sharesController)),
                  SizedBox(width: 8.0),
                  Expanded(child: buildTextField('Saving Certificates', savingCertificatesController)),
                  SizedBox(width: 8.0),
                  Expanded(child: buildTextField('Pensions funded by money in possession', pensionsController)),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(child: buildTextField('stock Value', stockValueController)),
                  SizedBox(width: 8.0),
                  Expanded(child: buildTextField('Borrowed money', borrowedMoneyController)),
                  SizedBox(width: 8.0),
                  Expanded(child: buildTextField('Goods bought on credit', goodsOnCreditController)),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(child: buildTextField('Wages due to employees', wagesDueController)),
                  SizedBox(width: 8.0),
                  Expanded(child: buildTextField('Taxes due', taxesDueController)),
                  SizedBox(width: 8.0),
                  Expanded(child: buildTextField('Rent due', rentDueController)),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(child: buildTextField('Utility bills due immediately', utilityBillsDueController)),
                ],
              ),
              SizedBox(height: 30.0),
              InkWell(
                onTap: calculateZakat,
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: TColors.primaryColor,
                  ),
                  child: Text('Calculate Zakat', style: TextStyle(color: Colors.white, fontSize: 16),),
                ),
              ),

              SizedBox(height: 30.0),
              Text('Total Zakat: $totalZakat',style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: TColors.primaryColor),),
            ],
          ),
        ),
      ),
    );
  }
}