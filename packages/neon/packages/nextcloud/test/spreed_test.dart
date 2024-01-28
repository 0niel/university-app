import 'dart:async';
import 'dart:convert';

import 'package:built_value/json_object.dart';
import 'package:nextcloud/core.dart' as core;
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/spreed.dart' as spreed;
import 'package:nextcloud_test/nextcloud_test.dart';
import 'package:test/test.dart';
import 'package:test_api/src/backend/invoker.dart';

void main() {
  presets(
    'spreed',
    'spreed',
    (preset) {
      late DockerContainer container;
      late NextcloudClient client1;
      setUpAll(() async {
        container = await DockerContainer.create(preset);
        client1 = await TestNextcloudClient.create(container);
      });
      tearDownAll(() async {
        if (Invoker.current!.liveTest.errors.isNotEmpty) {
          print(await container.allLogs());
        }
        container.destroy();
      });

      Future<spreed.Room> createTestRoom() async => (await client1.spreed.room.createRoom(
            roomType: spreed.RoomType.public.value,
            roomName: 'Test',
          ))
              .body
              .ocs
              .data;

      group('Helpers', () {
        test('Is supported', () async {
          final response = await client1.core.ocs.getCapabilities();
          expect(response.statusCode, 200);
          expect(() => response.headers, isA<void>());

          final result = client1.spreed.getVersionCheck(response.body.ocs.data);
          expect(result.versions, isNotNull);
          expect(result.versions, isNotEmpty);
          expect(result.isSupported, isTrue);
        });

        test('Participant permissions', () async {
          expect(spreed.ParticipantPermission.$default.binary, 0);
          expect(spreed.ParticipantPermission.values.byBinary(0), {spreed.ParticipantPermission.$default});
          expect({spreed.ParticipantPermission.$default}.binary, 0);

          expect(spreed.ParticipantPermission.custom.binary, 1);
          expect(spreed.ParticipantPermission.canSendMessageAndShareAndReact.binary, 128);
          expect(spreed.ParticipantPermission.values.byBinary(129), {
            spreed.ParticipantPermission.custom,
            spreed.ParticipantPermission.canSendMessageAndShareAndReact,
          });
          expect(
            {
              spreed.ParticipantPermission.custom,
              spreed.ParticipantPermission.canSendMessageAndShareAndReact,
            }.binary,
            129,
          );
        });
      });

      group('Room', () {
        test('Get rooms', () async {
          final response = await client1.spreed.room.getRooms();
          expect(response.body.ocs.data, isNotEmpty);
          final room = response.body.ocs.data.singleWhere((room) => room.type == spreed.RoomType.changelog.value);
          expect(room.id, isPositive);
          expect(room.token, isNotEmpty);
          expect(room.type, spreed.RoomType.changelog.value);
          expect(room.name, 'user1');
          expect(room.displayName, 'Talk updates ✅');
          expect(room.participantType, spreed.ParticipantType.user.value);
          expect(spreed.ParticipantPermission.values.byBinary(room.permissions), {
            spreed.ParticipantPermission.startCall,
            spreed.ParticipantPermission.joinCall,
            spreed.ParticipantPermission.canPublishAudio,
            spreed.ParticipantPermission.canPublishVideo,
            spreed.ParticipantPermission.canScreenShare,
            spreed.ParticipantPermission.canSendMessageAndShareAndReact,
          });
        });

        test('Session', () async {
          var room = await createTestRoom();
          expect(room.sessionId, '0');

          final response = await client1.spreed.room.joinRoom(token: room.token);
          expect(response.body.ocs.data.id, room.id);
          expect(response.body.ocs.data.sessionId, isNot(room.sessionId));

          room = (await client1.spreed.room.getSingleRoom(token: room.token)).body.ocs.data;
          expect(room.sessionId, response.body.ocs.data.sessionId);

          await client1.spreed.room.leaveRoom(token: room.token);
          room = (await client1.spreed.room.getSingleRoom(token: room.token)).body.ocs.data;
          expect(room.sessionId, '0');
        });

        group('Create room', () {
          test('One-to-One', () async {
            final response = await client1.spreed.room.createRoom(
              roomType: spreed.RoomType.oneToOne.value,
              invite: 'user2',
            );
            expect(response.body.ocs.data.id, isPositive);
            expect(response.body.ocs.data.token, isNotEmpty);
            expect(response.body.ocs.data.type, spreed.RoomType.oneToOne.value);
            expect(response.body.ocs.data.name, 'user2');
            expect(response.body.ocs.data.displayName, 'User Two');
            expect(response.body.ocs.data.participantType, spreed.ParticipantType.owner.value);
            expect(spreed.ParticipantPermission.values.byBinary(response.body.ocs.data.permissions), {
              spreed.ParticipantPermission.startCall,
              spreed.ParticipantPermission.joinCall,
              spreed.ParticipantPermission.canIgnoreLobby,
              spreed.ParticipantPermission.canPublishAudio,
              spreed.ParticipantPermission.canPublishVideo,
              spreed.ParticipantPermission.canScreenShare,
              spreed.ParticipantPermission.canSendMessageAndShareAndReact,
            });
          });

          test('Group', () async {
            final response = await client1.spreed.room.createRoom(
              roomType: spreed.RoomType.group.value,
              invite: 'admin',
            );
            expect(response.body.ocs.data.id, isPositive);
            expect(response.body.ocs.data.token, isNotEmpty);
            expect(response.body.ocs.data.type, spreed.RoomType.group.value);
            expect(response.body.ocs.data.name, 'admin');
            expect(response.body.ocs.data.displayName, 'admin');
            expect(response.body.ocs.data.participantType, spreed.ParticipantType.owner.value);
            expect(spreed.ParticipantPermission.values.byBinary(response.body.ocs.data.permissions), {
              spreed.ParticipantPermission.startCall,
              spreed.ParticipantPermission.joinCall,
              spreed.ParticipantPermission.canIgnoreLobby,
              spreed.ParticipantPermission.canPublishAudio,
              spreed.ParticipantPermission.canPublishVideo,
              spreed.ParticipantPermission.canScreenShare,
              spreed.ParticipantPermission.canSendMessageAndShareAndReact,
            });
          });

          test('Public', () async {
            final response = await client1.spreed.room.createRoom(
              roomType: spreed.RoomType.public.value,
              roomName: 'abc',
            );
            expect(response.body.ocs.data.id, isPositive);
            expect(response.body.ocs.data.token, isNotEmpty);
            expect(response.body.ocs.data.type, spreed.RoomType.public.value);
            expect(response.body.ocs.data.name, 'abc');
            expect(response.body.ocs.data.displayName, 'abc');
            expect(response.body.ocs.data.participantType, spreed.ParticipantType.owner.value);
            expect(spreed.ParticipantPermission.values.byBinary(response.body.ocs.data.permissions), {
              spreed.ParticipantPermission.startCall,
              spreed.ParticipantPermission.joinCall,
              spreed.ParticipantPermission.canIgnoreLobby,
              spreed.ParticipantPermission.canPublishAudio,
              spreed.ParticipantPermission.canPublishVideo,
              spreed.ParticipantPermission.canScreenShare,
              spreed.ParticipantPermission.canSendMessageAndShareAndReact,
            });
          });
        });
      });

      group('Chat', () {
        test('Send message', () async {
          final startTime = DateTime.now();
          final room = await createTestRoom();

          final response = await client1.spreed.chat.sendMessage(
            token: room.token,
            message: 'bla',
          );
          expect(response.body.ocs.data!.id, isPositive);
          expect(response.body.ocs.data!.actorType, spreed.ActorType.users.name);
          expect(response.body.ocs.data!.actorId, 'user1');
          expect(response.body.ocs.data!.actorDisplayName, 'User One');
          expect(response.body.ocs.data!.timestamp * 1000, closeTo(startTime.millisecondsSinceEpoch, 10E3));
          expect(response.body.ocs.data!.message, 'bla');
          expect(response.body.ocs.data!.messageType, spreed.MessageType.comment.name);
        });

        group('Get messages', () {
          test('Directly', () async {
            final startTime = DateTime.now();
            final room = await createTestRoom();
            await client1.spreed.chat.sendMessage(
              token: room.token,
              message: '123',
              replyTo: (await client1.spreed.chat.sendMessage(
                token: room.token,
                message: 'bla',
              ))
                  .body
                  .ocs
                  .data!
                  .id,
            );

            final response = await client1.spreed.chat.receiveMessages(
              token: room.token,
              lookIntoFuture: spreed.ChatReceiveMessagesLookIntoFuture.$0,
            );
            expect(response.headers.xChatLastGiven, isNotEmpty);
            expect(response.headers.xChatLastCommonRead, isNotEmpty);

            expect(response.body.ocs.data, hasLength(3));

            expect(response.body.ocs.data[0].id, isPositive);
            expect(response.body.ocs.data[0].actorType, spreed.ActorType.users.name);
            expect(response.body.ocs.data[0].actorId, 'user1');
            expect(response.body.ocs.data[0].actorDisplayName, 'User One');
            expect(response.body.ocs.data[0].timestamp * 1000, closeTo(startTime.millisecondsSinceEpoch, 10E3));
            expect(response.body.ocs.data[0].message, '123');
            expect(response.body.ocs.data[0].messageType, spreed.MessageType.comment.name);

            expect(response.body.ocs.data[0].parent!.id, isPositive);
            expect(response.body.ocs.data[0].parent!.actorType, spreed.ActorType.users.name);
            expect(response.body.ocs.data[0].parent!.actorId, 'user1');
            expect(response.body.ocs.data[0].parent!.actorDisplayName, 'User One');
            expect(
              response.body.ocs.data[0].parent!.timestamp * 1000,
              closeTo(startTime.millisecondsSinceEpoch, 10E3),
            );
            expect(response.body.ocs.data[0].parent!.message, 'bla');
            expect(response.body.ocs.data[0].parent!.messageType, spreed.MessageType.comment.name);

            expect(response.body.ocs.data[1].id, isPositive);
            expect(response.body.ocs.data[1].actorType, spreed.ActorType.users.name);
            expect(response.body.ocs.data[1].actorId, 'user1');
            expect(response.body.ocs.data[1].actorDisplayName, 'User One');
            expect(response.body.ocs.data[1].timestamp * 1000, closeTo(startTime.millisecondsSinceEpoch, 10E3));
            expect(response.body.ocs.data[1].message, 'bla');
            expect(response.body.ocs.data[1].messageType, spreed.MessageType.comment.name);

            expect(response.body.ocs.data[2].id, isPositive);
            expect(response.body.ocs.data[2].actorType, spreed.ActorType.users.name);
            expect(response.body.ocs.data[2].actorId, 'user1');
            expect(response.body.ocs.data[2].actorDisplayName, 'User One');
            expect(response.body.ocs.data[2].timestamp * 1000, closeTo(startTime.millisecondsSinceEpoch, 10E3));
            expect(response.body.ocs.data[2].message, 'You created the conversation');
            expect(response.body.ocs.data[2].systemMessage, 'conversation_created');
            expect(response.body.ocs.data[2].messageType, spreed.MessageType.system.name);
          });

          test('Polling', () async {
            final startTime = DateTime.now();

            final room = await createTestRoom();
            final message = (await client1.spreed.chat.sendMessage(
              token: room.token,
              message: 'bla',
            ))
                .body
                .ocs
                .data!;
            unawaited(
              Future<void>.delayed(const Duration(seconds: 1)).then((_) async {
                await client1.spreed.chat.sendMessage(
                  token: room.token,
                  message: '123',
                );
              }),
            );

            final response = await client1.spreed.chat.receiveMessages(
              token: room.token,
              lookIntoFuture: spreed.ChatReceiveMessagesLookIntoFuture.$1,
              timeout: 3,
              lastKnownMessageId: message.id,
            );
            expect(response.body.ocs.data, hasLength(1));
            expect(response.body.ocs.data[0].id, isPositive);
            expect(response.body.ocs.data[0].actorType, spreed.ActorType.users.name);
            expect(response.body.ocs.data[0].actorId, 'user1');
            expect(response.body.ocs.data[0].actorDisplayName, 'User One');
            expect(response.body.ocs.data[0].timestamp * 1000, closeTo(startTime.millisecondsSinceEpoch, 10E3));
            expect(response.body.ocs.data[0].message, '123');
            expect(response.body.ocs.data[0].messageType, spreed.MessageType.comment.name);
          });
        });
      });

      group('Call', () {
        test('Start and end call', () async {
          var room = await createTestRoom();
          expect(room.hasCall, isFalse);
          room = (await client1.spreed.room.joinRoom(token: room.token)).body.ocs.data;

          await client1.spreed.call.joinCall(token: room.token);
          room = (await client1.spreed.room.getSingleRoom(token: room.token)).body.ocs.data;
          expect(room.hasCall, isTrue);

          await client1.spreed.call.leaveCall(token: room.token);
          room = (await client1.spreed.room.getSingleRoom(token: room.token)).body.ocs.data;
          expect(room.hasCall, isFalse);
        });
      });

      group('Signaling', () {
        test('Get settings', () async {
          final room = await createTestRoom();

          final response = await client1.spreed.signaling.getSettings(token: room.token);
          expect(response.body.ocs.data.signalingMode, 'internal');
          expect(response.body.ocs.data.userId, 'user1');
          expect(response.body.ocs.data.hideWarning, false);
          expect(response.body.ocs.data.server, '');
          expect(response.body.ocs.data.ticket, contains(':user1:'));
          expect(response.body.ocs.data.helloAuthParams.$10.userid, 'user1');
          expect(response.body.ocs.data.helloAuthParams.$10.ticket, contains(':user1:'));
          expect(
            response.body.ocs.data.helloAuthParams.$20.token.split('').where((x) => x == '.'),
            hasLength(2),
          );
          expect(response.body.ocs.data.stunservers, hasLength(1));
          expect(response.body.ocs.data.stunservers[0].urls, hasLength(1));
          expect(response.body.ocs.data.stunservers[0].urls[0], 'stun:stun.nextcloud.com:443');
          expect(response.body.ocs.data.turnservers, hasLength(1));
          expect(response.body.ocs.data.turnservers[0].urls, hasLength(4));
          expect(
            response.body.ocs.data.turnservers[0].urls[0],
            'turn:staticauth.openrelay.metered.ca:443?transport=udp',
          );
          expect(
            response.body.ocs.data.turnservers[0].urls[1],
            'turn:staticauth.openrelay.metered.ca:443?transport=tcp',
          );
          expect(
            response.body.ocs.data.turnservers[0].urls[2],
            'turns:staticauth.openrelay.metered.ca:443?transport=udp',
          );
          expect(
            response.body.ocs.data.turnservers[0].urls[3],
            'turns:staticauth.openrelay.metered.ca:443?transport=tcp',
          );
          expect(response.body.ocs.data.turnservers[0].username, isNotEmpty);
          expect((response.body.ocs.data.turnservers[0].credential as StringJsonObject).asString, isNotEmpty);
          expect(response.body.ocs.data.sipDialinInfo, '');
        });

        test('Send and receive messages', () async {
          final room = await createTestRoom();

          final room1 = (await client1.spreed.room.joinRoom(token: room.token)).body.ocs.data;
          await client1.spreed.call.joinCall(token: room.token);

          final client2 = await TestNextcloudClient.create(
            container,
            username: 'user2',
          );

          final room2 = (await client2.spreed.room.joinRoom(token: room.token)).body.ocs.data;
          await client2.spreed.call.joinCall(token: room.token);

          await client1.spreed.signaling.sendMessages(
            token: room.token,
            messages: json.encode([
              {
                'ev': 'message',
                'sessionId': room1.sessionId,
                'fn': json.encode({
                  'to': room2.sessionId,
                }),
              },
            ]),
          );

          await Future<void>.delayed(const Duration(seconds: 1));

          final messages = (await client2.spreed.signaling.pullMessages(token: room.token)).body.ocs.data;
          expect(messages, hasLength(2));
          expect(messages[0].type, 'message');
          expect(json.decode(messages[0].data.string!), {'to': room2.sessionId, 'from': room1.sessionId});
          expect(messages[1].type, 'usersInRoom');
          expect(messages[1].data.builtListSignalingSession, hasLength(2));
          expect(messages[1].data.builtListSignalingSession![0].userId, 'user1');
          expect(messages[1].data.builtListSignalingSession![1].userId, 'user2');
        });
      });
    },
    retry: retryCount,
    timeout: timeout,
  );
}
