import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample4/app_provider.dart';
import 'package:sample4/success_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppProvider>(
      create: (_) => AppProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sample4',
        theme: ThemeData(useMaterial3: true),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? searchTerm;

  void submit() async {
    setState(() {
      autovalidateMode = AutovalidateMode.always;
    });

    final form = formkey.currentState;
    if (form == null || !form.validate()) return;
    form.save();
    try {
      await context.read<AppProvider>().getResult(searchTerm!);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SuccessPage(),
        ),
      );
    } catch (e) {
      showDialog(
        context: (context),
        builder: (context) => AlertDialog(
          content: Text('Someting went wrong'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppProvider>().state;
    return Scaffold(
      appBar: AppBar(
        title: Text('Sample4'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: formkey,
            autovalidateMode: autovalidateMode,
            child: ListView(
              shrinkWrap: true,
              children: [
                TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Search'),
                    prefixIcon: Icon(Icons.search),
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Search trem required';
                    }
                    return null;
                  },
                  onSaved: (String? value) => searchTerm = value,
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  child: Text(
                    appState == AppState.loading ? 'Loading...' : 'Get Result',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: appState == AppState.loading ? null : submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
