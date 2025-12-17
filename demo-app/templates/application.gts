import type { TemplateOnlyComponent } from '@ember/component/template-only';
import { on } from '@ember/modifier';
import { animatable, viewTransitionName } from '#src/index.ts';
import { fn } from '@ember/helper';
import { type Product, products } from '../products/index.gts';
import { CloseButton } from '../components/close-button.gts';

const selectedProduct = animatable<Product | null>(null);

const Tray = <template>
  <style scoped>
    .outer {
      border: 1px solid black;
      border-radius: 10px;
      box-shadow: #0000007d 5px 5px 9px 0px;
      background-color: white;
      overflow: clip;
      view-transition-class: expansion;
    }
    .expanded.outer {
      view-transition-class: expansion isolated;
    }
    .inner {
      view-transition-class: content-swap;
    }
    .expanded .inner {
      view-transition-class: content-swap isolated;
    }
  </style>
  <div
    class="outer {{if @expanded 'expanded'}}"
    ...attributes
    {{viewTransitionName "outer" @matchId}}
  >
    <div class="inner" {{viewTransitionName "inner" @matchId}}>
      {{yield}}
    </div>
  </div>
</template> satisfies TemplateOnlyComponent<{
  Element: HTMLElement;
  Blocks: { default: [] };
  Args: { matchId: string | number; expanded?: boolean };
}>;

const FittedPlaceholder = <template>
  <style scoped>
    div {
      border: 1px solid black;
      border-radius: 10px;
      width: 364px;
      height: 668px;
      box-sizing: border-box;
      padding: 0.5rem;
      border-color: #00000000;
    }
  </style>
  <div ...attributes>
    {{yield}}
  </div>
</template> satisfies TemplateOnlyComponent<{
  Element: HTMLElement;
  Blocks: { default: [] };
}>;

function eq<T>(a: T, b: T): boolean {
  return a === b;
}

const ProductList = <template>
  <style scoped>
    div {
      display: flex;
    }
    div > * {
      margin: 0.5rem;
    }
  </style>
  <div ...attributes>
    {{#each products as |product|}}
      {{#if (eq product selectedProduct.current)}}
        <FittedPlaceholder />
      {{else}}
        <Tray
          {{on "click" (fn selectedProduct.set product)}}
          @matchId={{product.id}}
        >
          {{yield product}}
        </Tray>
      {{/if}}
    {{/each}}
  </div>
</template> satisfies TemplateOnlyComponent<{
  Element: HTMLElement;
  Blocks: { default: [Product] };
  Args: {
    products: Product[];
  };
}>;

const Plane = <template>
  <style scoped>
    .plane {
      width: 100vw;
      height: 100vh;
      position: absolute;
      top: 0;
      left: 0;
      display: flex;
      justify-content: center;
      align-items: center;
      pointer-events: none;
    }
    .scrim {
      width: 100vw;
      height: 100vh;
      position: absolute;
      top: 0;
      left: 0;
      background-color: #00000070;
      view-transition-name: scrim;
    }
    .content {
      position: relative;
      pointer-events: auto;
    }
  </style>
  <div class="scrim" {{on "click" @scrimClicked}}></div>
  <div class="plane">
    <div class="content">
      {{yield}}
    </div>
  </div>
</template> satisfies TemplateOnlyComponent<{
  Blocks: {
    default: [];
  };
  Args: {
    scrimClicked: () => void;
  };
}>;

<template>
  <style>
    body {
      background-color: #9d9dd7;
    }

    /* opt out of the default whole-page view transition */
    :root {
      view-transition-name: none;
    }

    ::view-transition-group(scrim) {
      animation-duration: 0.5s;
    }

    ::view-transition-group(.expansion) {
      animation-duration: 0.5s;
      border: 1px solid black;
      box-sizing: border-box;
      border-radius: 10px;
      background-color: white;
      box-shadow: #0000007d 5px 5px 9px 0px;
    }

    ::view-transition-group(.isolated) {
      z-index: 1;
    }

    ::view-transition-old(.expansion),
    ::view-transition-new(.expansion) {
      /* Prevent the default animation */
      animation: none;
      display: none;
    }

    ::view-transition-group(.content-swap) {
      animation-duration: 0.5s;
      overflow: clip;
      clip-path: inset(0px round 10px);
    }

    ::view-transition-old(.content-swap),
    ::view-transition-new(.content-swap) {
    }
  </style>

  <ProductList @products={{products}} as |product|>
    <product.small />
  </ProductList>

  {{#if selectedProduct.current}}
    <Plane @scrimClicked={{fn selectedProduct.set null}}>
      <Tray @matchId={{selectedProduct.current.id}} @expanded={{true}}>
        <CloseButton {{on "click" (fn selectedProduct.set null)}} />
        <selectedProduct.current.big />
      </Tray>
    </Plane>
  {{/if}}
</template>
