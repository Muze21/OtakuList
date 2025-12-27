// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'anime_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AnimeModel _$AnimeModelFromJson(Map<String, dynamic> json) {
  return _AnimeModel.fromJson(json);
}

/// @nodoc
mixin _$AnimeModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get synopsis => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  int get episodes => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  List<String> get genres => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int? get year => throw _privateConstructorUsedError;
  String? get studio => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this AnimeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnimeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnimeModelCopyWith<AnimeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnimeModelCopyWith<$Res> {
  factory $AnimeModelCopyWith(
    AnimeModel value,
    $Res Function(AnimeModel) then,
  ) = _$AnimeModelCopyWithImpl<$Res, AnimeModel>;
  @useResult
  $Res call({
    String id,
    String title,
    String? synopsis,
    @JsonKey(name: 'image_url') String? imageUrl,
    int episodes,
    double rating,
    List<String> genres,
    String status,
    int? year,
    String? studio,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  });
}

/// @nodoc
class _$AnimeModelCopyWithImpl<$Res, $Val extends AnimeModel>
    implements $AnimeModelCopyWith<$Res> {
  _$AnimeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnimeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? synopsis = freezed,
    Object? imageUrl = freezed,
    Object? episodes = null,
    Object? rating = null,
    Object? genres = null,
    Object? status = null,
    Object? year = freezed,
    Object? studio = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            synopsis: freezed == synopsis
                ? _value.synopsis
                : synopsis // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            episodes: null == episodes
                ? _value.episodes
                : episodes // ignore: cast_nullable_to_non_nullable
                      as int,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double,
            genres: null == genres
                ? _value.genres
                : genres // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            year: freezed == year
                ? _value.year
                : year // ignore: cast_nullable_to_non_nullable
                      as int?,
            studio: freezed == studio
                ? _value.studio
                : studio // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnimeModelImplCopyWith<$Res>
    implements $AnimeModelCopyWith<$Res> {
  factory _$$AnimeModelImplCopyWith(
    _$AnimeModelImpl value,
    $Res Function(_$AnimeModelImpl) then,
  ) = __$$AnimeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String? synopsis,
    @JsonKey(name: 'image_url') String? imageUrl,
    int episodes,
    double rating,
    List<String> genres,
    String status,
    int? year,
    String? studio,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  });
}

/// @nodoc
class __$$AnimeModelImplCopyWithImpl<$Res>
    extends _$AnimeModelCopyWithImpl<$Res, _$AnimeModelImpl>
    implements _$$AnimeModelImplCopyWith<$Res> {
  __$$AnimeModelImplCopyWithImpl(
    _$AnimeModelImpl _value,
    $Res Function(_$AnimeModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnimeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? synopsis = freezed,
    Object? imageUrl = freezed,
    Object? episodes = null,
    Object? rating = null,
    Object? genres = null,
    Object? status = null,
    Object? year = freezed,
    Object? studio = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$AnimeModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        synopsis: freezed == synopsis
            ? _value.synopsis
            : synopsis // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        episodes: null == episodes
            ? _value.episodes
            : episodes // ignore: cast_nullable_to_non_nullable
                  as int,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double,
        genres: null == genres
            ? _value._genres
            : genres // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        year: freezed == year
            ? _value.year
            : year // ignore: cast_nullable_to_non_nullable
                  as int?,
        studio: freezed == studio
            ? _value.studio
            : studio // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnimeModelImpl extends _AnimeModel {
  const _$AnimeModelImpl({
    required this.id,
    required this.title,
    this.synopsis,
    @JsonKey(name: 'image_url') this.imageUrl,
    required this.episodes,
    required this.rating,
    required final List<String> genres,
    required this.status,
    this.year,
    this.studio,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  }) : _genres = genres,
       super._();

  factory _$AnimeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnimeModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? synopsis;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  final int episodes;
  @override
  final double rating;
  final List<String> _genres;
  @override
  List<String> get genres {
    if (_genres is EqualUnmodifiableListView) return _genres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_genres);
  }

  @override
  final String status;
  @override
  final int? year;
  @override
  final String? studio;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @override
  String toString() {
    return 'AnimeModel(id: $id, title: $title, synopsis: $synopsis, imageUrl: $imageUrl, episodes: $episodes, rating: $rating, genres: $genres, status: $status, year: $year, studio: $studio, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnimeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.synopsis, synopsis) ||
                other.synopsis == synopsis) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.episodes, episodes) ||
                other.episodes == episodes) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            const DeepCollectionEquality().equals(other._genres, _genres) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.studio, studio) || other.studio == studio) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    synopsis,
    imageUrl,
    episodes,
    rating,
    const DeepCollectionEquality().hash(_genres),
    status,
    year,
    studio,
    createdAt,
    updatedAt,
  );

  /// Create a copy of AnimeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnimeModelImplCopyWith<_$AnimeModelImpl> get copyWith =>
      __$$AnimeModelImplCopyWithImpl<_$AnimeModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnimeModelImplToJson(this);
  }
}

abstract class _AnimeModel extends AnimeModel {
  const factory _AnimeModel({
    required final String id,
    required final String title,
    final String? synopsis,
    @JsonKey(name: 'image_url') final String? imageUrl,
    required final int episodes,
    required final double rating,
    required final List<String> genres,
    required final String status,
    final int? year,
    final String? studio,
    @JsonKey(name: 'created_at') final String? createdAt,
    @JsonKey(name: 'updated_at') final String? updatedAt,
  }) = _$AnimeModelImpl;
  const _AnimeModel._() : super._();

  factory _AnimeModel.fromJson(Map<String, dynamic> json) =
      _$AnimeModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get synopsis;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  int get episodes;
  @override
  double get rating;
  @override
  List<String> get genres;
  @override
  String get status;
  @override
  int? get year;
  @override
  String? get studio;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;

  /// Create a copy of AnimeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnimeModelImplCopyWith<_$AnimeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
