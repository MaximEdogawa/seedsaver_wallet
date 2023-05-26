// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again:
// With a Flutter package, run `flutter pub run build_runner build`.
// With a Dart package, run `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types, depend_on_referenced_packages
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'models/data_model.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(3, 8100874347014221800),
      name: 'Pubkey',
      lastPropertyId: const IdUid(3, 5396068773404061658),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 8999477624694319943),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(3, 5396068773404061658),
            name: 'key',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(5, 6211547280233684704),
      name: 'Vault',
      lastPropertyId: const IdUid(2, 1748800403241533890),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 9050987589216228476),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 1748800403241533890),
            name: 'singeltonHex',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// Open an ObjectBox store with the model declared in this file.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(5, 6211547280233684704),
      lastIndexId: const IdUid(0, 0),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [
        6790616114949955276,
        27739178097031260,
        4415469355332837336
      ],
      retiredIndexUids: const [],
      retiredPropertyUids: const [
        8678260272674569300,
        6667700363825399265,
        5743873347595674596,
        4498209001749921074,
        6300761322401889408,
        6893934957833362235,
        7689994152740651263,
        3360898552623033367
      ],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    Pubkey: EntityDefinition<Pubkey>(
        model: _entities[0],
        toOneRelations: (Pubkey object) => [],
        toManyRelations: (Pubkey object) => {},
        getId: (Pubkey object) => object.id,
        setId: (Pubkey object, int id) {
          object.id = id;
        },
        objectToFB: (Pubkey object, fb.Builder fbb) {
          final keyOffset =
              object.key == null ? null : fbb.writeString(object.key!);
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addOffset(2, keyOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Pubkey()
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..key = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 8);

          return object;
        }),
    Vault: EntityDefinition<Vault>(
        model: _entities[1],
        toOneRelations: (Vault object) => [],
        toManyRelations: (Vault object) => {},
        getId: (Vault object) => object.id,
        setId: (Vault object, int id) {
          object.id = id;
        },
        objectToFB: (Vault object, fb.Builder fbb) {
          final singeltonHexOffset = object.singeltonHex == null
              ? null
              : fbb.writeString(object.singeltonHex!);
          fbb.startTable(3);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, singeltonHexOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Vault()
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..singeltonHex = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 6);

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [Pubkey] entity fields to define ObjectBox queries.
class Pubkey_ {
  /// see [Pubkey.id]
  static final id = QueryIntegerProperty<Pubkey>(_entities[0].properties[0]);

  /// see [Pubkey.key]
  static final key = QueryStringProperty<Pubkey>(_entities[0].properties[1]);
}

/// [Vault] entity fields to define ObjectBox queries.
class Vault_ {
  /// see [Vault.id]
  static final id = QueryIntegerProperty<Vault>(_entities[1].properties[0]);

  /// see [Vault.singeltonHex]
  static final singeltonHex =
      QueryStringProperty<Vault>(_entities[1].properties[1]);
}