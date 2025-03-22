## 3.0.0

- **Upgrade to Dart 3**: Upgraded project to be fully compatible with Dart 3.
- **Improved Tests**: 
  - CI setup
  - Integration tests
  - Code coverage reporting
- **Analyzer Fixes**: Resolved various issues detected by the analyzer to improve code quality and maintainability.
- **Web-Incompatible Components Removed**: 
  - **Breaking Change**: Removed `GeniusApiAuth.authorize`. 
    - Use `GeniusApiAuth.constructAuthorize` instead.
    - Ensure you handle the opening of the link according to your intended platform and flow.

## 2.0.1

- fix error in library level comment

## 2.0.0

- null safety
- const constructors
- lints
- fixed that `GeniusApiAuth.token` had `Future<void>` return type isntead of `Future<String>`
- updated dependencies

## 1.0.0

- Initial release.
