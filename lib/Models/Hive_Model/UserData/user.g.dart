// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      username: fields[0] as String?,
      displayName: fields[1] as String?,
      email: fields[2] as String?,
      password: fields[3] as String?,
      joiningDate: fields[4] as String?,
      bio: fields[5] as String?,
      location: fields[6] as String?,
      completeProfile: fields[7] as bool?,
      coverUrl: fields[8] as String?,
      profileUrl: fields[9] as String?,
      following: fields[10] as int,
      followers: fields[11] as int,
      posts: fields[12] as int,
      isVerify: fields[13] as bool,
      website: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.displayName)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.joiningDate)
      ..writeByte(5)
      ..write(obj.bio)
      ..writeByte(6)
      ..write(obj.location)
      ..writeByte(7)
      ..write(obj.completeProfile)
      ..writeByte(8)
      ..write(obj.coverUrl)
      ..writeByte(9)
      ..write(obj.profileUrl)
      ..writeByte(10)
      ..write(obj.following)
      ..writeByte(11)
      ..write(obj.followers)
      ..writeByte(12)
      ..write(obj.posts)
      ..writeByte(13)
      ..write(obj.isVerify)
      ..writeByte(14)
      ..write(obj.website);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
