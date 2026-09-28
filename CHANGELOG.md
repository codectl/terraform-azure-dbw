# Changelog

## [3.0.0](https://github.com/CloudNationHQ/terraform-azure-dbw/compare/v2.4.0...v3.0.0) (2026-09-18)


### ⚠ BREAKING CHANGES

* this change causes recreates

### Features

* azurerm provider 5 upgrade ([#29](https://github.com/CloudNationHQ/terraform-azure-dbw/issues/29)) ([eeaffbe](https://github.com/CloudNationHQ/terraform-azure-dbw/commit/eeaffbe6b3b5c1dc3dc1c49e83c107ead2b500df))
* **deps:** bump github.com/cloudnationhq/az-cn-go-validor in /tests ([#25](https://github.com/CloudNationHQ/terraform-azure-dbw/issues/25)) ([adc4de0](https://github.com/CloudNationHQ/terraform-azure-dbw/commit/adc4de032fb510694f1185be8bcf4ec25e0275b1))
* **deps:** bump golang.org/x/crypto from 0.45.0 to 0.52.0 in /tests ([#27](https://github.com/CloudNationHQ/terraform-azure-dbw/issues/27)) ([526737a](https://github.com/CloudNationHQ/terraform-azure-dbw/commit/526737a0c16b0a880af85a294882fd53414b70e0))

## [2.4.0](https://github.com/CloudNationHQ/terraform-azure-dbw/compare/v2.3.1...v2.4.0) (2026-04-29)


### Features

* Add lifecycle ignore for custom_parameters ([#23](https://github.com/CloudNationHQ/terraform-azure-dbw/issues/23)) ([6958038](https://github.com/CloudNationHQ/terraform-azure-dbw/commit/6958038bd9b6b25420b9dfee88f0952e7cd40eca))
* **deps:** bump golang.org/x/net from 0.23.0 to 0.36.0 in /tests ([#16](https://github.com/CloudNationHQ/terraform-azure-dbw/issues/16)) ([3bc3f62](https://github.com/CloudNationHQ/terraform-azure-dbw/commit/3bc3f626756b820df9fefac5ea1f3d876632d3ac))

## [2.3.1](https://github.com/CloudNationHQ/terraform-azure-dbw/compare/v2.3.0...v2.3.1) (2026-03-04)


### Bug Fixes

* simplify resource group lookup in main.tf and clean up example READMEs ([#21](https://github.com/CloudNationHQ/terraform-azure-dbw/issues/21)) ([0c0567e](https://github.com/CloudNationHQ/terraform-azure-dbw/commit/0c0567ef6326a47317745239415fb1c8bcbc053b))

## [2.3.0](https://github.com/CloudNationHQ/terraform-azure-dbw/compare/v2.2.0...v2.3.0) (2026-03-04)


### Features

* type definitions ([#19](https://github.com/CloudNationHQ/terraform-azure-dbw/issues/19)) ([2c4a623](https://github.com/CloudNationHQ/terraform-azure-dbw/commit/2c4a6230e23bf5e37a93545485e9c9848e2215af))

## [2.2.0](https://github.com/CloudNationHQ/terraform-azure-dbw/compare/v2.1.0...v2.2.0) (2024-11-11)


### Features

* enhance testing with sequential, parallel modes and flags for exceptions and skip-destroy ([#8](https://github.com/CloudNationHQ/terraform-azure-dbw/issues/8)) ([836dcf5](https://github.com/CloudNationHQ/terraform-azure-dbw/commit/836dcf5db03adf544c9c79b4e7b573534118a1d7))

## [2.1.0](https://github.com/CloudNationHQ/terraform-azure-dbw/compare/v2.0.0...v2.1.0) (2024-10-11)


### Features

* auto generated docs and refine makefile ([#6](https://github.com/CloudNationHQ/terraform-azure-dbw/issues/6)) ([0bd991a](https://github.com/CloudNationHQ/terraform-azure-dbw/commit/0bd991ad7c42ce739a371c78b922538e617378fc))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#5](https://github.com/CloudNationHQ/terraform-azure-dbw/issues/5)) ([ff8e5e6](https://github.com/CloudNationHQ/terraform-azure-dbw/commit/ff8e5e6d0c1ed763e041c2ec1cfce221d48325b1))

## [2.0.0](https://github.com/CloudNationHQ/terraform-azure-dbw/compare/v1.0.0...v2.0.0) (2024-09-25)


### ⚠ BREAKING CHANGES

* Version 4 of the azurerm provider includes breaking changes.

### Features

* upgrade azurerm provider to v4 ([#3](https://github.com/CloudNationHQ/terraform-azure-dbw/issues/3)) ([dcc98fb](https://github.com/CloudNationHQ/terraform-azure-dbw/commit/dcc98fbf90527b1c459f9cedb660c51c7fc6e9cb))

### Upgrade from v1.0.0 to v2.0.0:

- Update module reference to: `version = "~> 2.0"`

## 1.0.0 (2024-09-05)


### Features

* add initial resources, templates, (readme) docs and example usages ([50c7b16](https://github.com/CloudNationHQ/terraform-azure-dbw/commit/50c7b16f9dbcbfc90240d4ab5278cdfd7e0a5542))
* update readme ([4b2185a](https://github.com/CloudNationHQ/terraform-azure-dbw/commit/4b2185a946bb3aed595d09e520a1f8da53eb75cf))
