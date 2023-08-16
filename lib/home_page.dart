import 'package:assignment2_crud/model/contact_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

String selectedFilterValue = 'All';
class _HomePageState extends State<HomePage> {
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController numberEditingController = TextEditingController();
  TextEditingController searchEditingController = TextEditingController();
  String? contactCategory;
  List<Contact> contactList = List.empty(growable: true);
  String searchingText = '';

  List<Contact> get filteredContactsIcon {
    return contactList.where((contact) {
      final name = contact.type;
      if (selectedFilterValue == 'All') {
        return name.contains('');
      } else{
        return name.contains(selectedFilterValue);
      }
    }).toList();
  }

  List<Contact> get searchingContacts {
    return filteredContactsIcon.where((contact) {
      final name = contact.name.toLowerCase();
      final search = searchingText.toLowerCase();
      return name.contains(search);
    }).toList();
  }

  void reload() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Contacts List', style: TextStyle(color: Colors.black),),
        backgroundColor:Color(0xffD4D4D4),
        elevation: 1,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(context: context, builder: (BuildContext context) => ShowFilter(),);},
              icon: Icon(Icons.filter_list, color: Colors.black, size: 28,))
        ],
      ),
      floatingActionButton: CircleAvatar(
        backgroundColor: Colors.indigo,
        radius: 30,
        child: IconButton(
          icon: Icon(Icons.add, size: 32, color: Colors.white,),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    StatefulBuilder(builder: (context, setState) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Container(
                          width: 300.0,
                          height: 440,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18)),
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Create New',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'Name',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    TextFormField(
                                      autofocus: true,
                                      controller: nameEditingController,
                                      keyboardType: TextInputType.name,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Mobile No',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    TextFormField(
                                      controller: numberEditingController,
                                      keyboardType: TextInputType.number,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Contact Type',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    RadioListTile(
                                      activeColor: Colors.black,
                                      title: Text("Business"),
                                      value: "Business",
                                      groupValue: contactCategory,
                                      onChanged: (value) {
                                        setState(() {
                                          contactCategory = value.toString();
                                        });
                                      },
                                    ),
                                    RadioListTile(
                                      activeColor: Colors.black,
                                      title: Text("Personal"),
                                      value: "Personal",
                                      groupValue: contactCategory,
                                      onChanged: (value) {
                                        setState(() {
                                          contactCategory = value.toString();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Divider(
                                height: 14,
                                thickness: 2,
                              ),
                              Center(
                                  child: TextButton(
                                      onPressed: () {
                                        String name = nameEditingController.text;
                                        String number = numberEditingController.text;
                                        if (name.isNotEmpty &&
                                            number.isNotEmpty) {
                                          reload();
                                          contactList.add(Contact(
                                              name: name,
                                              number: number,
                                              type: contactCategory!));
                                          contactCategory = '';
                                          nameEditingController.text = '';
                                          numberEditingController.text = '';
                                          Navigator.pop(context);
                                          print(searchingContacts);
                                          print(searchingContacts[0].number);
                                        }
                                      },
                                      child: Text(
                                        'Add',
                                        style: TextStyle(
                                            color: Colors.indigo,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )))
                            ],
                          ),
                        ),
                      );
                    }));
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20,15,20,15),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffD4D4D4)),
                  borderRadius: BorderRadius.circular(50)
              ),
              child: TextField(
                autofocus: false,
                controller: searchEditingController,
                style: const TextStyle(color: Colors.black),
                cursorColor: Colors.black,
                onChanged: (value) {
                  setState(() {
                    searchingText = value;
                  });
                },
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 2,color: Colors.indigo,)
                      ,borderRadius: BorderRadius.circular(50)),
                  prefixIcon: const Icon(Icons.search_outlined, color: Colors.black,),
                  fillColor: Colors.black12,
                  focusColor: Colors.black12,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        searchEditingController.text = '';
                        searchingText = '';
                      });
                    },
                  ),
                  hintText: 'Search',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: searchingContacts.length,
                itemBuilder: (context, index) {
                  final contactWithIndex = searchingContacts[index];
                  return getContactItem( index, contactWithIndex);
                }
            ),
          ),
        ],
      ),
    );
  }


  Widget getContactItem(int index, final contactWithIndex) {
    return  Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.lightGreen,
            foregroundColor: Colors.white,
            child: Text(
              contactWithIndex.name[0].toUpperCase(),
              style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),
            ),
          ),
          title:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(contactWithIndex.name,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              SizedBox(height: 5,),
              Text(contactWithIndex.number,style: TextStyle(fontSize:16, fontWeight:FontWeight.w400,color: Colors.blueGrey),),
              // Text(contactWithIndex.type),
            ],
          ),
          trailing: Text(contactWithIndex.type,style: TextStyle(color: Colors.grey),),
          onTap: () {
            nameEditingController.text = searchingContacts[index].name;
            numberEditingController.text = searchingContacts[index].number;
            contactCategory = searchingContacts[index].type;

            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    StatefulBuilder(builder: (context, setState) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(12.0)),
                        //this right here
                        child: Container(
                          width: 300.0,
                          height: 440,
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(15)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Edit',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'Name',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    TextFormField(
                                      controller: nameEditingController,
                                      keyboardType: TextInputType.name,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Mobile no',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    TextFormField(
                                      controller: numberEditingController,
                                      keyboardType: TextInputType.number,
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      'Contact Type',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    RadioListTile(
                                      activeColor: Colors.black,
                                      title: Text("Business"),
                                      value: "Business",
                                      groupValue: contactCategory,
                                      onChanged: (value) {
                                        setState(() {
                                          contactCategory = value.toString();
                                        });
                                      },
                                    ),
                                    RadioListTile(
                                      activeColor: Colors.black,
                                      title: Text("Personal"),
                                      value: "Personal",
                                      groupValue: contactCategory,
                                      onChanged: (value) {
                                        setState(() {
                                          contactCategory = value.toString();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Divider(
                                height: 14,
                                thickness: 2,
                              ),
                              IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        contactList.removeAt(index);
                                        nameEditingController.text = '';
                                        numberEditingController.text = '';
                                        contactCategory = '';
                                        reload();
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                            color: Colors.indigo,
                                            fontSize: 20,
                                            fontWeight:
                                            FontWeight.bold),
                                      ),
                                    ),
                                    VerticalDivider(thickness: 2,),
                                    TextButton(
                                        onPressed: () {
                                          String name = nameEditingController.text;
                                          String number = numberEditingController.text;
                                          Navigator.pop(context);
                                          if (name.isNotEmpty && number.isNotEmpty) {
                                            reload();
                                            searchingContacts[index].name = name;
                                            searchingContacts[index].number = number;
                                            searchingContacts[index].type = contactCategory!;
                                            contactCategory = '';
                                            nameEditingController.text = '';
                                            numberEditingController.text = '';
                                          }
                                        },
                                        child: Text(
                                          'Update',
                                          style: TextStyle(
                                              color: Colors.indigo,
                                              fontSize: 20,
                                              fontWeight:
                                              FontWeight.bold),
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }));
          },
        ),
        Divider(
          indent: 80,
          endIndent: 18,
          height: 20,thickness: 2,)
      ],
    );
  }

  Widget ShowFilter() {
    return StatefulBuilder(builder: (context, setState) {
      return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0)), //this right here
        child: Container(
          width: 290,
          height: 290,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.filter_list,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Filter',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    RadioListTile(
                      activeColor: Colors.black,
                      title: Text("All"),
                      value: "All",
                      groupValue: selectedFilterValue,
                      onChanged: (value) {
                        setState(() {
                          selectedFilterValue = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      activeColor: Colors.black,
                      title: Text("Business"),
                      value: "Business",
                      groupValue: selectedFilterValue,
                      onChanged: (value) {
                        setState(() {
                          selectedFilterValue = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      activeColor: Colors.black,
                      title: Text("Personal"),
                      value: "Personal",
                      groupValue: selectedFilterValue,
                      onChanged: (value) {
                        setState(() {
                          selectedFilterValue = value.toString();
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                height: 10,
                thickness: 2,
              ),
              Center(
                  child: TextButton(
                      onPressed: () {
                        reload();
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Done!',
                        style: TextStyle(
                            color: Colors.indigo,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )))
            ],
          ),
        ),
      );
    });
  }
}


