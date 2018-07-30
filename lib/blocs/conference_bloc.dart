// Copyright 2018, Devoxx
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:voxxedapp/data/conference_repository.dart';
import 'package:voxxedapp/models/conference.dart';

class ConferenceBloc {
  final ConferenceRepository repository;
  final _conferences = BehaviorSubject<BuiltList<Conference>>();

  ConferenceBloc(this.repository) {
    _loadCachedConferences();
    refreshConferences();
  }

  Observable<BuiltList<Conference>> get conferences => _conferences.stream;

  Future<Null> refreshConferences() async {
    final newList = await repository.refreshConferences();
    print('Adding ${newList?.length} refreshed items to stream.');
    _conferences.controller.add(newList);
  }

  Future<Null> _loadCachedConferences() async {
    final newList = await repository.loadCachedConferences();
    print('Adding ${newList?.length} cached items to stream.');
    _conferences.controller.add(newList);
  }
}

class ConferenceBlocProvider extends InheritedWidget {
  final ConferenceBloc _bloc;

  ConferenceBlocProvider({
    Key key,
    @required ConferenceBloc conferenceBloc,
    Widget child,
  })  : _bloc = conferenceBloc,
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static ConferenceBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(ConferenceBlocProvider)
              as ConferenceBlocProvider)
          ._bloc;
}
