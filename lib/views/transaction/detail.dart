import 'package:final_project/models/models.dart';
import 'package:flutter/material.dart';

class TransactionDetail extends StatelessWidget {
  late Transaction transaction;
  
  TransactionDetail(this.transaction, {Key? key}) : super(key: key);

  Transaction getTransaction(){
    return this.transaction;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cash Flow"),
      ),
      body: Column(
        children: [
          TransactionInfo(transaction),
          ListView(
            shrinkWrap: true,
            children: [
              Divider(
                thickness: 1.5,
              ),
              ListTile(
                title: Container(
                  child: Row(
                    children: [
                      Container(
                        decoration: new BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle
                        ),
                        child: new Icon(Icons.remove, size: 40),
                      ),  
                      Text(" Auto", style: TextStyle(fontSize: 30)),  
                    ],
                  )
                ),
                
                
                trailing: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("-200",style: TextStyle(fontSize: 20,color: Colors.red),),
                      Text("25-10-2021")  
                    ],
                  )
                ),
                // tileColor: Colors.black12,
              ),
              Divider(
                thickness: 1.5,
              ),
              Divider(
                thickness: 1.5,
              ),
              ListTile(
                title: Container(
                  child: Row(
                    children: [
                      Container(
                        decoration: new BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle
                        ),
                        child: new Icon(Icons.add, size: 40),
                      ),  
                      Text(" Replenishment", style: TextStyle(fontSize: 30)),  
                    ],
                  )
                ),
                // Text("Replenishment", style: TextStyle(fontSize: 30),),
                trailing: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("+2000",style: TextStyle(fontSize: 20,color: Colors.green),),
                      Text("25-10-2021")  
                    ],
                  )
                ),
              ),
              Divider(
                thickness: 1.5,
              ),
            ],
          )
        ],
      ),
    );
  }
}



class TransactionInfo extends StatelessWidget {
  late Transaction transaction;
  TransactionInfo(
      this.transaction,{
        Key? key,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "${transaction.description}",
                style: TextStyle(fontSize: 26.0),
              ),
            ),
          ),
          Center(
            child: Text(
              "${transaction.amount}",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        ],
      ),
    );
  }
}
