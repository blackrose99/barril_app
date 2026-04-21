// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MesasTable extends Mesas with TableInfo<$MesasTable, Mesa> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MesasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
      'estado', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('libre'));
  @override
  List<GeneratedColumn> get $columns => [id, nombre, estado];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mesas';
  @override
  VerificationContext validateIntegrity(Insertable<Mesa> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(_estadoMeta,
          estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Mesa map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Mesa(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      estado: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}estado'])!,
    );
  }

  @override
  $MesasTable createAlias(String alias) {
    return $MesasTable(attachedDatabase, alias);
  }
}

class Mesa extends DataClass implements Insertable<Mesa> {
  final int id;
  final String nombre;
  final String estado;
  const Mesa({required this.id, required this.nombre, required this.estado});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['estado'] = Variable<String>(estado);
    return map;
  }

  MesasCompanion toCompanion(bool nullToAbsent) {
    return MesasCompanion(
      id: Value(id),
      nombre: Value(nombre),
      estado: Value(estado),
    );
  }

  factory Mesa.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Mesa(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      estado: serializer.fromJson<String>(json['estado']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'estado': serializer.toJson<String>(estado),
    };
  }

  Mesa copyWith({int? id, String? nombre, String? estado}) => Mesa(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        estado: estado ?? this.estado,
      );
  Mesa copyWithCompanion(MesasCompanion data) {
    return Mesa(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      estado: data.estado.present ? data.estado.value : this.estado,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Mesa(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('estado: $estado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, estado);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Mesa &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.estado == this.estado);
}

class MesasCompanion extends UpdateCompanion<Mesa> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> estado;
  const MesasCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.estado = const Value.absent(),
  });
  MesasCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.estado = const Value.absent(),
  }) : nombre = Value(nombre);
  static Insertable<Mesa> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? estado,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (estado != null) 'estado': estado,
    });
  }

  MesasCompanion copyWith(
      {Value<int>? id, Value<String>? nombre, Value<String>? estado}) {
    return MesasCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      estado: estado ?? this.estado,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MesasCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('estado: $estado')
          ..write(')'))
        .toString();
  }
}

class $MeserosTable extends Meseros with TableInfo<$MeserosTable, Mesero> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeserosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, nombre];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meseros';
  @override
  VerificationContext validateIntegrity(Insertable<Mesero> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Mesero map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Mesero(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
    );
  }

  @override
  $MeserosTable createAlias(String alias) {
    return $MeserosTable(attachedDatabase, alias);
  }
}

class Mesero extends DataClass implements Insertable<Mesero> {
  final int id;
  final String nombre;
  const Mesero({required this.id, required this.nombre});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    return map;
  }

  MeserosCompanion toCompanion(bool nullToAbsent) {
    return MeserosCompanion(
      id: Value(id),
      nombre: Value(nombre),
    );
  }

  factory Mesero.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Mesero(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
    };
  }

  Mesero copyWith({int? id, String? nombre}) => Mesero(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
      );
  Mesero copyWithCompanion(MeserosCompanion data) {
    return Mesero(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Mesero(')
          ..write('id: $id, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Mesero && other.id == this.id && other.nombre == this.nombre);
}

class MeserosCompanion extends UpdateCompanion<Mesero> {
  final Value<int> id;
  final Value<String> nombre;
  const MeserosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
  });
  MeserosCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
  }) : nombre = Value(nombre);
  static Insertable<Mesero> custom({
    Expression<int>? id,
    Expression<String>? nombre,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
    });
  }

  MeserosCompanion copyWith({Value<int>? id, Value<String>? nombre}) {
    return MeserosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeserosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }
}

class $PedidosTable extends Pedidos with TableInfo<$PedidosTable, Pedido> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PedidosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _mesaIdMeta = const VerificationMeta('mesaId');
  @override
  late final GeneratedColumn<int> mesaId = GeneratedColumn<int>(
      'mesa_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES mesas (id)'));
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
      'tipo', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('mesa'));
  static const VerificationMeta _valorDomicilioMeta =
      const VerificationMeta('valorDomicilio');
  @override
  late final GeneratedColumn<double> valorDomicilio = GeneratedColumn<double>(
      'valor_domicilio', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
      'estado', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('abierto'));
  static const VerificationMeta _creadoEnMeta =
      const VerificationMeta('creadoEn');
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
      'creado_en', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _cerradoEnMeta =
      const VerificationMeta('cerradoEn');
  @override
  late final GeneratedColumn<DateTime> cerradoEn = GeneratedColumn<DateTime>(
      'cerrado_en', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, mesaId, tipo, valorDomicilio, estado, creadoEn, cerradoEn];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pedidos';
  @override
  VerificationContext validateIntegrity(Insertable<Pedido> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('mesa_id')) {
      context.handle(_mesaIdMeta,
          mesaId.isAcceptableOrUnknown(data['mesa_id']!, _mesaIdMeta));
    }
    if (data.containsKey('tipo')) {
      context.handle(
          _tipoMeta, tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta));
    }
    if (data.containsKey('valor_domicilio')) {
      context.handle(
          _valorDomicilioMeta,
          valorDomicilio.isAcceptableOrUnknown(
              data['valor_domicilio']!, _valorDomicilioMeta));
    }
    if (data.containsKey('estado')) {
      context.handle(_estadoMeta,
          estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta));
    }
    if (data.containsKey('creado_en')) {
      context.handle(_creadoEnMeta,
          creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta));
    }
    if (data.containsKey('cerrado_en')) {
      context.handle(_cerradoEnMeta,
          cerradoEn.isAcceptableOrUnknown(data['cerrado_en']!, _cerradoEnMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Pedido map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pedido(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      mesaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mesa_id']),
      tipo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tipo'])!,
      valorDomicilio: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}valor_domicilio'])!,
      estado: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}estado'])!,
      creadoEn: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}creado_en'])!,
      cerradoEn: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}cerrado_en']),
    );
  }

  @override
  $PedidosTable createAlias(String alias) {
    return $PedidosTable(attachedDatabase, alias);
  }
}

class Pedido extends DataClass implements Insertable<Pedido> {
  final int id;
  final int? mesaId;
  final String tipo;
  final double valorDomicilio;
  final String estado;
  final DateTime creadoEn;
  final DateTime? cerradoEn;
  const Pedido(
      {required this.id,
      this.mesaId,
      required this.tipo,
      required this.valorDomicilio,
      required this.estado,
      required this.creadoEn,
      this.cerradoEn});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || mesaId != null) {
      map['mesa_id'] = Variable<int>(mesaId);
    }
    map['tipo'] = Variable<String>(tipo);
    map['valor_domicilio'] = Variable<double>(valorDomicilio);
    map['estado'] = Variable<String>(estado);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    if (!nullToAbsent || cerradoEn != null) {
      map['cerrado_en'] = Variable<DateTime>(cerradoEn);
    }
    return map;
  }

  PedidosCompanion toCompanion(bool nullToAbsent) {
    return PedidosCompanion(
      id: Value(id),
      mesaId:
          mesaId == null && nullToAbsent ? const Value.absent() : Value(mesaId),
      tipo: Value(tipo),
      valorDomicilio: Value(valorDomicilio),
      estado: Value(estado),
      creadoEn: Value(creadoEn),
      cerradoEn: cerradoEn == null && nullToAbsent
          ? const Value.absent()
          : Value(cerradoEn),
    );
  }

  factory Pedido.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pedido(
      id: serializer.fromJson<int>(json['id']),
      mesaId: serializer.fromJson<int?>(json['mesaId']),
      tipo: serializer.fromJson<String>(json['tipo']),
      valorDomicilio: serializer.fromJson<double>(json['valorDomicilio']),
      estado: serializer.fromJson<String>(json['estado']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
      cerradoEn: serializer.fromJson<DateTime?>(json['cerradoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mesaId': serializer.toJson<int?>(mesaId),
      'tipo': serializer.toJson<String>(tipo),
      'valorDomicilio': serializer.toJson<double>(valorDomicilio),
      'estado': serializer.toJson<String>(estado),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
      'cerradoEn': serializer.toJson<DateTime?>(cerradoEn),
    };
  }

  Pedido copyWith(
          {int? id,
          Value<int?> mesaId = const Value.absent(),
          String? tipo,
          double? valorDomicilio,
          String? estado,
          DateTime? creadoEn,
          Value<DateTime?> cerradoEn = const Value.absent()}) =>
      Pedido(
        id: id ?? this.id,
        mesaId: mesaId.present ? mesaId.value : this.mesaId,
        tipo: tipo ?? this.tipo,
        valorDomicilio: valorDomicilio ?? this.valorDomicilio,
        estado: estado ?? this.estado,
        creadoEn: creadoEn ?? this.creadoEn,
        cerradoEn: cerradoEn.present ? cerradoEn.value : this.cerradoEn,
      );
  Pedido copyWithCompanion(PedidosCompanion data) {
    return Pedido(
      id: data.id.present ? data.id.value : this.id,
      mesaId: data.mesaId.present ? data.mesaId.value : this.mesaId,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      valorDomicilio: data.valorDomicilio.present
          ? data.valorDomicilio.value
          : this.valorDomicilio,
      estado: data.estado.present ? data.estado.value : this.estado,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
      cerradoEn: data.cerradoEn.present ? data.cerradoEn.value : this.cerradoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Pedido(')
          ..write('id: $id, ')
          ..write('mesaId: $mesaId, ')
          ..write('tipo: $tipo, ')
          ..write('valorDomicilio: $valorDomicilio, ')
          ..write('estado: $estado, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('cerradoEn: $cerradoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, mesaId, tipo, valorDomicilio, estado, creadoEn, cerradoEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pedido &&
          other.id == this.id &&
          other.mesaId == this.mesaId &&
          other.tipo == this.tipo &&
          other.valorDomicilio == this.valorDomicilio &&
          other.estado == this.estado &&
          other.creadoEn == this.creadoEn &&
          other.cerradoEn == this.cerradoEn);
}

class PedidosCompanion extends UpdateCompanion<Pedido> {
  final Value<int> id;
  final Value<int?> mesaId;
  final Value<String> tipo;
  final Value<double> valorDomicilio;
  final Value<String> estado;
  final Value<DateTime> creadoEn;
  final Value<DateTime?> cerradoEn;
  const PedidosCompanion({
    this.id = const Value.absent(),
    this.mesaId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.valorDomicilio = const Value.absent(),
    this.estado = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.cerradoEn = const Value.absent(),
  });
  PedidosCompanion.insert({
    this.id = const Value.absent(),
    this.mesaId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.valorDomicilio = const Value.absent(),
    this.estado = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.cerradoEn = const Value.absent(),
  });
  static Insertable<Pedido> custom({
    Expression<int>? id,
    Expression<int>? mesaId,
    Expression<String>? tipo,
    Expression<double>? valorDomicilio,
    Expression<String>? estado,
    Expression<DateTime>? creadoEn,
    Expression<DateTime>? cerradoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mesaId != null) 'mesa_id': mesaId,
      if (tipo != null) 'tipo': tipo,
      if (valorDomicilio != null) 'valor_domicilio': valorDomicilio,
      if (estado != null) 'estado': estado,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (cerradoEn != null) 'cerrado_en': cerradoEn,
    });
  }

  PedidosCompanion copyWith(
      {Value<int>? id,
      Value<int?>? mesaId,
      Value<String>? tipo,
      Value<double>? valorDomicilio,
      Value<String>? estado,
      Value<DateTime>? creadoEn,
      Value<DateTime?>? cerradoEn}) {
    return PedidosCompanion(
      id: id ?? this.id,
      mesaId: mesaId ?? this.mesaId,
      tipo: tipo ?? this.tipo,
      valorDomicilio: valorDomicilio ?? this.valorDomicilio,
      estado: estado ?? this.estado,
      creadoEn: creadoEn ?? this.creadoEn,
      cerradoEn: cerradoEn ?? this.cerradoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mesaId.present) {
      map['mesa_id'] = Variable<int>(mesaId.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (valorDomicilio.present) {
      map['valor_domicilio'] = Variable<double>(valorDomicilio.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (cerradoEn.present) {
      map['cerrado_en'] = Variable<DateTime>(cerradoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PedidosCompanion(')
          ..write('id: $id, ')
          ..write('mesaId: $mesaId, ')
          ..write('tipo: $tipo, ')
          ..write('valorDomicilio: $valorDomicilio, ')
          ..write('estado: $estado, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('cerradoEn: $cerradoEn')
          ..write(')'))
        .toString();
  }
}

class $ItemsPedidoTable extends ItemsPedido
    with TableInfo<$ItemsPedidoTable, ItemsPedidoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemsPedidoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _pedidoIdMeta =
      const VerificationMeta('pedidoId');
  @override
  late final GeneratedColumn<int> pedidoId = GeneratedColumn<int>(
      'pedido_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES pedidos (id)'));
  static const VerificationMeta _productoIdMeta =
      const VerificationMeta('productoId');
  @override
  late final GeneratedColumn<int> productoId = GeneratedColumn<int>(
      'producto_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nombreProductoMeta =
      const VerificationMeta('nombreProducto');
  @override
  late final GeneratedColumn<String> nombreProducto = GeneratedColumn<String>(
      'nombre_producto', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _precioMeta = const VerificationMeta('precio');
  @override
  late final GeneratedColumn<double> precio = GeneratedColumn<double>(
      'precio', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _cantidadMeta =
      const VerificationMeta('cantidad');
  @override
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
      'cantidad', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _adicionalesMeta =
      const VerificationMeta('adicionales');
  @override
  late final GeneratedColumn<String> adicionales = GeneratedColumn<String>(
      'adicionales', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _notaMeta = const VerificationMeta('nota');
  @override
  late final GeneratedColumn<String> nota = GeneratedColumn<String>(
      'nota', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        pedidoId,
        productoId,
        nombreProducto,
        precio,
        cantidad,
        adicionales,
        nota
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'items_pedido';
  @override
  VerificationContext validateIntegrity(Insertable<ItemsPedidoData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pedido_id')) {
      context.handle(_pedidoIdMeta,
          pedidoId.isAcceptableOrUnknown(data['pedido_id']!, _pedidoIdMeta));
    } else if (isInserting) {
      context.missing(_pedidoIdMeta);
    }
    if (data.containsKey('producto_id')) {
      context.handle(
          _productoIdMeta,
          productoId.isAcceptableOrUnknown(
              data['producto_id']!, _productoIdMeta));
    } else if (isInserting) {
      context.missing(_productoIdMeta);
    }
    if (data.containsKey('nombre_producto')) {
      context.handle(
          _nombreProductoMeta,
          nombreProducto.isAcceptableOrUnknown(
              data['nombre_producto']!, _nombreProductoMeta));
    } else if (isInserting) {
      context.missing(_nombreProductoMeta);
    }
    if (data.containsKey('precio')) {
      context.handle(_precioMeta,
          precio.isAcceptableOrUnknown(data['precio']!, _precioMeta));
    } else if (isInserting) {
      context.missing(_precioMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(_cantidadMeta,
          cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta));
    }
    if (data.containsKey('adicionales')) {
      context.handle(
          _adicionalesMeta,
          adicionales.isAcceptableOrUnknown(
              data['adicionales']!, _adicionalesMeta));
    }
    if (data.containsKey('nota')) {
      context.handle(
          _notaMeta, nota.isAcceptableOrUnknown(data['nota']!, _notaMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItemsPedidoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemsPedidoData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      pedidoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pedido_id'])!,
      productoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}producto_id'])!,
      nombreProducto: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}nombre_producto'])!,
      precio: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}precio'])!,
      cantidad: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cantidad'])!,
      adicionales: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}adicionales'])!,
      nota: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nota'])!,
    );
  }

  @override
  $ItemsPedidoTable createAlias(String alias) {
    return $ItemsPedidoTable(attachedDatabase, alias);
  }
}

class ItemsPedidoData extends DataClass implements Insertable<ItemsPedidoData> {
  final int id;
  final int pedidoId;
  final int productoId;
  final String nombreProducto;
  final double precio;
  final int cantidad;
  final String adicionales;
  final String nota;
  const ItemsPedidoData(
      {required this.id,
      required this.pedidoId,
      required this.productoId,
      required this.nombreProducto,
      required this.precio,
      required this.cantidad,
      required this.adicionales,
      required this.nota});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pedido_id'] = Variable<int>(pedidoId);
    map['producto_id'] = Variable<int>(productoId);
    map['nombre_producto'] = Variable<String>(nombreProducto);
    map['precio'] = Variable<double>(precio);
    map['cantidad'] = Variable<int>(cantidad);
    map['adicionales'] = Variable<String>(adicionales);
    map['nota'] = Variable<String>(nota);
    return map;
  }

  ItemsPedidoCompanion toCompanion(bool nullToAbsent) {
    return ItemsPedidoCompanion(
      id: Value(id),
      pedidoId: Value(pedidoId),
      productoId: Value(productoId),
      nombreProducto: Value(nombreProducto),
      precio: Value(precio),
      cantidad: Value(cantidad),
      adicionales: Value(adicionales),
      nota: Value(nota),
    );
  }

  factory ItemsPedidoData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemsPedidoData(
      id: serializer.fromJson<int>(json['id']),
      pedidoId: serializer.fromJson<int>(json['pedidoId']),
      productoId: serializer.fromJson<int>(json['productoId']),
      nombreProducto: serializer.fromJson<String>(json['nombreProducto']),
      precio: serializer.fromJson<double>(json['precio']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      adicionales: serializer.fromJson<String>(json['adicionales']),
      nota: serializer.fromJson<String>(json['nota']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pedidoId': serializer.toJson<int>(pedidoId),
      'productoId': serializer.toJson<int>(productoId),
      'nombreProducto': serializer.toJson<String>(nombreProducto),
      'precio': serializer.toJson<double>(precio),
      'cantidad': serializer.toJson<int>(cantidad),
      'adicionales': serializer.toJson<String>(adicionales),
      'nota': serializer.toJson<String>(nota),
    };
  }

  ItemsPedidoData copyWith(
          {int? id,
          int? pedidoId,
          int? productoId,
          String? nombreProducto,
          double? precio,
          int? cantidad,
          String? adicionales,
          String? nota}) =>
      ItemsPedidoData(
        id: id ?? this.id,
        pedidoId: pedidoId ?? this.pedidoId,
        productoId: productoId ?? this.productoId,
        nombreProducto: nombreProducto ?? this.nombreProducto,
        precio: precio ?? this.precio,
        cantidad: cantidad ?? this.cantidad,
        adicionales: adicionales ?? this.adicionales,
        nota: nota ?? this.nota,
      );
  ItemsPedidoData copyWithCompanion(ItemsPedidoCompanion data) {
    return ItemsPedidoData(
      id: data.id.present ? data.id.value : this.id,
      pedidoId: data.pedidoId.present ? data.pedidoId.value : this.pedidoId,
      productoId:
          data.productoId.present ? data.productoId.value : this.productoId,
      nombreProducto: data.nombreProducto.present
          ? data.nombreProducto.value
          : this.nombreProducto,
      precio: data.precio.present ? data.precio.value : this.precio,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      adicionales:
          data.adicionales.present ? data.adicionales.value : this.adicionales,
      nota: data.nota.present ? data.nota.value : this.nota,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemsPedidoData(')
          ..write('id: $id, ')
          ..write('pedidoId: $pedidoId, ')
          ..write('productoId: $productoId, ')
          ..write('nombreProducto: $nombreProducto, ')
          ..write('precio: $precio, ')
          ..write('cantidad: $cantidad, ')
          ..write('adicionales: $adicionales, ')
          ..write('nota: $nota')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, pedidoId, productoId, nombreProducto,
      precio, cantidad, adicionales, nota);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemsPedidoData &&
          other.id == this.id &&
          other.pedidoId == this.pedidoId &&
          other.productoId == this.productoId &&
          other.nombreProducto == this.nombreProducto &&
          other.precio == this.precio &&
          other.cantidad == this.cantidad &&
          other.adicionales == this.adicionales &&
          other.nota == this.nota);
}

class ItemsPedidoCompanion extends UpdateCompanion<ItemsPedidoData> {
  final Value<int> id;
  final Value<int> pedidoId;
  final Value<int> productoId;
  final Value<String> nombreProducto;
  final Value<double> precio;
  final Value<int> cantidad;
  final Value<String> adicionales;
  final Value<String> nota;
  const ItemsPedidoCompanion({
    this.id = const Value.absent(),
    this.pedidoId = const Value.absent(),
    this.productoId = const Value.absent(),
    this.nombreProducto = const Value.absent(),
    this.precio = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.adicionales = const Value.absent(),
    this.nota = const Value.absent(),
  });
  ItemsPedidoCompanion.insert({
    this.id = const Value.absent(),
    required int pedidoId,
    required int productoId,
    required String nombreProducto,
    required double precio,
    this.cantidad = const Value.absent(),
    this.adicionales = const Value.absent(),
    this.nota = const Value.absent(),
  })  : pedidoId = Value(pedidoId),
        productoId = Value(productoId),
        nombreProducto = Value(nombreProducto),
        precio = Value(precio);
  static Insertable<ItemsPedidoData> custom({
    Expression<int>? id,
    Expression<int>? pedidoId,
    Expression<int>? productoId,
    Expression<String>? nombreProducto,
    Expression<double>? precio,
    Expression<int>? cantidad,
    Expression<String>? adicionales,
    Expression<String>? nota,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pedidoId != null) 'pedido_id': pedidoId,
      if (productoId != null) 'producto_id': productoId,
      if (nombreProducto != null) 'nombre_producto': nombreProducto,
      if (precio != null) 'precio': precio,
      if (cantidad != null) 'cantidad': cantidad,
      if (adicionales != null) 'adicionales': adicionales,
      if (nota != null) 'nota': nota,
    });
  }

  ItemsPedidoCompanion copyWith(
      {Value<int>? id,
      Value<int>? pedidoId,
      Value<int>? productoId,
      Value<String>? nombreProducto,
      Value<double>? precio,
      Value<int>? cantidad,
      Value<String>? adicionales,
      Value<String>? nota}) {
    return ItemsPedidoCompanion(
      id: id ?? this.id,
      pedidoId: pedidoId ?? this.pedidoId,
      productoId: productoId ?? this.productoId,
      nombreProducto: nombreProducto ?? this.nombreProducto,
      precio: precio ?? this.precio,
      cantidad: cantidad ?? this.cantidad,
      adicionales: adicionales ?? this.adicionales,
      nota: nota ?? this.nota,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pedidoId.present) {
      map['pedido_id'] = Variable<int>(pedidoId.value);
    }
    if (productoId.present) {
      map['producto_id'] = Variable<int>(productoId.value);
    }
    if (nombreProducto.present) {
      map['nombre_producto'] = Variable<String>(nombreProducto.value);
    }
    if (precio.present) {
      map['precio'] = Variable<double>(precio.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (adicionales.present) {
      map['adicionales'] = Variable<String>(adicionales.value);
    }
    if (nota.present) {
      map['nota'] = Variable<String>(nota.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemsPedidoCompanion(')
          ..write('id: $id, ')
          ..write('pedidoId: $pedidoId, ')
          ..write('productoId: $productoId, ')
          ..write('nombreProducto: $nombreProducto, ')
          ..write('precio: $precio, ')
          ..write('cantidad: $cantidad, ')
          ..write('adicionales: $adicionales, ')
          ..write('nota: $nota')
          ..write(')'))
        .toString();
  }
}

class $CategoriasTable extends Categorias
    with TableInfo<$CategoriasTable, Categoria> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ordenMeta = const VerificationMeta('orden');
  @override
  late final GeneratedColumn<int> orden = GeneratedColumn<int>(
      'orden', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, nombre, orden];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categorias';
  @override
  VerificationContext validateIntegrity(Insertable<Categoria> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('orden')) {
      context.handle(
          _ordenMeta, orden.isAcceptableOrUnknown(data['orden']!, _ordenMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Categoria map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Categoria(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      orden: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}orden'])!,
    );
  }

  @override
  $CategoriasTable createAlias(String alias) {
    return $CategoriasTable(attachedDatabase, alias);
  }
}

class Categoria extends DataClass implements Insertable<Categoria> {
  final int id;
  final String nombre;
  final int orden;
  const Categoria(
      {required this.id, required this.nombre, required this.orden});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['orden'] = Variable<int>(orden);
    return map;
  }

  CategoriasCompanion toCompanion(bool nullToAbsent) {
    return CategoriasCompanion(
      id: Value(id),
      nombre: Value(nombre),
      orden: Value(orden),
    );
  }

  factory Categoria.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Categoria(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      orden: serializer.fromJson<int>(json['orden']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'orden': serializer.toJson<int>(orden),
    };
  }

  Categoria copyWith({int? id, String? nombre, int? orden}) => Categoria(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        orden: orden ?? this.orden,
      );
  Categoria copyWithCompanion(CategoriasCompanion data) {
    return Categoria(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      orden: data.orden.present ? data.orden.value : this.orden,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Categoria(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('orden: $orden')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, orden);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Categoria &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.orden == this.orden);
}

class CategoriasCompanion extends UpdateCompanion<Categoria> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<int> orden;
  const CategoriasCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.orden = const Value.absent(),
  });
  CategoriasCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.orden = const Value.absent(),
  }) : nombre = Value(nombre);
  static Insertable<Categoria> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<int>? orden,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (orden != null) 'orden': orden,
    });
  }

  CategoriasCompanion copyWith(
      {Value<int>? id, Value<String>? nombre, Value<int>? orden}) {
    return CategoriasCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      orden: orden ?? this.orden,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (orden.present) {
      map['orden'] = Variable<int>(orden.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriasCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('orden: $orden')
          ..write(')'))
        .toString();
  }
}

class $ProductosTable extends Productos
    with TableInfo<$ProductosTable, Producto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _categoriaIdMeta =
      const VerificationMeta('categoriaId');
  @override
  late final GeneratedColumn<int> categoriaId = GeneratedColumn<int>(
      'categoria_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES categorias (id)'));
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descripcionMeta =
      const VerificationMeta('descripcion');
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
      'descripcion', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _precioMeta = const VerificationMeta('precio');
  @override
  late final GeneratedColumn<double> precio = GeneratedColumn<double>(
      'precio', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
      'activo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("activo" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, categoriaId, nombre, descripcion, precio, activo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'productos';
  @override
  VerificationContext validateIntegrity(Insertable<Producto> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('categoria_id')) {
      context.handle(
          _categoriaIdMeta,
          categoriaId.isAcceptableOrUnknown(
              data['categoria_id']!, _categoriaIdMeta));
    } else if (isInserting) {
      context.missing(_categoriaIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
          _descripcionMeta,
          descripcion.isAcceptableOrUnknown(
              data['descripcion']!, _descripcionMeta));
    }
    if (data.containsKey('precio')) {
      context.handle(_precioMeta,
          precio.isAcceptableOrUnknown(data['precio']!, _precioMeta));
    } else if (isInserting) {
      context.missing(_precioMeta);
    }
    if (data.containsKey('activo')) {
      context.handle(_activoMeta,
          activo.isAcceptableOrUnknown(data['activo']!, _activoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Producto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Producto(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      categoriaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}categoria_id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      descripcion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}descripcion'])!,
      precio: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}precio'])!,
      activo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}activo'])!,
    );
  }

  @override
  $ProductosTable createAlias(String alias) {
    return $ProductosTable(attachedDatabase, alias);
  }
}

class Producto extends DataClass implements Insertable<Producto> {
  final int id;
  final int categoriaId;
  final String nombre;
  final String descripcion;
  final double precio;
  final bool activo;
  const Producto(
      {required this.id,
      required this.categoriaId,
      required this.nombre,
      required this.descripcion,
      required this.precio,
      required this.activo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['categoria_id'] = Variable<int>(categoriaId);
    map['nombre'] = Variable<String>(nombre);
    map['descripcion'] = Variable<String>(descripcion);
    map['precio'] = Variable<double>(precio);
    map['activo'] = Variable<bool>(activo);
    return map;
  }

  ProductosCompanion toCompanion(bool nullToAbsent) {
    return ProductosCompanion(
      id: Value(id),
      categoriaId: Value(categoriaId),
      nombre: Value(nombre),
      descripcion: Value(descripcion),
      precio: Value(precio),
      activo: Value(activo),
    );
  }

  factory Producto.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Producto(
      id: serializer.fromJson<int>(json['id']),
      categoriaId: serializer.fromJson<int>(json['categoriaId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      precio: serializer.fromJson<double>(json['precio']),
      activo: serializer.fromJson<bool>(json['activo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoriaId': serializer.toJson<int>(categoriaId),
      'nombre': serializer.toJson<String>(nombre),
      'descripcion': serializer.toJson<String>(descripcion),
      'precio': serializer.toJson<double>(precio),
      'activo': serializer.toJson<bool>(activo),
    };
  }

  Producto copyWith(
          {int? id,
          int? categoriaId,
          String? nombre,
          String? descripcion,
          double? precio,
          bool? activo}) =>
      Producto(
        id: id ?? this.id,
        categoriaId: categoriaId ?? this.categoriaId,
        nombre: nombre ?? this.nombre,
        descripcion: descripcion ?? this.descripcion,
        precio: precio ?? this.precio,
        activo: activo ?? this.activo,
      );
  Producto copyWithCompanion(ProductosCompanion data) {
    return Producto(
      id: data.id.present ? data.id.value : this.id,
      categoriaId:
          data.categoriaId.present ? data.categoriaId.value : this.categoriaId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      descripcion:
          data.descripcion.present ? data.descripcion.value : this.descripcion,
      precio: data.precio.present ? data.precio.value : this.precio,
      activo: data.activo.present ? data.activo.value : this.activo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Producto(')
          ..write('id: $id, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('precio: $precio, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, categoriaId, nombre, descripcion, precio, activo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Producto &&
          other.id == this.id &&
          other.categoriaId == this.categoriaId &&
          other.nombre == this.nombre &&
          other.descripcion == this.descripcion &&
          other.precio == this.precio &&
          other.activo == this.activo);
}

class ProductosCompanion extends UpdateCompanion<Producto> {
  final Value<int> id;
  final Value<int> categoriaId;
  final Value<String> nombre;
  final Value<String> descripcion;
  final Value<double> precio;
  final Value<bool> activo;
  const ProductosCompanion({
    this.id = const Value.absent(),
    this.categoriaId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.precio = const Value.absent(),
    this.activo = const Value.absent(),
  });
  ProductosCompanion.insert({
    this.id = const Value.absent(),
    required int categoriaId,
    required String nombre,
    this.descripcion = const Value.absent(),
    required double precio,
    this.activo = const Value.absent(),
  })  : categoriaId = Value(categoriaId),
        nombre = Value(nombre),
        precio = Value(precio);
  static Insertable<Producto> custom({
    Expression<int>? id,
    Expression<int>? categoriaId,
    Expression<String>? nombre,
    Expression<String>? descripcion,
    Expression<double>? precio,
    Expression<bool>? activo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoriaId != null) 'categoria_id': categoriaId,
      if (nombre != null) 'nombre': nombre,
      if (descripcion != null) 'descripcion': descripcion,
      if (precio != null) 'precio': precio,
      if (activo != null) 'activo': activo,
    });
  }

  ProductosCompanion copyWith(
      {Value<int>? id,
      Value<int>? categoriaId,
      Value<String>? nombre,
      Value<String>? descripcion,
      Value<double>? precio,
      Value<bool>? activo}) {
    return ProductosCompanion(
      id: id ?? this.id,
      categoriaId: categoriaId ?? this.categoriaId,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      precio: precio ?? this.precio,
      activo: activo ?? this.activo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoriaId.present) {
      map['categoria_id'] = Variable<int>(categoriaId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (precio.present) {
      map['precio'] = Variable<double>(precio.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductosCompanion(')
          ..write('id: $id, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('precio: $precio, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }
}

class $AdicionalesTable extends Adicionales
    with TableInfo<$AdicionalesTable, Adicionale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AdicionalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
      'activo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("activo" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [id, nombre, activo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'adicionales';
  @override
  VerificationContext validateIntegrity(Insertable<Adicionale> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('activo')) {
      context.handle(_activoMeta,
          activo.isAcceptableOrUnknown(data['activo']!, _activoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Adicionale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Adicionale(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      activo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}activo'])!,
    );
  }

  @override
  $AdicionalesTable createAlias(String alias) {
    return $AdicionalesTable(attachedDatabase, alias);
  }
}

class Adicionale extends DataClass implements Insertable<Adicionale> {
  final int id;
  final String nombre;
  final bool activo;
  const Adicionale(
      {required this.id, required this.nombre, required this.activo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['activo'] = Variable<bool>(activo);
    return map;
  }

  AdicionalesCompanion toCompanion(bool nullToAbsent) {
    return AdicionalesCompanion(
      id: Value(id),
      nombre: Value(nombre),
      activo: Value(activo),
    );
  }

  factory Adicionale.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Adicionale(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      activo: serializer.fromJson<bool>(json['activo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'activo': serializer.toJson<bool>(activo),
    };
  }

  Adicionale copyWith({int? id, String? nombre, bool? activo}) => Adicionale(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        activo: activo ?? this.activo,
      );
  Adicionale copyWithCompanion(AdicionalesCompanion data) {
    return Adicionale(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      activo: data.activo.present ? data.activo.value : this.activo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Adicionale(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, activo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Adicionale &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.activo == this.activo);
}

class AdicionalesCompanion extends UpdateCompanion<Adicionale> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<bool> activo;
  const AdicionalesCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.activo = const Value.absent(),
  });
  AdicionalesCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.activo = const Value.absent(),
  }) : nombre = Value(nombre);
  static Insertable<Adicionale> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<bool>? activo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (activo != null) 'activo': activo,
    });
  }

  AdicionalesCompanion copyWith(
      {Value<int>? id, Value<String>? nombre, Value<bool>? activo}) {
    return AdicionalesCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      activo: activo ?? this.activo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AdicionalesCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }
}

class $FacturasTable extends Facturas with TableInfo<$FacturasTable, Factura> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FacturasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
      'codigo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pedidoIdMeta =
      const VerificationMeta('pedidoId');
  @override
  late final GeneratedColumn<int> pedidoId = GeneratedColumn<int>(
      'pedido_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _subtotalMeta =
      const VerificationMeta('subtotal');
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
      'subtotal', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _domicilioMeta =
      const VerificationMeta('domicilio');
  @override
  late final GeneratedColumn<double> domicilio = GeneratedColumn<double>(
      'domicilio', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
      'total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
      'estado', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pendiente'));
  static const VerificationMeta _creadaEnMeta =
      const VerificationMeta('creadaEn');
  @override
  late final GeneratedColumn<DateTime> creadaEn = GeneratedColumn<DateTime>(
      'creada_en', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, codigo, pedidoId, subtotal, domicilio, total, estado, creadaEn];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'facturas';
  @override
  VerificationContext validateIntegrity(Insertable<Factura> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('codigo')) {
      context.handle(_codigoMeta,
          codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta));
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('pedido_id')) {
      context.handle(_pedidoIdMeta,
          pedidoId.isAcceptableOrUnknown(data['pedido_id']!, _pedidoIdMeta));
    } else if (isInserting) {
      context.missing(_pedidoIdMeta);
    }
    if (data.containsKey('subtotal')) {
      context.handle(_subtotalMeta,
          subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta));
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    if (data.containsKey('domicilio')) {
      context.handle(_domicilioMeta,
          domicilio.isAcceptableOrUnknown(data['domicilio']!, _domicilioMeta));
    }
    if (data.containsKey('total')) {
      context.handle(
          _totalMeta, total.isAcceptableOrUnknown(data['total']!, _totalMeta));
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(_estadoMeta,
          estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta));
    }
    if (data.containsKey('creada_en')) {
      context.handle(_creadaEnMeta,
          creadaEn.isAcceptableOrUnknown(data['creada_en']!, _creadaEnMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Factura map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Factura(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      codigo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}codigo'])!,
      pedidoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pedido_id'])!,
      subtotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}subtotal'])!,
      domicilio: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}domicilio'])!,
      total: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total'])!,
      estado: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}estado'])!,
      creadaEn: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}creada_en'])!,
    );
  }

  @override
  $FacturasTable createAlias(String alias) {
    return $FacturasTable(attachedDatabase, alias);
  }
}

class Factura extends DataClass implements Insertable<Factura> {
  final int id;
  final String codigo;
  final int pedidoId;
  final double subtotal;
  final double domicilio;
  final double total;
  final String estado;
  final DateTime creadaEn;
  const Factura(
      {required this.id,
      required this.codigo,
      required this.pedidoId,
      required this.subtotal,
      required this.domicilio,
      required this.total,
      required this.estado,
      required this.creadaEn});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['codigo'] = Variable<String>(codigo);
    map['pedido_id'] = Variable<int>(pedidoId);
    map['subtotal'] = Variable<double>(subtotal);
    map['domicilio'] = Variable<double>(domicilio);
    map['total'] = Variable<double>(total);
    map['estado'] = Variable<String>(estado);
    map['creada_en'] = Variable<DateTime>(creadaEn);
    return map;
  }

  FacturasCompanion toCompanion(bool nullToAbsent) {
    return FacturasCompanion(
      id: Value(id),
      codigo: Value(codigo),
      pedidoId: Value(pedidoId),
      subtotal: Value(subtotal),
      domicilio: Value(domicilio),
      total: Value(total),
      estado: Value(estado),
      creadaEn: Value(creadaEn),
    );
  }

  factory Factura.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Factura(
      id: serializer.fromJson<int>(json['id']),
      codigo: serializer.fromJson<String>(json['codigo']),
      pedidoId: serializer.fromJson<int>(json['pedidoId']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      domicilio: serializer.fromJson<double>(json['domicilio']),
      total: serializer.fromJson<double>(json['total']),
      estado: serializer.fromJson<String>(json['estado']),
      creadaEn: serializer.fromJson<DateTime>(json['creadaEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'codigo': serializer.toJson<String>(codigo),
      'pedidoId': serializer.toJson<int>(pedidoId),
      'subtotal': serializer.toJson<double>(subtotal),
      'domicilio': serializer.toJson<double>(domicilio),
      'total': serializer.toJson<double>(total),
      'estado': serializer.toJson<String>(estado),
      'creadaEn': serializer.toJson<DateTime>(creadaEn),
    };
  }

  Factura copyWith(
          {int? id,
          String? codigo,
          int? pedidoId,
          double? subtotal,
          double? domicilio,
          double? total,
          String? estado,
          DateTime? creadaEn}) =>
      Factura(
        id: id ?? this.id,
        codigo: codigo ?? this.codigo,
        pedidoId: pedidoId ?? this.pedidoId,
        subtotal: subtotal ?? this.subtotal,
        domicilio: domicilio ?? this.domicilio,
        total: total ?? this.total,
        estado: estado ?? this.estado,
        creadaEn: creadaEn ?? this.creadaEn,
      );
  Factura copyWithCompanion(FacturasCompanion data) {
    return Factura(
      id: data.id.present ? data.id.value : this.id,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      pedidoId: data.pedidoId.present ? data.pedidoId.value : this.pedidoId,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      domicilio: data.domicilio.present ? data.domicilio.value : this.domicilio,
      total: data.total.present ? data.total.value : this.total,
      estado: data.estado.present ? data.estado.value : this.estado,
      creadaEn: data.creadaEn.present ? data.creadaEn.value : this.creadaEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Factura(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('pedidoId: $pedidoId, ')
          ..write('subtotal: $subtotal, ')
          ..write('domicilio: $domicilio, ')
          ..write('total: $total, ')
          ..write('estado: $estado, ')
          ..write('creadaEn: $creadaEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, codigo, pedidoId, subtotal, domicilio, total, estado, creadaEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Factura &&
          other.id == this.id &&
          other.codigo == this.codigo &&
          other.pedidoId == this.pedidoId &&
          other.subtotal == this.subtotal &&
          other.domicilio == this.domicilio &&
          other.total == this.total &&
          other.estado == this.estado &&
          other.creadaEn == this.creadaEn);
}

class FacturasCompanion extends UpdateCompanion<Factura> {
  final Value<int> id;
  final Value<String> codigo;
  final Value<int> pedidoId;
  final Value<double> subtotal;
  final Value<double> domicilio;
  final Value<double> total;
  final Value<String> estado;
  final Value<DateTime> creadaEn;
  const FacturasCompanion({
    this.id = const Value.absent(),
    this.codigo = const Value.absent(),
    this.pedidoId = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.domicilio = const Value.absent(),
    this.total = const Value.absent(),
    this.estado = const Value.absent(),
    this.creadaEn = const Value.absent(),
  });
  FacturasCompanion.insert({
    this.id = const Value.absent(),
    required String codigo,
    required int pedidoId,
    required double subtotal,
    this.domicilio = const Value.absent(),
    required double total,
    this.estado = const Value.absent(),
    this.creadaEn = const Value.absent(),
  })  : codigo = Value(codigo),
        pedidoId = Value(pedidoId),
        subtotal = Value(subtotal),
        total = Value(total);
  static Insertable<Factura> custom({
    Expression<int>? id,
    Expression<String>? codigo,
    Expression<int>? pedidoId,
    Expression<double>? subtotal,
    Expression<double>? domicilio,
    Expression<double>? total,
    Expression<String>? estado,
    Expression<DateTime>? creadaEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (codigo != null) 'codigo': codigo,
      if (pedidoId != null) 'pedido_id': pedidoId,
      if (subtotal != null) 'subtotal': subtotal,
      if (domicilio != null) 'domicilio': domicilio,
      if (total != null) 'total': total,
      if (estado != null) 'estado': estado,
      if (creadaEn != null) 'creada_en': creadaEn,
    });
  }

  FacturasCompanion copyWith(
      {Value<int>? id,
      Value<String>? codigo,
      Value<int>? pedidoId,
      Value<double>? subtotal,
      Value<double>? domicilio,
      Value<double>? total,
      Value<String>? estado,
      Value<DateTime>? creadaEn}) {
    return FacturasCompanion(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      pedidoId: pedidoId ?? this.pedidoId,
      subtotal: subtotal ?? this.subtotal,
      domicilio: domicilio ?? this.domicilio,
      total: total ?? this.total,
      estado: estado ?? this.estado,
      creadaEn: creadaEn ?? this.creadaEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (pedidoId.present) {
      map['pedido_id'] = Variable<int>(pedidoId.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (domicilio.present) {
      map['domicilio'] = Variable<double>(domicilio.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (creadaEn.present) {
      map['creada_en'] = Variable<DateTime>(creadaEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FacturasCompanion(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('pedidoId: $pedidoId, ')
          ..write('subtotal: $subtotal, ')
          ..write('domicilio: $domicilio, ')
          ..write('total: $total, ')
          ..write('estado: $estado, ')
          ..write('creadaEn: $creadaEn')
          ..write(')'))
        .toString();
  }
}

class $ConfiguracionTable extends Configuracion
    with TableInfo<$ConfiguracionTable, ConfiguracionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConfiguracionTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _claveMeta = const VerificationMeta('clave');
  @override
  late final GeneratedColumn<String> clave = GeneratedColumn<String>(
      'clave', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _valorMeta = const VerificationMeta('valor');
  @override
  late final GeneratedColumn<String> valor = GeneratedColumn<String>(
      'valor', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, clave, valor];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'configuracion';
  @override
  VerificationContext validateIntegrity(Insertable<ConfiguracionData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('clave')) {
      context.handle(
          _claveMeta, clave.isAcceptableOrUnknown(data['clave']!, _claveMeta));
    } else if (isInserting) {
      context.missing(_claveMeta);
    }
    if (data.containsKey('valor')) {
      context.handle(
          _valorMeta, valor.isAcceptableOrUnknown(data['valor']!, _valorMeta));
    } else if (isInserting) {
      context.missing(_valorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConfiguracionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConfiguracionData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      clave: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}clave'])!,
      valor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}valor'])!,
    );
  }

  @override
  $ConfiguracionTable createAlias(String alias) {
    return $ConfiguracionTable(attachedDatabase, alias);
  }
}

class ConfiguracionData extends DataClass
    implements Insertable<ConfiguracionData> {
  final int id;
  final String clave;
  final String valor;
  const ConfiguracionData(
      {required this.id, required this.clave, required this.valor});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['clave'] = Variable<String>(clave);
    map['valor'] = Variable<String>(valor);
    return map;
  }

  ConfiguracionCompanion toCompanion(bool nullToAbsent) {
    return ConfiguracionCompanion(
      id: Value(id),
      clave: Value(clave),
      valor: Value(valor),
    );
  }

  factory ConfiguracionData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConfiguracionData(
      id: serializer.fromJson<int>(json['id']),
      clave: serializer.fromJson<String>(json['clave']),
      valor: serializer.fromJson<String>(json['valor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clave': serializer.toJson<String>(clave),
      'valor': serializer.toJson<String>(valor),
    };
  }

  ConfiguracionData copyWith({int? id, String? clave, String? valor}) =>
      ConfiguracionData(
        id: id ?? this.id,
        clave: clave ?? this.clave,
        valor: valor ?? this.valor,
      );
  ConfiguracionData copyWithCompanion(ConfiguracionCompanion data) {
    return ConfiguracionData(
      id: data.id.present ? data.id.value : this.id,
      clave: data.clave.present ? data.clave.value : this.clave,
      valor: data.valor.present ? data.valor.value : this.valor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConfiguracionData(')
          ..write('id: $id, ')
          ..write('clave: $clave, ')
          ..write('valor: $valor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, clave, valor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConfiguracionData &&
          other.id == this.id &&
          other.clave == this.clave &&
          other.valor == this.valor);
}

class ConfiguracionCompanion extends UpdateCompanion<ConfiguracionData> {
  final Value<int> id;
  final Value<String> clave;
  final Value<String> valor;
  const ConfiguracionCompanion({
    this.id = const Value.absent(),
    this.clave = const Value.absent(),
    this.valor = const Value.absent(),
  });
  ConfiguracionCompanion.insert({
    this.id = const Value.absent(),
    required String clave,
    required String valor,
  })  : clave = Value(clave),
        valor = Value(valor);
  static Insertable<ConfiguracionData> custom({
    Expression<int>? id,
    Expression<String>? clave,
    Expression<String>? valor,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clave != null) 'clave': clave,
      if (valor != null) 'valor': valor,
    });
  }

  ConfiguracionCompanion copyWith(
      {Value<int>? id, Value<String>? clave, Value<String>? valor}) {
    return ConfiguracionCompanion(
      id: id ?? this.id,
      clave: clave ?? this.clave,
      valor: valor ?? this.valor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (clave.present) {
      map['clave'] = Variable<String>(clave.value);
    }
    if (valor.present) {
      map['valor'] = Variable<String>(valor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConfiguracionCompanion(')
          ..write('id: $id, ')
          ..write('clave: $clave, ')
          ..write('valor: $valor')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MesasTable mesas = $MesasTable(this);
  late final $MeserosTable meseros = $MeserosTable(this);
  late final $PedidosTable pedidos = $PedidosTable(this);
  late final $ItemsPedidoTable itemsPedido = $ItemsPedidoTable(this);
  late final $CategoriasTable categorias = $CategoriasTable(this);
  late final $ProductosTable productos = $ProductosTable(this);
  late final $AdicionalesTable adicionales = $AdicionalesTable(this);
  late final $FacturasTable facturas = $FacturasTable(this);
  late final $ConfiguracionTable configuracion = $ConfiguracionTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        mesas,
        meseros,
        pedidos,
        itemsPedido,
        categorias,
        productos,
        adicionales,
        facturas,
        configuracion
      ];
}

typedef $$MesasTableCreateCompanionBuilder = MesasCompanion Function({
  Value<int> id,
  required String nombre,
  Value<String> estado,
});
typedef $$MesasTableUpdateCompanionBuilder = MesasCompanion Function({
  Value<int> id,
  Value<String> nombre,
  Value<String> estado,
});

final class $$MesasTableReferences
    extends BaseReferences<_$AppDatabase, $MesasTable, Mesa> {
  $$MesasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PedidosTable, List<Pedido>> _pedidosRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.pedidos,
          aliasName: $_aliasNameGenerator(db.mesas.id, db.pedidos.mesaId));

  $$PedidosTableProcessedTableManager get pedidosRefs {
    final manager = $$PedidosTableTableManager($_db, $_db.pedidos)
        .filter((f) => f.mesaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_pedidosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MesasTableFilterComposer extends Composer<_$AppDatabase, $MesasTable> {
  $$MesasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get estado => $composableBuilder(
      column: $table.estado, builder: (column) => ColumnFilters(column));

  Expression<bool> pedidosRefs(
      Expression<bool> Function($$PedidosTableFilterComposer f) f) {
    final $$PedidosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.pedidos,
        getReferencedColumn: (t) => t.mesaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PedidosTableFilterComposer(
              $db: $db,
              $table: $db.pedidos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MesasTableOrderingComposer
    extends Composer<_$AppDatabase, $MesasTable> {
  $$MesasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get estado => $composableBuilder(
      column: $table.estado, builder: (column) => ColumnOrderings(column));
}

class $$MesasTableAnnotationComposer
    extends Composer<_$AppDatabase, $MesasTable> {
  $$MesasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  Expression<T> pedidosRefs<T extends Object>(
      Expression<T> Function($$PedidosTableAnnotationComposer a) f) {
    final $$PedidosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.pedidos,
        getReferencedColumn: (t) => t.mesaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PedidosTableAnnotationComposer(
              $db: $db,
              $table: $db.pedidos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MesasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MesasTable,
    Mesa,
    $$MesasTableFilterComposer,
    $$MesasTableOrderingComposer,
    $$MesasTableAnnotationComposer,
    $$MesasTableCreateCompanionBuilder,
    $$MesasTableUpdateCompanionBuilder,
    (Mesa, $$MesasTableReferences),
    Mesa,
    PrefetchHooks Function({bool pedidosRefs})> {
  $$MesasTableTableManager(_$AppDatabase db, $MesasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MesasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MesasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MesasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<String> estado = const Value.absent(),
          }) =>
              MesasCompanion(
            id: id,
            nombre: nombre,
            estado: estado,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nombre,
            Value<String> estado = const Value.absent(),
          }) =>
              MesasCompanion.insert(
            id: id,
            nombre: nombre,
            estado: estado,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$MesasTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({pedidosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (pedidosRefs) db.pedidos],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (pedidosRefs)
                    await $_getPrefetchedData<Mesa, $MesasTable, Pedido>(
                        currentTable: table,
                        referencedTable:
                            $$MesasTableReferences._pedidosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MesasTableReferences(db, table, p0).pedidosRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.mesaId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MesasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MesasTable,
    Mesa,
    $$MesasTableFilterComposer,
    $$MesasTableOrderingComposer,
    $$MesasTableAnnotationComposer,
    $$MesasTableCreateCompanionBuilder,
    $$MesasTableUpdateCompanionBuilder,
    (Mesa, $$MesasTableReferences),
    Mesa,
    PrefetchHooks Function({bool pedidosRefs})>;
typedef $$MeserosTableCreateCompanionBuilder = MeserosCompanion Function({
  Value<int> id,
  required String nombre,
});
typedef $$MeserosTableUpdateCompanionBuilder = MeserosCompanion Function({
  Value<int> id,
  Value<String> nombre,
});

class $$MeserosTableFilterComposer
    extends Composer<_$AppDatabase, $MeserosTable> {
  $$MeserosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));
}

class $$MeserosTableOrderingComposer
    extends Composer<_$AppDatabase, $MeserosTable> {
  $$MeserosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));
}

class $$MeserosTableAnnotationComposer
    extends Composer<_$AppDatabase, $MeserosTable> {
  $$MeserosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);
}

class $$MeserosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MeserosTable,
    Mesero,
    $$MeserosTableFilterComposer,
    $$MeserosTableOrderingComposer,
    $$MeserosTableAnnotationComposer,
    $$MeserosTableCreateCompanionBuilder,
    $$MeserosTableUpdateCompanionBuilder,
    (Mesero, BaseReferences<_$AppDatabase, $MeserosTable, Mesero>),
    Mesero,
    PrefetchHooks Function()> {
  $$MeserosTableTableManager(_$AppDatabase db, $MeserosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MeserosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MeserosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MeserosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nombre = const Value.absent(),
          }) =>
              MeserosCompanion(
            id: id,
            nombre: nombre,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nombre,
          }) =>
              MeserosCompanion.insert(
            id: id,
            nombre: nombre,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MeserosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MeserosTable,
    Mesero,
    $$MeserosTableFilterComposer,
    $$MeserosTableOrderingComposer,
    $$MeserosTableAnnotationComposer,
    $$MeserosTableCreateCompanionBuilder,
    $$MeserosTableUpdateCompanionBuilder,
    (Mesero, BaseReferences<_$AppDatabase, $MeserosTable, Mesero>),
    Mesero,
    PrefetchHooks Function()>;
typedef $$PedidosTableCreateCompanionBuilder = PedidosCompanion Function({
  Value<int> id,
  Value<int?> mesaId,
  Value<String> tipo,
  Value<double> valorDomicilio,
  Value<String> estado,
  Value<DateTime> creadoEn,
  Value<DateTime?> cerradoEn,
});
typedef $$PedidosTableUpdateCompanionBuilder = PedidosCompanion Function({
  Value<int> id,
  Value<int?> mesaId,
  Value<String> tipo,
  Value<double> valorDomicilio,
  Value<String> estado,
  Value<DateTime> creadoEn,
  Value<DateTime?> cerradoEn,
});

final class $$PedidosTableReferences
    extends BaseReferences<_$AppDatabase, $PedidosTable, Pedido> {
  $$PedidosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MesasTable _mesaIdTable(_$AppDatabase db) => db.mesas
      .createAlias($_aliasNameGenerator(db.pedidos.mesaId, db.mesas.id));

  $$MesasTableProcessedTableManager? get mesaId {
    final $_column = $_itemColumn<int>('mesa_id');
    if ($_column == null) return null;
    final manager = $$MesasTableTableManager($_db, $_db.mesas)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mesaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ItemsPedidoTable, List<ItemsPedidoData>>
      _itemsPedidoRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.itemsPedido,
              aliasName:
                  $_aliasNameGenerator(db.pedidos.id, db.itemsPedido.pedidoId));

  $$ItemsPedidoTableProcessedTableManager get itemsPedidoRefs {
    final manager = $$ItemsPedidoTableTableManager($_db, $_db.itemsPedido)
        .filter((f) => f.pedidoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemsPedidoRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PedidosTableFilterComposer
    extends Composer<_$AppDatabase, $PedidosTable> {
  $$PedidosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get valorDomicilio => $composableBuilder(
      column: $table.valorDomicilio,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get estado => $composableBuilder(
      column: $table.estado, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
      column: $table.creadoEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get cerradoEn => $composableBuilder(
      column: $table.cerradoEn, builder: (column) => ColumnFilters(column));

  $$MesasTableFilterComposer get mesaId {
    final $$MesasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mesaId,
        referencedTable: $db.mesas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MesasTableFilterComposer(
              $db: $db,
              $table: $db.mesas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> itemsPedidoRefs(
      Expression<bool> Function($$ItemsPedidoTableFilterComposer f) f) {
    final $$ItemsPedidoTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.itemsPedido,
        getReferencedColumn: (t) => t.pedidoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsPedidoTableFilterComposer(
              $db: $db,
              $table: $db.itemsPedido,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PedidosTableOrderingComposer
    extends Composer<_$AppDatabase, $PedidosTable> {
  $$PedidosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get valorDomicilio => $composableBuilder(
      column: $table.valorDomicilio,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get estado => $composableBuilder(
      column: $table.estado, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
      column: $table.creadoEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get cerradoEn => $composableBuilder(
      column: $table.cerradoEn, builder: (column) => ColumnOrderings(column));

  $$MesasTableOrderingComposer get mesaId {
    final $$MesasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mesaId,
        referencedTable: $db.mesas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MesasTableOrderingComposer(
              $db: $db,
              $table: $db.mesas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PedidosTableAnnotationComposer
    extends Composer<_$AppDatabase, $PedidosTable> {
  $$PedidosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<double> get valorDomicilio => $composableBuilder(
      column: $table.valorDomicilio, builder: (column) => column);

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  GeneratedColumn<DateTime> get cerradoEn =>
      $composableBuilder(column: $table.cerradoEn, builder: (column) => column);

  $$MesasTableAnnotationComposer get mesaId {
    final $$MesasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mesaId,
        referencedTable: $db.mesas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MesasTableAnnotationComposer(
              $db: $db,
              $table: $db.mesas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> itemsPedidoRefs<T extends Object>(
      Expression<T> Function($$ItemsPedidoTableAnnotationComposer a) f) {
    final $$ItemsPedidoTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.itemsPedido,
        getReferencedColumn: (t) => t.pedidoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsPedidoTableAnnotationComposer(
              $db: $db,
              $table: $db.itemsPedido,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PedidosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PedidosTable,
    Pedido,
    $$PedidosTableFilterComposer,
    $$PedidosTableOrderingComposer,
    $$PedidosTableAnnotationComposer,
    $$PedidosTableCreateCompanionBuilder,
    $$PedidosTableUpdateCompanionBuilder,
    (Pedido, $$PedidosTableReferences),
    Pedido,
    PrefetchHooks Function({bool mesaId, bool itemsPedidoRefs})> {
  $$PedidosTableTableManager(_$AppDatabase db, $PedidosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PedidosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PedidosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PedidosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> mesaId = const Value.absent(),
            Value<String> tipo = const Value.absent(),
            Value<double> valorDomicilio = const Value.absent(),
            Value<String> estado = const Value.absent(),
            Value<DateTime> creadoEn = const Value.absent(),
            Value<DateTime?> cerradoEn = const Value.absent(),
          }) =>
              PedidosCompanion(
            id: id,
            mesaId: mesaId,
            tipo: tipo,
            valorDomicilio: valorDomicilio,
            estado: estado,
            creadoEn: creadoEn,
            cerradoEn: cerradoEn,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> mesaId = const Value.absent(),
            Value<String> tipo = const Value.absent(),
            Value<double> valorDomicilio = const Value.absent(),
            Value<String> estado = const Value.absent(),
            Value<DateTime> creadoEn = const Value.absent(),
            Value<DateTime?> cerradoEn = const Value.absent(),
          }) =>
              PedidosCompanion.insert(
            id: id,
            mesaId: mesaId,
            tipo: tipo,
            valorDomicilio: valorDomicilio,
            estado: estado,
            creadoEn: creadoEn,
            cerradoEn: cerradoEn,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$PedidosTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({mesaId = false, itemsPedidoRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (itemsPedidoRefs) db.itemsPedido],
              addJoins: <
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
                      dynamic>>(state) {
                if (mesaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.mesaId,
                    referencedTable: $$PedidosTableReferences._mesaIdTable(db),
                    referencedColumn:
                        $$PedidosTableReferences._mesaIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (itemsPedidoRefs)
                    await $_getPrefetchedData<Pedido, $PedidosTable,
                            ItemsPedidoData>(
                        currentTable: table,
                        referencedTable:
                            $$PedidosTableReferences._itemsPedidoRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PedidosTableReferences(db, table, p0)
                                .itemsPedidoRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.pedidoId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PedidosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PedidosTable,
    Pedido,
    $$PedidosTableFilterComposer,
    $$PedidosTableOrderingComposer,
    $$PedidosTableAnnotationComposer,
    $$PedidosTableCreateCompanionBuilder,
    $$PedidosTableUpdateCompanionBuilder,
    (Pedido, $$PedidosTableReferences),
    Pedido,
    PrefetchHooks Function({bool mesaId, bool itemsPedidoRefs})>;
typedef $$ItemsPedidoTableCreateCompanionBuilder = ItemsPedidoCompanion
    Function({
  Value<int> id,
  required int pedidoId,
  required int productoId,
  required String nombreProducto,
  required double precio,
  Value<int> cantidad,
  Value<String> adicionales,
  Value<String> nota,
});
typedef $$ItemsPedidoTableUpdateCompanionBuilder = ItemsPedidoCompanion
    Function({
  Value<int> id,
  Value<int> pedidoId,
  Value<int> productoId,
  Value<String> nombreProducto,
  Value<double> precio,
  Value<int> cantidad,
  Value<String> adicionales,
  Value<String> nota,
});

final class $$ItemsPedidoTableReferences
    extends BaseReferences<_$AppDatabase, $ItemsPedidoTable, ItemsPedidoData> {
  $$ItemsPedidoTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PedidosTable _pedidoIdTable(_$AppDatabase db) =>
      db.pedidos.createAlias(
          $_aliasNameGenerator(db.itemsPedido.pedidoId, db.pedidos.id));

  $$PedidosTableProcessedTableManager get pedidoId {
    final $_column = $_itemColumn<int>('pedido_id')!;

    final manager = $$PedidosTableTableManager($_db, $_db.pedidos)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pedidoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ItemsPedidoTableFilterComposer
    extends Composer<_$AppDatabase, $ItemsPedidoTable> {
  $$ItemsPedidoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombreProducto => $composableBuilder(
      column: $table.nombreProducto,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get precio => $composableBuilder(
      column: $table.precio, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cantidad => $composableBuilder(
      column: $table.cantidad, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get adicionales => $composableBuilder(
      column: $table.adicionales, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nota => $composableBuilder(
      column: $table.nota, builder: (column) => ColumnFilters(column));

  $$PedidosTableFilterComposer get pedidoId {
    final $$PedidosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pedidoId,
        referencedTable: $db.pedidos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PedidosTableFilterComposer(
              $db: $db,
              $table: $db.pedidos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ItemsPedidoTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemsPedidoTable> {
  $$ItemsPedidoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombreProducto => $composableBuilder(
      column: $table.nombreProducto,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get precio => $composableBuilder(
      column: $table.precio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cantidad => $composableBuilder(
      column: $table.cantidad, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get adicionales => $composableBuilder(
      column: $table.adicionales, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nota => $composableBuilder(
      column: $table.nota, builder: (column) => ColumnOrderings(column));

  $$PedidosTableOrderingComposer get pedidoId {
    final $$PedidosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pedidoId,
        referencedTable: $db.pedidos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PedidosTableOrderingComposer(
              $db: $db,
              $table: $db.pedidos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ItemsPedidoTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemsPedidoTable> {
  $$ItemsPedidoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => column);

  GeneratedColumn<String> get nombreProducto => $composableBuilder(
      column: $table.nombreProducto, builder: (column) => column);

  GeneratedColumn<double> get precio =>
      $composableBuilder(column: $table.precio, builder: (column) => column);

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<String> get adicionales => $composableBuilder(
      column: $table.adicionales, builder: (column) => column);

  GeneratedColumn<String> get nota =>
      $composableBuilder(column: $table.nota, builder: (column) => column);

  $$PedidosTableAnnotationComposer get pedidoId {
    final $$PedidosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pedidoId,
        referencedTable: $db.pedidos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PedidosTableAnnotationComposer(
              $db: $db,
              $table: $db.pedidos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ItemsPedidoTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ItemsPedidoTable,
    ItemsPedidoData,
    $$ItemsPedidoTableFilterComposer,
    $$ItemsPedidoTableOrderingComposer,
    $$ItemsPedidoTableAnnotationComposer,
    $$ItemsPedidoTableCreateCompanionBuilder,
    $$ItemsPedidoTableUpdateCompanionBuilder,
    (ItemsPedidoData, $$ItemsPedidoTableReferences),
    ItemsPedidoData,
    PrefetchHooks Function({bool pedidoId})> {
  $$ItemsPedidoTableTableManager(_$AppDatabase db, $ItemsPedidoTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemsPedidoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemsPedidoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemsPedidoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> pedidoId = const Value.absent(),
            Value<int> productoId = const Value.absent(),
            Value<String> nombreProducto = const Value.absent(),
            Value<double> precio = const Value.absent(),
            Value<int> cantidad = const Value.absent(),
            Value<String> adicionales = const Value.absent(),
            Value<String> nota = const Value.absent(),
          }) =>
              ItemsPedidoCompanion(
            id: id,
            pedidoId: pedidoId,
            productoId: productoId,
            nombreProducto: nombreProducto,
            precio: precio,
            cantidad: cantidad,
            adicionales: adicionales,
            nota: nota,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int pedidoId,
            required int productoId,
            required String nombreProducto,
            required double precio,
            Value<int> cantidad = const Value.absent(),
            Value<String> adicionales = const Value.absent(),
            Value<String> nota = const Value.absent(),
          }) =>
              ItemsPedidoCompanion.insert(
            id: id,
            pedidoId: pedidoId,
            productoId: productoId,
            nombreProducto: nombreProducto,
            precio: precio,
            cantidad: cantidad,
            adicionales: adicionales,
            nota: nota,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ItemsPedidoTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({pedidoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (pedidoId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.pedidoId,
                    referencedTable:
                        $$ItemsPedidoTableReferences._pedidoIdTable(db),
                    referencedColumn:
                        $$ItemsPedidoTableReferences._pedidoIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ItemsPedidoTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ItemsPedidoTable,
    ItemsPedidoData,
    $$ItemsPedidoTableFilterComposer,
    $$ItemsPedidoTableOrderingComposer,
    $$ItemsPedidoTableAnnotationComposer,
    $$ItemsPedidoTableCreateCompanionBuilder,
    $$ItemsPedidoTableUpdateCompanionBuilder,
    (ItemsPedidoData, $$ItemsPedidoTableReferences),
    ItemsPedidoData,
    PrefetchHooks Function({bool pedidoId})>;
typedef $$CategoriasTableCreateCompanionBuilder = CategoriasCompanion Function({
  Value<int> id,
  required String nombre,
  Value<int> orden,
});
typedef $$CategoriasTableUpdateCompanionBuilder = CategoriasCompanion Function({
  Value<int> id,
  Value<String> nombre,
  Value<int> orden,
});

final class $$CategoriasTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriasTable, Categoria> {
  $$CategoriasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProductosTable, List<Producto>>
      _productosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.productos,
          aliasName:
              $_aliasNameGenerator(db.categorias.id, db.productos.categoriaId));

  $$ProductosTableProcessedTableManager get productosRefs {
    final manager = $$ProductosTableTableManager($_db, $_db.productos)
        .filter((f) => f.categoriaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_productosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CategoriasTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orden => $composableBuilder(
      column: $table.orden, builder: (column) => ColumnFilters(column));

  Expression<bool> productosRefs(
      Expression<bool> Function($$ProductosTableFilterComposer f) f) {
    final $$ProductosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.productos,
        getReferencedColumn: (t) => t.categoriaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductosTableFilterComposer(
              $db: $db,
              $table: $db.productos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriasTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orden => $composableBuilder(
      column: $table.orden, builder: (column) => ColumnOrderings(column));
}

class $$CategoriasTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<int> get orden =>
      $composableBuilder(column: $table.orden, builder: (column) => column);

  Expression<T> productosRefs<T extends Object>(
      Expression<T> Function($$ProductosTableAnnotationComposer a) f) {
    final $$ProductosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.productos,
        getReferencedColumn: (t) => t.categoriaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductosTableAnnotationComposer(
              $db: $db,
              $table: $db.productos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriasTable,
    Categoria,
    $$CategoriasTableFilterComposer,
    $$CategoriasTableOrderingComposer,
    $$CategoriasTableAnnotationComposer,
    $$CategoriasTableCreateCompanionBuilder,
    $$CategoriasTableUpdateCompanionBuilder,
    (Categoria, $$CategoriasTableReferences),
    Categoria,
    PrefetchHooks Function({bool productosRefs})> {
  $$CategoriasTableTableManager(_$AppDatabase db, $CategoriasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<int> orden = const Value.absent(),
          }) =>
              CategoriasCompanion(
            id: id,
            nombre: nombre,
            orden: orden,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nombre,
            Value<int> orden = const Value.absent(),
          }) =>
              CategoriasCompanion.insert(
            id: id,
            nombre: nombre,
            orden: orden,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CategoriasTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({productosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (productosRefs) db.productos],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productosRefs)
                    await $_getPrefetchedData<Categoria, $CategoriasTable,
                            Producto>(
                        currentTable: table,
                        referencedTable:
                            $$CategoriasTableReferences._productosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoriasTableReferences(db, table, p0)
                                .productosRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoriaId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CategoriasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriasTable,
    Categoria,
    $$CategoriasTableFilterComposer,
    $$CategoriasTableOrderingComposer,
    $$CategoriasTableAnnotationComposer,
    $$CategoriasTableCreateCompanionBuilder,
    $$CategoriasTableUpdateCompanionBuilder,
    (Categoria, $$CategoriasTableReferences),
    Categoria,
    PrefetchHooks Function({bool productosRefs})>;
typedef $$ProductosTableCreateCompanionBuilder = ProductosCompanion Function({
  Value<int> id,
  required int categoriaId,
  required String nombre,
  Value<String> descripcion,
  required double precio,
  Value<bool> activo,
});
typedef $$ProductosTableUpdateCompanionBuilder = ProductosCompanion Function({
  Value<int> id,
  Value<int> categoriaId,
  Value<String> nombre,
  Value<String> descripcion,
  Value<double> precio,
  Value<bool> activo,
});

final class $$ProductosTableReferences
    extends BaseReferences<_$AppDatabase, $ProductosTable, Producto> {
  $$ProductosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriasTable _categoriaIdTable(_$AppDatabase db) =>
      db.categorias.createAlias(
          $_aliasNameGenerator(db.productos.categoriaId, db.categorias.id));

  $$CategoriasTableProcessedTableManager get categoriaId {
    final $_column = $_itemColumn<int>('categoria_id')!;

    final manager = $$CategoriasTableTableManager($_db, $_db.categorias)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoriaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ProductosTableFilterComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get precio => $composableBuilder(
      column: $table.precio, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnFilters(column));

  $$CategoriasTableFilterComposer get categoriaId {
    final $$CategoriasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoriaId,
        referencedTable: $db.categorias,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriasTableFilterComposer(
              $db: $db,
              $table: $db.categorias,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductosTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get precio => $composableBuilder(
      column: $table.precio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnOrderings(column));

  $$CategoriasTableOrderingComposer get categoriaId {
    final $$CategoriasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoriaId,
        referencedTable: $db.categorias,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriasTableOrderingComposer(
              $db: $db,
              $table: $db.categorias,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => column);

  GeneratedColumn<double> get precio =>
      $composableBuilder(column: $table.precio, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  $$CategoriasTableAnnotationComposer get categoriaId {
    final $$CategoriasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoriaId,
        referencedTable: $db.categorias,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriasTableAnnotationComposer(
              $db: $db,
              $table: $db.categorias,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductosTable,
    Producto,
    $$ProductosTableFilterComposer,
    $$ProductosTableOrderingComposer,
    $$ProductosTableAnnotationComposer,
    $$ProductosTableCreateCompanionBuilder,
    $$ProductosTableUpdateCompanionBuilder,
    (Producto, $$ProductosTableReferences),
    Producto,
    PrefetchHooks Function({bool categoriaId})> {
  $$ProductosTableTableManager(_$AppDatabase db, $ProductosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> categoriaId = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<String> descripcion = const Value.absent(),
            Value<double> precio = const Value.absent(),
            Value<bool> activo = const Value.absent(),
          }) =>
              ProductosCompanion(
            id: id,
            categoriaId: categoriaId,
            nombre: nombre,
            descripcion: descripcion,
            precio: precio,
            activo: activo,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int categoriaId,
            required String nombre,
            Value<String> descripcion = const Value.absent(),
            required double precio,
            Value<bool> activo = const Value.absent(),
          }) =>
              ProductosCompanion.insert(
            id: id,
            categoriaId: categoriaId,
            nombre: nombre,
            descripcion: descripcion,
            precio: precio,
            activo: activo,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ProductosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({categoriaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (categoriaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoriaId,
                    referencedTable:
                        $$ProductosTableReferences._categoriaIdTable(db),
                    referencedColumn:
                        $$ProductosTableReferences._categoriaIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ProductosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductosTable,
    Producto,
    $$ProductosTableFilterComposer,
    $$ProductosTableOrderingComposer,
    $$ProductosTableAnnotationComposer,
    $$ProductosTableCreateCompanionBuilder,
    $$ProductosTableUpdateCompanionBuilder,
    (Producto, $$ProductosTableReferences),
    Producto,
    PrefetchHooks Function({bool categoriaId})>;
typedef $$AdicionalesTableCreateCompanionBuilder = AdicionalesCompanion
    Function({
  Value<int> id,
  required String nombre,
  Value<bool> activo,
});
typedef $$AdicionalesTableUpdateCompanionBuilder = AdicionalesCompanion
    Function({
  Value<int> id,
  Value<String> nombre,
  Value<bool> activo,
});

class $$AdicionalesTableFilterComposer
    extends Composer<_$AppDatabase, $AdicionalesTable> {
  $$AdicionalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnFilters(column));
}

class $$AdicionalesTableOrderingComposer
    extends Composer<_$AppDatabase, $AdicionalesTable> {
  $$AdicionalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnOrderings(column));
}

class $$AdicionalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AdicionalesTable> {
  $$AdicionalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);
}

class $$AdicionalesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AdicionalesTable,
    Adicionale,
    $$AdicionalesTableFilterComposer,
    $$AdicionalesTableOrderingComposer,
    $$AdicionalesTableAnnotationComposer,
    $$AdicionalesTableCreateCompanionBuilder,
    $$AdicionalesTableUpdateCompanionBuilder,
    (Adicionale, BaseReferences<_$AppDatabase, $AdicionalesTable, Adicionale>),
    Adicionale,
    PrefetchHooks Function()> {
  $$AdicionalesTableTableManager(_$AppDatabase db, $AdicionalesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AdicionalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AdicionalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AdicionalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<bool> activo = const Value.absent(),
          }) =>
              AdicionalesCompanion(
            id: id,
            nombre: nombre,
            activo: activo,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nombre,
            Value<bool> activo = const Value.absent(),
          }) =>
              AdicionalesCompanion.insert(
            id: id,
            nombre: nombre,
            activo: activo,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AdicionalesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AdicionalesTable,
    Adicionale,
    $$AdicionalesTableFilterComposer,
    $$AdicionalesTableOrderingComposer,
    $$AdicionalesTableAnnotationComposer,
    $$AdicionalesTableCreateCompanionBuilder,
    $$AdicionalesTableUpdateCompanionBuilder,
    (Adicionale, BaseReferences<_$AppDatabase, $AdicionalesTable, Adicionale>),
    Adicionale,
    PrefetchHooks Function()>;
typedef $$FacturasTableCreateCompanionBuilder = FacturasCompanion Function({
  Value<int> id,
  required String codigo,
  required int pedidoId,
  required double subtotal,
  Value<double> domicilio,
  required double total,
  Value<String> estado,
  Value<DateTime> creadaEn,
});
typedef $$FacturasTableUpdateCompanionBuilder = FacturasCompanion Function({
  Value<int> id,
  Value<String> codigo,
  Value<int> pedidoId,
  Value<double> subtotal,
  Value<double> domicilio,
  Value<double> total,
  Value<String> estado,
  Value<DateTime> creadaEn,
});

class $$FacturasTableFilterComposer
    extends Composer<_$AppDatabase, $FacturasTable> {
  $$FacturasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get codigo => $composableBuilder(
      column: $table.codigo, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pedidoId => $composableBuilder(
      column: $table.pedidoId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get subtotal => $composableBuilder(
      column: $table.subtotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get domicilio => $composableBuilder(
      column: $table.domicilio, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get estado => $composableBuilder(
      column: $table.estado, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get creadaEn => $composableBuilder(
      column: $table.creadaEn, builder: (column) => ColumnFilters(column));
}

class $$FacturasTableOrderingComposer
    extends Composer<_$AppDatabase, $FacturasTable> {
  $$FacturasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get codigo => $composableBuilder(
      column: $table.codigo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pedidoId => $composableBuilder(
      column: $table.pedidoId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get subtotal => $composableBuilder(
      column: $table.subtotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get domicilio => $composableBuilder(
      column: $table.domicilio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get estado => $composableBuilder(
      column: $table.estado, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get creadaEn => $composableBuilder(
      column: $table.creadaEn, builder: (column) => ColumnOrderings(column));
}

class $$FacturasTableAnnotationComposer
    extends Composer<_$AppDatabase, $FacturasTable> {
  $$FacturasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<int> get pedidoId =>
      $composableBuilder(column: $table.pedidoId, builder: (column) => column);

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<double> get domicilio =>
      $composableBuilder(column: $table.domicilio, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<DateTime> get creadaEn =>
      $composableBuilder(column: $table.creadaEn, builder: (column) => column);
}

class $$FacturasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FacturasTable,
    Factura,
    $$FacturasTableFilterComposer,
    $$FacturasTableOrderingComposer,
    $$FacturasTableAnnotationComposer,
    $$FacturasTableCreateCompanionBuilder,
    $$FacturasTableUpdateCompanionBuilder,
    (Factura, BaseReferences<_$AppDatabase, $FacturasTable, Factura>),
    Factura,
    PrefetchHooks Function()> {
  $$FacturasTableTableManager(_$AppDatabase db, $FacturasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FacturasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FacturasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FacturasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> codigo = const Value.absent(),
            Value<int> pedidoId = const Value.absent(),
            Value<double> subtotal = const Value.absent(),
            Value<double> domicilio = const Value.absent(),
            Value<double> total = const Value.absent(),
            Value<String> estado = const Value.absent(),
            Value<DateTime> creadaEn = const Value.absent(),
          }) =>
              FacturasCompanion(
            id: id,
            codigo: codigo,
            pedidoId: pedidoId,
            subtotal: subtotal,
            domicilio: domicilio,
            total: total,
            estado: estado,
            creadaEn: creadaEn,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String codigo,
            required int pedidoId,
            required double subtotal,
            Value<double> domicilio = const Value.absent(),
            required double total,
            Value<String> estado = const Value.absent(),
            Value<DateTime> creadaEn = const Value.absent(),
          }) =>
              FacturasCompanion.insert(
            id: id,
            codigo: codigo,
            pedidoId: pedidoId,
            subtotal: subtotal,
            domicilio: domicilio,
            total: total,
            estado: estado,
            creadaEn: creadaEn,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FacturasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FacturasTable,
    Factura,
    $$FacturasTableFilterComposer,
    $$FacturasTableOrderingComposer,
    $$FacturasTableAnnotationComposer,
    $$FacturasTableCreateCompanionBuilder,
    $$FacturasTableUpdateCompanionBuilder,
    (Factura, BaseReferences<_$AppDatabase, $FacturasTable, Factura>),
    Factura,
    PrefetchHooks Function()>;
typedef $$ConfiguracionTableCreateCompanionBuilder = ConfiguracionCompanion
    Function({
  Value<int> id,
  required String clave,
  required String valor,
});
typedef $$ConfiguracionTableUpdateCompanionBuilder = ConfiguracionCompanion
    Function({
  Value<int> id,
  Value<String> clave,
  Value<String> valor,
});

class $$ConfiguracionTableFilterComposer
    extends Composer<_$AppDatabase, $ConfiguracionTable> {
  $$ConfiguracionTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clave => $composableBuilder(
      column: $table.clave, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get valor => $composableBuilder(
      column: $table.valor, builder: (column) => ColumnFilters(column));
}

class $$ConfiguracionTableOrderingComposer
    extends Composer<_$AppDatabase, $ConfiguracionTable> {
  $$ConfiguracionTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clave => $composableBuilder(
      column: $table.clave, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get valor => $composableBuilder(
      column: $table.valor, builder: (column) => ColumnOrderings(column));
}

class $$ConfiguracionTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConfiguracionTable> {
  $$ConfiguracionTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clave =>
      $composableBuilder(column: $table.clave, builder: (column) => column);

  GeneratedColumn<String> get valor =>
      $composableBuilder(column: $table.valor, builder: (column) => column);
}

class $$ConfiguracionTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ConfiguracionTable,
    ConfiguracionData,
    $$ConfiguracionTableFilterComposer,
    $$ConfiguracionTableOrderingComposer,
    $$ConfiguracionTableAnnotationComposer,
    $$ConfiguracionTableCreateCompanionBuilder,
    $$ConfiguracionTableUpdateCompanionBuilder,
    (
      ConfiguracionData,
      BaseReferences<_$AppDatabase, $ConfiguracionTable, ConfiguracionData>
    ),
    ConfiguracionData,
    PrefetchHooks Function()> {
  $$ConfiguracionTableTableManager(_$AppDatabase db, $ConfiguracionTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConfiguracionTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConfiguracionTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConfiguracionTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> clave = const Value.absent(),
            Value<String> valor = const Value.absent(),
          }) =>
              ConfiguracionCompanion(
            id: id,
            clave: clave,
            valor: valor,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String clave,
            required String valor,
          }) =>
              ConfiguracionCompanion.insert(
            id: id,
            clave: clave,
            valor: valor,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ConfiguracionTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ConfiguracionTable,
    ConfiguracionData,
    $$ConfiguracionTableFilterComposer,
    $$ConfiguracionTableOrderingComposer,
    $$ConfiguracionTableAnnotationComposer,
    $$ConfiguracionTableCreateCompanionBuilder,
    $$ConfiguracionTableUpdateCompanionBuilder,
    (
      ConfiguracionData,
      BaseReferences<_$AppDatabase, $ConfiguracionTable, ConfiguracionData>
    ),
    ConfiguracionData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MesasTableTableManager get mesas =>
      $$MesasTableTableManager(_db, _db.mesas);
  $$MeserosTableTableManager get meseros =>
      $$MeserosTableTableManager(_db, _db.meseros);
  $$PedidosTableTableManager get pedidos =>
      $$PedidosTableTableManager(_db, _db.pedidos);
  $$ItemsPedidoTableTableManager get itemsPedido =>
      $$ItemsPedidoTableTableManager(_db, _db.itemsPedido);
  $$CategoriasTableTableManager get categorias =>
      $$CategoriasTableTableManager(_db, _db.categorias);
  $$ProductosTableTableManager get productos =>
      $$ProductosTableTableManager(_db, _db.productos);
  $$AdicionalesTableTableManager get adicionales =>
      $$AdicionalesTableTableManager(_db, _db.adicionales);
  $$FacturasTableTableManager get facturas =>
      $$FacturasTableTableManager(_db, _db.facturas);
  $$ConfiguracionTableTableManager get configuracion =>
      $$ConfiguracionTableTableManager(_db, _db.configuracion);
}
