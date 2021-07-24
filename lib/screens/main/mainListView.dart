import 'package:cash_analyzer/app/index.dart';

import 'package:cash_analyzer/screens/main/GoalSection.dart';
import 'package:cash_analyzer/screens/main/PaymentList.dart';
import 'package:cash_analyzer/screens/setting/setting.dart';
import 'package:cash_analyzer/utils/time.dart';

class MainListViewHome extends StatefulWidget {
  static const routeName = '/';

  @override
  State<StatefulWidget> createState() {
    return MainListViewHomeState();
  }
}

// When use stateful widget in Bloc using project
class MainListViewHomeState extends State<MainListViewHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final bloc = BlocProvider.of<DataProcessBloc>(context)!.bloc;
    Future.microtask(() => bloc.fetchSessionData());

    return SafeArea(
      child: Scaffold(
        backgroundColor: black48,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: StreamBuilder<SessionData>(
              stream: bloc.sessionDataStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return buildBody(snapshot.data!);
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ),
        floatingActionButton: IconButton(
          icon: Icon(Icons.settings, color: white),
          onPressed: () {
            service!.navigateTo(SettingPage.routeName);
            print("setting button");
          },
        ),
      ),
    );
  }

  Widget buildBody(SessionData data) {
    SessionInfo si = data.sessionInfo;
    List<String> keys = data.paymentListData.keys.toList();
    int todayUse = 0;
    List<PaymentInfo>? paymentInfoList =
        data.paymentListData[removeTime(DateTime.now()).toIso8601String()];
    if (paymentInfoList != null) {
      paymentInfoList.forEach((element) {
        todayUse += element.price;
      });
    }

    return Column(
      children: [
        Expanded(
            flex: 35,
            child: Column(
              children: [
                SizedBox(height: 40),
                GoalSection(si, todayUse),
              ],
            )),
        Expanded(
          flex: 65,
          child: Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(bottom: 30),
            child: Container(
              constraints: BoxConstraints(maxHeight: 350),
              width: width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: keys.length,
                itemBuilder: (BuildContext context, int index) {
                  String key = keys[keys.length-1-index];
                  return Container(
                      margin: EdgeInsets.only(right: index != 1 ? 18 : 0),
                      // child: PaymentList(PaymentListData(
                      //     pData, DateTime.now().subtract(Duration(days: index)))),
                      child: PaymentList(PaymentListData(
                          DateTime.parse(key), data.paymentListData[key]!)));
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
