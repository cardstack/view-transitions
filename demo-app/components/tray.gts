import { viewTransitionName } from '#src/index.ts';
import type { TemplateOnlyComponent } from '@ember/component/template-only';

export const Tray = <template>
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
