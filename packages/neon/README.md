# Neon

<img src="assets/logo.svg" alt="Neon logo" width="200"/>

A framework for building convergent cross-platform Nextcloud clients using Flutter.

## The goals of Neon

The Neon project has three main goals:

1. The [Neon framework](packages/neon_framework) does the heavy lifting for Nextcloud client developers. Neon already handles the authentication flow and manages data requests and caching. This means that developers can reuse a lot of the code and do not need to reinvent the wheel.
2. The [Neon app](packages/app) is a cross-platform Nextcloud client that runs on iOS, Android, macOS, Windows, Linux and Web. We already support Android and Linux with the other platforms being work in progress.
3. The [Neon app](packages/app) is a multi client app. This means that you can have multiple clients in the same mobile app. It enables seamless switching between multiple apps as Nextcloud users have enjoyed on the web forever.

### Current problems with other clients

- There are many clients that are designed to run exclusively on a single platform or device type. They all have different code bases, which makes feature parity and maintenance much more difficult.
- The user experience and features differ significantly from platform to platform, which leads to frustration. This particularly affects mobile devices running Linux (e.g. postmarketOS). There is no suitable client on this platform at all. Using the desktop Linux client for file synchronization would probably work, but it still lacks almost all the features available on e.g. Android and the client is not converging to the needs of a mobile screens.
- Even on feature-rich platforms, features are spread across multiple apps, making it more complicated for the user who simply wants to get the most out of their Nextcloud server on their device.

### How Neon as a framework tries to solve them

The Neon project uses [Dart](https://dart.dev/) and [Flutter](https://flutter.dev/) to help mobile client developers building apps. Flutter allows us to build convergent cross-platform clients that feel native. 
We are a 100% FOSS framework and do not rely on any proprietary libraries making it easy for developers to publish their apps in places like the [F-Droid](https://f-droid.org/) store.
We provide a generated [Nextcloud Dart client](packages/nextcloud) that is generated from the new OpenAPI specifications shipped with Nextcloud and is already being used by other Dart and Flutter projects. Gone are the days of looking at the PHP code and implementing an API client by hand which can be time-consuming and very error-prone.

We provide abstractions, common utilities and prebuilt UI components (called Widgets in Flutter) that can be re-used. This allows Neon to make developing a new Nextcloud client as easy as adding a few custom UI elements and the necessary state management, while everything else is already taken care of for you.

## Contributing

We encourage every client developer to contribute their app implementation back into Neon.
This way the app developers can choose from a large set of clients to enable.
Check out our [contributing docs](CONTRIBUTING.md) to get started with developing with Neon.

We have a lot of [documentation](docs) from helping you set up your development environment to our guidelines.
Please make sure to read them before starting to contribute.

## Development and support

We have a Matrix space where you can ask questions: https://matrix.to/#/#nextcloud-neon:matrix.org

## Features

See [here](packages/app/README.md) for screenshots.

- :heavy_check_mark: Supported
- :construction: Work in progress 
- :rocket: Planned

| App                                               | Status             |
|---------------------------------------------------|--------------------|
| [Dashboard](packages/neon/neon_dashboard)         | :heavy_check_mark: |
| [Files](packages/neon/neon_files)                 | :heavy_check_mark: |
| [News](packages/neon/neon_news)                   | :heavy_check_mark: |
| [Notes](packages/neon/neon_notes)                 | :heavy_check_mark: |
| [Notifications](packages/neon/neon_notifications) | :heavy_check_mark: |
| Activity                                          | :rocket:           |
| Calendar                                          | :rocket:           |
| Contacts                                          | :rocket:           |
| Cookbook                                          | :rocket:           |
| Photos                                            | :rocket:           |
| Talk                                              | :rocket:           |
| Tasks                                             | :rocket:           |

## Platform support

| Platform  | Progress           |
|-----------|--------------------|
| Android   | :heavy_check_mark: |
| iOS       | :construction:     |
| MacOS     | :construction:     |
| Linux     | :heavy_check_mark: |
| Windows   | :rocket:           |
| Web       | :construction:     |
