import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kore_app/auth/authentication_bloc.dart';
import 'package:kore_app/auth/authentication_event.dart';
import 'package:kore_app/auth/user_repository.dart';
import 'package:kore_app/data/api.dart';
import 'package:kore_app/models/account.dart';
import 'package:kore_app/models/user.dart';
import 'package:kore_app/screens/accountDetail.dart';
import 'package:kore_app/utils/theme.dart';

class AccountListState extends State<AccountList> {
  Future<User>
      _user; // = User("Tina", "https://image.flaticon.com/icons/png/128/201/201570.png", "satus");
  Future<List<Account>> _contracts;
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _nameFont = const TextStyle(color: Colors.white, fontSize: 28);
  static const PHOTO_PLACEHOLDER_PATH = "https://image.flaticon.com/icons/png/128/201/201570.png";
  Future<String> _username;
  Future<String> _token;
  Api _api;
  // final Set<ContractInfo> _saved = Set<ContractInfo>();
  //one of the state lifecycle function, only load once
  //good place for dummydata loading
  @override
  initState() {
    super.initState();
    _token = widget.userRepository.hasToken();
    _username = widget.userRepository.getUsername();
    _api = Api();
    _user = _api.getUserByUsername(_token, _username);
    _contracts = _api.getAccountsById(_token);
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Contract List'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                authenticationBloc.dispatch(LoggedOut());
              },
            ),
          ],
        ),
        body: FutureBuilder<List<Account>>(
          future: _contracts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                  children: <Widget>[_profileRow(), _buildList(snapshot.data)]);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner
            return CircularProgressIndicator();
          },
        ));
  }

  Widget _profileRow() {
    return Container(
      // margin: const EdgeInsets.symmetric(vertical: 0.0),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.only(bottomLeft: const Radius.circular(30.0)),
        color: KorePrimaryColor,
      ),
      child: FutureBuilder<User>(
          future: _user,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //Using expanded to ensure the image is always sized with contraint
                  Expanded(
                    child: new Container(
                      height: 150.0,
                      // margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: new CachedNetworkImage(
                        imageUrl: snapshot.data.iconFileUrl==null? PHOTO_PLACEHOLDER_PATH:snapshot.data.iconFileUrl,
                        placeholder: (context, url) =>
                            new CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      ),
                    ),
                  ),
                  Expanded(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(snapshot.data.name, style: _nameFont),
                        new Container(
                          margin: const EdgeInsets.only(top: 5.0),
                          child: new Text(snapshot.data.status.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          }),
    );
  }

  Widget _buildList(List<Account> accounts) {
    return Flexible(
        child: ListView.builder(
            padding: const EdgeInsets.all(25.0),
            itemBuilder: (context, i) {
              if (i.isOdd) return Divider();

              final index = i ~/ 2;
              if (accounts.length > index) {
                return _buildRow(accounts[index]);
              }
              return null;
            }));
  }

  Widget _buildRow(Account account) {
    return ListTile(
      title: Text(
        account.accountName,
        style: _biggerFont,
      ),
      // trailing: Icon(
      //   // Add the lines from here...
      //   account.percentage >= 100 ? Icons.done : null,
      // ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AccountDetail(account: account, userRepository: widget.userRepository),
            ));
      },
    );
  }
}

class AccountList extends StatefulWidget {
  AccountList({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  final UserRepository userRepository;

  @override
  AccountListState createState() => new AccountListState();
}
