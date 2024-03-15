import 'package:chattor_app/constants/color.dart';
import 'package:chattor_app/repository/auth_repository.dart';
import 'package:chattor_app/widgets/homePageWidgets/contact_list.dart';
import 'package:chattor_app/widgets/homePageWidgets/info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Widget> _tabViews = [const ContactsList(), const InfoPage()];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authRepositoryProvider).setUserState(true);
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        ref.read(authRepositoryProvider).setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColor.appBarColor,
        centerTitle: false,
        title: const Text(
          'Chattor',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton(
            iconColor: Colors.black,
            color: MyColor.bgColor,
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: const Text(
                    'Create a Group',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('/createGroupPage');
                  },
                )
              ];
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 4,
          labelColor: MyColor.tabColor,
          unselectedLabelColor: const Color.fromARGB(153, 129, 129, 129),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          tabs: const [
            Tab(text: 'CHATS'),
            Tab(text: 'INFO'),
          ],
        ),
      ),
      body: TabBarView(controller: _tabController,children: _tabViews,),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/selectContactsPage');
        },
        backgroundColor: MyColor.appBarColor,
        child: const Icon(
          Icons.comment,
          color: Colors.black,
        ),
      ),
    );
  }
}
