import { consumeTag, tagFor, dirtyTagFor } from '@glimmer/validator';
import { schedule } from '@ember/runloop';
import { modifier } from 'ember-modifier';

function animatable(initialValue, opts) {
  return new AnimatableImpl(initialValue, opts?.equals ?? Object.is);
}
const viewTransitionName = modifier(function (element, parts) {
  element.style.viewTransitionName = parts.map(p => String(p)).join('');
});
function waitForRender() {
  return new Promise(resolve => {
    /* eslint-disable ember/no-runloop */
    schedule('afterRender', () => {
      resolve();
    });
  });
}
class AnimatableImpl {
  #current;
  #equals;
  constructor(initial, equals) {
    this.#current = initial;
    this.#equals = equals;
  }
  get current() {
    consumeTag(tagFor(this, 'current'));
    return this.#current;
  }
  #set(newValue) {
    dirtyTagFor(this, 'current');
    this.#current = newValue;
  }
  set = newValue => {
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

export { animatable, viewTransitionName };
//# sourceMappingURL=index.js.map
