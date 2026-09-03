import 'dart:convert';
import 'dart:typed_data';

import 'package:campus_repository/campus_repository.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:supabase/supabase.dart';
import 'package:test/test.dart';

const _materialUserId = '00000000-0000-4000-8000-000000000010';

void main() {
  test('material subjects preserve legacy and multiple subject payloads', () {
    final legacy = StudyMaterial.fromJson({
      'id': 'legacy',
      'title': 'Notes',
      'subjectName': 'Математика',
    });
    final multiple = StudyMaterial.fromJson({
      'id': 'multiple',
      'title': 'Notes',
      'subjectName': 'Математика',
      'subjectNames': ['Математика', 'Программирование'],
    });
    expect(legacy.subjects, ['Математика']);
    expect(multiple.subjects, ['Математика', 'Программирование']);
    expect(multiple.toJson()['subjectNames'], multiple.subjects);
  });

  group('group space mutations', () {
    test('normalizes safe links and returns the created id', () async {
      Map<String, Object?>? body;
      final client = MockClient((request) async {
        body = (jsonDecode(request.body) as Map).cast();
        return http.Response(
          jsonEncode('00000000-0000-4000-8000-000000000001'),
          200,
          request: request,
        );
      });

      final id = await _repository(client).addGroupLink(
        title: 'Chat',
        url: 't.me/group',
        kind: 'telegram',
      );

      expect(id, '00000000-0000-4000-8000-000000000001');
      expect(body?['p_url'], 'https://t.me/group');
    });

    test('rejects unsafe links before a network request', () async {
      var called = false;
      final repository = _repository(
        MockClient((request) async {
          called = true;
          return http.Response('null', 200, request: request);
        }),
      );

      await expectLater(
        repository.addGroupLink(
          title: 'Unsafe',
          url: 'javascript:alert(1)',
        ),
        throwsFormatException,
      );
      expect(called, isFalse);
    });

    test('parses the authoritative like state', () async {
      final liked = await _repository(
        MockClient(
          (request) async => http.Response(
            'true',
            200,
            request: request,
            headers: {'content-type': 'application/json'},
          ),
        ),
      ).toggleGroupPostLike('post-id');

      expect(liked, isTrue);
    });

    test('rejects malformed group-space mutation results', () async {
      final repository = _repository(
        MockClient(
          (request) async => http.Response(
            'null',
            200,
            request: request,
            headers: {'content-type': 'application/json'},
          ),
        ),
      );

      await expectLater(
        repository.toggleGroupPostLike('post-id'),
        throwsFormatException,
      );
      await expectLater(repository.getGroupSpace(), throwsFormatException);
    });
  });

  test('removes an uploaded file when material creation fails', () async {
    var uploaded = false;
    var removed = false;
    var uploadPath = '';
    var removedPaths = <String>[];
    final client = MockClient((request) async {
      final path = request.url.path;
      if (request.method == 'POST' && path.contains('/storage/v1/object/')) {
        uploaded = true;
        uploadPath = path;
        return http.Response(
          jsonEncode({'Key': path}),
          200,
          request: request,
        );
      }
      if (request.method == 'DELETE' && path.endsWith('/lesson-materials')) {
        removed = true;
        removedPaths = ((jsonDecode(request.body) as Map)['prefixes'] as List)
            .cast<String>();
        return http.Response('[]', 200, request: request);
      }
      if (path.endsWith('/rest/v1/rpc/create_public_material_v2')) {
        return http.Response(
          jsonEncode({
            'code': 'P0001',
            'message': 'metadata rejected',
            'details': null,
            'hint': null,
          }),
          400,
          request: request,
        );
      }
      return http.Response('Not found', 404, request: request);
    });
    final repository = await _signedInRepository(client);

    await expectLater(
      repository.createPublicMaterial(
        title: 'Notes',
        subjectName: 'Math',
        fileName: 'note.pdf',
        fileBytes: Uint8List.fromList(const [1, 2, 3]),
      ),
      throwsA(isA<PostgrestException>()),
    );

    expect(uploaded, isTrue);
    expect(removed, isTrue);
    expect(
      uploadPath,
      startsWith('/storage/v1/object/lesson-materials/$_materialUserId/bank/'),
    );
    expect(removedPaths, [
      uploadPath.substring('/storage/v1/object/lesson-materials/'.length),
    ]);
  });

  test('requires a signed-in user before uploading a valid file', () async {
    var called = false;
    final repository = _repository(
      MockClient((request) async {
        called = true;
        return http.Response('null', 200, request: request);
      }),
    );
    await expectLater(
      repository.createPublicMaterial(
        title: 'Notes',
        subjectName: 'Math',
        fileName: 'notes.pdf',
        fileBytes: Uint8List.fromList([1]),
      ),
      throwsA(isA<AuthException>()),
    );
    expect(called, isFalse);
  });

  test(
    'does not delete an upload after an ambiguous publication response',
    () async {
      var removed = false;
      final repository = await _signedInRepository(
        MockClient((request) async {
          if (request.method == 'DELETE') removed = true;
          if (request.url.path.contains('/storage/v1/object/')) {
            return http.Response(
              jsonEncode({'Key': request.url.path}),
              200,
              request: request,
            );
          }
          throw http.ClientException(
            'Connection closed after sending publication',
          );
        }),
      );
      await expectLater(
        repository.createPublicMaterial(
          title: 'Notes',
          subjectName: 'Math',
          fileName: 'notes.pdf',
          fileBytes: Uint8List.fromList([1, 2, 3]),
        ),
        throwsA(isA<http.ClientException>()),
      );
      expect(removed, isFalse);
    },
  );

  test('rejects fileless material creation before a network request', () async {
    var called = false;
    final repository = _repository(
      MockClient((request) async {
        called = true;
        return http.Response('not called', 500, request: request);
      }),
    );

    await expectLater(
      repository.createPublicMaterial(title: 'Notes', subjectName: 'Math'),
      throwsArgumentError,
    );
    expect(called, isFalse);
  });

  test('publishes multiple subjects with one upload and one RPC', () async {
    var uploads = 0;
    var creations = 0;
    final repository = await _signedInRepository(
      MockClient((request) async {
        if (request.url.path.contains('/storage/v1/object/')) {
          uploads++;
          return http.Response('{"Key":"bank/file"}', 200, request: request);
        }
        expect(request.url.path, '/rest/v1/rpc/create_public_material_v2');
        creations++;
        final parameters = jsonDecode(request.body) as Map;
        expect(parameters['p_subject_names'], [
          'Математика',
          'Программирование',
        ]);
        expect(parameters.containsKey('p_subject_name'), isFalse);
        expect(parameters['p_file_size'], 3);
        expect(
          parameters['p_file_path'],
          matches('^$_materialUserId/bank/[a-f0-9]{32}\$'),
        );
        return http.Response(
          '"00000000-0000-4000-8000-000000000001"',
          200,
          request: request,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    await repository.createPublicMaterial(
      title: 'Notes',
      subjectName: 'Математика',
      subjectNames: [' Математика ', 'Программирование', 'Математика'],
      fileName: 'notes.pdf',
      fileBytes: Uint8List.fromList([1, 2, 3]),
    );
    expect(uploads, 1);
    expect(creations, 1);
  });

  test('requires a subject before uploading a file', () async {
    var called = false;
    final repository = _repository(
      MockClient((request) async {
        called = true;
        return http.Response('null', 200, request: request);
      }),
    );
    await expectLater(
      repository.createPublicMaterial(
        title: 'Notes',
        subjectName: '',
        fileName: 'notes.pdf',
        fileBytes: Uint8List.fromList([1]),
      ),
      throwsArgumentError,
    );
    expect(called, isFalse);
  });

  test(
    'decodes the subject search contract without silently hiding errors',
    () async {
      final repository = _repository(
        MockClient((request) async {
          expect(request.url.path, '/rest/v1/rpc/search_material_subjects');
          return http.Response(
            '["Математика","Программирование"]',
            200,
            request: request,
            headers: {'content-type': 'application/json'},
          );
        }),
      );
      expect(await repository.searchMaterialSubjects(' мат '), [
        'Математика',
        'Программирование',
      ]);
    },
  );

  test('loads materials through the tenant-scoped v2 RPC', () async {
    final repository = _repository(
      MockClient((request) async {
        expect(
          request.url.path,
          '/rest/v1/rpc/list_public_materials_v2',
        );
        expect(jsonDecode(request.body), {
          'p_organization_id': 'university',
          'p_limit': 25,
        });
        return http.Response(
          jsonEncode([
            {
              'id': 'material-1',
              'title': 'Legacy anonymous notes',
              'hasFile': false,
              'requiresRepublish': true,
            },
          ]),
          200,
          request: request,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final materials = await repository.getPublicMaterials(limit: 25);
    final material = materials.singleOrNull;

    expect(material?.requiresRepublish, isTrue);
    expect(material?.hasFile, isFalse);
  });

  test('creates a signed URL for an attached public material', () async {
    final client = MockClient((request) async {
      if (request.url.path.endsWith('/rest/v1/rpc/access_public_material')) {
        expect(jsonDecode(request.body), {'p_id': 'material-1'});
        return http.Response(
          jsonEncode({
            'filePath': 'bank/material.pdf',
            'canDownload': true,
            'price': 0,
          }),
          200,
          request: request,
          headers: {'content-type': 'application/json'},
        );
      }
      expect(
        request.url.path,
        '/storage/v1/object/sign/lesson-materials/bank/material.pdf',
      );
      return http.Response(
        jsonEncode({'signedURL': '/object/sign/lesson-materials/note?token=x'}),
        200,
        request: request,
      );
    });
    final repository = _repository(client);

    final url = await repository.createPublicMaterialUrl(
      const StudyMaterial(
        id: 'material-1',
        title: 'Notes',
        fileName: 'note.pdf',
        hasFile: true,
      ),
    );

    expect(
      url,
      'https://project.supabase.co/storage/v1/object/sign/'
      'lesson-materials/note?token=x',
    );
  });

  test('rejects a public material without an attached file', () async {
    final repository = _repository(
      MockClient((request) async => http.Response('not called', 500)),
    );

    expect(
      () => repository.createPublicMaterialUrl(
        const StudyMaterial(id: 'material-1', title: 'Notes'),
      ),
      throwsFormatException,
    );
  });

  test('paid access never purchases or signs without an entitlement', () async {
    final calls = <String>[];
    final repository = _repository(
      MockClient((request) async {
        calls.add(request.url.pathSegments.last);
        return http.Response(
          jsonEncode({'canDownload': false, 'price': 40, 'filePath': null}),
          200,
          request: request,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    const material = StudyMaterial(id: 'paid', title: 'Paid', hasFile: true);
    final access = await repository.getPublicMaterialAccess(material);
    expect(access.canDownload, isFalse);
    expect(access.price, 40);
    await expectLater(
      repository.createPublicMaterialUrl(material),
      throwsA(isA<MaterialPurchaseException>()),
    );
    expect(calls, ['access_public_material', 'access_public_material']);
  });

  test(
    'purchase sends only the material and explicitly confirmed price',
    () async {
      final repository = _repository(
        MockClient((request) async {
          expect(request.url.pathSegments.last, 'purchase_public_material');
          expect(jsonDecode(request.body), {
            'p_id': 'paid',
            'p_expected_price': 40,
          });
          return http.Response(
            jsonEncode({'canDownload': true, 'price': 40}),
            200,
            request: request,
            headers: {'content-type': 'application/json'},
          );
        }),
      );
      await repository.purchasePublicMaterial(
        const StudyMaterial(id: 'paid', title: 'Paid'),
        expectedPrice: 40,
      );
    },
  );

  for (final (message, reason) in [
    ('MATERIAL_PRICE_CHANGED', MaterialPurchaseFailure.priceChanged),
    (
      'MATERIAL_INSUFFICIENT_BALANCE',
      MaterialPurchaseFailure.insufficientBalance,
    ),
  ]) {
    test('maps $message without retrying a purchase', () async {
      var calls = 0;
      final repository = _repository(
        MockClient((request) async {
          calls++;
          return http.Response(
            jsonEncode({'code': '22023', 'message': message}),
            400,
            request: request,
            headers: {'content-type': 'application/json'},
          );
        }),
      );
      await expectLater(
        repository.purchasePublicMaterial(
          const StudyMaterial(id: 'paid', title: 'Paid'),
          expectedPrice: 40,
        ),
        throwsA(
          isA<MaterialPurchaseException>().having(
            (error) => error.reason,
            'reason',
            reason,
          ),
        ),
      );
      expect(calls, 1);
    });
  }

  test('rejects malformed access and unconfirmed purchase payloads', () async {
    final repository = _repository(
      MockClient(
        (request) async => http.Response(
          jsonEncode({'canDownload': 'true', 'price': -1}),
          200,
          request: request,
          headers: {'content-type': 'application/json'},
        ),
      ),
    );
    const material = StudyMaterial(id: 'paid', title: 'Paid');
    await expectLater(
      repository.getPublicMaterialAccess(material),
      throwsFormatException,
    );
    await expectLater(
      repository.purchasePublicMaterial(material, expectedPrice: 40),
      throwsFormatException,
    );
  });

  group('saveGroupNote', () {
    test('sends the expected revision and parses the result', () async {
      Map<String, Object?>? requestBody;
      final client = MockClient((request) async {
        requestBody = (jsonDecode(request.body) as Map).cast();
        return http.Response(
          jsonEncode({
            'revision': 8,
            'updatedAt': '2026-07-11T09:30:00.000Z',
          }),
          200,
          request: request,
          headers: {'content-type': 'application/json'},
        );
      });
      final repository = _repository(client);

      final result = await repository.saveGroupNote(
        id: 'note-id',
        title: 'Title',
        content: 'Content',
        expectedRevision: 7,
      );

      expect(requestBody, {
        'p_id': 'note-id',
        'p_title': 'Title',
        'p_content': 'Content',
        'p_expected_revision': 7,
      });
      expect(result.revision, 8);
      expect(result.updatedAt.toUtc(), DateTime.utc(2026, 7, 11, 9, 30));
    });

    test('maps PT409 to a typed conflict', () async {
      final client = MockClient(
        (request) async => http.Response(
          jsonEncode({
            'code': 'PT409',
            'message': 'Group note was modified by another editor',
            'details': null,
            'hint': null,
          }),
          409,
          request: request,
          headers: {'content-type': 'application/json'},
        ),
      );

      await expectLater(
        _repository(client).saveGroupNote(
          id: 'note-id',
          title: 'Title',
          content: 'Content',
          expectedRevision: 7,
        ),
        throwsA(isA<CollabNoteConflictException>()),
      );
    });

    test('rejects malformed success payloads', () async {
      final client = MockClient(
        (request) async => http.Response(
          'null',
          200,
          request: request,
          headers: {'content-type': 'application/json'},
        ),
      );

      await expectLater(
        _repository(client).saveGroupNote(
          id: 'note-id',
          title: 'Title',
          content: 'Content',
          expectedRevision: 0,
        ),
        throwsFormatException,
      );
    });
  });

  test('uses exact mentorship RPC contracts', () async {
    final calls = <(String, Map<String, Object?>)>[];
    final client = MockClient((request) async {
      final method = request.url.pathSegments.reversed.take(1).join();
      final body = Map<String, Object?>.from(jsonDecode(request.body) as Map);
      calls.add((method, body));
      final response = switch (method) {
        'get_mentors' => jsonEncode([
          {
            'userId': 'mentor-1',
            'fullName': 'Mentor',
            'topics': ['python'],
          },
        ]),
        'get_my_mentor_requests' => jsonEncode([
          {
            'id': 'request-1',
            'mentorUserId': 'mentor-1',
            'requesterId': 'requester-1',
            'whenSlot': 'week',
            'status': 'accepted',
          },
        ]),
        'create_mentor_request' => jsonEncode('request-1'),
        _ => 'null',
      };
      return http.Response(
        response,
        200,
        request: request,
        headers: {'content-type': 'application/json'},
      );
    });
    final repository = _repository(client);

    final mentors = await repository.getMentors();
    final requests = await repository.getMyMentorRequests();
    await repository.deleteMentorProfile();
    await repository.createMentorRequest(
      mentorUserId: 'mentor-1',
      topic: 'python',
      whenSlot: 'tomorrow',
      message: 'Help',
    );
    await repository.actOnMentorRequest(
      id: 'request-1',
      action: .confirmComplete,
    );

    final [parsedMentor] = mentors;
    final [parsedRequest] = requests;
    expect(parsedMentor.userId, 'mentor-1');
    expect(parsedRequest.status, MentorRequestStatus.accepted);
    expect(calls.map((call) => call.$1), [
      'get_mentors',
      'get_my_mentor_requests',
      'delete_mentor_profile',
      'create_mentor_request',
      'act_on_mentor_request',
    ]);
    final [mentorsCall, requestsCall, deleteCall, createCall, actionCall] =
        calls;
    expect(mentorsCall.$2, {'p_organization_id': 'university'});
    expect(requestsCall.$2, {'p_organization_id': 'university'});
    expect(deleteCall.$2, {'p_organization_id': 'university'});
    expect(createCall.$2, {
      'p_organization_id': 'university',
      'p_mentor_user_id': 'mentor-1',
      'p_topic': 'python',
      'p_when_slot': 'tomorrow',
      'p_message': 'Help',
    });
    expect(actionCall.$2, {
      'p_id': 'request-1',
      'p_action': 'confirm_complete',
    });
  });

  test('uses exact team lifecycle RPC contracts', () async {
    final calls = <(String, Map<String, Object?>)>[];
    final client = MockClient((request) async {
      final method = request.url.pathSegments.lastOrNull ?? '';
      final body = Map<String, Object?>.from(jsonDecode(request.body) as Map);
      calls.add((method, body));
      final response = switch (method) {
        'get_teams' => jsonEncode([
          {'id': 'team-1', 'title': 'Campus Crew'},
        ]),
        'get_team_applications' => jsonEncode([
          {
            'id': 'application-1',
            'teamId': 'team-1',
            'applicantId': 'user-1',
          },
        ]),
        _ => 'null',
      };
      return http.Response(
        response,
        200,
        request: request,
        headers: {'content-type': 'application/json'},
      );
    });
    final repository = _repository(client);
    final deadline = DateTime.parse('2026-08-01T12:30:00+03:00');

    final teams = await repository.getTeams();
    await repository.createTeam(
      title: 'Campus Crew',
      eventName: 'Demo Day',
      description: 'Build together',
      neededRoles: const ['backend', 'design'],
      capacity: 4,
      kind: 'project',
      deadlineAt: deadline,
      boost: true,
    );
    await repository.applyToTeam(
      teamId: 'team-1',
      role: 'backend',
      message: 'Ready',
      attachProfile: false,
    );
    final applications = await repository.getTeamApplications('team-1');
    await repository.actOnTeamApplication(
      id: 'application-1',
      action: .accept,
    );
    await repository.leaveTeam('team-1');
    await repository.deleteTeam('team-1');

    expect(teams.singleOrNull?.title, 'Campus Crew');
    expect(applications.singleOrNull?.teamId, 'team-1');
    expect(calls.map((call) => call.$1), [
      'get_teams',
      'create_team',
      'apply_to_team',
      'get_team_applications',
      'act_on_team_application',
      'leave_team',
      'delete_team',
    ]);
    final [
      getCall,
      createCall,
      applyCall,
      applicationsCall,
      actionCall,
      leaveCall,
      deleteCall,
    ] = calls;
    expect(getCall.$2, {'p_organization_id': 'university'});
    expect(createCall.$2, {
      'p_organization_id': 'university',
      'p_title': 'Campus Crew',
      'p_event_name': 'Demo Day',
      'p_description': 'Build together',
      'p_needed_roles': ['backend', 'design'],
      'p_capacity': 4,
      'p_kind': 'project',
      'p_deadline_at': '2026-08-01T09:30:00.000Z',
      'p_boost': true,
    });
    expect(applyCall.$2, {
      'p_team_id': 'team-1',
      'p_role': 'backend',
      'p_message': 'Ready',
      'p_attach_profile': false,
    });
    expect(applicationsCall.$2, {'p_team_id': 'team-1'});
    expect(actionCall.$2, {
      'p_id': 'application-1',
      'p_action': 'accept',
    });
    expect(leaveCall.$2, {'p_team_id': 'team-1'});
    expect(deleteCall.$2, {'p_id': 'team-1'});
  });

  test('uses exact marketplace RPC contracts', () async {
    final calls = <(String, Map<String, Object?>)>[];
    final client = MockClient((request) async {
      final method = request.url.pathSegments.lastOrNull ?? '';
      final body = Map<String, Object?>.from(jsonDecode(request.body) as Map);
      calls.add((method, body));
      final response = switch (method) {
        'get_listings' => jsonEncode([
          {
            'id': '123e4567-e89b-42d3-a456-426614174000',
            'title': 'Book',
            'price': 500,
            'showContact': true,
            'sellerHandle': 'seller_user',
          },
        ]),
        'create_listing' => jsonEncode('123e4567-e89b-42d3-a456-426614174001'),
        _ => 'null',
      };
      return http.Response(
        response,
        200,
        request: request,
        headers: {'content-type': 'application/json'},
      );
    });
    final repository = _repository(client);

    final listings = await repository.getListings();
    final id = await repository.createListing(
      title: 'Book',
      price: 500,
      category: 'books',
      description: 'Clean',
      showContact: true,
    );
    await repository.setListingSold(
      id: '123e4567-e89b-42d3-a456-426614174000',
      sold: true,
    );
    await repository.deleteListing(
      '123e4567-e89b-42d3-a456-426614174000',
    );

    expect(listings.singleOrNull?.sellerHandle, 'seller_user');
    expect(id, '123e4567-e89b-42d3-a456-426614174001');
    expect(calls.map((call) => call.$1), [
      'get_listings',
      'create_listing',
      'set_listing_sold',
      'delete_listing',
    ]);
    expect(calls.elementAtOrNull(0)?.$2, {'p_organization_id': 'university'});
    expect(calls.elementAtOrNull(1)?.$2, {
      'p_organization_id': 'university',
      'p_title': 'Book',
      'p_price': 500,
      'p_category': 'books',
      'p_emoji': '📦',
      'p_description': 'Clean',
      'p_show_contact': true,
    });
    expect(calls.elementAtOrNull(2)?.$2, {
      'p_id': '123e4567-e89b-42d3-a456-426614174000',
      'p_sold': true,
    });
    expect(calls.elementAtOrNull(3)?.$2, {
      'p_id': '123e4567-e89b-42d3-a456-426614174000',
    });
  });

  test('createListing rejects a malformed RPC id', () async {
    final client = MockClient(
      (request) async => http.Response(
        jsonEncode('not-a-uuid'),
        200,
        request: request,
        headers: {'content-type': 'application/json'},
      ),
    );

    await expectLater(
      _repository(client).createListing(title: 'Book', price: 500),
      throwsFormatException,
    );
  });
}

CampusRepository _repository(http.Client client) => .new(
  supabase: SupabaseClient(
    'https://project.supabase.co',
    'key',
    httpClient: client,
  ),
  organizationId: 'university',
);

Future<CampusRepository> _signedInRepository(http.Client client) async {
  final supabase = SupabaseClient(
    'https://project.supabase.co',
    'key',
    httpClient: client,
    authOptions: const AuthClientOptions(autoRefreshToken: false),
  );
  addTearDown(supabase.dispose);
  await supabase.auth.setInitialSession(
    jsonEncode({
      'access_token': 'test-access-token',
      'token_type': 'bearer',
      'user': {'id': _materialUserId},
    }),
  );
  return CampusRepository(supabase: supabase, organizationId: 'university');
}
