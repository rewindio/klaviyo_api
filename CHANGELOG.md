# CHANGELOG

## [1.7.0]

### Changed

 - Updated to return count as zero, when there are no results found in klaviyo account
  
## [1.6.0]

### Added

 - Support `/v1/people/exclusions`

## [1.5.0]

### Added

 - Support `/v2/list<id>/exclusions/all`
 - MarkerCollections can now return the next page of results

### Changed

 - `List#members` has been replaced with `ListMember#all_members` and now returns a regular collection instead of an Enumerator

## [1.4.0]

### Added

 - Support `/v1/metrics`, `/v1/metrics/timeline`
 - Support `/v1/metrics/<id>/timeline`

## [1.3.1]

### Changed

 - Improve performance of `.count` by only getting the first item instead of the first page

## [1.3.0]

### Added

 - Support `/v1/person/<id>`
 - Support `/v1/people`
 - Support `.count` on Profile

## [1.2.0]

### Added

 - Support `/v2/list/<id>/members`
 - Support `/v2/group/<id>/members/all` through `KlaviyoAPI::List#members`

## [1.0.0]

### Added

- Created
