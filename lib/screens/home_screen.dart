import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../widgets/user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? currentUser;
  bool isLoading = false;
  String? errorMessage;
  List<User> userHistory = [];

  @override
  void initState() {
    super.initState();
    _loadRandomUser();
  }

  Future<void> _loadRandomUser() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final user = await UserService.fetchRandomUser();
      setState(() {
        currentUser = user;
        userHistory.insert(0, user);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceAll('Exception: ', '');
        isLoading = false;
      });
    }
  }

  void _clearHistory() {
    setState(() {
      userHistory.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('History cleared')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random User Generator'),
        centerTitle: true,
        elevation: 0,
        actions: [
          if (userHistory.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: _clearHistory,
              tooltip: 'Clear History',
            ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Error: $errorMessage',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _loadRandomUser,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : currentUser == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.person_add, size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text('No user loaded yet'),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _loadRandomUser,
                            child: const Text('Load User'),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            UserCard(user: currentUser!),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _loadRandomUser,
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('Get New User'),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            if (userHistory.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'User History (${userHistory.length})',
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    height: 120,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: userHistory.length,
                                      itemBuilder: (context, index) {
                                        final user = userHistory[index];
                                        return Padding(
                                          padding: const EdgeInsets.only(right: 12.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                currentUser = user;
                                              });
                                            },
                                            child: Column(
                                              children: [
                                                CircleAvatar(
                                                  radius: 40,
                                                  backgroundImage: NetworkImage(user.picture),
                                                ),
                                                const SizedBox(height: 4),
                                                SizedBox(
                                                  width: 80,
                                                  child: Text(
                                                    user.firstName,
                                                    textAlign: TextAlign.center,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(fontSize: 12),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
    );
  }
}
