import type { TemplateOnlyComponent } from '@ember/component/template-only';

export const CloseButton = <template>
  <style scoped>
    button {
      position: absolute;
      top: 0;
      right: 0;
      margin: 0.5rem;
    }
  </style>
  <button type="button" ...attributes>X</button>
</template> satisfies TemplateOnlyComponent<{ Element: HTMLButtonElement }>;
