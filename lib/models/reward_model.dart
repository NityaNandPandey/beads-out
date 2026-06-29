import 'package:equatable/equatable.dart';

class RewardModel extends Equatable {
  const RewardModel({
    required this.id,
    required this.type,
    required this.amount,
    this.description,
    this.iconAsset,
  });

  final String id;
  final RewardType type;
  final int amount;
  final String? description;
  final String? iconAsset;

  @override
  List<Object?> get props => [id, type, amount, description, iconAsset];
}

enum RewardType {
  coins,
  stars,
  skin,
  powerUp,
  extraLife,
}
