import 'package:bloc_test/bloc_test.dart';
import 'package:rtu_mirea_app/contributors/bloc/contributors_bloc.dart';

class MockContributorsBloc
    extends MockBloc<ContributorsEvent, ContributorsState>
    implements ContributorsBloc {}
