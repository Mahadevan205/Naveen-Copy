import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'new.dart';

void main(){
  runApp(MaterialApp(
    home: OverHeads(title: ''),
  )
      );
}

class OverHeads extends StatefulWidget {
  final String title;
  const OverHeads({super.key, required this.title});

  @override
  State<OverHeads> createState() => _OverHeadsState();
}

class _OverHeadsState extends State<OverHeads> {
  bool _isTypeFocused =false;
  bool _invalidStatusType =false;
  String scopeOfWork="CEO Approval";
  List<String> scopeType=[
    "scope1",
    "scope2",
    "scope3",
  ];
  // List to store the input field values
  List<TextEditingController> controllers1 = [];

  //Second Table Declarations.
  List siteStaff=[];
  List overHeads=[];


  //Second Table Declarations.
  var titleControllers= <TextEditingController>[];
  var gradeController =<TextEditingController>[];
  var salaryControllers =<TextEditingController>[];
  var incrementControllers=<TextEditingController>[];
  var startDateControllers=<TextEditingController>[];
  var endDateControllers=<TextEditingController>[];
  var daysControllers=<TextEditingController>[];
  var amountControllers=<TextEditingController>[];
  var totalAmountController= TextEditingController();

  //Third Table Declarations.
  var annualBenefits = <TextEditingController>[];
  var amountOverheads= <TextEditingController>[];
  var totalAmountsOverheads = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with one pair of input fields.
    controllers1.add(TextEditingController());

    //---------Second Table Declarations.
    titleControllers.add(TextEditingController());
    gradeController.add(TextEditingController());
    salaryControllers.add(TextEditingController());
    incrementControllers.add(TextEditingController());
    startDateControllers.add(TextEditingController());
    endDateControllers.add(TextEditingController());
    daysControllers.add(TextEditingController());
    amountControllers.add(TextEditingController());
    siteStaff.add("${siteStaff.length + 1}");

    //-------Third Table Declarations.
    annualBenefits.add(TextEditingController());
    amountOverheads.add(TextEditingController());
    overHeads.add("${overHeads.length + 1}");

  }
  @override
  void dispose() {
    // Dispose all controllers when the widget is disposed
    for (var controller in controllers1) {
      controller.dispose();
    }

    super.dispose();
  }

  // Function to add a new pair of input fields
  void _addNewField() {
    setState(() {
      controllers1.add(TextEditingController());
    });
  }

  ///Number Suffix.
  String _getNumberSuffix(int number) {
    if (number >= 11 && number <= 13) {
      return "th";
    } else {
      switch (number % 10) {
        case 1:
          return "st";
        case 2:
          return "nd";
        case 3:
          return "rd";
        default:
          return "th";
      }
    }
  }

  ///Checking Financial Year.
  FinancialYearSpan checkFinancialYearSpan(String startDateStr, String endDateStr) {
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    DateTime startDate = dateFormat.parse(startDateStr);
    DateTime endDate = dateFormat.parse(endDateStr);

    DateTime getFinancialYearStart(DateTime date) {
      int year = (date.month >= 4) ? date.year : date.year - 1;
      return DateTime(year, 4, 1);
    }

    DateTime getFinancialYearEnd(DateTime date) {
      int year = (date.month >= 4) ? date.year + 1 : date.year;
      return DateTime(year, 3, 31);
    }

    DateTime startFinancialYearStart = getFinancialYearStart(startDate);
    DateTime startFinancialYearEnd = getFinancialYearEnd(startDate);

    DateTime endFinancialYearStart = getFinancialYearStart(endDate);
    DateTime endFinancialYearEnd = getFinancialYearEnd(endDate);

    if (startDate.isAfter(endFinancialYearEnd) || endDate.isBefore(startFinancialYearStart)) {
      // This condition is theoretically not possible since end date should be after start date
      throw ArgumentError('End date must be after start date');
    }

    if (startFinancialYearStart == endFinancialYearStart) {
      return FinancialYearSpan.oneFinancialYear;
    } else if ((startFinancialYearStart.isBefore(endDate) && endDate.isBefore(startFinancialYearEnd.add(Duration(days: 1)))) ||
        (endFinancialYearStart.isBefore(endDate) && endDate.isBefore(endFinancialYearEnd.add(Duration(days: 1))))) {
      return FinancialYearSpan.twoFinancialYears;
    } else {
      return FinancialYearSpan.moreThanTwoFinancialYears;
    }
  }
  late FinancialYearSpan result;

  /// Function to calculate financial year start and end based on a given date
  List<DateTime> calculateFinancialYear(DateTime date) {
    if (date.month >= 4) {
      return [DateTime(date.year, 4, 1), DateTime(date.year + 1, 3, 31)];
    } else {
      return [DateTime(date.year - 1, 4, 1), DateTime(date.year, 3, 31)];
    }
  }

  void _removeField(int index) {
    setState(() {
      // Dispose of the controller to avoid memory leaks
      controllers1[index].dispose();
      // Remove the controller from the list
      controllers1.removeAt(index);
    });
  }

  caluculation(){
    double tempTotal = 0.0;
    for (var controller in amountOverheads) {
      if (controller.text.isNotEmpty) {
        try {
          //Increment Operator.
          tempTotal += double.parse(controller.text);
        } catch (e) {
          // Handle parsing error if needed.
          print('-------Exception-----');
          print(e);
        }
      }
    }
    setState(() {
      totalAmountsOverheads.text = tempTotal.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.grey,
          title: Center(child: Text(widget.title,
            style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),))),

      body: SingleChildScrollView(
          child:Padding(padding: const EdgeInsets.all(40),
            child:Column(children: [
              ///First Card.
              Card(
                surfaceTintColor:const Color(0XFFFDFAFD),
                child:Column(children: [
                  //Header Container.
                  Container(height: 35,
                    color: Colors.blue,
                    child: const Center(child: Padding(
                      padding: EdgeInsets.only(left: 50.0,top: 10),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('Pitch',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                    )),

                  ),

                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: 30,),
                        //Dynamic Field.
                        Expanded(flex: 3,
                          child: Wrap(
                            direction: Axis.horizontal,
                            spacing: 16.0, // Spacing between items horizontally
                            runSpacing: 16.0, // Spacing between items vertically
                            children: List.generate(
                              controllers1.length, (index) {
                              String suffix = _getNumberSuffix(index + 1);
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    children: [
                                      Text("${index + 1}$suffix", style: textFieldStyle,),
                                      const SizedBox(width: 5,),
                                      InkWell(
                                          onTap: (){
                                            _removeField(index);
                                          },
                                          child: const Icon(Icons.remove_circle,size: 17,color: Colors.red,))
                                    ],
                                  ),
                                  const SizedBox(height: 9,),
                                  SizedBox(
                                    width: 100,
                                    height: 35,
                                    child: TextFormField(
                                      controller: controllers1[index],
                                      decoration: textFieldDecoration(hintText: '${index + 1}'),
                                    ),
                                  ),
                                ],
                              );
                            },
                            ),
                          ),
                        ),

                        //Button.
                        MaterialButton(
                          color: Colors.blue,
                          onPressed: (){
                            _addNewField();
                            for(int i=0;i<controllers1.length;i++){
                              print('----values-----');
                              print(controllers1[i].text);
                            }
                          },child: const Row(children: [
                          Icon(Icons.add_circle_outlined,size: 14,color: Colors.white,),
                          SizedBox(width: 5,),
                          Text("Pitch",style: TextStyle(color: Colors.white),)
                        ]),)

                      ],),
                  ),
                ]) ,),
              const SizedBox(height: 50,),
              ///Second Card.
              Card(
                surfaceTintColor:const Color(0XFFFDFAFD),
                child: Column(children: [
                  //Header Container.
                  Container(height: 35,
                    color: Colors.blue,
                    child: const Center(child: Padding(
                      padding: EdgeInsets.only(left: 50.0,top: 10),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('Site Staff',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                    )),
                  ),
                  const SizedBox(height: 10,),
                  //Table Header.
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      height: 34,
                      child:   Row(
                        children:  [
                          Expanded(child: Center(child: Text('SN',style: textFieldStyle,))),
                          Expanded(flex: 2,child: Center(child: Text("Title",style: textFieldStyle))),
                          const SizedBox(width: 30,),
                          Expanded(child: Center(child: Text("Grade",style: textFieldStyle))),
                          const SizedBox(width: 30,),
                          Expanded(child: Center(child: Text("Salary",style: textFieldStyle))),
                          const SizedBox(width: 30,),
                          Expanded(child: Center(child: Text("Increment %",style: textFieldStyle))),
                          const SizedBox(width: 30,),
                          Expanded(child: Center(child: Text("Start Date",style: textFieldStyle))),
                          const SizedBox(width: 30,),
                          Expanded(child: Center(child: Text("End Date",style: textFieldStyle))),
                          const SizedBox(width: 30,),
                          Expanded(child: Center(child: Text("Days",style: textFieldStyle))),
                          const SizedBox(width: 30,),
                          Expanded(child: Center(child: Text("Amount",style: textFieldStyle))),
                          const SizedBox(width: 30,),
                        ],
                      ),
                    ),
                  ),
                  //Dynamic Table.
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: siteStaff.length,
                    itemBuilder: (context, index) {
                      //double totalAmount = 0.0;
                      try{
                        if(index==0){
                          //print('--------amountControllers--------');
                          // print(amountControllers[index].text);
                          // // double amount = double.parse(amountControllers[index].text);
                          // // //totalAmount += amount;
                          // // totalAmountController.text = amount.toString();
                          // // print('--------Check this------');
                          // // print(totalAmountController.text);
                          //
                        }else {
                          // double amount = double.parse(amountControllers[index].text);
                          // totalAmount += amount;
                          // totalAmountController.text = totalAmount.toString();

                        }
                      }
                      catch(e){
                        print('-------Exception------');
                        print(e);
                      }
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10,right: 10),
                            child: SizedBox(
                              height: 50,
                              child: Row(
                                children:  [

                                  Expanded(child: Center(child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration:BoxDecoration(border: Border.all(color: Colors.grey,),
                                          borderRadius: BorderRadius.circular(5)) ,
                                      child: Center(child: Text('${index+1}'))),)),

                                  Expanded(flex: 2,child: Center(child:TextFormField(
                                    controller:titleControllers[index],
                                    decoration: textFieldDecoration(hintText:"Project Manager - PEB Specialist"),),)),
                                  const SizedBox(width: 30,),
                                  Expanded(child: Center(child:TextFormField(
                                    controller:gradeController[index],
                                    decoration: textFieldDecoration(hintText:"Sr Project Manager"),),)),
                                  const SizedBox(width: 30,),
                                  Expanded(child: Center(child:TextFormField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                                    ],
                                    //keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    controller:salaryControllers[index],
                                    decoration: textFieldDecoration(hintText:""),),)),
                                  const SizedBox(width: 30,),
                                  Expanded(child: Center(child:TextFormField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                                    ],
                                    onChanged: (val){
                                      double tempValue=0.0;
                                      setState(() {

                                      });
                                      if(val.isNotEmpty || val!=""){
                                        try{
                                          tempValue=double.parse(val.toString());
                                          if(tempValue>100){
                                            incrementControllers[index].clear();
                                          }
                                          else{
                                            print('------text----');
                                            print(salaryControllers[index].text);
                                            print(incrementControllers[index].text);
                                          }
                                        }
                                        catch(e){
                                          incrementControllers[index].clear();
                                        }
                                      }
                                    },
                                    controller:incrementControllers[index],
                                    decoration: textFieldDecoration(hintText:"%"),),)),
                                  const SizedBox(width: 30,),
                                  Expanded(child: Center(child:TextFormField(
                                    onTap: ()async{
                                      DateTime ? pickedDate= await showDatePicker(context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1990),
                                          lastDate: DateTime.now()
                                      );
                                      if(pickedDate!=null){
                                        String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                                        startDateControllers[index].text=formattedDate;
                                      }
                                      else{
                                        log("Start Date Not Selected");
                                      }
                                    },
                                    controller:startDateControllers[index],
                                    decoration: textFieldDecoration(hintText:""),),)),
                                  const SizedBox(width: 30,),

                                  ///old
                                  Expanded(child: Center(child:TextFormField(
                                    onTap: ()async{
                                      double tempTotal=0.0;
                                      String formattedEndDate;
                                      DateTime? pickedDate = await showDatePicker(context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1999),
                                          lastDate: DateTime.now());
                                      if(pickedDate!=null){
                                        formattedEndDate=DateFormat('dd-MM-yyyy').format(pickedDate);
                                        endDateControllers[index].text=formattedEndDate;
                                      }
                                      else{
                                        log("End Date Not Picked");
                                      }
                                      if(startDateControllers[index].text.isNotEmpty && endDateControllers[index].text.isNotEmpty){
                                        DateFormat  dateFormat = DateFormat('dd-MM-yyyy');
                                        DateTime startDate= dateFormat.parse(startDateControllers[index].text);
                                        DateTime endDate = dateFormat.parse(endDateControllers[index].text);
                                        daysControllers[index].text= endDate.difference(startDate).inDays.toString();

                                        /// Storing in result Checking Financial Year Or Not.
                                        result =  checkFinancialYearSpan(startDateControllers[index].text, endDateControllers[index].text);

                                        ///Switch Case.
                                        switch (result) {
                                          case FinancialYearSpan.oneFinancialYear:{

                                            amountControllers[index].text= ((double.parse(salaryControllers[index].text.toString())/365)*(double.parse(daysControllers[index].text))).toStringAsFixed(2);
                                            tempTotal += double.parse(amountControllers[index].text);
                                            //Total amount controller.
                                            double currentTotal = double.tryParse(totalAmountController.text) ?? 0.0;
                                            currentTotal += tempTotal;
                                            totalAmountController.text = currentTotal.toStringAsFixed(2);
                                          }

                                          break;
                                          case FinancialYearSpan.twoFinancialYears:{
                                            double salary=double.parse(salaryControllers[index].text.toString());
                                            double incrementPercentage=double.parse(incrementControllers[index].text.toString());
                                            double days=double.parse(daysControllers[index].text.toString());
                                            double amountWithinFY1=0.0;
                                            double amountWithinFY2=0.0;
                                            double totalAmountFY1AndFY2=0.0;

                                            // Calculate financial years for the start and end dates
                                            List<DateTime> fy1 = calculateFinancialYear(startDate);
                                            List<DateTime> fy2 = calculateFinancialYear(endDate);

                                            // Initialize counters
                                            int monthsBeforeFY1 = 0;
                                            int monthsWithinFY1 = 0;
                                            int monthsWithinFY2 = 0;

                                            // Calculate months in each category
                                            DateTime currentDate = startDate;
                                            while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
                                              if (currentDate.isBefore(fy1[0])) {
                                                monthsBeforeFY1++;
                                              } else if (currentDate.isBefore(fy1[1].add(Duration(days: 1)))) {
                                                monthsWithinFY1++;
                                              } else if (currentDate.isBefore(fy2[1].add(Duration(days: 1)))) {
                                                monthsWithinFY2++;
                                              }

                                              // Move to the next month
                                              currentDate = currentDate.month == 12
                                                  ? DateTime(currentDate.year + 1, 1, currentDate.day)
                                                  : DateTime(currentDate.year, currentDate.month + 1, currentDate.day);
                                            }
                                            amountWithinFY1 = salary * monthsWithinFY1;
                                            amountWithinFY2 = (((incrementPercentage/100)*salary)+salary)*monthsWithinFY2;
                                            totalAmountFY1AndFY2 = ((amountWithinFY1 + amountWithinFY2)/365)*days;
                                            amountControllers[index].text= totalAmountFY1AndFY2.toStringAsFixed(2);
                                            tempTotal += double.parse(amountControllers[index].text);

                                            // Correctly add the tempTotal to the current totalAmountController value
                                            double currentTotal = double.tryParse(totalAmountController.text) ?? 0.0;
                                            currentTotal += tempTotal;
                                            totalAmountController.text = currentTotal.toStringAsFixed(2);

                                            print(totalAmountController.text);

                                            print('------monthsWithinFY1------');
                                            print(monthsWithinFY1);
                                            print('------monthsWithinFY2-------');
                                            print(monthsWithinFY2);
                                            print('The dates span two financial years.');
                                          }
                                          break;
                                          case FinancialYearSpan.moreThanTwoFinancialYears:{
                                            print('The dates span more than two financial years.');
                                          }
                                          break;
                                        }


                                      }

                                    },
                                    controller:endDateControllers[index],
                                    decoration: textFieldDecoration(hintText:""),),)),
                                  const SizedBox(width: 30,),
                                  Expanded(child: Center(child:TextFormField(
                                    onChanged: (days){ },
                                    controller:daysControllers[index],
                                    decoration: textFieldDecoration(hintText:""),),)),
                                  const SizedBox(width: 30,),
                                  Expanded(child: Center(child:TextFormField(
                                    controller:amountControllers[index],
                                    decoration: textFieldDecoration(hintText:""),),)),
                                  const SizedBox(width: 10,),
                                  InkWell(
                                    onTap:(){
                                      setState(() {
                                        try{
                                          siteStaff.removeAt(index);
                                          titleControllers.removeAt(index);
                                          gradeController.removeAt(index);
                                          salaryControllers.removeAt(index);
                                          incrementControllers.removeAt(index);
                                          startDateControllers.removeAt(index);
                                          endDateControllers.removeAt(index);
                                          daysControllers.removeAt(index);
                                          amountControllers.removeAt(index);
                                        }
                                        catch(e){
                                          print('-------Exception----');
                                          print(e);
                                        }
                                      });
                                    },
                                    child: const Icon(Icons.remove_circle_outline_outlined,size: 18,
                                      color: Colors.blue,),
                                  ),
                                  const SizedBox(width: 10,),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },),

                  Padding(
                    padding: const EdgeInsets.all(50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MaterialButton(
                          color: Colors.blue,
                          onPressed: (){
                            setState(() {
                              siteStaff.add("${siteStaff.length + 1}");
                              titleControllers.add(TextEditingController());
                              gradeController.add(TextEditingController());
                              salaryControllers.add(TextEditingController());
                              incrementControllers.add(TextEditingController());
                              startDateControllers.add(TextEditingController());
                              endDateControllers.add(TextEditingController());
                              daysControllers.add(TextEditingController());
                              amountControllers.add(TextEditingController());
                            });


                          },child: const Row(children: [
                          Icon(Icons.add_circle_outlined,size: 14,color: Colors.white,),
                          SizedBox(width: 5,),
                          Text("Add",style: TextStyle(color: Colors.white),)
                        ]),
                        ),
                        Row(children: [
                          const Text("Total Amount",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                          const SizedBox(width: 10,),
                          Builder(
                              builder: (context) {
                                return SizedBox(
                                  width: 120,
                                  child: TextFormField(
                                    controller:totalAmountController,
                                    decoration: textFieldDecoration(hintText:""),),
                                );
                              }
                          )
                        ],)
                      ],),
                  )
                ]),

              ),
              ///Third Card.
              Card(
                surfaceTintColor:const Color(0XFFFDFAFD),
                child: Column(children: [
                  //Header Container.
                  Container(height: 35,
                    color: Colors.blue,
                    child: const Center(child: Padding(
                      padding: EdgeInsets.only(left: 50.0,top: 10),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('Overheads',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                    )),
                  ),

                  const SizedBox(height: 10,),
                  //Table Header.
                  Padding(
                    padding: const EdgeInsets.only(left:30,right: 10,top: 10,bottom: 10),
                    child: SizedBox(
                      height: 34,
                      child:   Row(
                        children:  [
                          Expanded(child: Center(child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Text('SN',style: textFieldStyle,),
                          ))),
                          Expanded(flex: 2,child: Text("Item",style: textFieldStyle)),
                          Expanded(child: Container()),
                          Expanded(child: Center(child: Text("Amount",style: textFieldStyle))),
                          const SizedBox(width: 30,),
                        ],
                      ),
                    ),
                  ),
                  //Dynamic Table.
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: overHeads.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10,right: 30),
                            child: SizedBox(
                              height: 50,
                              child: Row(
                                children:  [

                                  Expanded(child: Center(child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration:BoxDecoration(border: Border.all(color: Colors.grey,),
                                          borderRadius: BorderRadius.circular(5)) ,
                                      child: Center(child: Text('${index+1}'))),)),

                                  Expanded(flex: 2,child: Center(child:TextFormField(
                                    controller:annualBenefits[index],
                                    decoration: textFieldDecoration(hintText:"ANNUAL BENEFITS"),),)),

                                  Expanded(flex: 1,child: Container()),
                                  SizedBox(
                                    width:200,
                                    child: TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                                      ],
                                      onChanged: (val){
                                        caluculation();
                                      },
                                      controller:amountOverheads[index],
                                      decoration: textFieldDecoration(hintText:""),),
                                  ),

                                  const SizedBox(width: 10,),
                                  InkWell(
                                    onTap:(){
                                      setState(() {
                                        try{
                                          annualBenefits.removeAt(index);
                                          amountOverheads.removeAt(index);
                                          overHeads.removeAt(index);
                                          caluculation();
                                        }
                                        catch(e){
                                          print('-------Exception----');
                                          print(e);
                                        }
                                      });
                                    },
                                    child: const Icon(Icons.remove_circle_outline_outlined,size: 18,
                                      color: Colors.blue,),
                                  ),
                                  const SizedBox(width: 10,),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },),

                  Padding(
                    padding: const EdgeInsets.all(50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MaterialButton(
                          color: Colors.blue,
                          onPressed: (){
                            setState(() {
                              annualBenefits.add(TextEditingController());
                              amountOverheads.add(TextEditingController());
                              overHeads.add("${overHeads.length + 1}");
                            });


                          },child: const Row(children: [
                          Icon(Icons.add_circle_outlined,size: 14,color: Colors.white,),
                          SizedBox(width: 5,),
                          Text("Add",style: TextStyle(color: Colors.white),)
                        ]),
                        ),
                        Row(children: [
                          const Text("Total Amount",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                          const SizedBox(width: 10,),
                          SizedBox(
                            width: 200,
                            child: TextFormField(
                              controller:totalAmountsOverheads,
                              decoration: textFieldDecoration(hintText:""),),
                          )
                        ],)
                      ],),
                  )
                ]),

              ),
              const SizedBox(height: 50,),
              MaterialButton(
                  color: Colors.blue,
                  child: const Text("Submit"),
                  onPressed: (){
                    List siteStaffList=[
                      {
                        "siteStaff":[],
                        "totalAmount":totalAmountController.text,
                      }

                    ];

                    for(int i=0;i<siteStaff.length;i++){
                      Map siteStaff= {
                        "title":titleControllers[i].text,
                        "grade":gradeController[i].text,
                        "salary":salaryControllers[i].text,
                        'increment':incrementControllers[i].text,
                        'startDate':startDateControllers[i].text,
                        'endDate':endDateControllers[i].text,
                        'days':daysControllers[i].text,
                        'amount':amountControllers[i].text,
                      };
                      siteStaffList[0]["siteStaff"].add(siteStaff);
                      print('----------Individual Map-----');
                      print(siteStaff);
                    }
                    // print('--------siteStaffList------');
                    // print(siteStaffList);

                  })
            ]) ,) ),
    );
  }
}



enum FinancialYearSpan {
  oneFinancialYear,
  twoFinancialYears,
  moreThanTwoFinancialYears,
}


// import 'package:flutter/material.dart';
//
//
//
// class MyApp2 extends StatefulWidget {
//   @override
//   _MyApp2State createState() => _MyApp2State();
// }
//
// class _MyApp2State extends State<MyApp2> {
//   List<TextEditingController> amountOverheads = [];
//   TextEditingController totalAmountsOverheads = TextEditingController();
//   double totalAmount = 0.0;
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize with some sample controllers
//     _addNewField(); // Add an initial field for demonstration
//   }
//
//   @override
//   void dispose() {
//     for (var controller in amountOverheads) {
//       controller.dispose();
//     }
//     totalAmountsOverheads.dispose();
//     super.dispose();
//   }
//
//   void _addNewField() {
//     setState(() {
//       var controller = TextEditingController();
//       controller.addListener(() {
//         _calculateTotalAmount();
//       });
//       amountOverheads.add(controller);
//     });
//   }
//
//   void _removeField(int index) {
//     setState(() {
//       amountOverheads[index].dispose();
//       amountOverheads.removeAt(index);
//       _calculateTotalAmount(); // Recalculate total after removing a field
//     });
//   }
//
//   void _calculateTotalAmount() {
//     double tempTotal = 0.0;
//     for (var controller in amountOverheads) {
//       if (controller.text.isNotEmpty) {
//         try {
//           tempTotal += double.parse(controller.text);
//         } catch (e) {
//           // Handle parsing error if needed
//         }
//       }
//     }
//     setState(() {
//       totalAmount = tempTotal;
//       totalAmountsOverheads.text = totalAmount.toString();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Dynamic Text Fields'),
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: amountOverheads.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: TextField(
//                       controller: amountOverheads[index],
//                       keyboardType: TextInputType.number,
//                       decoration: InputDecoration(
//                         labelText: 'Amount $index',
//                       ),
//                     ),
//                     trailing: IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () => _removeField(index),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 controller: totalAmountsOverheads,
//                 readOnly: true,
//                 decoration: InputDecoration(
//                   labelText: 'Total Amount',
//                 ),
//               ),
//             ),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: _addNewField,
//           child: Icon(Icons.add),
//         ),
//       ),
//     );
//   }
// }



