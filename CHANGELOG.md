# Changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.4.5] - 2020-05-25
### fix
- Dont trigger error in list when given optional params

## [0.4.4] - 2020-05-24
### fix
- Removed dependencie with Plug to test


## [0.4.3] - 2020-05-23
### fix
- When params is nil automatic return error

## [0.4.1] - 2020-05-23
### fix
- Returned conn in action fallback handler

## [0.4.0] - 2020-05-23
### Added
- Added handler to action fallback from phoenix

## [0.3.0] - 2020-05-23
### Added
- Can filter and return a list of maps

## [0.2.0] - 2020-05-19
### Added
- Scroll inside nested filters

## [0.1.3] - 2020-05-15
### Added
- Create CHANGELOG file

### Changed
- Remove atomize module
- Update description of Paramsx
- Return of params now will be in format {:ok, params} or {:error, some_error}
