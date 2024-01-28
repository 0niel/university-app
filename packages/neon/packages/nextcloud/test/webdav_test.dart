import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:mocktail/mocktail.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud_test/nextcloud_test.dart';
import 'package:test/test.dart';
import 'package:test_api/src/backend/invoker.dart';
import 'package:universal_io/io.dart';

class MockCallbackFunction extends Mock {
  void progressCallback(double progress);
}

void main() {
  group('constructUri', () {
    for (final values in [
      ('http://cloud.example.com', 'http://cloud.example.com'),
      ('http://cloud.example.com/', 'http://cloud.example.com'),
      ('http://cloud.example.com/subdir', 'http://cloud.example.com/subdir'),
      ('http://cloud.example.com/subdir/', 'http://cloud.example.com/subdir'),
    ]) {
      final baseURL = Uri.parse(values.$1);
      final sanitizedBaseURL = Uri.parse(values.$2);

      test(baseURL, () {
        expect(
          WebDavClient.constructUri(baseURL).toString(),
          '$sanitizedBaseURL$webdavBase',
        );
        expect(
          WebDavClient.constructUri(baseURL, PathUri.parse('/')).toString(),
          '$sanitizedBaseURL$webdavBase',
        );
        expect(
          WebDavClient.constructUri(baseURL, PathUri.parse('test')).toString(),
          '$sanitizedBaseURL$webdavBase/test',
        );
        expect(
          WebDavClient.constructUri(baseURL, PathUri.parse('test/')).toString(),
          '$sanitizedBaseURL$webdavBase/test',
        );
        expect(
          WebDavClient.constructUri(baseURL, PathUri.parse('/test')).toString(),
          '$sanitizedBaseURL$webdavBase/test',
        );
        expect(
          WebDavClient.constructUri(baseURL, PathUri.parse('/test/')).toString(),
          '$sanitizedBaseURL$webdavBase/test',
        );
      });
    }
  });

  group('PathUri', () {
    test('isAbsolute', () {
      expect(PathUri.parse('').isAbsolute, false);
      expect(PathUri.parse('/').isAbsolute, true);
      expect(PathUri.parse('test').isAbsolute, false);
      expect(PathUri.parse('test/').isAbsolute, false);
      expect(PathUri.parse('/test').isAbsolute, true);
      expect(PathUri.parse('/test/').isAbsolute, true);
    });

    test('isDirectory', () {
      expect(PathUri.parse('').isDirectory, true);
      expect(PathUri.parse('/').isDirectory, true);
      expect(PathUri.parse('test').isDirectory, false);
      expect(PathUri.parse('test/').isDirectory, true);
      expect(PathUri.parse('/test').isDirectory, false);
      expect(PathUri.parse('/test/').isDirectory, true);
    });

    test('pathSegments', () {
      expect(PathUri.parse('').pathSegments, isEmpty);
      expect(PathUri.parse('/').pathSegments, isEmpty);
      expect(PathUri.parse('test').pathSegments, ['test']);
      expect(PathUri.parse('test/').pathSegments, ['test']);
      expect(PathUri.parse('/test').pathSegments, ['test']);
      expect(PathUri.parse('/test/').pathSegments, ['test']);
    });

    test('path', () {
      expect(PathUri.parse('').path, '');
      expect(PathUri.parse('/').path, '/');
      expect(PathUri.parse('test').path, 'test');
      expect(PathUri.parse('test/').path, 'test/');
      expect(PathUri.parse('/test').path, '/test');
      expect(PathUri.parse('/test/').path, '/test/');
    });

    test('normalization', () {
      expect(PathUri.parse('/test/abc/').path, '/test/abc/');
      expect(PathUri.parse('//test//abc//').path, '/test/abc/');
      expect(PathUri.parse('///test///abc///').path, '/test/abc/');
    });

    test('name', () {
      expect(PathUri.parse('').name, '');
      expect(PathUri.parse('test').name, 'test');
      expect(PathUri.parse('/test/').name, 'test');
      expect(PathUri.parse('abc/test').name, 'test');
      expect(PathUri.parse('/abc/test/').name, 'test');
    });

    test('parent', () {
      expect(PathUri.parse('').parent, null);
      expect(PathUri.parse('/').parent, null);
      expect(PathUri.parse('test').parent, PathUri.parse(''));
      expect(PathUri.parse('test/abc').parent, PathUri.parse('test/'));
      expect(PathUri.parse('test/abc/').parent, PathUri.parse('test/'));
      expect(PathUri.parse('/test/abc').parent, PathUri.parse('/test/'));
      expect(PathUri.parse('/test/abc/').parent, PathUri.parse('/test/'));
    });

    test('join', () {
      expect(PathUri.parse('').join(PathUri.parse('test')), PathUri.parse('test'));
      expect(PathUri.parse('/').join(PathUri.parse('test')), PathUri.parse('/test'));
      expect(() => PathUri.parse('test').join(PathUri.parse('abc')), throwsA(isA<StateError>()));
      expect(PathUri.parse('test/').join(PathUri.parse('abc')), PathUri.parse('test/abc'));
      expect(PathUri.parse('test/').join(PathUri.parse('abc/123')), PathUri.parse('test/abc/123'));
      expect(PathUri.parse('/test/').join(PathUri.parse('abc')), PathUri.parse('/test/abc'));
      expect(PathUri.parse('/test/').join(PathUri.parse('/abc')), PathUri.parse('/test/abc'));
      expect(PathUri.parse('/test/').join(PathUri.parse('/abc/')), PathUri.parse('/test/abc/'));
    });

    test('rename', () {
      expect(PathUri.parse('').rename('test'), PathUri.parse(''));
      expect(PathUri.parse('test').rename('abc'), PathUri.parse('abc'));
      expect(PathUri.parse('test/').rename('abc'), PathUri.parse('abc/'));
      expect(PathUri.parse('test/abc').rename('123'), PathUri.parse('test/123'));
      expect(PathUri.parse('test/abc/').rename('123'), PathUri.parse('test/123/'));
      expect(() => PathUri.parse('test').rename('abc/'), throwsA(isA<Exception>()));
      expect(() => PathUri.parse('test/').rename('abc/'), throwsA(isA<Exception>()));
      expect(() => PathUri.parse('test').rename('/abc'), throwsA(isA<Exception>()));
      expect(() => PathUri.parse('test/').rename('/abc'), throwsA(isA<Exception>()));
      expect(() => PathUri.parse('test').rename('abc/123'), throwsA(isA<Exception>()));
      expect(() => PathUri.parse('test/').rename('abc/123'), throwsA(isA<Exception>()));
    });
  });

  presets(
    'server',
    'webdav',
    (preset) {
      late DockerContainer container;
      late NextcloudClient client;

      setUpAll(() async {
        container = await DockerContainer.create(preset);
        client = await TestNextcloudClient.create(container);
      });
      tearDownAll(() async {
        if (Invoker.current!.liveTest.errors.isNotEmpty) {
          print(await container.allLogs());
        }
        container.destroy();
      });

      test('List directory', () async {
        final responses = (await client.webdav.propfind(
          PathUri.parse('/'),
          prop: const WebDavPropWithoutValues.fromBools(
            nchaspreview: true,
            davgetcontenttype: true,
            davgetlastmodified: true,
            ocsize: true,
          ),
        ))
            .responses;
        expect(responses, isNotEmpty);
        final props =
            responses.singleWhere((response) => response.href!.endsWith('/Nextcloud.png')).propstats.first.prop;
        expect(props.nchaspreview, isTrue);
        expect(props.davgetcontenttype, 'image/png');
        expect(webdavDateFormat.parseUtc(props.davgetlastmodified!).isBefore(DateTime.now()), isTrue);
        expect(props.ocsize, 50598);
      });

      test('List directory recursively', () async {
        final responses = (await client.webdav.propfind(
          PathUri.parse('/'),
          depth: WebDavDepth.infinity,
        ))
            .responses;
        expect(responses, isNotEmpty);
      });

      test('Get file props', () async {
        final response = (await client.webdav.propfind(
          PathUri.parse('Nextcloud.png'),
          prop: const WebDavPropWithoutValues.fromBools(
            davgetlastmodified: true,
            davgetetag: true,
            davgetcontenttype: true,
            davgetcontentlength: true,
            davresourcetype: true,
            ocid: true,
            ocfileid: true,
            ocfavorite: true,
            occommentshref: true,
            occommentscount: true,
            occommentsunread: true,
            ocdownloadurl: true,
            ocownerid: true,
            ocownerdisplayname: true,
            ocsize: true,
            ocpermissions: true,
            ncnote: true,
            ncdatafingerprint: true,
            nchaspreview: true,
            ncmounttype: true,
            ncisencrypted: true,
            ncmetadataetag: true,
            ncuploadtime: true,
            nccreationtime: true,
            ncrichworkspace: true,
            ocssharepermissions: true,
            ocmsharepermissions: true,
          ),
        ))
            .toWebDavFiles()
            .single;

        expect(response.path, PathUri.parse('Nextcloud.png'));
        expect(response.id, isNotEmpty);
        expect(response.fileId, isNotEmpty);
        expect(response.isCollection, isFalse);
        expect(response.mimeType, 'image/png');
        expect(response.etag, isNotEmpty);
        expect(response.size, 50598);
        expect(response.ownerId, 'user1');
        expect(response.ownerDisplay, 'User One');
        expect(response.lastModified!.isBefore(DateTime.now()), isTrue);
        expect(response.isDirectory, isFalse);
        expect(response.uploadedDate, DateTime.utc(1970));
        expect(response.createdDate, DateTime.utc(1970));
        expect(response.favorite, isFalse);
        expect(response.hasPreview, isTrue);
        expect(response.name, 'Nextcloud.png');
        expect(response.isDirectory, isFalse);

        expect(webdavDateFormat.parseUtc(response.props.davgetlastmodified!).isBefore(DateTime.now()), isTrue);
        expect(response.props.davgetetag, isNotEmpty);
        expect(response.props.davgetcontenttype, 'image/png');
        expect(response.props.davgetcontentlength, 50598);
        expect(response.props.davresourcetype!.collection, isNull);
        expect(response.props.ocid, isNotEmpty);
        expect(response.props.ocfileid, isNotEmpty);
        expect(response.props.ocfavorite, 0);
        expect(response.props.occommentshref, isNotEmpty);
        expect(response.props.occommentscount, 0);
        expect(response.props.occommentsunread, 0);
        expect(response.props.ocdownloadurl, isNull);
        expect(response.props.ocownerid, 'user1');
        expect(response.props.ocownerdisplayname, 'User One');
        expect(response.props.ocsize, 50598);
        expect(response.props.ocpermissions, 'RGDNVW');
        expect(response.props.ncnote, isNull);
        expect(response.props.ncdatafingerprint, isNull);
        expect(response.props.nchaspreview, isTrue);
        expect(response.props.ncmounttype, isNull);
        expect(response.props.ncisencrypted, isNull);
        expect(response.props.ncmetadataetag, isNull);
        expect(response.props.ncuploadtime, 0);
        expect(response.props.nccreationtime, 0);
        expect(response.props.ncrichworkspace, isNull);
        expect(response.props.ocssharepermissions, 19);
        expect(json.decode(response.props.ocmsharepermissions!), ['share', 'read', 'write']);
      });

      test('Get directory props', () async {
        final data = utf8.encode('test');
        await client.webdav.mkcol(PathUri.parse('dir-props'));
        await client.webdav.put(data, PathUri.parse('dir-props/test.txt'));

        final response = (await client.webdav.propfind(
          PathUri.parse('dir-props'),
          prop: const WebDavPropWithoutValues.fromBools(
            davgetcontenttype: true,
            davgetlastmodified: true,
            davresourcetype: true,
            ocsize: true,
          ),
          depth: WebDavDepth.zero,
        ))
            .toWebDavFiles()
            .single;

        expect(response.path, PathUri.parse('dir-props/'));
        expect(response.isCollection, isTrue);
        expect(response.mimeType, isNull);
        expect(response.size, data.lengthInBytes);
        expect(
          response.lastModified!.millisecondsSinceEpoch,
          closeTo(DateTime.now().millisecondsSinceEpoch, 10E3),
        );
        expect(response.name, 'dir-props');
        expect(response.isDirectory, isTrue);

        expect(response.props.davgetcontenttype, isNull);
        expect(
          webdavDateFormat.parseUtc(response.props.davgetlastmodified!).millisecondsSinceEpoch,
          closeTo(DateTime.now().millisecondsSinceEpoch, 10E3),
        );
        expect(response.props.davresourcetype!.collection, isNotNull);
        expect(response.props.ocsize, data.lengthInBytes);
      });

      test('Filter files', () async {
        final response = await client.webdav.put(utf8.encode('test'), PathUri.parse('filter.txt'));
        final id = response.headers['oc-fileid'];
        await client.webdav.proppatch(
          PathUri.parse('filter.txt'),
          set: const WebDavProp(
            ocfavorite: 1,
          ),
        );

        final responses = (await client.webdav.report(
          PathUri.parse('/'),
          const WebDavOcFilterRules(
            ocfavorite: 1,
          ),
          prop: const WebDavPropWithoutValues.fromBools(
            ocid: true,
            ocfavorite: true,
          ),
        ))
            .responses;
        expect(responses, isNotEmpty);
        final props = responses.singleWhere((response) => response.href!.endsWith('/filter.txt')).propstats.first.prop;
        expect(props.ocid, id);
        expect(props.ocfavorite, 1);
      });

      test('Set properties', () async {
        final lastModifiedDate = DateTime.utc(1972, 3);
        final createdDate = DateTime.utc(1971, 2);
        final uploadTime = DateTime.now();

        await client.webdav.put(
          utf8.encode('test'),
          PathUri.parse('set-props.txt'),
          lastModified: lastModifiedDate,
          created: createdDate,
        );

        final updated = await client.webdav.proppatch(
          PathUri.parse('set-props.txt'),
          set: const WebDavProp(
            ocfavorite: 1,
          ),
        );
        expect(updated, isTrue);

        final props = (await client.webdav.propfind(
          PathUri.parse('set-props.txt'),
          prop: const WebDavPropWithoutValues.fromBools(
            ocfavorite: true,
            davgetlastmodified: true,
            nccreationtime: true,
            ncuploadtime: true,
          ),
        ))
            .responses
            .single
            .propstats
            .first
            .prop;
        expect(props.ocfavorite, 1);
        expect(webdavDateFormat.parseUtc(props.davgetlastmodified!), lastModifiedDate);
        expect(props.nccreationtime! * 1000, createdDate.millisecondsSinceEpoch);
        expect(props.ncuploadtime! * 1000, closeTo(uploadTime.millisecondsSinceEpoch, 10E3));
      });

      test('Remove properties', () async {
        await client.webdav.put(utf8.encode('test'), PathUri.parse('remove-props.txt'));

        var updated = await client.webdav.proppatch(
          PathUri.parse('remove-props.txt'),
          set: const WebDavProp(
            ocfavorite: 1,
          ),
        );
        expect(updated, isTrue);

        var props = (await client.webdav.propfind(
          PathUri.parse('remove-props.txt'),
          prop: const WebDavPropWithoutValues.fromBools(
            ocfavorite: true,
            nccreationtime: true,
            ncuploadtime: true,
          ),
        ))
            .responses
            .single
            .propstats
            .first
            .prop;
        expect(props.ocfavorite, 1);

        updated = await client.webdav.proppatch(
          PathUri.parse('remove-props.txt'),
          remove: const WebDavPropWithoutValues.fromBools(
            ocfavorite: true,
          ),
        );
        expect(updated, isFalse);

        props = (await client.webdav.propfind(
          PathUri.parse('remove-props.txt'),
          prop: const WebDavPropWithoutValues.fromBools(
            ocfavorite: true,
          ),
        ))
            .responses
            .single
            .propstats
            .first
            .prop;
        expect(props.ocfavorite, 0);
      });

      test('Upload and download file', () async {
        final destinationDir = Directory.systemTemp.createTempSync();
        final destination = File('${destinationDir.path}/test.png');
        final source = File('test/files/test.png');
        final progressValues = <double>[];

        await client.webdav.putFile(
          source,
          source.statSync(),
          PathUri.parse('upload.png'),
          onProgress: progressValues.add,
        );
        await client.webdav.getFile(
          PathUri.parse('upload.png'),
          destination,
          onProgress: progressValues.add,
        );
        expect(progressValues, containsAll([1.0, 1.0]));
        expect(destination.readAsBytesSync(), source.readAsBytesSync());

        destinationDir.deleteSync(recursive: true);
      });

      group('litmus', () {
        group('basic', () {
          test('options', () async {
            final options = await client.webdav.options();
            expect(options.capabilities, contains('1'));
            expect(options.capabilities, contains('3'));
            // Nextcloud only contains a fake plugin for Class 2 support: https://github.com/nextcloud/server/blob/master/apps/dav/lib/Connector/Sabre/FakeLockerPlugin.php
            // It does not actually support locking and is only there for compatibility reasons.
            expect(options.capabilities, isNot(contains('2')));
          });

          for (final (name, path) in [
            ('put_get', 'res'),
            ('put_get_utf8_segment', 'res-%e2%82%ac'),
          ]) {
            test(name, () async {
              final content = utf8.encode('This is a test file');

              final response = await client.webdav.put(content, PathUri.parse(path));
              expect(response.statusCode, 201);

              final downloadedContent = await client.webdav.get(PathUri.parse(path));
              expect(downloadedContent, equals(content));
            });
          }

          test('put_no_parent', () async {
            await expectLater(
              () => client.webdav.put(Uint8List(0), PathUri.parse('409me/noparent.txt')),
              // https://github.com/nextcloud/server/issues/39625
              throwsA(predicate<DynamiteStatusCodeException>((e) => e.statusCode == 409)),
            );
          });

          test('delete', () async {
            await client.webdav.put(Uint8List(0), PathUri.parse('delete.txt'));

            final response = await client.webdav.delete(PathUri.parse('delete.txt'));
            expect(response.statusCode, 204);
          });

          test('delete_null', () async {
            await expectLater(
              () => client.webdav.delete(PathUri.parse('delete-null.txt')),
              throwsA(predicate<DynamiteStatusCodeException>((e) => e.statusCode == 404)),
            );
          });

          // delete_fragment: This test is not applicable because the fragment is already removed on the client side

          test('mkcol', () async {
            final response = await client.webdav.mkcol(PathUri.parse('mkcol'));
            expect(response.statusCode, 201);
          });

          test('mkcol_again', () async {
            await client.webdav.mkcol(PathUri.parse('mkcol-again'));

            await expectLater(
              () => client.webdav.mkcol(PathUri.parse('mkcol-again')),
              throwsA(predicate<DynamiteStatusCodeException>((e) => e.statusCode == 405)),
            );
          });

          test('delete_coll', () async {
            var response = await client.webdav.mkcol(PathUri.parse('delete-coll'));

            response = await client.webdav.delete(PathUri.parse('delete-coll'));
            expect(response.statusCode, 204);
          });

          test('mkcol_no_parent', () async {
            await expectLater(
              () => client.webdav.mkcol(PathUri.parse('409me/noparent')),
              throwsA(predicate<DynamiteStatusCodeException>((e) => e.statusCode == 409)),
            );
          });

          // mkcol_with_body: This test is not applicable because we only write valid request bodies
        });

        group('copymove', () {
          test('copy_simple', () async {
            await client.webdav.mkcol(PathUri.parse('copy-simple-src'));

            final response =
                await client.webdav.copy(PathUri.parse('copy-simple-src'), PathUri.parse('copy-simple-dst'));
            expect(response.statusCode, 201);
          });

          test('copy_overwrite', () async {
            await client.webdav.mkcol(PathUri.parse('copy-overwrite-src'));
            await client.webdav.mkcol(PathUri.parse('copy-overwrite-dst'));

            await expectLater(
              () => client.webdav.copy(PathUri.parse('copy-overwrite-src'), PathUri.parse('copy-overwrite-dst')),
              throwsA(predicate<DynamiteStatusCodeException>((e) => e.statusCode == 412)),
            );

            final response = await client.webdav
                .copy(PathUri.parse('copy-overwrite-src'), PathUri.parse('copy-overwrite-dst'), overwrite: true);
            expect(response.statusCode, 204);
          });

          test('copy_nodestcoll', () async {
            await client.webdav.mkcol(PathUri.parse('copy-nodestcoll-src'));

            await expectLater(
              () => client.webdav.copy(PathUri.parse('copy-nodestcoll-src'), PathUri.parse('nonesuch/dst')),
              throwsA(predicate<DynamiteStatusCodeException>((e) => e.statusCode == 409)),
            );
          });

          test('copy_coll', () async {
            await client.webdav.mkcol(PathUri.parse('copy-coll-src'));
            await client.webdav.mkcol(PathUri.parse('copy-coll-src/sub'));
            for (var i = 0; i < 10; i++) {
              await client.webdav.put(Uint8List(0), PathUri.parse('copy-coll-src/$i.txt'));
            }
            await client.webdav.copy(PathUri.parse('copy-coll-src'), PathUri.parse('copy-coll-dst1'));
            await client.webdav.copy(PathUri.parse('copy-coll-src'), PathUri.parse('copy-coll-dst2'));

            await expectLater(
              () => client.webdav.copy(PathUri.parse('copy-coll-src'), PathUri.parse('copy-coll-dst1')),
              throwsA(predicate<DynamiteStatusCodeException>((e) => e.statusCode == 412)),
            );

            var response = await client.webdav
                .copy(PathUri.parse('copy-coll-src'), PathUri.parse('copy-coll-dst2'), overwrite: true);
            expect(response.statusCode, 204);

            for (var i = 0; i < 10; i++) {
              response = await client.webdav.delete(PathUri.parse('copy-coll-dst1/$i.txt'));
              expect(response.statusCode, 204);
            }

            response = await client.webdav.delete(PathUri.parse('copy-coll-dst1/sub'));
            expect(response.statusCode, 204);

            response = await client.webdav.delete(PathUri.parse('copy-coll-dst2'));
            expect(response.statusCode, 204);
          });

          // copy_shallow: Does not work on litmus, let's wait for https://github.com/nextcloud/server/issues/39627

          test('move', () async {
            await client.webdav.put(Uint8List(0), PathUri.parse('move-src1.txt'));
            await client.webdav.put(Uint8List(0), PathUri.parse('move-src2.txt'));
            await client.webdav.mkcol(PathUri.parse('move-coll'));

            var response = await client.webdav.move(PathUri.parse('move-src1.txt'), PathUri.parse('move-dst.txt'));
            expect(response.statusCode, 201);

            await expectLater(
              () => client.webdav.move(PathUri.parse('move-src2.txt'), PathUri.parse('move-dst.txt')),
              throwsA(predicate<DynamiteStatusCodeException>((e) => e.statusCode == 412)),
            );

            response = await client.webdav
                .move(PathUri.parse('move-src2.txt'), PathUri.parse('move-dst.txt'), overwrite: true);
            expect(response.statusCode, 204);
          });

          test('move_coll', () async {
            await client.webdav.mkcol(PathUri.parse('move-coll-src'));
            await client.webdav.mkcol(PathUri.parse('move-coll-src/sub'));
            for (var i = 0; i < 10; i++) {
              await client.webdav.put(Uint8List(0), PathUri.parse('move-coll-src/$i.txt'));
            }
            await client.webdav.put(Uint8List(0), PathUri.parse('move-coll-noncoll'));
            await client.webdav.copy(PathUri.parse('move-coll-src'), PathUri.parse('move-coll-dst2'));
            await client.webdav.move(PathUri.parse('move-coll-src'), PathUri.parse('move-coll-dst1'));

            await expectLater(
              () => client.webdav.move(PathUri.parse('move-coll-dst1'), PathUri.parse('move-coll-dst2')),
              throwsA(predicate<DynamiteStatusCodeException>((e) => e.statusCode == 412)),
            );

            await client.webdav.move(PathUri.parse('move-coll-dst2'), PathUri.parse('move-coll-dst1'), overwrite: true);
            await client.webdav.copy(PathUri.parse('move-coll-dst1'), PathUri.parse('move-coll-dst2'));

            for (var i = 0; i < 10; i++) {
              final response = await client.webdav.delete(PathUri.parse('move-coll-dst1/$i.txt'));
              expect(response.statusCode, 204);
            }

            final response = await client.webdav.delete(PathUri.parse('move-coll-dst1/sub'));
            expect(response.statusCode, 204);

            await expectLater(
              () => client.webdav.move(PathUri.parse('move-coll-dst2'), PathUri.parse('move-coll-noncoll')),
              throwsA(predicate<DynamiteStatusCodeException>((e) => e.statusCode == 412)),
            );
          });
        });

        group('largefile', () {
          final largefileSize = pow(10, 9).toInt(); // 1GB

          // large_put: Already covered by large_get

          test('large_get', () async {
            final response = await client.webdav.put(Uint8List(largefileSize), PathUri.parse('largefile.txt'));
            expect(response.statusCode, 201);

            final downloadedContent = await client.webdav.get(PathUri.parse('largefile.txt'));
            expect(downloadedContent, hasLength(largefileSize));
          });
        });

        // props: Most of them are either not applicable or hard/impossible to implement because we don't allow just writing any props
      });

      test('Upload and download empty file', () async {
        final callback = MockCallbackFunction();

        final destinationDir = Directory.systemTemp.createTempSync();
        final destination = File('${destinationDir.path}/empty-file');
        final source = File('${destinationDir.path}/empty-file-source')..createSync();

        await client.webdav.putFile(
          source,
          source.statSync(),
          PathUri.parse('empty-file'),
        );
        await client.webdav.getFile(
          PathUri.parse('empty-file'),
          destination,
          onProgress: callback.progressCallback,
        );

        verify(() => callback.progressCallback(1)).called(1);
        verifyNever(() => callback.progressCallback(any(that: isNot(1))));

        expect(destination.readAsBytesSync(), isEmpty);
        destinationDir.deleteSync(recursive: true);
      });
    },
    retry: retryCount,
    timeout: timeout,
  );
}
