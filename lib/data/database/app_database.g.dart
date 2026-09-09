// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CardGroupsTable extends CardGroups
    with TableInfo<$CardGroupsTable, CardGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardGroup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardGroup(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CardGroupsTable createAlias(String alias) {
    return $CardGroupsTable(attachedDatabase, alias);
  }
}

class CardGroup extends DataClass implements Insertable<CardGroup> {
  final int id;
  final String name;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CardGroup({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CardGroupsCompanion toCompanion(bool nullToAbsent) {
    return CardGroupsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CardGroup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardGroup(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CardGroup copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CardGroup(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CardGroup copyWithCompanion(CardGroupsCompanion data) {
    return CardGroup(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardGroup(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardGroup &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CardGroupsCompanion extends UpdateCompanion<CardGroup> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CardGroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CardGroupsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CardGroup> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CardGroupsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return CardGroupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardGroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $FlashcardsTable extends Flashcards
    with TableInfo<$FlashcardsTable, Flashcard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FlashcardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<FlashcardType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<FlashcardType>($FlashcardsTable.$convertertype);
  static const VerificationMeta _frontMeta = const VerificationMeta('front');
  @override
  late final GeneratedColumn<String> front = GeneratedColumn<String>(
    'front',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _backMeta = const VerificationMeta('back');
  @override
  late final GeneratedColumn<String> back = GeneratedColumn<String>(
    'back',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exampleMeta = const VerificationMeta(
    'example',
  );
  @override
  late final GeneratedColumn<String> example = GeneratedColumn<String>(
    'example',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioPathMeta = const VerificationMeta(
    'audioPath',
  );
  @override
  late final GeneratedColumn<String> audioPath = GeneratedColumn<String>(
    'audio_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CardDifficulty, int> difficulty =
      GeneratedColumn<int>(
        'difficulty',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<CardDifficulty>($FlashcardsTable.$converterdifficulty);
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<CardSource, int> source =
      GeneratedColumn<int>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<CardSource>($FlashcardsTable.$convertersource);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastReviewAtMeta = const VerificationMeta(
    'lastReviewAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastReviewAt = GeneratedColumn<DateTime>(
    'last_review_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextReviewAtMeta = const VerificationMeta(
    'nextReviewAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextReviewAt = GeneratedColumn<DateTime>(
    'next_review_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intervalMeta = const VerificationMeta(
    'interval',
  );
  @override
  late final GeneratedColumn<int> interval = GeneratedColumn<int>(
    'interval',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _repetitionsMeta = const VerificationMeta(
    'repetitions',
  );
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
    'repetitions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _correctAnswersMeta = const VerificationMeta(
    'correctAnswers',
  );
  @override
  late final GeneratedColumn<int> correctAnswers = GeneratedColumn<int>(
    'correct_answers',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _incorrectAnswersMeta = const VerificationMeta(
    'incorrectAnswers',
  );
  @override
  late final GeneratedColumn<int> incorrectAnswers = GeneratedColumn<int>(
    'incorrect_answers',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    front,
    back,
    example,
    audioPath,
    difficulty,
    tags,
    source,
    createdAt,
    updatedAt,
    lastReviewAt,
    nextReviewAt,
    interval,
    repetitions,
    correctAnswers,
    incorrectAnswers,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'flashcards';
  @override
  VerificationContext validateIntegrity(
    Insertable<Flashcard> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('front')) {
      context.handle(
        _frontMeta,
        front.isAcceptableOrUnknown(data['front']!, _frontMeta),
      );
    } else if (isInserting) {
      context.missing(_frontMeta);
    }
    if (data.containsKey('back')) {
      context.handle(
        _backMeta,
        back.isAcceptableOrUnknown(data['back']!, _backMeta),
      );
    } else if (isInserting) {
      context.missing(_backMeta);
    }
    if (data.containsKey('example')) {
      context.handle(
        _exampleMeta,
        example.isAcceptableOrUnknown(data['example']!, _exampleMeta),
      );
    }
    if (data.containsKey('audio_path')) {
      context.handle(
        _audioPathMeta,
        audioPath.isAcceptableOrUnknown(data['audio_path']!, _audioPathMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('last_review_at')) {
      context.handle(
        _lastReviewAtMeta,
        lastReviewAt.isAcceptableOrUnknown(
          data['last_review_at']!,
          _lastReviewAtMeta,
        ),
      );
    }
    if (data.containsKey('next_review_at')) {
      context.handle(
        _nextReviewAtMeta,
        nextReviewAt.isAcceptableOrUnknown(
          data['next_review_at']!,
          _nextReviewAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextReviewAtMeta);
    }
    if (data.containsKey('interval')) {
      context.handle(
        _intervalMeta,
        interval.isAcceptableOrUnknown(data['interval']!, _intervalMeta),
      );
    }
    if (data.containsKey('repetitions')) {
      context.handle(
        _repetitionsMeta,
        repetitions.isAcceptableOrUnknown(
          data['repetitions']!,
          _repetitionsMeta,
        ),
      );
    }
    if (data.containsKey('correct_answers')) {
      context.handle(
        _correctAnswersMeta,
        correctAnswers.isAcceptableOrUnknown(
          data['correct_answers']!,
          _correctAnswersMeta,
        ),
      );
    }
    if (data.containsKey('incorrect_answers')) {
      context.handle(
        _incorrectAnswersMeta,
        incorrectAnswers.isAcceptableOrUnknown(
          data['incorrect_answers']!,
          _incorrectAnswersMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Flashcard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Flashcard(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: $FlashcardsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      front: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}front'],
      )!,
      back: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}back'],
      )!,
      example: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}example'],
      ),
      audioPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_path'],
      ),
      difficulty: $FlashcardsTable.$converterdifficulty.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}difficulty'],
        )!,
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
      source: $FlashcardsTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}source'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      lastReviewAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_review_at'],
      ),
      nextReviewAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_review_at'],
      )!,
      interval: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval'],
      )!,
      repetitions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repetitions'],
      )!,
      correctAnswers: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_answers'],
      )!,
      incorrectAnswers: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}incorrect_answers'],
      )!,
    );
  }

  @override
  $FlashcardsTable createAlias(String alias) {
    return $FlashcardsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<FlashcardType, int, int> $convertertype =
      const EnumIndexConverter<FlashcardType>(FlashcardType.values);
  static JsonTypeConverter2<CardDifficulty, int, int> $converterdifficulty =
      const EnumIndexConverter<CardDifficulty>(CardDifficulty.values);
  static JsonTypeConverter2<CardSource, int, int> $convertersource =
      const EnumIndexConverter<CardSource>(CardSource.values);
}

class Flashcard extends DataClass implements Insertable<Flashcard> {
  final int id;
  final FlashcardType type;
  final String front;
  final String back;
  final String? example;
  final String? audioPath;
  final CardDifficulty difficulty;
  final String tags;
  final CardSource source;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastReviewAt;
  final DateTime nextReviewAt;

  /// Intervalo hasta la próxima revisión, en minutos.
  final int interval;
  final int repetitions;
  final int correctAnswers;
  final int incorrectAnswers;
  const Flashcard({
    required this.id,
    required this.type,
    required this.front,
    required this.back,
    this.example,
    this.audioPath,
    required this.difficulty,
    required this.tags,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
    this.lastReviewAt,
    required this.nextReviewAt,
    required this.interval,
    required this.repetitions,
    required this.correctAnswers,
    required this.incorrectAnswers,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['type'] = Variable<int>($FlashcardsTable.$convertertype.toSql(type));
    }
    map['front'] = Variable<String>(front);
    map['back'] = Variable<String>(back);
    if (!nullToAbsent || example != null) {
      map['example'] = Variable<String>(example);
    }
    if (!nullToAbsent || audioPath != null) {
      map['audio_path'] = Variable<String>(audioPath);
    }
    {
      map['difficulty'] = Variable<int>(
        $FlashcardsTable.$converterdifficulty.toSql(difficulty),
      );
    }
    map['tags'] = Variable<String>(tags);
    {
      map['source'] = Variable<int>(
        $FlashcardsTable.$convertersource.toSql(source),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastReviewAt != null) {
      map['last_review_at'] = Variable<DateTime>(lastReviewAt);
    }
    map['next_review_at'] = Variable<DateTime>(nextReviewAt);
    map['interval'] = Variable<int>(interval);
    map['repetitions'] = Variable<int>(repetitions);
    map['correct_answers'] = Variable<int>(correctAnswers);
    map['incorrect_answers'] = Variable<int>(incorrectAnswers);
    return map;
  }

  FlashcardsCompanion toCompanion(bool nullToAbsent) {
    return FlashcardsCompanion(
      id: Value(id),
      type: Value(type),
      front: Value(front),
      back: Value(back),
      example: example == null && nullToAbsent
          ? const Value.absent()
          : Value(example),
      audioPath: audioPath == null && nullToAbsent
          ? const Value.absent()
          : Value(audioPath),
      difficulty: Value(difficulty),
      tags: Value(tags),
      source: Value(source),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastReviewAt: lastReviewAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewAt),
      nextReviewAt: Value(nextReviewAt),
      interval: Value(interval),
      repetitions: Value(repetitions),
      correctAnswers: Value(correctAnswers),
      incorrectAnswers: Value(incorrectAnswers),
    );
  }

  factory Flashcard.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Flashcard(
      id: serializer.fromJson<int>(json['id']),
      type: $FlashcardsTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      front: serializer.fromJson<String>(json['front']),
      back: serializer.fromJson<String>(json['back']),
      example: serializer.fromJson<String?>(json['example']),
      audioPath: serializer.fromJson<String?>(json['audioPath']),
      difficulty: $FlashcardsTable.$converterdifficulty.fromJson(
        serializer.fromJson<int>(json['difficulty']),
      ),
      tags: serializer.fromJson<String>(json['tags']),
      source: $FlashcardsTable.$convertersource.fromJson(
        serializer.fromJson<int>(json['source']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastReviewAt: serializer.fromJson<DateTime?>(json['lastReviewAt']),
      nextReviewAt: serializer.fromJson<DateTime>(json['nextReviewAt']),
      interval: serializer.fromJson<int>(json['interval']),
      repetitions: serializer.fromJson<int>(json['repetitions']),
      correctAnswers: serializer.fromJson<int>(json['correctAnswers']),
      incorrectAnswers: serializer.fromJson<int>(json['incorrectAnswers']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<int>(
        $FlashcardsTable.$convertertype.toJson(type),
      ),
      'front': serializer.toJson<String>(front),
      'back': serializer.toJson<String>(back),
      'example': serializer.toJson<String?>(example),
      'audioPath': serializer.toJson<String?>(audioPath),
      'difficulty': serializer.toJson<int>(
        $FlashcardsTable.$converterdifficulty.toJson(difficulty),
      ),
      'tags': serializer.toJson<String>(tags),
      'source': serializer.toJson<int>(
        $FlashcardsTable.$convertersource.toJson(source),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastReviewAt': serializer.toJson<DateTime?>(lastReviewAt),
      'nextReviewAt': serializer.toJson<DateTime>(nextReviewAt),
      'interval': serializer.toJson<int>(interval),
      'repetitions': serializer.toJson<int>(repetitions),
      'correctAnswers': serializer.toJson<int>(correctAnswers),
      'incorrectAnswers': serializer.toJson<int>(incorrectAnswers),
    };
  }

  Flashcard copyWith({
    int? id,
    FlashcardType? type,
    String? front,
    String? back,
    Value<String?> example = const Value.absent(),
    Value<String?> audioPath = const Value.absent(),
    CardDifficulty? difficulty,
    String? tags,
    CardSource? source,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> lastReviewAt = const Value.absent(),
    DateTime? nextReviewAt,
    int? interval,
    int? repetitions,
    int? correctAnswers,
    int? incorrectAnswers,
  }) => Flashcard(
    id: id ?? this.id,
    type: type ?? this.type,
    front: front ?? this.front,
    back: back ?? this.back,
    example: example.present ? example.value : this.example,
    audioPath: audioPath.present ? audioPath.value : this.audioPath,
    difficulty: difficulty ?? this.difficulty,
    tags: tags ?? this.tags,
    source: source ?? this.source,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lastReviewAt: lastReviewAt.present ? lastReviewAt.value : this.lastReviewAt,
    nextReviewAt: nextReviewAt ?? this.nextReviewAt,
    interval: interval ?? this.interval,
    repetitions: repetitions ?? this.repetitions,
    correctAnswers: correctAnswers ?? this.correctAnswers,
    incorrectAnswers: incorrectAnswers ?? this.incorrectAnswers,
  );
  Flashcard copyWithCompanion(FlashcardsCompanion data) {
    return Flashcard(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      front: data.front.present ? data.front.value : this.front,
      back: data.back.present ? data.back.value : this.back,
      example: data.example.present ? data.example.value : this.example,
      audioPath: data.audioPath.present ? data.audioPath.value : this.audioPath,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      tags: data.tags.present ? data.tags.value : this.tags,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastReviewAt: data.lastReviewAt.present
          ? data.lastReviewAt.value
          : this.lastReviewAt,
      nextReviewAt: data.nextReviewAt.present
          ? data.nextReviewAt.value
          : this.nextReviewAt,
      interval: data.interval.present ? data.interval.value : this.interval,
      repetitions: data.repetitions.present
          ? data.repetitions.value
          : this.repetitions,
      correctAnswers: data.correctAnswers.present
          ? data.correctAnswers.value
          : this.correctAnswers,
      incorrectAnswers: data.incorrectAnswers.present
          ? data.incorrectAnswers.value
          : this.incorrectAnswers,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Flashcard(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('front: $front, ')
          ..write('back: $back, ')
          ..write('example: $example, ')
          ..write('audioPath: $audioPath, ')
          ..write('difficulty: $difficulty, ')
          ..write('tags: $tags, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastReviewAt: $lastReviewAt, ')
          ..write('nextReviewAt: $nextReviewAt, ')
          ..write('interval: $interval, ')
          ..write('repetitions: $repetitions, ')
          ..write('correctAnswers: $correctAnswers, ')
          ..write('incorrectAnswers: $incorrectAnswers')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    front,
    back,
    example,
    audioPath,
    difficulty,
    tags,
    source,
    createdAt,
    updatedAt,
    lastReviewAt,
    nextReviewAt,
    interval,
    repetitions,
    correctAnswers,
    incorrectAnswers,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Flashcard &&
          other.id == this.id &&
          other.type == this.type &&
          other.front == this.front &&
          other.back == this.back &&
          other.example == this.example &&
          other.audioPath == this.audioPath &&
          other.difficulty == this.difficulty &&
          other.tags == this.tags &&
          other.source == this.source &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastReviewAt == this.lastReviewAt &&
          other.nextReviewAt == this.nextReviewAt &&
          other.interval == this.interval &&
          other.repetitions == this.repetitions &&
          other.correctAnswers == this.correctAnswers &&
          other.incorrectAnswers == this.incorrectAnswers);
}

class FlashcardsCompanion extends UpdateCompanion<Flashcard> {
  final Value<int> id;
  final Value<FlashcardType> type;
  final Value<String> front;
  final Value<String> back;
  final Value<String?> example;
  final Value<String?> audioPath;
  final Value<CardDifficulty> difficulty;
  final Value<String> tags;
  final Value<CardSource> source;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> lastReviewAt;
  final Value<DateTime> nextReviewAt;
  final Value<int> interval;
  final Value<int> repetitions;
  final Value<int> correctAnswers;
  final Value<int> incorrectAnswers;
  const FlashcardsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.front = const Value.absent(),
    this.back = const Value.absent(),
    this.example = const Value.absent(),
    this.audioPath = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.tags = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastReviewAt = const Value.absent(),
    this.nextReviewAt = const Value.absent(),
    this.interval = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.correctAnswers = const Value.absent(),
    this.incorrectAnswers = const Value.absent(),
  });
  FlashcardsCompanion.insert({
    this.id = const Value.absent(),
    required FlashcardType type,
    required String front,
    required String back,
    this.example = const Value.absent(),
    this.audioPath = const Value.absent(),
    required CardDifficulty difficulty,
    this.tags = const Value.absent(),
    required CardSource source,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.lastReviewAt = const Value.absent(),
    required DateTime nextReviewAt,
    this.interval = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.correctAnswers = const Value.absent(),
    this.incorrectAnswers = const Value.absent(),
  }) : type = Value(type),
       front = Value(front),
       back = Value(back),
       difficulty = Value(difficulty),
       source = Value(source),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       nextReviewAt = Value(nextReviewAt);
  static Insertable<Flashcard> custom({
    Expression<int>? id,
    Expression<int>? type,
    Expression<String>? front,
    Expression<String>? back,
    Expression<String>? example,
    Expression<String>? audioPath,
    Expression<int>? difficulty,
    Expression<String>? tags,
    Expression<int>? source,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastReviewAt,
    Expression<DateTime>? nextReviewAt,
    Expression<int>? interval,
    Expression<int>? repetitions,
    Expression<int>? correctAnswers,
    Expression<int>? incorrectAnswers,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (front != null) 'front': front,
      if (back != null) 'back': back,
      if (example != null) 'example': example,
      if (audioPath != null) 'audio_path': audioPath,
      if (difficulty != null) 'difficulty': difficulty,
      if (tags != null) 'tags': tags,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastReviewAt != null) 'last_review_at': lastReviewAt,
      if (nextReviewAt != null) 'next_review_at': nextReviewAt,
      if (interval != null) 'interval': interval,
      if (repetitions != null) 'repetitions': repetitions,
      if (correctAnswers != null) 'correct_answers': correctAnswers,
      if (incorrectAnswers != null) 'incorrect_answers': incorrectAnswers,
    });
  }

  FlashcardsCompanion copyWith({
    Value<int>? id,
    Value<FlashcardType>? type,
    Value<String>? front,
    Value<String>? back,
    Value<String?>? example,
    Value<String?>? audioPath,
    Value<CardDifficulty>? difficulty,
    Value<String>? tags,
    Value<CardSource>? source,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? lastReviewAt,
    Value<DateTime>? nextReviewAt,
    Value<int>? interval,
    Value<int>? repetitions,
    Value<int>? correctAnswers,
    Value<int>? incorrectAnswers,
  }) {
    return FlashcardsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      front: front ?? this.front,
      back: back ?? this.back,
      example: example ?? this.example,
      audioPath: audioPath ?? this.audioPath,
      difficulty: difficulty ?? this.difficulty,
      tags: tags ?? this.tags,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastReviewAt: lastReviewAt ?? this.lastReviewAt,
      nextReviewAt: nextReviewAt ?? this.nextReviewAt,
      interval: interval ?? this.interval,
      repetitions: repetitions ?? this.repetitions,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      incorrectAnswers: incorrectAnswers ?? this.incorrectAnswers,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $FlashcardsTable.$convertertype.toSql(type.value),
      );
    }
    if (front.present) {
      map['front'] = Variable<String>(front.value);
    }
    if (back.present) {
      map['back'] = Variable<String>(back.value);
    }
    if (example.present) {
      map['example'] = Variable<String>(example.value);
    }
    if (audioPath.present) {
      map['audio_path'] = Variable<String>(audioPath.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<int>(
        $FlashcardsTable.$converterdifficulty.toSql(difficulty.value),
      );
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (source.present) {
      map['source'] = Variable<int>(
        $FlashcardsTable.$convertersource.toSql(source.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastReviewAt.present) {
      map['last_review_at'] = Variable<DateTime>(lastReviewAt.value);
    }
    if (nextReviewAt.present) {
      map['next_review_at'] = Variable<DateTime>(nextReviewAt.value);
    }
    if (interval.present) {
      map['interval'] = Variable<int>(interval.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (correctAnswers.present) {
      map['correct_answers'] = Variable<int>(correctAnswers.value);
    }
    if (incorrectAnswers.present) {
      map['incorrect_answers'] = Variable<int>(incorrectAnswers.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlashcardsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('front: $front, ')
          ..write('back: $back, ')
          ..write('example: $example, ')
          ..write('audioPath: $audioPath, ')
          ..write('difficulty: $difficulty, ')
          ..write('tags: $tags, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastReviewAt: $lastReviewAt, ')
          ..write('nextReviewAt: $nextReviewAt, ')
          ..write('interval: $interval, ')
          ..write('repetitions: $repetitions, ')
          ..write('correctAnswers: $correctAnswers, ')
          ..write('incorrectAnswers: $incorrectAnswers')
          ..write(')'))
        .toString();
  }
}

class $CardGroupMembershipsTable extends CardGroupMemberships
    with TableInfo<$CardGroupMembershipsTable, CardGroupMembership> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardGroupMembershipsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<int> cardId = GeneratedColumn<int>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES flashcards (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES card_groups (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [cardId, groupId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_group_memberships';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardGroupMembership> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cardId, groupId};
  @override
  CardGroupMembership map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardGroupMembership(
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}card_id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}group_id'],
      )!,
    );
  }

  @override
  $CardGroupMembershipsTable createAlias(String alias) {
    return $CardGroupMembershipsTable(attachedDatabase, alias);
  }
}

class CardGroupMembership extends DataClass
    implements Insertable<CardGroupMembership> {
  final int cardId;
  final int groupId;
  const CardGroupMembership({required this.cardId, required this.groupId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['card_id'] = Variable<int>(cardId);
    map['group_id'] = Variable<int>(groupId);
    return map;
  }

  CardGroupMembershipsCompanion toCompanion(bool nullToAbsent) {
    return CardGroupMembershipsCompanion(
      cardId: Value(cardId),
      groupId: Value(groupId),
    );
  }

  factory CardGroupMembership.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardGroupMembership(
      cardId: serializer.fromJson<int>(json['cardId']),
      groupId: serializer.fromJson<int>(json['groupId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cardId': serializer.toJson<int>(cardId),
      'groupId': serializer.toJson<int>(groupId),
    };
  }

  CardGroupMembership copyWith({int? cardId, int? groupId}) =>
      CardGroupMembership(
        cardId: cardId ?? this.cardId,
        groupId: groupId ?? this.groupId,
      );
  CardGroupMembership copyWithCompanion(CardGroupMembershipsCompanion data) {
    return CardGroupMembership(
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardGroupMembership(')
          ..write('cardId: $cardId, ')
          ..write('groupId: $groupId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cardId, groupId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardGroupMembership &&
          other.cardId == this.cardId &&
          other.groupId == this.groupId);
}

class CardGroupMembershipsCompanion
    extends UpdateCompanion<CardGroupMembership> {
  final Value<int> cardId;
  final Value<int> groupId;
  final Value<int> rowid;
  const CardGroupMembershipsCompanion({
    this.cardId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CardGroupMembershipsCompanion.insert({
    required int cardId,
    required int groupId,
    this.rowid = const Value.absent(),
  }) : cardId = Value(cardId),
       groupId = Value(groupId);
  static Insertable<CardGroupMembership> custom({
    Expression<int>? cardId,
    Expression<int>? groupId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cardId != null) 'card_id': cardId,
      if (groupId != null) 'group_id': groupId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CardGroupMembershipsCompanion copyWith({
    Value<int>? cardId,
    Value<int>? groupId,
    Value<int>? rowid,
  }) {
    return CardGroupMembershipsCompanion(
      cardId: cardId ?? this.cardId,
      groupId: groupId ?? this.groupId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cardId.present) {
      map['card_id'] = Variable<int>(cardId.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardGroupMembershipsCompanion(')
          ..write('cardId: $cardId, ')
          ..write('groupId: $groupId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReviewsTable extends Reviews with TableInfo<$ReviewsTable, Review> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<int> cardId = GeneratedColumn<int>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES flashcards (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ReviewResult, int> result =
      GeneratedColumn<int>(
        'result',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<ReviewResult>($ReviewsTable.$converterresult);
  @override
  late final GeneratedColumnWithTypeConverter<ReviewRating, int> difficulty =
      GeneratedColumn<int>(
        'difficulty',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<ReviewRating>($ReviewsTable.$converterdifficulty);
  static const VerificationMeta _reviewedAtMeta = const VerificationMeta(
    'reviewedAt',
  );
  @override
  late final GeneratedColumn<DateTime> reviewedAt = GeneratedColumn<DateTime>(
    'reviewed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _previousIntervalMeta = const VerificationMeta(
    'previousInterval',
  );
  @override
  late final GeneratedColumn<int> previousInterval = GeneratedColumn<int>(
    'previous_interval',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _newIntervalMeta = const VerificationMeta(
    'newInterval',
  );
  @override
  late final GeneratedColumn<int> newInterval = GeneratedColumn<int>(
    'new_interval',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardId,
    result,
    difficulty,
    reviewedAt,
    previousInterval,
    newInterval,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reviews';
  @override
  VerificationContext validateIntegrity(
    Insertable<Review> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('reviewed_at')) {
      context.handle(
        _reviewedAtMeta,
        reviewedAt.isAcceptableOrUnknown(data['reviewed_at']!, _reviewedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_reviewedAtMeta);
    }
    if (data.containsKey('previous_interval')) {
      context.handle(
        _previousIntervalMeta,
        previousInterval.isAcceptableOrUnknown(
          data['previous_interval']!,
          _previousIntervalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_previousIntervalMeta);
    }
    if (data.containsKey('new_interval')) {
      context.handle(
        _newIntervalMeta,
        newInterval.isAcceptableOrUnknown(
          data['new_interval']!,
          _newIntervalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_newIntervalMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Review map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Review(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}card_id'],
      )!,
      result: $ReviewsTable.$converterresult.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}result'],
        )!,
      ),
      difficulty: $ReviewsTable.$converterdifficulty.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}difficulty'],
        )!,
      ),
      reviewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reviewed_at'],
      )!,
      previousInterval: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}previous_interval'],
      )!,
      newInterval: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}new_interval'],
      )!,
    );
  }

  @override
  $ReviewsTable createAlias(String alias) {
    return $ReviewsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ReviewResult, int, int> $converterresult =
      const EnumIndexConverter<ReviewResult>(ReviewResult.values);
  static JsonTypeConverter2<ReviewRating, int, int> $converterdifficulty =
      const EnumIndexConverter<ReviewRating>(ReviewRating.values);
}

class Review extends DataClass implements Insertable<Review> {
  final int id;
  final int cardId;
  final ReviewResult result;
  final ReviewRating difficulty;
  final DateTime reviewedAt;

  /// Intervalos en minutos, igual que [Flashcards.interval].
  final int previousInterval;
  final int newInterval;
  const Review({
    required this.id,
    required this.cardId,
    required this.result,
    required this.difficulty,
    required this.reviewedAt,
    required this.previousInterval,
    required this.newInterval,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['card_id'] = Variable<int>(cardId);
    {
      map['result'] = Variable<int>(
        $ReviewsTable.$converterresult.toSql(result),
      );
    }
    {
      map['difficulty'] = Variable<int>(
        $ReviewsTable.$converterdifficulty.toSql(difficulty),
      );
    }
    map['reviewed_at'] = Variable<DateTime>(reviewedAt);
    map['previous_interval'] = Variable<int>(previousInterval);
    map['new_interval'] = Variable<int>(newInterval);
    return map;
  }

  ReviewsCompanion toCompanion(bool nullToAbsent) {
    return ReviewsCompanion(
      id: Value(id),
      cardId: Value(cardId),
      result: Value(result),
      difficulty: Value(difficulty),
      reviewedAt: Value(reviewedAt),
      previousInterval: Value(previousInterval),
      newInterval: Value(newInterval),
    );
  }

  factory Review.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Review(
      id: serializer.fromJson<int>(json['id']),
      cardId: serializer.fromJson<int>(json['cardId']),
      result: $ReviewsTable.$converterresult.fromJson(
        serializer.fromJson<int>(json['result']),
      ),
      difficulty: $ReviewsTable.$converterdifficulty.fromJson(
        serializer.fromJson<int>(json['difficulty']),
      ),
      reviewedAt: serializer.fromJson<DateTime>(json['reviewedAt']),
      previousInterval: serializer.fromJson<int>(json['previousInterval']),
      newInterval: serializer.fromJson<int>(json['newInterval']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cardId': serializer.toJson<int>(cardId),
      'result': serializer.toJson<int>(
        $ReviewsTable.$converterresult.toJson(result),
      ),
      'difficulty': serializer.toJson<int>(
        $ReviewsTable.$converterdifficulty.toJson(difficulty),
      ),
      'reviewedAt': serializer.toJson<DateTime>(reviewedAt),
      'previousInterval': serializer.toJson<int>(previousInterval),
      'newInterval': serializer.toJson<int>(newInterval),
    };
  }

  Review copyWith({
    int? id,
    int? cardId,
    ReviewResult? result,
    ReviewRating? difficulty,
    DateTime? reviewedAt,
    int? previousInterval,
    int? newInterval,
  }) => Review(
    id: id ?? this.id,
    cardId: cardId ?? this.cardId,
    result: result ?? this.result,
    difficulty: difficulty ?? this.difficulty,
    reviewedAt: reviewedAt ?? this.reviewedAt,
    previousInterval: previousInterval ?? this.previousInterval,
    newInterval: newInterval ?? this.newInterval,
  );
  Review copyWithCompanion(ReviewsCompanion data) {
    return Review(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      result: data.result.present ? data.result.value : this.result,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      reviewedAt: data.reviewedAt.present
          ? data.reviewedAt.value
          : this.reviewedAt,
      previousInterval: data.previousInterval.present
          ? data.previousInterval.value
          : this.previousInterval,
      newInterval: data.newInterval.present
          ? data.newInterval.value
          : this.newInterval,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Review(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('result: $result, ')
          ..write('difficulty: $difficulty, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('previousInterval: $previousInterval, ')
          ..write('newInterval: $newInterval')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cardId,
    result,
    difficulty,
    reviewedAt,
    previousInterval,
    newInterval,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Review &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.result == this.result &&
          other.difficulty == this.difficulty &&
          other.reviewedAt == this.reviewedAt &&
          other.previousInterval == this.previousInterval &&
          other.newInterval == this.newInterval);
}

class ReviewsCompanion extends UpdateCompanion<Review> {
  final Value<int> id;
  final Value<int> cardId;
  final Value<ReviewResult> result;
  final Value<ReviewRating> difficulty;
  final Value<DateTime> reviewedAt;
  final Value<int> previousInterval;
  final Value<int> newInterval;
  const ReviewsCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.result = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.reviewedAt = const Value.absent(),
    this.previousInterval = const Value.absent(),
    this.newInterval = const Value.absent(),
  });
  ReviewsCompanion.insert({
    this.id = const Value.absent(),
    required int cardId,
    required ReviewResult result,
    required ReviewRating difficulty,
    required DateTime reviewedAt,
    required int previousInterval,
    required int newInterval,
  }) : cardId = Value(cardId),
       result = Value(result),
       difficulty = Value(difficulty),
       reviewedAt = Value(reviewedAt),
       previousInterval = Value(previousInterval),
       newInterval = Value(newInterval);
  static Insertable<Review> custom({
    Expression<int>? id,
    Expression<int>? cardId,
    Expression<int>? result,
    Expression<int>? difficulty,
    Expression<DateTime>? reviewedAt,
    Expression<int>? previousInterval,
    Expression<int>? newInterval,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (result != null) 'result': result,
      if (difficulty != null) 'difficulty': difficulty,
      if (reviewedAt != null) 'reviewed_at': reviewedAt,
      if (previousInterval != null) 'previous_interval': previousInterval,
      if (newInterval != null) 'new_interval': newInterval,
    });
  }

  ReviewsCompanion copyWith({
    Value<int>? id,
    Value<int>? cardId,
    Value<ReviewResult>? result,
    Value<ReviewRating>? difficulty,
    Value<DateTime>? reviewedAt,
    Value<int>? previousInterval,
    Value<int>? newInterval,
  }) {
    return ReviewsCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      result: result ?? this.result,
      difficulty: difficulty ?? this.difficulty,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      previousInterval: previousInterval ?? this.previousInterval,
      newInterval: newInterval ?? this.newInterval,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<int>(cardId.value);
    }
    if (result.present) {
      map['result'] = Variable<int>(
        $ReviewsTable.$converterresult.toSql(result.value),
      );
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<int>(
        $ReviewsTable.$converterdifficulty.toSql(difficulty.value),
      );
    }
    if (reviewedAt.present) {
      map['reviewed_at'] = Variable<DateTime>(reviewedAt.value);
    }
    if (previousInterval.present) {
      map['previous_interval'] = Variable<int>(previousInterval.value);
    }
    if (newInterval.present) {
      map['new_interval'] = Variable<int>(newInterval.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewsCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('result: $result, ')
          ..write('difficulty: $difficulty, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('previousInterval: $previousInterval, ')
          ..write('newInterval: $newInterval')
          ..write(')'))
        .toString();
  }
}

class $CardErrorsTable extends CardErrors
    with TableInfo<$CardErrorsTable, CardError> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardErrorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<int> cardId = GeneratedColumn<int>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES flashcards (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _userAnswerMeta = const VerificationMeta(
    'userAnswer',
  );
  @override
  late final GeneratedColumn<String> userAnswer = GeneratedColumn<String>(
    'user_answer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctAnswerMeta = const VerificationMeta(
    'correctAnswer',
  );
  @override
  late final GeneratedColumn<String> correctAnswer = GeneratedColumn<String>(
    'correct_answer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardId,
    userAnswer,
    correctAnswer,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_errors';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardError> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('user_answer')) {
      context.handle(
        _userAnswerMeta,
        userAnswer.isAcceptableOrUnknown(data['user_answer']!, _userAnswerMeta),
      );
    } else if (isInserting) {
      context.missing(_userAnswerMeta);
    }
    if (data.containsKey('correct_answer')) {
      context.handle(
        _correctAnswerMeta,
        correctAnswer.isAcceptableOrUnknown(
          data['correct_answer']!,
          _correctAnswerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correctAnswerMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardError map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardError(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}card_id'],
      )!,
      userAnswer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_answer'],
      )!,
      correctAnswer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}correct_answer'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CardErrorsTable createAlias(String alias) {
    return $CardErrorsTable(attachedDatabase, alias);
  }
}

class CardError extends DataClass implements Insertable<CardError> {
  final int id;
  final int cardId;
  final String userAnswer;
  final String correctAnswer;
  final String? note;
  final DateTime createdAt;
  const CardError({
    required this.id,
    required this.cardId,
    required this.userAnswer,
    required this.correctAnswer,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['card_id'] = Variable<int>(cardId);
    map['user_answer'] = Variable<String>(userAnswer);
    map['correct_answer'] = Variable<String>(correctAnswer);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CardErrorsCompanion toCompanion(bool nullToAbsent) {
    return CardErrorsCompanion(
      id: Value(id),
      cardId: Value(cardId),
      userAnswer: Value(userAnswer),
      correctAnswer: Value(correctAnswer),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory CardError.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardError(
      id: serializer.fromJson<int>(json['id']),
      cardId: serializer.fromJson<int>(json['cardId']),
      userAnswer: serializer.fromJson<String>(json['userAnswer']),
      correctAnswer: serializer.fromJson<String>(json['correctAnswer']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cardId': serializer.toJson<int>(cardId),
      'userAnswer': serializer.toJson<String>(userAnswer),
      'correctAnswer': serializer.toJson<String>(correctAnswer),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CardError copyWith({
    int? id,
    int? cardId,
    String? userAnswer,
    String? correctAnswer,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => CardError(
    id: id ?? this.id,
    cardId: cardId ?? this.cardId,
    userAnswer: userAnswer ?? this.userAnswer,
    correctAnswer: correctAnswer ?? this.correctAnswer,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  CardError copyWithCompanion(CardErrorsCompanion data) {
    return CardError(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      userAnswer: data.userAnswer.present
          ? data.userAnswer.value
          : this.userAnswer,
      correctAnswer: data.correctAnswer.present
          ? data.correctAnswer.value
          : this.correctAnswer,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardError(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('userAnswer: $userAnswer, ')
          ..write('correctAnswer: $correctAnswer, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, cardId, userAnswer, correctAnswer, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardError &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.userAnswer == this.userAnswer &&
          other.correctAnswer == this.correctAnswer &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class CardErrorsCompanion extends UpdateCompanion<CardError> {
  final Value<int> id;
  final Value<int> cardId;
  final Value<String> userAnswer;
  final Value<String> correctAnswer;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const CardErrorsCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.userAnswer = const Value.absent(),
    this.correctAnswer = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CardErrorsCompanion.insert({
    this.id = const Value.absent(),
    required int cardId,
    required String userAnswer,
    required String correctAnswer,
    this.note = const Value.absent(),
    required DateTime createdAt,
  }) : cardId = Value(cardId),
       userAnswer = Value(userAnswer),
       correctAnswer = Value(correctAnswer),
       createdAt = Value(createdAt);
  static Insertable<CardError> custom({
    Expression<int>? id,
    Expression<int>? cardId,
    Expression<String>? userAnswer,
    Expression<String>? correctAnswer,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (userAnswer != null) 'user_answer': userAnswer,
      if (correctAnswer != null) 'correct_answer': correctAnswer,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CardErrorsCompanion copyWith({
    Value<int>? id,
    Value<int>? cardId,
    Value<String>? userAnswer,
    Value<String>? correctAnswer,
    Value<String?>? note,
    Value<DateTime>? createdAt,
  }) {
    return CardErrorsCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      userAnswer: userAnswer ?? this.userAnswer,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<int>(cardId.value);
    }
    if (userAnswer.present) {
      map['user_answer'] = Variable<String>(userAnswer.value);
    }
    if (correctAnswer.present) {
      map['correct_answer'] = Variable<String>(correctAnswer.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardErrorsCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('userAnswer: $userAnswer, ')
          ..write('correctAnswer: $correctAnswer, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CardGroupsTable cardGroups = $CardGroupsTable(this);
  late final $FlashcardsTable flashcards = $FlashcardsTable(this);
  late final $CardGroupMembershipsTable cardGroupMemberships =
      $CardGroupMembershipsTable(this);
  late final $ReviewsTable reviews = $ReviewsTable(this);
  late final $CardErrorsTable cardErrors = $CardErrorsTable(this);
  late final Index idxFlashcardsNextReview = Index(
    'idx_flashcards_next_review',
    'CREATE INDEX idx_flashcards_next_review ON flashcards (next_review_at)',
  );
  late final Index idxCardGroupMembershipsGroup = Index(
    'idx_card_group_memberships_group',
    'CREATE INDEX idx_card_group_memberships_group ON card_group_memberships (group_id)',
  );
  late final Index idxReviewsCard = Index(
    'idx_reviews_card',
    'CREATE INDEX idx_reviews_card ON reviews (card_id)',
  );
  late final Index idxCardErrorsCard = Index(
    'idx_card_errors_card',
    'CREATE INDEX idx_card_errors_card ON card_errors (card_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cardGroups,
    flashcards,
    cardGroupMemberships,
    reviews,
    cardErrors,
    idxFlashcardsNextReview,
    idxCardGroupMembershipsGroup,
    idxReviewsCard,
    idxCardErrorsCard,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'flashcards',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('card_group_memberships', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'card_groups',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('card_group_memberships', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'flashcards',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reviews', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'flashcards',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('card_errors', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CardGroupsTableCreateCompanionBuilder = CardGroupsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> description,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $$CardGroupsTableUpdateCompanionBuilder = CardGroupsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> description,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$CardGroupsTableReferences
    extends BaseReferences<_$AppDatabase, $CardGroupsTable, CardGroup> {
  $$CardGroupsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $CardGroupMembershipsTable,
    List<CardGroupMembership>
  >
  _cardGroupMembershipsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.cardGroupMemberships,
        aliasName: 'card_groups__id__card_group_memberships__group_id',
      );

  $$CardGroupMembershipsTableProcessedTableManager
  get cardGroupMembershipsRefs {
    final manager = $$CardGroupMembershipsTableTableManager(
      $_db,
      $_db.cardGroupMemberships,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _cardGroupMembershipsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CardGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $CardGroupsTable> {
  $$CardGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> cardGroupMembershipsRefs(
    Expression<bool> Function($$CardGroupMembershipsTableFilterComposer f) f,
  ) {
    final $$CardGroupMembershipsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardGroupMemberships,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardGroupMembershipsTableFilterComposer(
            $db: $db,
            $table: $db.cardGroupMemberships,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CardGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardGroupsTable> {
  $$CardGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CardGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardGroupsTable> {
  $$CardGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> cardGroupMembershipsRefs<T extends Object>(
    Expression<T> Function($$CardGroupMembershipsTableAnnotationComposer a) f,
  ) {
    final $$CardGroupMembershipsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.cardGroupMemberships,
          getReferencedColumn: (t) => t.groupId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CardGroupMembershipsTableAnnotationComposer(
                $db: $db,
                $table: $db.cardGroupMemberships,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CardGroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardGroupsTable,
          CardGroup,
          $$CardGroupsTableFilterComposer,
          $$CardGroupsTableOrderingComposer,
          $$CardGroupsTableAnnotationComposer,
          $$CardGroupsTableCreateCompanionBuilder,
          $$CardGroupsTableUpdateCompanionBuilder,
          (CardGroup, $$CardGroupsTableReferences),
          CardGroup,
          PrefetchHooks Function({bool cardGroupMembershipsRefs})
        > {
  $$CardGroupsTableTableManager(_$AppDatabase db, $CardGroupsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CardGroupsCompanion(
                id: id,
                name: name,
                description: description,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => CardGroupsCompanion.insert(
                id: id,
                name: name,
                description: description,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CardGroupsTable, CardGroup>(table),
                  $$CardGroupsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cardGroupMembershipsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (cardGroupMembershipsRefs) db.cardGroupMemberships,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (cardGroupMembershipsRefs)
                    await $_getPrefetchedData<
                      CardGroup,
                      $CardGroupsTable,
                      CardGroupMembership
                    >(
                      currentTable: table,
                      referencedTable: $$CardGroupsTableReferences
                          ._cardGroupMembershipsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CardGroupsTableReferences(
                            db,
                            table,
                            p0,
                          ).cardGroupMembershipsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.groupId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CardGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardGroupsTable,
      CardGroup,
      $$CardGroupsTableFilterComposer,
      $$CardGroupsTableOrderingComposer,
      $$CardGroupsTableAnnotationComposer,
      $$CardGroupsTableCreateCompanionBuilder,
      $$CardGroupsTableUpdateCompanionBuilder,
      (CardGroup, $$CardGroupsTableReferences),
      CardGroup,
      PrefetchHooks Function({bool cardGroupMembershipsRefs})
    >;
typedef $$FlashcardsTableCreateCompanionBuilder = FlashcardsCompanion Function({
  Value<int> id,
  required FlashcardType type,
  required String front,
  required String back,
  Value<String?> example,
  Value<String?> audioPath,
  required CardDifficulty difficulty,
  Value<String> tags,
  required CardSource source,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> lastReviewAt,
  required DateTime nextReviewAt,
  Value<int> interval,
  Value<int> repetitions,
  Value<int> correctAnswers,
  Value<int> incorrectAnswers,
});
typedef $$FlashcardsTableUpdateCompanionBuilder = FlashcardsCompanion Function({
  Value<int> id,
  Value<FlashcardType> type,
  Value<String> front,
  Value<String> back,
  Value<String?> example,
  Value<String?> audioPath,
  Value<CardDifficulty> difficulty,
  Value<String> tags,
  Value<CardSource> source,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> lastReviewAt,
  Value<DateTime> nextReviewAt,
  Value<int> interval,
  Value<int> repetitions,
  Value<int> correctAnswers,
  Value<int> incorrectAnswers,
});

final class $$FlashcardsTableReferences
    extends BaseReferences<_$AppDatabase, $FlashcardsTable, Flashcard> {
  $$FlashcardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $CardGroupMembershipsTable,
    List<CardGroupMembership>
  >
  _cardGroupMembershipsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.cardGroupMemberships,
        aliasName: 'flashcards__id__card_group_memberships__card_id',
      );

  $$CardGroupMembershipsTableProcessedTableManager
  get cardGroupMembershipsRefs {
    final manager = $$CardGroupMembershipsTableTableManager(
      $_db,
      $_db.cardGroupMemberships,
    ).filter((f) => f.cardId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _cardGroupMembershipsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReviewsTable, List<Review>> _reviewsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.reviews,
    aliasName: 'flashcards__id__reviews__card_id',
  );

  $$ReviewsTableProcessedTableManager get reviewsRefs {
    final manager = $$ReviewsTableTableManager(
      $_db,
      $_db.reviews,
    ).filter((f) => f.cardId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_reviewsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CardErrorsTable, List<CardError>>
  _cardErrorsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cardErrors,
    aliasName: 'flashcards__id__card_errors__card_id',
  );

  $$CardErrorsTableProcessedTableManager get cardErrorsRefs {
    final manager = $$CardErrorsTableTableManager(
      $_db,
      $_db.cardErrors,
    ).filter((f) => f.cardId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_cardErrorsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FlashcardsTableFilterComposer
    extends Composer<_$AppDatabase, $FlashcardsTable> {
  $$FlashcardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<FlashcardType, FlashcardType, int> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get front => $composableBuilder(
    column: $table.front,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get back => $composableBuilder(
    column: $table.back,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get example => $composableBuilder(
    column: $table.example,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CardDifficulty, CardDifficulty, int>
  get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CardSource, CardSource, int> get source =>
      $composableBuilder(
        column: $table.source,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastReviewAt => $composableBuilder(
    column: $table.lastReviewAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextReviewAt => $composableBuilder(
    column: $table.nextReviewAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get interval => $composableBuilder(
    column: $table.interval,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctAnswers => $composableBuilder(
    column: $table.correctAnswers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get incorrectAnswers => $composableBuilder(
    column: $table.incorrectAnswers,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> cardGroupMembershipsRefs(
    Expression<bool> Function($$CardGroupMembershipsTableFilterComposer f) f,
  ) {
    final $$CardGroupMembershipsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardGroupMemberships,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardGroupMembershipsTableFilterComposer(
            $db: $db,
            $table: $db.cardGroupMemberships,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> reviewsRefs(
    Expression<bool> Function($$ReviewsTableFilterComposer f) f,
  ) {
    final $$ReviewsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviews,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewsTableFilterComposer(
            $db: $db,
            $table: $db.reviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cardErrorsRefs(
    Expression<bool> Function($$CardErrorsTableFilterComposer f) f,
  ) {
    final $$CardErrorsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardErrors,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardErrorsTableFilterComposer(
            $db: $db,
            $table: $db.cardErrors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FlashcardsTableOrderingComposer
    extends Composer<_$AppDatabase, $FlashcardsTable> {
  $$FlashcardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get front => $composableBuilder(
    column: $table.front,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get back => $composableBuilder(
    column: $table.back,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get example => $composableBuilder(
    column: $table.example,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastReviewAt => $composableBuilder(
    column: $table.lastReviewAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextReviewAt => $composableBuilder(
    column: $table.nextReviewAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get interval => $composableBuilder(
    column: $table.interval,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctAnswers => $composableBuilder(
    column: $table.correctAnswers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get incorrectAnswers => $composableBuilder(
    column: $table.incorrectAnswers,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FlashcardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FlashcardsTable> {
  $$FlashcardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<FlashcardType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get front =>
      $composableBuilder(column: $table.front, builder: (column) => column);

  GeneratedColumn<String> get back =>
      $composableBuilder(column: $table.back, builder: (column) => column);

  GeneratedColumn<String> get example =>
      $composableBuilder(column: $table.example, builder: (column) => column);

  GeneratedColumn<String> get audioPath =>
      $composableBuilder(column: $table.audioPath, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CardDifficulty, int> get difficulty =>
      $composableBuilder(
        column: $table.difficulty,
        builder: (column) => column,
      );

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CardSource, int> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReviewAt => $composableBuilder(
    column: $table.lastReviewAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextReviewAt => $composableBuilder(
    column: $table.nextReviewAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get interval =>
      $composableBuilder(column: $table.interval, builder: (column) => column);

  GeneratedColumn<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get correctAnswers => $composableBuilder(
    column: $table.correctAnswers,
    builder: (column) => column,
  );

  GeneratedColumn<int> get incorrectAnswers => $composableBuilder(
    column: $table.incorrectAnswers,
    builder: (column) => column,
  );

  Expression<T> cardGroupMembershipsRefs<T extends Object>(
    Expression<T> Function($$CardGroupMembershipsTableAnnotationComposer a) f,
  ) {
    final $$CardGroupMembershipsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.cardGroupMemberships,
          getReferencedColumn: (t) => t.cardId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CardGroupMembershipsTableAnnotationComposer(
                $db: $db,
                $table: $db.cardGroupMemberships,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> reviewsRefs<T extends Object>(
    Expression<T> Function($$ReviewsTableAnnotationComposer a) f,
  ) {
    final $$ReviewsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviews,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewsTableAnnotationComposer(
            $db: $db,
            $table: $db.reviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cardErrorsRefs<T extends Object>(
    Expression<T> Function($$CardErrorsTableAnnotationComposer a) f,
  ) {
    final $$CardErrorsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardErrors,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardErrorsTableAnnotationComposer(
            $db: $db,
            $table: $db.cardErrors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FlashcardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FlashcardsTable,
          Flashcard,
          $$FlashcardsTableFilterComposer,
          $$FlashcardsTableOrderingComposer,
          $$FlashcardsTableAnnotationComposer,
          $$FlashcardsTableCreateCompanionBuilder,
          $$FlashcardsTableUpdateCompanionBuilder,
          (Flashcard, $$FlashcardsTableReferences),
          Flashcard,
          PrefetchHooks Function({
            bool cardGroupMembershipsRefs,
            bool reviewsRefs,
            bool cardErrorsRefs,
          })
        > {
  $$FlashcardsTableTableManager(_$AppDatabase db, $FlashcardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FlashcardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FlashcardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FlashcardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<FlashcardType> type = const Value.absent(),
                Value<String> front = const Value.absent(),
                Value<String> back = const Value.absent(),
                Value<String?> example = const Value.absent(),
                Value<String?> audioPath = const Value.absent(),
                Value<CardDifficulty> difficulty = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<CardSource> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> lastReviewAt = const Value.absent(),
                Value<DateTime> nextReviewAt = const Value.absent(),
                Value<int> interval = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                Value<int> correctAnswers = const Value.absent(),
                Value<int> incorrectAnswers = const Value.absent(),
              }) => FlashcardsCompanion(
                id: id,
                type: type,
                front: front,
                back: back,
                example: example,
                audioPath: audioPath,
                difficulty: difficulty,
                tags: tags,
                source: source,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastReviewAt: lastReviewAt,
                nextReviewAt: nextReviewAt,
                interval: interval,
                repetitions: repetitions,
                correctAnswers: correctAnswers,
                incorrectAnswers: incorrectAnswers,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required FlashcardType type,
                required String front,
                required String back,
                Value<String?> example = const Value.absent(),
                Value<String?> audioPath = const Value.absent(),
                required CardDifficulty difficulty,
                Value<String> tags = const Value.absent(),
                required CardSource source,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> lastReviewAt = const Value.absent(),
                required DateTime nextReviewAt,
                Value<int> interval = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                Value<int> correctAnswers = const Value.absent(),
                Value<int> incorrectAnswers = const Value.absent(),
              }) => FlashcardsCompanion.insert(
                id: id,
                type: type,
                front: front,
                back: back,
                example: example,
                audioPath: audioPath,
                difficulty: difficulty,
                tags: tags,
                source: source,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastReviewAt: lastReviewAt,
                nextReviewAt: nextReviewAt,
                interval: interval,
                repetitions: repetitions,
                correctAnswers: correctAnswers,
                incorrectAnswers: incorrectAnswers,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FlashcardsTable, Flashcard>(table),
                  $$FlashcardsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                cardGroupMembershipsRefs = false,
                reviewsRefs = false,
                cardErrorsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (cardGroupMembershipsRefs) db.cardGroupMemberships,
                    if (reviewsRefs) db.reviews,
                    if (cardErrorsRefs) db.cardErrors,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (cardGroupMembershipsRefs)
                        await $_getPrefetchedData<
                          Flashcard,
                          $FlashcardsTable,
                          CardGroupMembership
                        >(
                          currentTable: table,
                          referencedTable: $$FlashcardsTableReferences
                              ._cardGroupMembershipsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FlashcardsTableReferences(
                                db,
                                table,
                                p0,
                              ).cardGroupMembershipsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cardId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (reviewsRefs)
                        await $_getPrefetchedData<
                          Flashcard,
                          $FlashcardsTable,
                          Review
                        >(
                          currentTable: table,
                          referencedTable: $$FlashcardsTableReferences
                              ._reviewsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FlashcardsTableReferences(
                                db,
                                table,
                                p0,
                              ).reviewsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cardId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (cardErrorsRefs)
                        await $_getPrefetchedData<
                          Flashcard,
                          $FlashcardsTable,
                          CardError
                        >(
                          currentTable: table,
                          referencedTable: $$FlashcardsTableReferences
                              ._cardErrorsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FlashcardsTableReferences(
                                db,
                                table,
                                p0,
                              ).cardErrorsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cardId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$FlashcardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FlashcardsTable,
      Flashcard,
      $$FlashcardsTableFilterComposer,
      $$FlashcardsTableOrderingComposer,
      $$FlashcardsTableAnnotationComposer,
      $$FlashcardsTableCreateCompanionBuilder,
      $$FlashcardsTableUpdateCompanionBuilder,
      (Flashcard, $$FlashcardsTableReferences),
      Flashcard,
      PrefetchHooks Function({
        bool cardGroupMembershipsRefs,
        bool reviewsRefs,
        bool cardErrorsRefs,
      })
    >;
typedef $$CardGroupMembershipsTableCreateCompanionBuilder =
    CardGroupMembershipsCompanion Function({
      required int cardId,
      required int groupId,
      Value<int> rowid,
    });
typedef $$CardGroupMembershipsTableUpdateCompanionBuilder =
    CardGroupMembershipsCompanion Function({
      Value<int> cardId,
      Value<int> groupId,
      Value<int> rowid,
    });

final class $$CardGroupMembershipsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CardGroupMembershipsTable,
          CardGroupMembership
        > {
  $$CardGroupMembershipsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $FlashcardsTable _cardIdTable(_$AppDatabase db) => db.flashcards
      .createAlias('card_group_memberships__card_id__flashcards__id');

  $$FlashcardsTableProcessedTableManager get cardId {
    final $_column = $_itemColumn<int>('card_id')!;

    final manager = $$FlashcardsTableTableManager(
      $_db,
      $_db.flashcards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CardGroupsTable _groupIdTable(_$AppDatabase db) => db.cardGroups
      .createAlias('card_group_memberships__group_id__card_groups__id');

  $$CardGroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<int>('group_id')!;

    final manager = $$CardGroupsTableTableManager(
      $_db,
      $_db.cardGroups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CardGroupMembershipsTableFilterComposer
    extends Composer<_$AppDatabase, $CardGroupMembershipsTable> {
  $$CardGroupMembershipsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$FlashcardsTableFilterComposer get cardId {
    final $$FlashcardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.flashcards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlashcardsTableFilterComposer(
            $db: $db,
            $table: $db.flashcards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CardGroupsTableFilterComposer get groupId {
    final $$CardGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.cardGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardGroupsTableFilterComposer(
            $db: $db,
            $table: $db.cardGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardGroupMembershipsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardGroupMembershipsTable> {
  $$CardGroupMembershipsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$FlashcardsTableOrderingComposer get cardId {
    final $$FlashcardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.flashcards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlashcardsTableOrderingComposer(
            $db: $db,
            $table: $db.flashcards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CardGroupsTableOrderingComposer get groupId {
    final $$CardGroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.cardGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardGroupsTableOrderingComposer(
            $db: $db,
            $table: $db.cardGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardGroupMembershipsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardGroupMembershipsTable> {
  $$CardGroupMembershipsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$FlashcardsTableAnnotationComposer get cardId {
    final $$FlashcardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.flashcards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlashcardsTableAnnotationComposer(
            $db: $db,
            $table: $db.flashcards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CardGroupsTableAnnotationComposer get groupId {
    final $$CardGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.cardGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.cardGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardGroupMembershipsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardGroupMembershipsTable,
          CardGroupMembership,
          $$CardGroupMembershipsTableFilterComposer,
          $$CardGroupMembershipsTableOrderingComposer,
          $$CardGroupMembershipsTableAnnotationComposer,
          $$CardGroupMembershipsTableCreateCompanionBuilder,
          $$CardGroupMembershipsTableUpdateCompanionBuilder,
          (CardGroupMembership, $$CardGroupMembershipsTableReferences),
          CardGroupMembership,
          PrefetchHooks Function({bool cardId, bool groupId})
        > {
  $$CardGroupMembershipsTableTableManager(
    _$AppDatabase db,
    $CardGroupMembershipsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardGroupMembershipsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardGroupMembershipsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CardGroupMembershipsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> cardId = const Value.absent(),
                Value<int> groupId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardGroupMembershipsCompanion(
                cardId: cardId,
                groupId: groupId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int cardId,
                required int groupId,
                Value<int> rowid = const Value.absent(),
              }) => CardGroupMembershipsCompanion.insert(
                cardId: cardId,
                groupId: groupId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CardGroupMembershipsTable, CardGroupMembership>(
                    table,
                  ),
                  $$CardGroupMembershipsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cardId = false, groupId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (cardId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.cardId,
                        referencedTable: $$CardGroupMembershipsTableReferences
                            ._cardIdTable(db),
                        referencedColumn: $$CardGroupMembershipsTableReferences
                            ._cardIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (groupId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.groupId,
                        referencedTable: $$CardGroupMembershipsTableReferences
                            ._groupIdTable(db),
                        referencedColumn: $$CardGroupMembershipsTableReferences
                            ._groupIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CardGroupMembershipsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardGroupMembershipsTable,
      CardGroupMembership,
      $$CardGroupMembershipsTableFilterComposer,
      $$CardGroupMembershipsTableOrderingComposer,
      $$CardGroupMembershipsTableAnnotationComposer,
      $$CardGroupMembershipsTableCreateCompanionBuilder,
      $$CardGroupMembershipsTableUpdateCompanionBuilder,
      (CardGroupMembership, $$CardGroupMembershipsTableReferences),
      CardGroupMembership,
      PrefetchHooks Function({bool cardId, bool groupId})
    >;
typedef $$ReviewsTableCreateCompanionBuilder = ReviewsCompanion Function({
  Value<int> id,
  required int cardId,
  required ReviewResult result,
  required ReviewRating difficulty,
  required DateTime reviewedAt,
  required int previousInterval,
  required int newInterval,
});
typedef $$ReviewsTableUpdateCompanionBuilder = ReviewsCompanion Function({
  Value<int> id,
  Value<int> cardId,
  Value<ReviewResult> result,
  Value<ReviewRating> difficulty,
  Value<DateTime> reviewedAt,
  Value<int> previousInterval,
  Value<int> newInterval,
});

final class $$ReviewsTableReferences
    extends BaseReferences<_$AppDatabase, $ReviewsTable, Review> {
  $$ReviewsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FlashcardsTable _cardIdTable(_$AppDatabase db) =>
      db.flashcards.createAlias('reviews__card_id__flashcards__id');

  $$FlashcardsTableProcessedTableManager get cardId {
    final $_column = $_itemColumn<int>('card_id')!;

    final manager = $$FlashcardsTableTableManager(
      $_db,
      $_db.flashcards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReviewsTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewsTable> {
  $$ReviewsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ReviewResult, ReviewResult, int> get result =>
      $composableBuilder(
        column: $table.result,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<ReviewRating, ReviewRating, int>
  get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get previousInterval => $composableBuilder(
    column: $table.previousInterval,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get newInterval => $composableBuilder(
    column: $table.newInterval,
    builder: (column) => ColumnFilters(column),
  );

  $$FlashcardsTableFilterComposer get cardId {
    final $$FlashcardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.flashcards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlashcardsTableFilterComposer(
            $db: $db,
            $table: $db.flashcards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewsTable> {
  $$ReviewsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get previousInterval => $composableBuilder(
    column: $table.previousInterval,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get newInterval => $composableBuilder(
    column: $table.newInterval,
    builder: (column) => ColumnOrderings(column),
  );

  $$FlashcardsTableOrderingComposer get cardId {
    final $$FlashcardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.flashcards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlashcardsTableOrderingComposer(
            $db: $db,
            $table: $db.flashcards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewsTable> {
  $$ReviewsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ReviewResult, int> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ReviewRating, int> get difficulty =>
      $composableBuilder(
        column: $table.difficulty,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get previousInterval => $composableBuilder(
    column: $table.previousInterval,
    builder: (column) => column,
  );

  GeneratedColumn<int> get newInterval => $composableBuilder(
    column: $table.newInterval,
    builder: (column) => column,
  );

  $$FlashcardsTableAnnotationComposer get cardId {
    final $$FlashcardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.flashcards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlashcardsTableAnnotationComposer(
            $db: $db,
            $table: $db.flashcards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReviewsTable,
          Review,
          $$ReviewsTableFilterComposer,
          $$ReviewsTableOrderingComposer,
          $$ReviewsTableAnnotationComposer,
          $$ReviewsTableCreateCompanionBuilder,
          $$ReviewsTableUpdateCompanionBuilder,
          (Review, $$ReviewsTableReferences),
          Review,
          PrefetchHooks Function({bool cardId})
        > {
  $$ReviewsTableTableManager(_$AppDatabase db, $ReviewsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cardId = const Value.absent(),
                Value<ReviewResult> result = const Value.absent(),
                Value<ReviewRating> difficulty = const Value.absent(),
                Value<DateTime> reviewedAt = const Value.absent(),
                Value<int> previousInterval = const Value.absent(),
                Value<int> newInterval = const Value.absent(),
              }) => ReviewsCompanion(
                id: id,
                cardId: cardId,
                result: result,
                difficulty: difficulty,
                reviewedAt: reviewedAt,
                previousInterval: previousInterval,
                newInterval: newInterval,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cardId,
                required ReviewResult result,
                required ReviewRating difficulty,
                required DateTime reviewedAt,
                required int previousInterval,
                required int newInterval,
              }) => ReviewsCompanion.insert(
                id: id,
                cardId: cardId,
                result: result,
                difficulty: difficulty,
                reviewedAt: reviewedAt,
                previousInterval: previousInterval,
                newInterval: newInterval,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReviewsTable, Review>(table),
                  $$ReviewsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cardId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (cardId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.cardId,
                        referencedTable: $$ReviewsTableReferences._cardIdTable(
                          db,
                        ),
                        referencedColumn: $$ReviewsTableReferences
                            ._cardIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReviewsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReviewsTable,
      Review,
      $$ReviewsTableFilterComposer,
      $$ReviewsTableOrderingComposer,
      $$ReviewsTableAnnotationComposer,
      $$ReviewsTableCreateCompanionBuilder,
      $$ReviewsTableUpdateCompanionBuilder,
      (Review, $$ReviewsTableReferences),
      Review,
      PrefetchHooks Function({bool cardId})
    >;
typedef $$CardErrorsTableCreateCompanionBuilder = CardErrorsCompanion Function({
  Value<int> id,
  required int cardId,
  required String userAnswer,
  required String correctAnswer,
  Value<String?> note,
  required DateTime createdAt,
});
typedef $$CardErrorsTableUpdateCompanionBuilder = CardErrorsCompanion Function({
  Value<int> id,
  Value<int> cardId,
  Value<String> userAnswer,
  Value<String> correctAnswer,
  Value<String?> note,
  Value<DateTime> createdAt,
});

final class $$CardErrorsTableReferences
    extends BaseReferences<_$AppDatabase, $CardErrorsTable, CardError> {
  $$CardErrorsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FlashcardsTable _cardIdTable(_$AppDatabase db) =>
      db.flashcards.createAlias('card_errors__card_id__flashcards__id');

  $$FlashcardsTableProcessedTableManager get cardId {
    final $_column = $_itemColumn<int>('card_id')!;

    final manager = $$FlashcardsTableTableManager(
      $_db,
      $_db.flashcards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CardErrorsTableFilterComposer
    extends Composer<_$AppDatabase, $CardErrorsTable> {
  $$CardErrorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userAnswer => $composableBuilder(
    column: $table.userAnswer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get correctAnswer => $composableBuilder(
    column: $table.correctAnswer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$FlashcardsTableFilterComposer get cardId {
    final $$FlashcardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.flashcards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlashcardsTableFilterComposer(
            $db: $db,
            $table: $db.flashcards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardErrorsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardErrorsTable> {
  $$CardErrorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userAnswer => $composableBuilder(
    column: $table.userAnswer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get correctAnswer => $composableBuilder(
    column: $table.correctAnswer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$FlashcardsTableOrderingComposer get cardId {
    final $$FlashcardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.flashcards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlashcardsTableOrderingComposer(
            $db: $db,
            $table: $db.flashcards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardErrorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardErrorsTable> {
  $$CardErrorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userAnswer => $composableBuilder(
    column: $table.userAnswer,
    builder: (column) => column,
  );

  GeneratedColumn<String> get correctAnswer => $composableBuilder(
    column: $table.correctAnswer,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$FlashcardsTableAnnotationComposer get cardId {
    final $$FlashcardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.flashcards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlashcardsTableAnnotationComposer(
            $db: $db,
            $table: $db.flashcards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardErrorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardErrorsTable,
          CardError,
          $$CardErrorsTableFilterComposer,
          $$CardErrorsTableOrderingComposer,
          $$CardErrorsTableAnnotationComposer,
          $$CardErrorsTableCreateCompanionBuilder,
          $$CardErrorsTableUpdateCompanionBuilder,
          (CardError, $$CardErrorsTableReferences),
          CardError,
          PrefetchHooks Function({bool cardId})
        > {
  $$CardErrorsTableTableManager(_$AppDatabase db, $CardErrorsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardErrorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardErrorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardErrorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cardId = const Value.absent(),
                Value<String> userAnswer = const Value.absent(),
                Value<String> correctAnswer = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CardErrorsCompanion(
                id: id,
                cardId: cardId,
                userAnswer: userAnswer,
                correctAnswer: correctAnswer,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cardId,
                required String userAnswer,
                required String correctAnswer,
                Value<String?> note = const Value.absent(),
                required DateTime createdAt,
              }) => CardErrorsCompanion.insert(
                id: id,
                cardId: cardId,
                userAnswer: userAnswer,
                correctAnswer: correctAnswer,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CardErrorsTable, CardError>(table),
                  $$CardErrorsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cardId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (cardId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.cardId,
                        referencedTable: $$CardErrorsTableReferences
                            ._cardIdTable(db),
                        referencedColumn: $$CardErrorsTableReferences
                            ._cardIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CardErrorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardErrorsTable,
      CardError,
      $$CardErrorsTableFilterComposer,
      $$CardErrorsTableOrderingComposer,
      $$CardErrorsTableAnnotationComposer,
      $$CardErrorsTableCreateCompanionBuilder,
      $$CardErrorsTableUpdateCompanionBuilder,
      (CardError, $$CardErrorsTableReferences),
      CardError,
      PrefetchHooks Function({bool cardId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CardGroupsTableTableManager get cardGroups =>
      $$CardGroupsTableTableManager(_db, _db.cardGroups);
  $$FlashcardsTableTableManager get flashcards =>
      $$FlashcardsTableTableManager(_db, _db.flashcards);
  $$CardGroupMembershipsTableTableManager get cardGroupMemberships =>
      $$CardGroupMembershipsTableTableManager(_db, _db.cardGroupMemberships);
  $$ReviewsTableTableManager get reviews =>
      $$ReviewsTableTableManager(_db, _db.reviews);
  $$CardErrorsTableTableManager get cardErrors =>
      $$CardErrorsTableTableManager(_db, _db.cardErrors);
}
