abstract final class AppRoutes {
  static const home = '/';
  static const study = '/study';
  static const progress = '/progress';
  static const settings = '/settings';
  static const cards = '/cards';
  static const createCard = '/cards/new';
  static const groups = '/groups';
  static const errors = '/errors';

  static String createCardInGroup(int groupId) => '/cards/new?groupId=$groupId';

  static String editCard(int cardId) => '/cards/$cardId/edit';

  static String groupDetail(int groupId) => '/groups/$groupId';
}
