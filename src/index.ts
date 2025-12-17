import { dirtyTagFor, consumeTag, tagFor } from '@glimmer/validator';
import { schedule } from '@ember/runloop';
import { modifier } from 'ember-modifier';

export interface Animatable<T> {
  readonly current: T;
  set(newValue: T): void;
}

export function animatable<T>(
  initialValue: T,
  opts?: { equals?: (a: T, b: T) => boolean },
): Animatable<T> {
  return new AnimatableImpl(initialValue, opts?.equals ?? Object.is);
}

export const viewTransitionName = modifier(function (
  element: HTMLElement,
  parts: (string | number)[],
) {
  element.style.viewTransitionName = parts.map((p) => String(p)).join('');
});

function waitForRender(): Promise<void> {
  return new Promise<void>((resolve) => {
    /* eslint-disable ember/no-runloop */
    schedule('afterRender', () => {
      resolve();
    });
  });
}

class AnimatableImpl<T> implements Animatable<T> {
  #current: T;
  #equals: (a: T, b: T) => boolean;

  constructor(initial: T, equals: (a: T, b: T) => boolean) {
    this.#current = initial;
    this.#equals = equals;
  }

  get current() {
    consumeTag(tagFor(this, 'current'));
    return this.#current;
  }

  #set(newValue: T) {
    dirtyTagFor(this, 'current');
    this.#current = newValue;
  }

  set = (newValue: T) => {
    if (this.#equals(this.#current, newValue)) {
      return;
    }
    if (!document.startViewTransition) {
      this.#set(newValue);
      return;
    }

    document.startViewTransition(async () => {
      this.#set(newValue);
      await waitForRender();
    });
  };
}
