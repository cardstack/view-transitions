# @cardstack/view-transitions

Ember utilities for triggering native View Transition API animations.

## Compatibility

- Ember.js v5.8 or above
- Embroider or ember-auto-import v2

## Installation

```
ember install @cardstack/view-transitions
```

## Usage

You will need to learn about the [View Transition API](https://developer.mozilla.org/en-US/docs/Web/API/View_Transition_API) to make use of this library. This library provides some small utilities that make it convenient to use View Transitions in Ember apps.

### Animatable values

```ts
export function animatable<T>(
  initialValue: T,
  opts?: { equals?: (a: T, b: T) => boolean },
): Animatable<T>

export interface Animatable<T> {
  readonly current: T;
  set(newValue: T): void;
}
```

Creates a value that triggers a ViewTransition whenever it changes. `current` does not update instantly when you call `set`, instead `current` is allowed to update after the ViewTransition has already snapshotted the "before" state for the View Transition.

```gts
import { animatable } from '@cardstack/view-transitions';

const expanded = animatable(false);

function toggleExpanded() {
  expanded.set(!expanded.current);
}

<template>
  <button {{on "click" toggleExpanded}}>Toggle</button>
  {{#if expanded.current}}
    <ExpandedContentHere />
  {{else}}
    <CollapsedContentHere />
  {{/if}}
</template>
```

Animatable values are also necessarily `tracked`, for full interoperability with the rest of Ember. You can consume them like any other tracked state, and re-renders will happen automatically, with the added bonus that the DOM state before and after the re-render will be captured by the browser and can be smoothly animated.

### viewTransitionName

A modifier that sets the `view-transition-name` CSS property. Useful for programmatically assigning unique names based on model IDs, etc. Accepts any number of strings or numbers and concatenates them to form the view-transition-name.

```ts
viewTransitionName: FunctionBasedModifier<{
  Args: {
      Positional: (string | number)[];
  };
  Element: HTMLElement;
}>;
```

```gts
import { viewTransitionName } from '@cardstack/view-transitions';
<template>
  {{#each @products as |product|}}
    <div {{viewTransitionName "product" product.id}}>
      {{product.title}}
    </div>
  {{/each}}
</template>
```

The critical thing to understand about the `view-transition-name` CSS property is that it must be unique on the whole page. It can appear in both the "old" and "new" states of the DOM, but can't appear simultaneously more than once. It controls which elements get captured (think: "screenshotted") during the ViewTransition, and how the old and new element correlate.

## Demo App

This repo contains a demo app. To run it:

```sh
pnpm install
pnpm start
```

## Contributing

See the [Contributing](CONTRIBUTING.md) guide for details.

## License

This project is licensed under the [MIT License](LICENSE.md).
