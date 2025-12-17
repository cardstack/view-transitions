import type { TemplateOnlyComponent } from '@ember/component/template-only';
import type { ComponentLike } from '@glint/template';

export interface Product {
  id: number;
  big: ComponentLike;
  small: ComponentLike;
}

function loadProducts() {
  const images: Record<string, { default: string }> = import.meta.glob(
    './*.png',
    { eager: true },
  );

  const products: Partial<Product>[] = [];

  for (let [filename, { default: url }] of Object.entries(images)) {
    let match = /\.\/product-(\d+)-(big|small)\.png/.exec(filename);
    if (match) {
      let id = Number(match[1]);
      let size = match[2] as 'big' | 'small';
      let component =
        size === 'big'
          ? <template><ProductBig @imageURL={{url}} /></template>
          : <template><ProductSmall @imageURL={{url}} /></template>;

      let product = products.find((p) => p.id === id);
      if (product) {
        product[size] = component;
      } else {
        product = { id, [size]: component };
        products.push(product);
      }
    }
  }
  return products.filter((p) => p.big && p.small && p.id != null) as Product[];
}

export const products = loadProducts();

const ProductBig = <template>
  <style scoped>
    img {
      width: 90vw;
      margin: 0.5rem;
    }
  </style>
  <img src={{@imageURL}} alt="a chair" />
</template> satisfies TemplateOnlyComponent<{
  Args: {
    imageURL: string;
  };
}>;

const ProductSmall = <template>
  <style scoped>
    img {
      width: 362px;
      height: 668px;
    }
  </style>
  <img src={{@imageURL}} alt="a chair" />
</template> satisfies TemplateOnlyComponent<{
  Args: {
    imageURL: string;
  };
}>;
