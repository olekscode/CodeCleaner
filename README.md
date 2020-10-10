# CodeCleaner
[![Build Status](https://travis-ci.org/olekscode/CodeCleaner.svg?branch=master)](https://travis-ci.org/olekscode/CodeCleaner)
[![Build status](https://ci.appveyor.com/api/projects/status/t7lxsakunjyl0dan?svg=true)](https://ci.appveyor.com/project/olekscode/CodeCleaner)
[![Coverage Status](https://coveralls.io/repos/github/olekscode/CodeCleaner/badge.svg?branch=master)](https://coveralls.io/github/olekscode/CodeCleaner?branch=master)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/olekscode/CodeCleaner/master/LICENSE)

## How to install it?

To install `CodeCleaner`, go to the Playground (Ctrl+OW) in your [Pharo](https://pharo.org/) image and execute the following Metacello script (select it and press Do-it button or Ctrl+D):

```Smalltalk
Metacello new
  baseline: 'CodeCleaner';
  repository: 'github://olekscode/CodeCleaner/src';
  load.
```

## How to depend on it?

If you want to add a dependency on `CodeCleaner` to your project, include the following lines into your baseline method:

```Smalltalk
spec
  baseline: 'CodeCleaner'
  with: [ spec repository: 'github://olekscode/CodeCleaner/src' ].
```

If you are new to baselines and Metacello, check out the [Baselines](https://github.com/pharo-open-documentation/pharo-wiki/blob/master/General/Baselines.md) tutorial on Pharo Wiki.

## How to use it?

