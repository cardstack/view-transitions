/* not part of ember's pubic types */
declare module '@glimmer/validator' {
  // this is really just an opaque type from our perspective
  export type Tag = {
    __tag_brand__: unknown;
  };

  export function consumeTag(tag: Tag): void;

  export function tagFor<T extends object>(
    obj: T,
    key: keyof T | string | symbol,
    meta?: TagMeta,
  ): Tag;

  export function dirtyTagFor<T extends object>(
    obj: T,
    key: keyof T | string | symbol,
  ): void;
}

/* glimmer-scoped-css */
interface HTMLStyleElementAttributes {
  scoped: unknown;
}
