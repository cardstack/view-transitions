import type { TemplateOnlyComponent } from '@ember/component/template-only';
import { on } from '@ember/modifier';

export const Plane = <template>
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
