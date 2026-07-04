import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ioc/flutter_ioc.dart';

import '../../../../core/services/user_service.dart';
import '../../event_form/widgets/user_item.dart';
import '../../../widgets/search_bar.dart';
import '../../../widgets/shimmer_effect.dart';
import '../cubit/connections_cubit.dart';
import '../cubit/connections_state.dart';

class ConnectionsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ConnectionsCubit(Ioc.container.get<UserService>())..fetchUsers(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Connections',
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<ConnectionsCubit, ConnectionsState>(
                builder: (context, state) {
                  return CustomSearchBar(
                    onChanged: (query) =>
                        context.read<ConnectionsCubit>().filterUsers(query),
                  );
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Other Profiles',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: BlocConsumer<ConnectionsCubit, ConnectionsState>(
                  listener: (context, state) {
                    if (state.error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error!)),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const ShimmerEffect(width: 454, height: 167);
                    } else if (state.filteredUsers.isEmpty) {
                      return Center(
                        child: Text(
                          state.searchQuery.isNotEmpty
                              ? 'No users found matching "${state.searchQuery}"'
                              : 'No users available',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: state.filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = state.filteredUsers[index];
                          return UserCard(
                            username: user.username,
                            displayName: user.displayName,
                            userId: user.id,
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
