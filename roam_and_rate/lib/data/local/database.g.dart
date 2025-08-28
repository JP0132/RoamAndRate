// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dobMeta = const VerificationMeta('dob');
  @override
  late final GeneratedColumn<DateTime> dob = GeneratedColumn<DateTime>(
    'dob',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _adminMeta = const VerificationMeta('admin');
  @override
  late final GeneratedColumn<bool> admin = GeneratedColumn<bool>(
    'admin',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("admin" IN (0, 1))',
    ),
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
    username,
    fullName,
    dob,
    gender,
    admin,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('dob')) {
      context.handle(
        _dobMeta,
        dob.isAcceptableOrUnknown(data['dob']!, _dobMeta),
      );
    } else if (isInserting) {
      context.missing(_dobMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('admin')) {
      context.handle(
        _adminMeta,
        admin.isAcceptableOrUnknown(data['admin']!, _adminMeta),
      );
    } else if (isInserting) {
      context.missing(_adminMeta);
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
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      dob: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}dob'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      )!,
      admin: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}admin'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String username;
  final String fullName;
  final DateTime dob;
  final String gender;
  final bool admin;
  final DateTime createdAt;
  const User({
    required this.id,
    required this.username,
    required this.fullName,
    required this.dob,
    required this.gender,
    required this.admin,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['username'] = Variable<String>(username);
    map['full_name'] = Variable<String>(fullName);
    map['dob'] = Variable<DateTime>(dob);
    map['gender'] = Variable<String>(gender);
    map['admin'] = Variable<bool>(admin);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      username: Value(username),
      fullName: Value(fullName),
      dob: Value(dob),
      gender: Value(gender),
      admin: Value(admin),
      createdAt: Value(createdAt),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      fullName: serializer.fromJson<String>(json['fullName']),
      dob: serializer.fromJson<DateTime>(json['dob']),
      gender: serializer.fromJson<String>(json['gender']),
      admin: serializer.fromJson<bool>(json['admin']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'username': serializer.toJson<String>(username),
      'fullName': serializer.toJson<String>(fullName),
      'dob': serializer.toJson<DateTime>(dob),
      'gender': serializer.toJson<String>(gender),
      'admin': serializer.toJson<bool>(admin),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  User copyWith({
    String? id,
    String? username,
    String? fullName,
    DateTime? dob,
    String? gender,
    bool? admin,
    DateTime? createdAt,
  }) => User(
    id: id ?? this.id,
    username: username ?? this.username,
    fullName: fullName ?? this.fullName,
    dob: dob ?? this.dob,
    gender: gender ?? this.gender,
    admin: admin ?? this.admin,
    createdAt: createdAt ?? this.createdAt,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      dob: data.dob.present ? data.dob.value : this.dob,
      gender: data.gender.present ? data.gender.value : this.gender,
      admin: data.admin.present ? data.admin.value : this.admin,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('fullName: $fullName, ')
          ..write('dob: $dob, ')
          ..write('gender: $gender, ')
          ..write('admin: $admin, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, username, fullName, dob, gender, admin, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.username == this.username &&
          other.fullName == this.fullName &&
          other.dob == this.dob &&
          other.gender == this.gender &&
          other.admin == this.admin &&
          other.createdAt == this.createdAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> username;
  final Value<String> fullName;
  final Value<DateTime> dob;
  final Value<String> gender;
  final Value<bool> admin;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.fullName = const Value.absent(),
    this.dob = const Value.absent(),
    this.gender = const Value.absent(),
    this.admin = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    required String fullName,
    required DateTime dob,
    required String gender,
    required bool admin,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : username = Value(username),
       fullName = Value(fullName),
       dob = Value(dob),
       gender = Value(gender),
       admin = Value(admin),
       createdAt = Value(createdAt);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? username,
    Expression<String>? fullName,
    Expression<DateTime>? dob,
    Expression<String>? gender,
    Expression<bool>? admin,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (fullName != null) 'full_name': fullName,
      if (dob != null) 'dob': dob,
      if (gender != null) 'gender': gender,
      if (admin != null) 'admin': admin,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String>? username,
    Value<String>? fullName,
    Value<DateTime>? dob,
    Value<String>? gender,
    Value<bool>? admin,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      admin: admin ?? this.admin,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (dob.present) {
      map['dob'] = Variable<DateTime>(dob.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (admin.present) {
      map['admin'] = Variable<bool>(admin.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('fullName: $fullName, ')
          ..write('dob: $dob, ')
          ..write('gender: $gender, ')
          ..write('admin: $admin, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TripsTable extends Trips with TableInfo<$TripsTable, Trip> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TripsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _tripNameMeta = const VerificationMeta(
    'tripName',
  );
  @override
  late final GeneratedColumn<String> tripName = GeneratedColumn<String>(
    'trip_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetMeta = const VerificationMeta('budget');
  @override
  late final GeneratedColumn<double> budget = GeneratedColumn<double>(
    'budget',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imagesMeta = const VerificationMeta('images');
  @override
  late final GeneratedColumn<String> images = GeneratedColumn<String>(
    'images',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bgColourMeta = const VerificationMeta(
    'bgColour',
  );
  @override
  late final GeneratedColumn<String> bgColour = GeneratedColumn<String>(
    'bg_colour',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
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
    userId,
    tripName,
    location,
    currency,
    budget,
    category,
    notes,
    images,
    bgColour,
    startDate,
    endDate,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trips';
  @override
  VerificationContext validateIntegrity(
    Insertable<Trip> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('trip_name')) {
      context.handle(
        _tripNameMeta,
        tripName.isAcceptableOrUnknown(data['trip_name']!, _tripNameMeta),
      );
    } else if (isInserting) {
      context.missing(_tripNameMeta);
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    } else if (isInserting) {
      context.missing(_locationMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('budget')) {
      context.handle(
        _budgetMeta,
        budget.isAcceptableOrUnknown(data['budget']!, _budgetMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('images')) {
      context.handle(
        _imagesMeta,
        images.isAcceptableOrUnknown(data['images']!, _imagesMeta),
      );
    }
    if (data.containsKey('bg_colour')) {
      context.handle(
        _bgColourMeta,
        bgColour.isAcceptableOrUnknown(data['bg_colour']!, _bgColourMeta),
      );
    } else if (isInserting) {
      context.missing(_bgColourMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
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
  Trip map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Trip(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      tripName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_name'],
      )!,
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      budget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}budget'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      images: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}images'],
      ),
      bgColour: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bg_colour'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TripsTable createAlias(String alias) {
    return $TripsTable(attachedDatabase, alias);
  }
}

class Trip extends DataClass implements Insertable<Trip> {
  final String id;
  final String userId;
  final String tripName;
  final String location;
  final String currency;
  final double budget;
  final String category;
  final String? notes;
  final String? images;
  final String bgColour;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  const Trip({
    required this.id,
    required this.userId,
    required this.tripName,
    required this.location,
    required this.currency,
    required this.budget,
    required this.category,
    this.notes,
    this.images,
    required this.bgColour,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['trip_name'] = Variable<String>(tripName);
    map['location'] = Variable<String>(location);
    map['currency'] = Variable<String>(currency);
    map['budget'] = Variable<double>(budget);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || images != null) {
      map['images'] = Variable<String>(images);
    }
    map['bg_colour'] = Variable<String>(bgColour);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TripsCompanion toCompanion(bool nullToAbsent) {
    return TripsCompanion(
      id: Value(id),
      userId: Value(userId),
      tripName: Value(tripName),
      location: Value(location),
      currency: Value(currency),
      budget: Value(budget),
      category: Value(category),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      images: images == null && nullToAbsent
          ? const Value.absent()
          : Value(images),
      bgColour: Value(bgColour),
      startDate: Value(startDate),
      endDate: Value(endDate),
      createdAt: Value(createdAt),
    );
  }

  factory Trip.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Trip(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      tripName: serializer.fromJson<String>(json['tripName']),
      location: serializer.fromJson<String>(json['location']),
      currency: serializer.fromJson<String>(json['currency']),
      budget: serializer.fromJson<double>(json['budget']),
      category: serializer.fromJson<String>(json['category']),
      notes: serializer.fromJson<String?>(json['notes']),
      images: serializer.fromJson<String?>(json['images']),
      bgColour: serializer.fromJson<String>(json['bgColour']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'tripName': serializer.toJson<String>(tripName),
      'location': serializer.toJson<String>(location),
      'currency': serializer.toJson<String>(currency),
      'budget': serializer.toJson<double>(budget),
      'category': serializer.toJson<String>(category),
      'notes': serializer.toJson<String?>(notes),
      'images': serializer.toJson<String?>(images),
      'bgColour': serializer.toJson<String>(bgColour),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Trip copyWith({
    String? id,
    String? userId,
    String? tripName,
    String? location,
    String? currency,
    double? budget,
    String? category,
    Value<String?> notes = const Value.absent(),
    Value<String?> images = const Value.absent(),
    String? bgColour,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
  }) => Trip(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    tripName: tripName ?? this.tripName,
    location: location ?? this.location,
    currency: currency ?? this.currency,
    budget: budget ?? this.budget,
    category: category ?? this.category,
    notes: notes.present ? notes.value : this.notes,
    images: images.present ? images.value : this.images,
    bgColour: bgColour ?? this.bgColour,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    createdAt: createdAt ?? this.createdAt,
  );
  Trip copyWithCompanion(TripsCompanion data) {
    return Trip(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      tripName: data.tripName.present ? data.tripName.value : this.tripName,
      location: data.location.present ? data.location.value : this.location,
      currency: data.currency.present ? data.currency.value : this.currency,
      budget: data.budget.present ? data.budget.value : this.budget,
      category: data.category.present ? data.category.value : this.category,
      notes: data.notes.present ? data.notes.value : this.notes,
      images: data.images.present ? data.images.value : this.images,
      bgColour: data.bgColour.present ? data.bgColour.value : this.bgColour,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Trip(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('tripName: $tripName, ')
          ..write('location: $location, ')
          ..write('currency: $currency, ')
          ..write('budget: $budget, ')
          ..write('category: $category, ')
          ..write('notes: $notes, ')
          ..write('images: $images, ')
          ..write('bgColour: $bgColour, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    tripName,
    location,
    currency,
    budget,
    category,
    notes,
    images,
    bgColour,
    startDate,
    endDate,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Trip &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.tripName == this.tripName &&
          other.location == this.location &&
          other.currency == this.currency &&
          other.budget == this.budget &&
          other.category == this.category &&
          other.notes == this.notes &&
          other.images == this.images &&
          other.bgColour == this.bgColour &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.createdAt == this.createdAt);
}

class TripsCompanion extends UpdateCompanion<Trip> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> tripName;
  final Value<String> location;
  final Value<String> currency;
  final Value<double> budget;
  final Value<String> category;
  final Value<String?> notes;
  final Value<String?> images;
  final Value<String> bgColour;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TripsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.tripName = const Value.absent(),
    this.location = const Value.absent(),
    this.currency = const Value.absent(),
    this.budget = const Value.absent(),
    this.category = const Value.absent(),
    this.notes = const Value.absent(),
    this.images = const Value.absent(),
    this.bgColour = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TripsCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required String tripName,
    required String location,
    required String currency,
    required double budget,
    required String category,
    this.notes = const Value.absent(),
    this.images = const Value.absent(),
    required String bgColour,
    required DateTime startDate,
    required DateTime endDate,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       tripName = Value(tripName),
       location = Value(location),
       currency = Value(currency),
       budget = Value(budget),
       category = Value(category),
       bgColour = Value(bgColour),
       startDate = Value(startDate),
       endDate = Value(endDate),
       createdAt = Value(createdAt);
  static Insertable<Trip> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? tripName,
    Expression<String>? location,
    Expression<String>? currency,
    Expression<double>? budget,
    Expression<String>? category,
    Expression<String>? notes,
    Expression<String>? images,
    Expression<String>? bgColour,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (tripName != null) 'trip_name': tripName,
      if (location != null) 'location': location,
      if (currency != null) 'currency': currency,
      if (budget != null) 'budget': budget,
      if (category != null) 'category': category,
      if (notes != null) 'notes': notes,
      if (images != null) 'images': images,
      if (bgColour != null) 'bg_colour': bgColour,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TripsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? tripName,
    Value<String>? location,
    Value<String>? currency,
    Value<double>? budget,
    Value<String>? category,
    Value<String?>? notes,
    Value<String?>? images,
    Value<String>? bgColour,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TripsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      tripName: tripName ?? this.tripName,
      location: location ?? this.location,
      currency: currency ?? this.currency,
      budget: budget ?? this.budget,
      category: category ?? this.category,
      notes: notes ?? this.notes,
      images: images ?? this.images,
      bgColour: bgColour ?? this.bgColour,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (tripName.present) {
      map['trip_name'] = Variable<String>(tripName.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (budget.present) {
      map['budget'] = Variable<double>(budget.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (images.present) {
      map['images'] = Variable<String>(images.value);
    }
    if (bgColour.present) {
      map['bg_colour'] = Variable<String>(bgColour.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TripsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('tripName: $tripName, ')
          ..write('location: $location, ')
          ..write('currency: $currency, ')
          ..write('budget: $budget, ')
          ..write('category: $category, ')
          ..write('notes: $notes, ')
          ..write('images: $images, ')
          ..write('bgColour: $bgColour, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RatingsTable extends Ratings with TableInfo<$RatingsTable, Rating> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RatingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trips (id)',
    ),
  );
  static const VerificationMeta _placeNameMeta = const VerificationMeta(
    'placeName',
  );
  @override
  late final GeneratedColumn<String> placeName = GeneratedColumn<String>(
    'place_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<double> rating = GeneratedColumn<double>(
    'rating',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateVisitedMeta = const VerificationMeta(
    'dateVisited',
  );
  @override
  late final GeneratedColumn<DateTime> dateVisited = GeneratedColumn<DateTime>(
    'date_visited',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _datePlannedMeta = const VerificationMeta(
    'datePlanned',
  );
  @override
  late final GeneratedColumn<DateTime> datePlanned = GeneratedColumn<DateTime>(
    'date_planned',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imagesMeta = const VerificationMeta('images');
  @override
  late final GeneratedColumn<String> images = GeneratedColumn<String>(
    'images',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> tags =
      GeneratedColumn<String>(
        'tags',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($RatingsTable.$convertertags);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tripId,
    placeName,
    location,
    category,
    status,
    rating,
    dateVisited,
    datePlanned,
    value,
    notes,
    images,
    tags,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ratings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Rating> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('place_name')) {
      context.handle(
        _placeNameMeta,
        placeName.isAcceptableOrUnknown(data['place_name']!, _placeNameMeta),
      );
    } else if (isInserting) {
      context.missing(_placeNameMeta);
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    } else if (isInserting) {
      context.missing(_locationMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('date_visited')) {
      context.handle(
        _dateVisitedMeta,
        dateVisited.isAcceptableOrUnknown(
          data['date_visited']!,
          _dateVisitedMeta,
        ),
      );
    }
    if (data.containsKey('date_planned')) {
      context.handle(
        _datePlannedMeta,
        datePlanned.isAcceptableOrUnknown(
          data['date_planned']!,
          _datePlannedMeta,
        ),
      );
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('images')) {
      context.handle(
        _imagesMeta,
        images.isAcceptableOrUnknown(data['images']!, _imagesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Rating map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Rating(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      )!,
      placeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_name'],
      )!,
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rating'],
      ),
      dateVisited: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_visited'],
      ),
      datePlanned: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_planned'],
      ),
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      images: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}images'],
      ),
      tags: $RatingsTable.$convertertags.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tags'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
    );
  }

  @override
  $RatingsTable createAlias(String alias) {
    return $RatingsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $convertertags =
      const StringListConverter();
}

class Rating extends DataClass implements Insertable<Rating> {
  final String id;
  final String tripId;
  final String placeName;
  final String location;
  final String category;
  final String status;
  final double? rating;
  final DateTime? dateVisited;
  final DateTime? datePlanned;
  final String? value;
  final String? notes;
  final String? images;
  final List<String> tags;
  final DateTime? createdAt;
  const Rating({
    required this.id,
    required this.tripId,
    required this.placeName,
    required this.location,
    required this.category,
    required this.status,
    this.rating,
    this.dateVisited,
    this.datePlanned,
    this.value,
    this.notes,
    this.images,
    required this.tags,
    this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['trip_id'] = Variable<String>(tripId);
    map['place_name'] = Variable<String>(placeName);
    map['location'] = Variable<String>(location);
    map['category'] = Variable<String>(category);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<double>(rating);
    }
    if (!nullToAbsent || dateVisited != null) {
      map['date_visited'] = Variable<DateTime>(dateVisited);
    }
    if (!nullToAbsent || datePlanned != null) {
      map['date_planned'] = Variable<DateTime>(datePlanned);
    }
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || images != null) {
      map['images'] = Variable<String>(images);
    }
    {
      map['tags'] = Variable<String>($RatingsTable.$convertertags.toSql(tags));
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  RatingsCompanion toCompanion(bool nullToAbsent) {
    return RatingsCompanion(
      id: Value(id),
      tripId: Value(tripId),
      placeName: Value(placeName),
      location: Value(location),
      category: Value(category),
      status: Value(status),
      rating: rating == null && nullToAbsent
          ? const Value.absent()
          : Value(rating),
      dateVisited: dateVisited == null && nullToAbsent
          ? const Value.absent()
          : Value(dateVisited),
      datePlanned: datePlanned == null && nullToAbsent
          ? const Value.absent()
          : Value(datePlanned),
      value: value == null && nullToAbsent
          ? const Value.absent()
          : Value(value),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      images: images == null && nullToAbsent
          ? const Value.absent()
          : Value(images),
      tags: Value(tags),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory Rating.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Rating(
      id: serializer.fromJson<String>(json['id']),
      tripId: serializer.fromJson<String>(json['tripId']),
      placeName: serializer.fromJson<String>(json['placeName']),
      location: serializer.fromJson<String>(json['location']),
      category: serializer.fromJson<String>(json['category']),
      status: serializer.fromJson<String>(json['status']),
      rating: serializer.fromJson<double?>(json['rating']),
      dateVisited: serializer.fromJson<DateTime?>(json['dateVisited']),
      datePlanned: serializer.fromJson<DateTime?>(json['datePlanned']),
      value: serializer.fromJson<String?>(json['value']),
      notes: serializer.fromJson<String?>(json['notes']),
      images: serializer.fromJson<String?>(json['images']),
      tags: serializer.fromJson<List<String>>(json['tags']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tripId': serializer.toJson<String>(tripId),
      'placeName': serializer.toJson<String>(placeName),
      'location': serializer.toJson<String>(location),
      'category': serializer.toJson<String>(category),
      'status': serializer.toJson<String>(status),
      'rating': serializer.toJson<double?>(rating),
      'dateVisited': serializer.toJson<DateTime?>(dateVisited),
      'datePlanned': serializer.toJson<DateTime?>(datePlanned),
      'value': serializer.toJson<String?>(value),
      'notes': serializer.toJson<String?>(notes),
      'images': serializer.toJson<String?>(images),
      'tags': serializer.toJson<List<String>>(tags),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  Rating copyWith({
    String? id,
    String? tripId,
    String? placeName,
    String? location,
    String? category,
    String? status,
    Value<double?> rating = const Value.absent(),
    Value<DateTime?> dateVisited = const Value.absent(),
    Value<DateTime?> datePlanned = const Value.absent(),
    Value<String?> value = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> images = const Value.absent(),
    List<String>? tags,
    Value<DateTime?> createdAt = const Value.absent(),
  }) => Rating(
    id: id ?? this.id,
    tripId: tripId ?? this.tripId,
    placeName: placeName ?? this.placeName,
    location: location ?? this.location,
    category: category ?? this.category,
    status: status ?? this.status,
    rating: rating.present ? rating.value : this.rating,
    dateVisited: dateVisited.present ? dateVisited.value : this.dateVisited,
    datePlanned: datePlanned.present ? datePlanned.value : this.datePlanned,
    value: value.present ? value.value : this.value,
    notes: notes.present ? notes.value : this.notes,
    images: images.present ? images.value : this.images,
    tags: tags ?? this.tags,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
  );
  Rating copyWithCompanion(RatingsCompanion data) {
    return Rating(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      placeName: data.placeName.present ? data.placeName.value : this.placeName,
      location: data.location.present ? data.location.value : this.location,
      category: data.category.present ? data.category.value : this.category,
      status: data.status.present ? data.status.value : this.status,
      rating: data.rating.present ? data.rating.value : this.rating,
      dateVisited: data.dateVisited.present
          ? data.dateVisited.value
          : this.dateVisited,
      datePlanned: data.datePlanned.present
          ? data.datePlanned.value
          : this.datePlanned,
      value: data.value.present ? data.value.value : this.value,
      notes: data.notes.present ? data.notes.value : this.notes,
      images: data.images.present ? data.images.value : this.images,
      tags: data.tags.present ? data.tags.value : this.tags,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Rating(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('placeName: $placeName, ')
          ..write('location: $location, ')
          ..write('category: $category, ')
          ..write('status: $status, ')
          ..write('rating: $rating, ')
          ..write('dateVisited: $dateVisited, ')
          ..write('datePlanned: $datePlanned, ')
          ..write('value: $value, ')
          ..write('notes: $notes, ')
          ..write('images: $images, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tripId,
    placeName,
    location,
    category,
    status,
    rating,
    dateVisited,
    datePlanned,
    value,
    notes,
    images,
    tags,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Rating &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.placeName == this.placeName &&
          other.location == this.location &&
          other.category == this.category &&
          other.status == this.status &&
          other.rating == this.rating &&
          other.dateVisited == this.dateVisited &&
          other.datePlanned == this.datePlanned &&
          other.value == this.value &&
          other.notes == this.notes &&
          other.images == this.images &&
          other.tags == this.tags &&
          other.createdAt == this.createdAt);
}

class RatingsCompanion extends UpdateCompanion<Rating> {
  final Value<String> id;
  final Value<String> tripId;
  final Value<String> placeName;
  final Value<String> location;
  final Value<String> category;
  final Value<String> status;
  final Value<double?> rating;
  final Value<DateTime?> dateVisited;
  final Value<DateTime?> datePlanned;
  final Value<String?> value;
  final Value<String?> notes;
  final Value<String?> images;
  final Value<List<String>> tags;
  final Value<DateTime?> createdAt;
  final Value<int> rowid;
  const RatingsCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.placeName = const Value.absent(),
    this.location = const Value.absent(),
    this.category = const Value.absent(),
    this.status = const Value.absent(),
    this.rating = const Value.absent(),
    this.dateVisited = const Value.absent(),
    this.datePlanned = const Value.absent(),
    this.value = const Value.absent(),
    this.notes = const Value.absent(),
    this.images = const Value.absent(),
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RatingsCompanion.insert({
    this.id = const Value.absent(),
    required String tripId,
    required String placeName,
    required String location,
    required String category,
    required String status,
    this.rating = const Value.absent(),
    this.dateVisited = const Value.absent(),
    this.datePlanned = const Value.absent(),
    this.value = const Value.absent(),
    this.notes = const Value.absent(),
    this.images = const Value.absent(),
    required List<String> tags,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : tripId = Value(tripId),
       placeName = Value(placeName),
       location = Value(location),
       category = Value(category),
       status = Value(status),
       tags = Value(tags);
  static Insertable<Rating> custom({
    Expression<String>? id,
    Expression<String>? tripId,
    Expression<String>? placeName,
    Expression<String>? location,
    Expression<String>? category,
    Expression<String>? status,
    Expression<double>? rating,
    Expression<DateTime>? dateVisited,
    Expression<DateTime>? datePlanned,
    Expression<String>? value,
    Expression<String>? notes,
    Expression<String>? images,
    Expression<String>? tags,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (placeName != null) 'place_name': placeName,
      if (location != null) 'location': location,
      if (category != null) 'category': category,
      if (status != null) 'status': status,
      if (rating != null) 'rating': rating,
      if (dateVisited != null) 'date_visited': dateVisited,
      if (datePlanned != null) 'date_planned': datePlanned,
      if (value != null) 'value': value,
      if (notes != null) 'notes': notes,
      if (images != null) 'images': images,
      if (tags != null) 'tags': tags,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RatingsCompanion copyWith({
    Value<String>? id,
    Value<String>? tripId,
    Value<String>? placeName,
    Value<String>? location,
    Value<String>? category,
    Value<String>? status,
    Value<double?>? rating,
    Value<DateTime?>? dateVisited,
    Value<DateTime?>? datePlanned,
    Value<String?>? value,
    Value<String?>? notes,
    Value<String?>? images,
    Value<List<String>>? tags,
    Value<DateTime?>? createdAt,
    Value<int>? rowid,
  }) {
    return RatingsCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      placeName: placeName ?? this.placeName,
      location: location ?? this.location,
      category: category ?? this.category,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      dateVisited: dateVisited ?? this.dateVisited,
      datePlanned: datePlanned ?? this.datePlanned,
      value: value ?? this.value,
      notes: notes ?? this.notes,
      images: images ?? this.images,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (placeName.present) {
      map['place_name'] = Variable<String>(placeName.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rating.present) {
      map['rating'] = Variable<double>(rating.value);
    }
    if (dateVisited.present) {
      map['date_visited'] = Variable<DateTime>(dateVisited.value);
    }
    if (datePlanned.present) {
      map['date_planned'] = Variable<DateTime>(datePlanned.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (images.present) {
      map['images'] = Variable<String>(images.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(
        $RatingsTable.$convertertags.toSql(tags.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RatingsCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('placeName: $placeName, ')
          ..write('location: $location, ')
          ..write('category: $category, ')
          ..write('status: $status, ')
          ..write('rating: $rating, ')
          ..write('dateVisited: $dateVisited, ')
          ..write('datePlanned: $datePlanned, ')
          ..write('value: $value, ')
          ..write('notes: $notes, ')
          ..write('images: $images, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trips (id)',
    ),
  );
  static const VerificationMeta _expenseNameMeta = const VerificationMeta(
    'expenseName',
  );
  @override
  late final GeneratedColumn<String> expenseName = GeneratedColumn<String>(
    'expense_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidMeta = const VerificationMeta('paid');
  @override
  late final GeneratedColumn<double> paid = GeneratedColumn<double>(
    'paid',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<double> cost = GeneratedColumn<double>(
    'cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _datePaidMeta = const VerificationMeta(
    'datePaid',
  );
  @override
  late final GeneratedColumn<DateTime> datePaid = GeneratedColumn<DateTime>(
    'date_paid',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateAddedMeta = const VerificationMeta(
    'dateAdded',
  );
  @override
  late final GeneratedColumn<DateTime> dateAdded = GeneratedColumn<DateTime>(
    'date_added',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imagesMeta = const VerificationMeta('images');
  @override
  late final GeneratedColumn<String> images = GeneratedColumn<String>(
    'images',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> tags =
      GeneratedColumn<String>(
        'tags',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($ExpensesTable.$convertertags);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tripId,
    expenseName,
    category,
    paid,
    cost,
    currency,
    datePaid,
    dateAdded,
    notes,
    images,
    type,
    tags,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Expense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('expense_name')) {
      context.handle(
        _expenseNameMeta,
        expenseName.isAcceptableOrUnknown(
          data['expense_name']!,
          _expenseNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_expenseNameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('paid')) {
      context.handle(
        _paidMeta,
        paid.isAcceptableOrUnknown(data['paid']!, _paidMeta),
      );
    } else if (isInserting) {
      context.missing(_paidMeta);
    }
    if (data.containsKey('cost')) {
      context.handle(
        _costMeta,
        cost.isAcceptableOrUnknown(data['cost']!, _costMeta),
      );
    } else if (isInserting) {
      context.missing(_costMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('date_paid')) {
      context.handle(
        _datePaidMeta,
        datePaid.isAcceptableOrUnknown(data['date_paid']!, _datePaidMeta),
      );
    } else if (isInserting) {
      context.missing(_datePaidMeta);
    }
    if (data.containsKey('date_added')) {
      context.handle(
        _dateAddedMeta,
        dateAdded.isAcceptableOrUnknown(data['date_added']!, _dateAddedMeta),
      );
    } else if (isInserting) {
      context.missing(_dateAddedMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('images')) {
      context.handle(
        _imagesMeta,
        images.isAcceptableOrUnknown(data['images']!, _imagesMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      )!,
      expenseName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expense_name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      paid: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}paid'],
      )!,
      cost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cost'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      datePaid: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_paid'],
      )!,
      dateAdded: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_added'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      images: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}images'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      tags: $ExpensesTable.$convertertags.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tags'],
        )!,
      ),
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $convertertags =
      const StringListConverter();
}

class Expense extends DataClass implements Insertable<Expense> {
  final String id;
  final String tripId;
  final String expenseName;
  final String category;
  final double paid;
  final double cost;
  final String currency;
  final DateTime datePaid;
  final DateTime dateAdded;
  final String? notes;
  final String? images;
  final String type;
  final List<String> tags;
  const Expense({
    required this.id,
    required this.tripId,
    required this.expenseName,
    required this.category,
    required this.paid,
    required this.cost,
    required this.currency,
    required this.datePaid,
    required this.dateAdded,
    this.notes,
    this.images,
    required this.type,
    required this.tags,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['trip_id'] = Variable<String>(tripId);
    map['expense_name'] = Variable<String>(expenseName);
    map['category'] = Variable<String>(category);
    map['paid'] = Variable<double>(paid);
    map['cost'] = Variable<double>(cost);
    map['currency'] = Variable<String>(currency);
    map['date_paid'] = Variable<DateTime>(datePaid);
    map['date_added'] = Variable<DateTime>(dateAdded);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || images != null) {
      map['images'] = Variable<String>(images);
    }
    map['type'] = Variable<String>(type);
    {
      map['tags'] = Variable<String>($ExpensesTable.$convertertags.toSql(tags));
    }
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      tripId: Value(tripId),
      expenseName: Value(expenseName),
      category: Value(category),
      paid: Value(paid),
      cost: Value(cost),
      currency: Value(currency),
      datePaid: Value(datePaid),
      dateAdded: Value(dateAdded),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      images: images == null && nullToAbsent
          ? const Value.absent()
          : Value(images),
      type: Value(type),
      tags: Value(tags),
    );
  }

  factory Expense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<String>(json['id']),
      tripId: serializer.fromJson<String>(json['tripId']),
      expenseName: serializer.fromJson<String>(json['expenseName']),
      category: serializer.fromJson<String>(json['category']),
      paid: serializer.fromJson<double>(json['paid']),
      cost: serializer.fromJson<double>(json['cost']),
      currency: serializer.fromJson<String>(json['currency']),
      datePaid: serializer.fromJson<DateTime>(json['datePaid']),
      dateAdded: serializer.fromJson<DateTime>(json['dateAdded']),
      notes: serializer.fromJson<String?>(json['notes']),
      images: serializer.fromJson<String?>(json['images']),
      type: serializer.fromJson<String>(json['type']),
      tags: serializer.fromJson<List<String>>(json['tags']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tripId': serializer.toJson<String>(tripId),
      'expenseName': serializer.toJson<String>(expenseName),
      'category': serializer.toJson<String>(category),
      'paid': serializer.toJson<double>(paid),
      'cost': serializer.toJson<double>(cost),
      'currency': serializer.toJson<String>(currency),
      'datePaid': serializer.toJson<DateTime>(datePaid),
      'dateAdded': serializer.toJson<DateTime>(dateAdded),
      'notes': serializer.toJson<String?>(notes),
      'images': serializer.toJson<String?>(images),
      'type': serializer.toJson<String>(type),
      'tags': serializer.toJson<List<String>>(tags),
    };
  }

  Expense copyWith({
    String? id,
    String? tripId,
    String? expenseName,
    String? category,
    double? paid,
    double? cost,
    String? currency,
    DateTime? datePaid,
    DateTime? dateAdded,
    Value<String?> notes = const Value.absent(),
    Value<String?> images = const Value.absent(),
    String? type,
    List<String>? tags,
  }) => Expense(
    id: id ?? this.id,
    tripId: tripId ?? this.tripId,
    expenseName: expenseName ?? this.expenseName,
    category: category ?? this.category,
    paid: paid ?? this.paid,
    cost: cost ?? this.cost,
    currency: currency ?? this.currency,
    datePaid: datePaid ?? this.datePaid,
    dateAdded: dateAdded ?? this.dateAdded,
    notes: notes.present ? notes.value : this.notes,
    images: images.present ? images.value : this.images,
    type: type ?? this.type,
    tags: tags ?? this.tags,
  );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      expenseName: data.expenseName.present
          ? data.expenseName.value
          : this.expenseName,
      category: data.category.present ? data.category.value : this.category,
      paid: data.paid.present ? data.paid.value : this.paid,
      cost: data.cost.present ? data.cost.value : this.cost,
      currency: data.currency.present ? data.currency.value : this.currency,
      datePaid: data.datePaid.present ? data.datePaid.value : this.datePaid,
      dateAdded: data.dateAdded.present ? data.dateAdded.value : this.dateAdded,
      notes: data.notes.present ? data.notes.value : this.notes,
      images: data.images.present ? data.images.value : this.images,
      type: data.type.present ? data.type.value : this.type,
      tags: data.tags.present ? data.tags.value : this.tags,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('expenseName: $expenseName, ')
          ..write('category: $category, ')
          ..write('paid: $paid, ')
          ..write('cost: $cost, ')
          ..write('currency: $currency, ')
          ..write('datePaid: $datePaid, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('notes: $notes, ')
          ..write('images: $images, ')
          ..write('type: $type, ')
          ..write('tags: $tags')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tripId,
    expenseName,
    category,
    paid,
    cost,
    currency,
    datePaid,
    dateAdded,
    notes,
    images,
    type,
    tags,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.expenseName == this.expenseName &&
          other.category == this.category &&
          other.paid == this.paid &&
          other.cost == this.cost &&
          other.currency == this.currency &&
          other.datePaid == this.datePaid &&
          other.dateAdded == this.dateAdded &&
          other.notes == this.notes &&
          other.images == this.images &&
          other.type == this.type &&
          other.tags == this.tags);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<String> id;
  final Value<String> tripId;
  final Value<String> expenseName;
  final Value<String> category;
  final Value<double> paid;
  final Value<double> cost;
  final Value<String> currency;
  final Value<DateTime> datePaid;
  final Value<DateTime> dateAdded;
  final Value<String?> notes;
  final Value<String?> images;
  final Value<String> type;
  final Value<List<String>> tags;
  final Value<int> rowid;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.expenseName = const Value.absent(),
    this.category = const Value.absent(),
    this.paid = const Value.absent(),
    this.cost = const Value.absent(),
    this.currency = const Value.absent(),
    this.datePaid = const Value.absent(),
    this.dateAdded = const Value.absent(),
    this.notes = const Value.absent(),
    this.images = const Value.absent(),
    this.type = const Value.absent(),
    this.tags = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required String tripId,
    required String expenseName,
    required String category,
    required double paid,
    required double cost,
    required String currency,
    required DateTime datePaid,
    required DateTime dateAdded,
    this.notes = const Value.absent(),
    this.images = const Value.absent(),
    required String type,
    required List<String> tags,
    this.rowid = const Value.absent(),
  }) : tripId = Value(tripId),
       expenseName = Value(expenseName),
       category = Value(category),
       paid = Value(paid),
       cost = Value(cost),
       currency = Value(currency),
       datePaid = Value(datePaid),
       dateAdded = Value(dateAdded),
       type = Value(type),
       tags = Value(tags);
  static Insertable<Expense> custom({
    Expression<String>? id,
    Expression<String>? tripId,
    Expression<String>? expenseName,
    Expression<String>? category,
    Expression<double>? paid,
    Expression<double>? cost,
    Expression<String>? currency,
    Expression<DateTime>? datePaid,
    Expression<DateTime>? dateAdded,
    Expression<String>? notes,
    Expression<String>? images,
    Expression<String>? type,
    Expression<String>? tags,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (expenseName != null) 'expense_name': expenseName,
      if (category != null) 'category': category,
      if (paid != null) 'paid': paid,
      if (cost != null) 'cost': cost,
      if (currency != null) 'currency': currency,
      if (datePaid != null) 'date_paid': datePaid,
      if (dateAdded != null) 'date_added': dateAdded,
      if (notes != null) 'notes': notes,
      if (images != null) 'images': images,
      if (type != null) 'type': type,
      if (tags != null) 'tags': tags,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpensesCompanion copyWith({
    Value<String>? id,
    Value<String>? tripId,
    Value<String>? expenseName,
    Value<String>? category,
    Value<double>? paid,
    Value<double>? cost,
    Value<String>? currency,
    Value<DateTime>? datePaid,
    Value<DateTime>? dateAdded,
    Value<String?>? notes,
    Value<String?>? images,
    Value<String>? type,
    Value<List<String>>? tags,
    Value<int>? rowid,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      expenseName: expenseName ?? this.expenseName,
      category: category ?? this.category,
      paid: paid ?? this.paid,
      cost: cost ?? this.cost,
      currency: currency ?? this.currency,
      datePaid: datePaid ?? this.datePaid,
      dateAdded: dateAdded ?? this.dateAdded,
      notes: notes ?? this.notes,
      images: images ?? this.images,
      type: type ?? this.type,
      tags: tags ?? this.tags,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (expenseName.present) {
      map['expense_name'] = Variable<String>(expenseName.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (paid.present) {
      map['paid'] = Variable<double>(paid.value);
    }
    if (cost.present) {
      map['cost'] = Variable<double>(cost.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (datePaid.present) {
      map['date_paid'] = Variable<DateTime>(datePaid.value);
    }
    if (dateAdded.present) {
      map['date_added'] = Variable<DateTime>(dateAdded.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (images.present) {
      map['images'] = Variable<String>(images.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(
        $ExpensesTable.$convertertags.toSql(tags.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('expenseName: $expenseName, ')
          ..write('category: $category, ')
          ..write('paid: $paid, ')
          ..write('cost: $cost, ')
          ..write('currency: $currency, ')
          ..write('datePaid: $datePaid, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('notes: $notes, ')
          ..write('images: $images, ')
          ..write('type: $type, ')
          ..write('tags: $tags, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $TripsTable trips = $TripsTable(this);
  late final $RatingsTable ratings = $RatingsTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final UserDao userDao = UserDao(this as AppDatabase);
  late final TripDao tripDao = TripDao(this as AppDatabase);
  late final RatingDao ratingDao = RatingDao(this as AppDatabase);
  late final ExpenseDao expenseDao = ExpenseDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    trips,
    ratings,
    expenses,
  ];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      required String username,
      required String fullName,
      required DateTime dob,
      required String gender,
      required bool admin,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      Value<String> username,
      Value<String> fullName,
      Value<DateTime> dob,
      Value<String> gender,
      Value<bool> admin,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TripsTable, List<Trip>> _tripsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.trips,
    aliasName: $_aliasNameGenerator(db.users.id, db.trips.userId),
  );

  $$TripsTableProcessedTableManager get tripsRefs {
    final manager = $$TripsTableTableManager(
      $_db,
      $_db.trips,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tripsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dob => $composableBuilder(
    column: $table.dob,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get admin => $composableBuilder(
    column: $table.admin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> tripsRefs(
    Expression<bool> Function($$TripsTableFilterComposer f) f,
  ) {
    final $$TripsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableFilterComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dob => $composableBuilder(
    column: $table.dob,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get admin => $composableBuilder(
    column: $table.admin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<DateTime> get dob =>
      $composableBuilder(column: $table.dob, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<bool> get admin =>
      $composableBuilder(column: $table.admin, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> tripsRefs<T extends Object>(
    Expression<T> Function($$TripsTableAnnotationComposer a) f,
  ) {
    final $$TripsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableAnnotationComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, $$UsersTableReferences),
          User,
          PrefetchHooks Function({bool tripsRefs})
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<DateTime> dob = const Value.absent(),
                Value<String> gender = const Value.absent(),
                Value<bool> admin = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                username: username,
                fullName: fullName,
                dob: dob,
                gender: gender,
                admin: admin,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String username,
                required String fullName,
                required DateTime dob,
                required String gender,
                required bool admin,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                username: username,
                fullName: fullName,
                dob: dob,
                gender: gender,
                admin: admin,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UsersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({tripsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (tripsRefs) db.trips],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tripsRefs)
                    await $_getPrefetchedData<User, $UsersTable, Trip>(
                      currentTable: table,
                      referencedTable: $$UsersTableReferences._tripsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$UsersTableReferences(db, table, p0).tripsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.userId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, $$UsersTableReferences),
      User,
      PrefetchHooks Function({bool tripsRefs})
    >;
typedef $$TripsTableCreateCompanionBuilder =
    TripsCompanion Function({
      Value<String> id,
      required String userId,
      required String tripName,
      required String location,
      required String currency,
      required double budget,
      required String category,
      Value<String?> notes,
      Value<String?> images,
      required String bgColour,
      required DateTime startDate,
      required DateTime endDate,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$TripsTableUpdateCompanionBuilder =
    TripsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> tripName,
      Value<String> location,
      Value<String> currency,
      Value<double> budget,
      Value<String> category,
      Value<String?> notes,
      Value<String?> images,
      Value<String> bgColour,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$TripsTableReferences
    extends BaseReferences<_$AppDatabase, $TripsTable, Trip> {
  $$TripsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias($_aliasNameGenerator(db.trips.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RatingsTable, List<Rating>> _ratingsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.ratings,
    aliasName: $_aliasNameGenerator(db.trips.id, db.ratings.tripId),
  );

  $$RatingsTableProcessedTableManager get ratingsRefs {
    final manager = $$RatingsTableTableManager(
      $_db,
      $_db.ratings,
    ).filter((f) => f.tripId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_ratingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExpensesTable, List<Expense>> _expensesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.expenses,
    aliasName: $_aliasNameGenerator(db.trips.id, db.expenses.tripId),
  );

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager(
      $_db,
      $_db.expenses,
    ).filter((f) => f.tripId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TripsTableFilterComposer extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tripName => $composableBuilder(
    column: $table.tripName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get budget => $composableBuilder(
    column: $table.budget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get images => $composableBuilder(
    column: $table.images,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bgColour => $composableBuilder(
    column: $table.bgColour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> ratingsRefs(
    Expression<bool> Function($$RatingsTableFilterComposer f) f,
  ) {
    final $$RatingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ratings,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RatingsTableFilterComposer(
            $db: $db,
            $table: $db.ratings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> expensesRefs(
    Expression<bool> Function($$ExpensesTableFilterComposer f) f,
  ) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableFilterComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TripsTableOrderingComposer
    extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tripName => $composableBuilder(
    column: $table.tripName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get budget => $composableBuilder(
    column: $table.budget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get images => $composableBuilder(
    column: $table.images,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bgColour => $composableBuilder(
    column: $table.bgColour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TripsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tripName =>
      $composableBuilder(column: $table.tripName, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<double> get budget =>
      $composableBuilder(column: $table.budget, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get images =>
      $composableBuilder(column: $table.images, builder: (column) => column);

  GeneratedColumn<String> get bgColour =>
      $composableBuilder(column: $table.bgColour, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> ratingsRefs<T extends Object>(
    Expression<T> Function($$RatingsTableAnnotationComposer a) f,
  ) {
    final $$RatingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ratings,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RatingsTableAnnotationComposer(
            $db: $db,
            $table: $db.ratings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> expensesRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TripsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TripsTable,
          Trip,
          $$TripsTableFilterComposer,
          $$TripsTableOrderingComposer,
          $$TripsTableAnnotationComposer,
          $$TripsTableCreateCompanionBuilder,
          $$TripsTableUpdateCompanionBuilder,
          (Trip, $$TripsTableReferences),
          Trip,
          PrefetchHooks Function({
            bool userId,
            bool ratingsRefs,
            bool expensesRefs,
          })
        > {
  $$TripsTableTableManager(_$AppDatabase db, $TripsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TripsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TripsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TripsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> tripName = const Value.absent(),
                Value<String> location = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<double> budget = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> images = const Value.absent(),
                Value<String> bgColour = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TripsCompanion(
                id: id,
                userId: userId,
                tripName: tripName,
                location: location,
                currency: currency,
                budget: budget,
                category: category,
                notes: notes,
                images: images,
                bgColour: bgColour,
                startDate: startDate,
                endDate: endDate,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String userId,
                required String tripName,
                required String location,
                required String currency,
                required double budget,
                required String category,
                Value<String?> notes = const Value.absent(),
                Value<String?> images = const Value.absent(),
                required String bgColour,
                required DateTime startDate,
                required DateTime endDate,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => TripsCompanion.insert(
                id: id,
                userId: userId,
                tripName: tripName,
                location: location,
                currency: currency,
                budget: budget,
                category: category,
                notes: notes,
                images: images,
                bgColour: bgColour,
                startDate: startDate,
                endDate: endDate,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TripsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({userId = false, ratingsRefs = false, expensesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (ratingsRefs) db.ratings,
                    if (expensesRefs) db.expenses,
                  ],
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
                        if (userId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.userId,
                                    referencedTable: $$TripsTableReferences
                                        ._userIdTable(db),
                                    referencedColumn: $$TripsTableReferences
                                        ._userIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (ratingsRefs)
                        await $_getPrefetchedData<Trip, $TripsTable, Rating>(
                          currentTable: table,
                          referencedTable: $$TripsTableReferences
                              ._ratingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TripsTableReferences(db, table, p0).ratingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tripId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (expensesRefs)
                        await $_getPrefetchedData<Trip, $TripsTable, Expense>(
                          currentTable: table,
                          referencedTable: $$TripsTableReferences
                              ._expensesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TripsTableReferences(
                                db,
                                table,
                                p0,
                              ).expensesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tripId == item.id,
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

typedef $$TripsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TripsTable,
      Trip,
      $$TripsTableFilterComposer,
      $$TripsTableOrderingComposer,
      $$TripsTableAnnotationComposer,
      $$TripsTableCreateCompanionBuilder,
      $$TripsTableUpdateCompanionBuilder,
      (Trip, $$TripsTableReferences),
      Trip,
      PrefetchHooks Function({bool userId, bool ratingsRefs, bool expensesRefs})
    >;
typedef $$RatingsTableCreateCompanionBuilder =
    RatingsCompanion Function({
      Value<String> id,
      required String tripId,
      required String placeName,
      required String location,
      required String category,
      required String status,
      Value<double?> rating,
      Value<DateTime?> dateVisited,
      Value<DateTime?> datePlanned,
      Value<String?> value,
      Value<String?> notes,
      Value<String?> images,
      required List<String> tags,
      Value<DateTime?> createdAt,
      Value<int> rowid,
    });
typedef $$RatingsTableUpdateCompanionBuilder =
    RatingsCompanion Function({
      Value<String> id,
      Value<String> tripId,
      Value<String> placeName,
      Value<String> location,
      Value<String> category,
      Value<String> status,
      Value<double?> rating,
      Value<DateTime?> dateVisited,
      Value<DateTime?> datePlanned,
      Value<String?> value,
      Value<String?> notes,
      Value<String?> images,
      Value<List<String>> tags,
      Value<DateTime?> createdAt,
      Value<int> rowid,
    });

final class $$RatingsTableReferences
    extends BaseReferences<_$AppDatabase, $RatingsTable, Rating> {
  $$RatingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TripsTable _tripIdTable(_$AppDatabase db) => db.trips.createAlias(
    $_aliasNameGenerator(db.ratings.tripId, db.trips.id),
  );

  $$TripsTableProcessedTableManager get tripId {
    final $_column = $_itemColumn<String>('trip_id')!;

    final manager = $$TripsTableTableManager(
      $_db,
      $_db.trips,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RatingsTableFilterComposer
    extends Composer<_$AppDatabase, $RatingsTable> {
  $$RatingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placeName => $composableBuilder(
    column: $table.placeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateVisited => $composableBuilder(
    column: $table.dateVisited,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get datePlanned => $composableBuilder(
    column: $table.datePlanned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get images => $composableBuilder(
    column: $table.images,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String> get tags =>
      $composableBuilder(
        column: $table.tags,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TripsTableFilterComposer get tripId {
    final $$TripsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableFilterComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RatingsTableOrderingComposer
    extends Composer<_$AppDatabase, $RatingsTable> {
  $$RatingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placeName => $composableBuilder(
    column: $table.placeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateVisited => $composableBuilder(
    column: $table.dateVisited,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get datePlanned => $composableBuilder(
    column: $table.datePlanned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get images => $composableBuilder(
    column: $table.images,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TripsTableOrderingComposer get tripId {
    final $$TripsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableOrderingComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RatingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RatingsTable> {
  $$RatingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get placeName =>
      $composableBuilder(column: $table.placeName, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<DateTime> get dateVisited => $composableBuilder(
    column: $table.dateVisited,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get datePlanned => $composableBuilder(
    column: $table.datePlanned,
    builder: (column) => column,
  );

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get images =>
      $composableBuilder(column: $table.images, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$TripsTableAnnotationComposer get tripId {
    final $$TripsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableAnnotationComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RatingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RatingsTable,
          Rating,
          $$RatingsTableFilterComposer,
          $$RatingsTableOrderingComposer,
          $$RatingsTableAnnotationComposer,
          $$RatingsTableCreateCompanionBuilder,
          $$RatingsTableUpdateCompanionBuilder,
          (Rating, $$RatingsTableReferences),
          Rating,
          PrefetchHooks Function({bool tripId})
        > {
  $$RatingsTableTableManager(_$AppDatabase db, $RatingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RatingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RatingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RatingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tripId = const Value.absent(),
                Value<String> placeName = const Value.absent(),
                Value<String> location = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<double?> rating = const Value.absent(),
                Value<DateTime?> dateVisited = const Value.absent(),
                Value<DateTime?> datePlanned = const Value.absent(),
                Value<String?> value = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> images = const Value.absent(),
                Value<List<String>> tags = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RatingsCompanion(
                id: id,
                tripId: tripId,
                placeName: placeName,
                location: location,
                category: category,
                status: status,
                rating: rating,
                dateVisited: dateVisited,
                datePlanned: datePlanned,
                value: value,
                notes: notes,
                images: images,
                tags: tags,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String tripId,
                required String placeName,
                required String location,
                required String category,
                required String status,
                Value<double?> rating = const Value.absent(),
                Value<DateTime?> dateVisited = const Value.absent(),
                Value<DateTime?> datePlanned = const Value.absent(),
                Value<String?> value = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> images = const Value.absent(),
                required List<String> tags,
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RatingsCompanion.insert(
                id: id,
                tripId: tripId,
                placeName: placeName,
                location: location,
                category: category,
                status: status,
                rating: rating,
                dateVisited: dateVisited,
                datePlanned: datePlanned,
                value: value,
                notes: notes,
                images: images,
                tags: tags,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RatingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tripId = false}) {
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
                    if (tripId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tripId,
                                referencedTable: $$RatingsTableReferences
                                    ._tripIdTable(db),
                                referencedColumn: $$RatingsTableReferences
                                    ._tripIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$RatingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RatingsTable,
      Rating,
      $$RatingsTableFilterComposer,
      $$RatingsTableOrderingComposer,
      $$RatingsTableAnnotationComposer,
      $$RatingsTableCreateCompanionBuilder,
      $$RatingsTableUpdateCompanionBuilder,
      (Rating, $$RatingsTableReferences),
      Rating,
      PrefetchHooks Function({bool tripId})
    >;
typedef $$ExpensesTableCreateCompanionBuilder =
    ExpensesCompanion Function({
      Value<String> id,
      required String tripId,
      required String expenseName,
      required String category,
      required double paid,
      required double cost,
      required String currency,
      required DateTime datePaid,
      required DateTime dateAdded,
      Value<String?> notes,
      Value<String?> images,
      required String type,
      required List<String> tags,
      Value<int> rowid,
    });
typedef $$ExpensesTableUpdateCompanionBuilder =
    ExpensesCompanion Function({
      Value<String> id,
      Value<String> tripId,
      Value<String> expenseName,
      Value<String> category,
      Value<double> paid,
      Value<double> cost,
      Value<String> currency,
      Value<DateTime> datePaid,
      Value<DateTime> dateAdded,
      Value<String?> notes,
      Value<String?> images,
      Value<String> type,
      Value<List<String>> tags,
      Value<int> rowid,
    });

final class $$ExpensesTableReferences
    extends BaseReferences<_$AppDatabase, $ExpensesTable, Expense> {
  $$ExpensesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TripsTable _tripIdTable(_$AppDatabase db) => db.trips.createAlias(
    $_aliasNameGenerator(db.expenses.tripId, db.trips.id),
  );

  $$TripsTableProcessedTableManager get tripId {
    final $_column = $_itemColumn<String>('trip_id')!;

    final manager = $$TripsTableTableManager(
      $_db,
      $_db.trips,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expenseName => $composableBuilder(
    column: $table.expenseName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get paid => $composableBuilder(
    column: $table.paid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get datePaid => $composableBuilder(
    column: $table.datePaid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateAdded => $composableBuilder(
    column: $table.dateAdded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get images => $composableBuilder(
    column: $table.images,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String> get tags =>
      $composableBuilder(
        column: $table.tags,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$TripsTableFilterComposer get tripId {
    final $$TripsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableFilterComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expenseName => $composableBuilder(
    column: $table.expenseName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get paid => $composableBuilder(
    column: $table.paid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get datePaid => $composableBuilder(
    column: $table.datePaid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateAdded => $composableBuilder(
    column: $table.dateAdded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get images => $composableBuilder(
    column: $table.images,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  $$TripsTableOrderingComposer get tripId {
    final $$TripsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableOrderingComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get expenseName => $composableBuilder(
    column: $table.expenseName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get paid =>
      $composableBuilder(column: $table.paid, builder: (column) => column);

  GeneratedColumn<double> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<DateTime> get datePaid =>
      $composableBuilder(column: $table.datePaid, builder: (column) => column);

  GeneratedColumn<DateTime> get dateAdded =>
      $composableBuilder(column: $table.dateAdded, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get images =>
      $composableBuilder(column: $table.images, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  $$TripsTableAnnotationComposer get tripId {
    final $$TripsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableAnnotationComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTable,
          Expense,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (Expense, $$ExpensesTableReferences),
          Expense,
          PrefetchHooks Function({bool tripId})
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tripId = const Value.absent(),
                Value<String> expenseName = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<double> paid = const Value.absent(),
                Value<double> cost = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<DateTime> datePaid = const Value.absent(),
                Value<DateTime> dateAdded = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> images = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<List<String>> tags = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                tripId: tripId,
                expenseName: expenseName,
                category: category,
                paid: paid,
                cost: cost,
                currency: currency,
                datePaid: datePaid,
                dateAdded: dateAdded,
                notes: notes,
                images: images,
                type: type,
                tags: tags,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String tripId,
                required String expenseName,
                required String category,
                required double paid,
                required double cost,
                required String currency,
                required DateTime datePaid,
                required DateTime dateAdded,
                Value<String?> notes = const Value.absent(),
                Value<String?> images = const Value.absent(),
                required String type,
                required List<String> tags,
                Value<int> rowid = const Value.absent(),
              }) => ExpensesCompanion.insert(
                id: id,
                tripId: tripId,
                expenseName: expenseName,
                category: category,
                paid: paid,
                cost: cost,
                currency: currency,
                datePaid: datePaid,
                dateAdded: dateAdded,
                notes: notes,
                images: images,
                type: type,
                tags: tags,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExpensesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tripId = false}) {
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
                    if (tripId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tripId,
                                referencedTable: $$ExpensesTableReferences
                                    ._tripIdTable(db),
                                referencedColumn: $$ExpensesTableReferences
                                    ._tripIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTable,
      Expense,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (Expense, $$ExpensesTableReferences),
      Expense,
      PrefetchHooks Function({bool tripId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$TripsTableTableManager get trips =>
      $$TripsTableTableManager(_db, _db.trips);
  $$RatingsTableTableManager get ratings =>
      $$RatingsTableTableManager(_db, _db.ratings);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
}
