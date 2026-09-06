import 'package:flutter_test/flutter_test.dart';
import 'package:stickeenglishnotes/data/database/app_database.dart';
import 'package:stickeenglishnotes/data/repositories/card_groups_repository.dart';
import 'package:stickeenglishnotes/features/groups/application/groups_controller.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase database;
  late GroupsController controller;
  late CardGroupsRepository groups;

  setUpAll(configureTestDrift);

  setUp(() {
    database = AppDatabase.memory();
    groups = CardGroupsRepository(database);
    controller = GroupsController(groups);
  });

  tearDown(() async {
    await database.close();
  });

  test('rechaza un nombre vacío', () {
    expect(controller.validateName('   '), 'Escribe un nombre');
    expect(
      () => controller.create(name: ' '),
      throwsArgumentError,
    );
  });

  test('crea y renombra un grupo', () async {
    final created = await controller.create(name: '  Verbos  ');
    expect(created.name, 'Verbos');

    await controller.rename(id: created.id, name: ' Phrasal verbs ');
    final updated = await groups.getById(created.id);
    expect(updated?.name, 'Phrasal verbs');
  });
}
