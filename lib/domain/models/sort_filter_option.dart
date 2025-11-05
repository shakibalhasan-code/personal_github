enum SortOption {
  dateCreated,
  dateUpdated,
  datePushed,
  starsHighToLow,
  starsLowToHigh,
  forksHighToLow,
  forksLowToHigh,
  nameAsc,
  nameDesc,
}

enum FilterOption {
  all,
  withDescription,
  withLanguage,
  starredOnly,
  forkedOnly,
}

extension SortOptionExtension on SortOption {
  String get label {
    switch (this) {
      case SortOption.dateCreated:
        return 'Created Date';
      case SortOption.dateUpdated:
        return 'Updated Date';
      case SortOption.datePushed:
        return 'Pushed Date';
      case SortOption.starsHighToLow:
        return 'Stars: High to Low';
      case SortOption.starsLowToHigh:
        return 'Stars: Low to High';
      case SortOption.forksHighToLow:
        return 'Forks: High to Low';
      case SortOption.forksLowToHigh:
        return 'Forks: Low to High';
      case SortOption.nameAsc:
        return 'Name: A to Z';
      case SortOption.nameDesc:
        return 'Name: Z to A';
    }
  }
}

extension FilterOptionExtension on FilterOption {
  String get label {
    switch (this) {
      case FilterOption.all:
        return 'All';
      case FilterOption.withDescription:
        return 'With Description';
      case FilterOption.withLanguage:
        return 'With Language';
      case FilterOption.starredOnly:
        return 'Starred Only';
      case FilterOption.forkedOnly:
        return 'Forked Only';
    }
  }
}
